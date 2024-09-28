package tests

import testing "core:testing"

import rt "../src"
import m "../src/math"

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

	did_hit, hits := rt.intersect(s, r)
	defer delete(hits)

	testing.expect(t, did_hit)
	testing.expect(t, len(hits) == 2)
	testing.expectf(t, hits[0] == 4.0, "%v != %v", hits[0], 4.0)
	testing.expectf(t, hits[1] == 6.0, "%v != %v", hits[1], 6.0)
}

@(test)
ray_sphere_intersect_tangent :: proc(t: ^testing.T) {
	// Scenario: A ray intersects a sphere at a tangent.

	r := rt.ray(m.point(0, 1, -5), m.vector(0, 0, 1))
	s := rt.sphere()

	did_hit, hits := rt.intersect(s, r)
	defer delete(hits)

	testing.expect(t, did_hit)
	testing.expect(t, len(hits) == 2)
	testing.expect(t, hits[0] == 5.0)
	testing.expect(t, hits[1] == 5.0)
}

@(test)
ray_sphere_intersect_miss :: proc(t: ^testing.T) {
	// Scenario: A ray misses a sphere.

	r := rt.ray(m.point(0, 2, -5), m.vector(0, 0, 1))
	s := rt.sphere()

	did_hit, hits := rt.intersect(s, r)
	defer delete(hits)

	testing.expect(t, !did_hit)
	testing.expect(t, hits == nil)
	testing.expect(t, len(hits) == 0)
}

@(test)
ray_sphere_intersect_inside :: proc(t: ^testing.T) {
	// Scenario: A ray originates inside a sphere.

	r := rt.ray(m.point(0, 0, 0), m.vector(0, 0, 1))
	s := rt.sphere()

	did_hit, hits := rt.intersect(s, r)
	defer delete(hits)

	testing.expect(t, did_hit)
	testing.expect(t, len(hits) == 2)
	testing.expect(t, hits[0] == -1.0)
	testing.expect(t, hits[1] == 1.0)
}

@(test)
ray_sphere_intersect_behind :: proc(t: ^testing.T) {
	// Scenario: A sphere is behind a ray.

	r := rt.ray(m.point(0, 0, 5), m.vector(0, 0, 1))
	s := rt.sphere()

	did_hit, hits := rt.intersect(s, r)
	defer delete(hits)

	testing.expect(t, did_hit)
	testing.expect(t, len(hits) == 2)
	testing.expect(t, hits[0] == -6.0)
	testing.expect(t, hits[1] == -4.0)
}
