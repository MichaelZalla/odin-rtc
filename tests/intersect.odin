package tests

import testing "core:testing"

import rt "../src"
import m "../src/math"

@(test)
intersection_create :: proc(t: ^testing.T) {
	// Scenario: An intersection encapsulate a t-value and an object.

	s := rt.sphere()
	i := rt.intersection(3.5, &s)

	testing.expect(t, i.t == 3.5)
	testing.expect(t, i.object == &s)
}

@(test)
intersection_aggregate :: proc(t: ^testing.T) {
	// Scenario: Aggregating multiple intersections.

	s := rt.sphere()

	i1 := rt.intersection(1, &s)
	i2 := rt.intersection(2, &s)
	i3 := rt.intersection(3, &s)

	xs := rt.intersections(i1, i2, i3)
	defer delete(xs)

	testing.expect(t, len(xs) == 3)

	testing.expect(t, xs[0].t == 1)
	testing.expect(t, xs[1].t == 2)
	testing.expect(t, xs[2].t == 3)
}

@(test)
ray_sphere_intersect :: proc(t: ^testing.T) {
	// Scenario: A ray intersects a sphere at two points.

	r := rt.ray(m.point(0, 0, -5), m.vector(0, 0, 1))
	s := rt.sphere()

	// sphere_to_ray = Vector{0,0,-5} - Vector{0,0,0}
	//  						 = Vector{0,0,-5}
	//
	// a = dot(m.Vector{0,0,1}, m.Vector{0,0,1})
	//   = 0 * 0 + 0 * 0 + 1 * 1 + 0 * 0
	//   = 0 + 0 + 1 + 0
	//   = 1
	//
	// b = 2 * dot(m.Vector{0,0,1}, Vector{0,0,-5})
	//   = 2 * (0 * 0 + 0 * 0 + 1 * -5 + 0 * 0)
	//   = 2 * (0 + 0 + 1 * -5 + 0)
	//   = 2 * (-5)
	//   = -10
	//
	// c = dot(sphere_to_ray, sphere_to_ray) - 1
	//   = (0 * 0 + 0 * 0 + -5 * -5 + 0 * 0) - 1
	//   = (0 + 0 + -5 * -5 + 0) - 1
	//   = (25) - 1
	//   = 24
	//
	// discriminant = b * b - 4 * a * c
	//  						= (-10 * -10) - 4 * 1 * 24
	//  						= 100 - 96
	//  						= 4

	xs := rt.intersect(&s, r)
	defer delete(xs)

	testing.expect(t, len(xs) == 2)
	testing.expectf(t, xs[0].t == 4.0, "%v != %v", xs[0].t, 4.0)
	testing.expectf(t, xs[1].t == 6.0, "%v != %v", xs[1].t, 6.0)
}

@(test)
ray_sphere_intersect_tangent :: proc(t: ^testing.T) {
	// Scenario: A ray intersects a sphere at a tangent.

	r := rt.ray(m.point(0, 1, -5), m.vector(0, 0, 1))
	s := rt.sphere()

	xs := rt.intersect(&s, r)
	defer delete(xs)

	testing.expect(t, len(xs) == 2)
	testing.expect(t, xs[0].t == 5.0)
	testing.expect(t, xs[1].t == 5.0)
}

@(test)
ray_sphere_intersect_miss :: proc(t: ^testing.T) {
	// Scenario: A ray misses a sphere.

	r := rt.ray(m.point(0, 2, -5), m.vector(0, 0, 1))
	s := rt.sphere()

	xs := rt.intersect(&s, r)
	defer delete(xs)

	testing.expect(t, xs == nil)
	testing.expect(t, len(xs) == 0)
}

@(test)
ray_sphere_intersect_inside :: proc(t: ^testing.T) {
	// Scenario: A ray originates inside a sphere.

	r := rt.ray(m.point(0, 0, 0), m.vector(0, 0, 1))
	s := rt.sphere()

	xs := rt.intersect(&s, r)
	defer delete(xs)

	testing.expect(t, len(xs) == 2)
	testing.expect(t, xs[0].t == -1.0)
	testing.expect(t, xs[1].t == 1.0)
}

@(test)
ray_sphere_intersect_behind :: proc(t: ^testing.T) {
	// Scenario: A sphere is behind a ray.

	r := rt.ray(m.point(0, 0, 5), m.vector(0, 0, 1))
	s := rt.sphere()

	xs := rt.intersect(&s, r)
	defer delete(xs)

	testing.expect(t, len(xs) == 2)
	testing.expect(t, xs[0].t == -6.0)
	testing.expect(t, xs[1].t == -4.0)
}

@(test)
ray_sphere_offset :: proc(t: ^testing.T) {
	// Scenario: The hit should offset the point.

	ray := rt.ray(m.point(0, 0, -5), m.vector(0, 0, 1))

	sphere := rt.sphere()
	sphere.transform = m.mat4_translate(m.vector(0, 0, 1))

	intersection := rt.intersection(5, &sphere)

	comps := rt.ray_prepare_computations(ray, intersection)

	testing.expect(t, comps.point.z > comps.over_point.z)

	testing.expect(t, comps.over_point.z < -m.EPSILON / 2)
}
