package tests

import testing "core:testing"

import rt "../src"
import m "../src/math"

@(test)
ray_create_query :: proc(t: ^testing.T) {
	// Scenario: Creating and querying a ray.

	origin := m.point(1, 2, 3)
	direction := m.vector(4, 5, 6)

	ray := rt.ray(origin, direction)

	testing.expect(t, ray.origin == origin)
	testing.expect(t, ray.direction == direction)
}

@(test)
ray_position_for_t :: proc(t: ^testing.T) {
	// Scenario: Computing a point from a distance.

	ray := rt.ray(m.point(2, 3, 4), m.vector(1, 0, 0))

	testing.expect(t, rt.position(ray, 0) == m.point(2, 3, 4))
	testing.expect(t, rt.position(ray, 1) == m.point(3, 3, 4))
	testing.expect(t, rt.position(ray, -1) == m.point(1, 3, 4))
	testing.expect(t, rt.position(ray, 2.5) == m.point(4.5, 3, 4))
}

@(test)
ray_translate :: proc(t: ^testing.T) {
	// Scenario: Translating a ray.

	ray1 := rt.ray(m.point(1, 2, 3), m.vector(0, 1, 0))

	translation := m.mat4_translate(m.vector(3, 4, 5))

	ray2 := rt.ray_transform(ray1, translation)

	testing.expect(t, ray2.origin == m.point(4, 6, 8))
	testing.expect(t, ray2.direction == m.vector(0, 1, 0))
}

@(test)
ray_scale :: proc(t: ^testing.T) {
	// Scenario: Scaling a ray.

	ray1 := rt.ray(m.point(1, 2, 3), m.vector(0, 1, 0))

	scale := m.mat4_scale(m.vector(2, 3, 4))

	ray2 := rt.ray_transform(ray1, scale)

	testing.expect(t, ray2.origin == m.point(2, 6, 12))
	testing.expect(t, ray2.direction == m.vector(0, 3, 0))
}

@(test)
ray_intersect_scaled_sphere :: proc(t: ^testing.T) {
	// Scenario: Intersecting a ray with a scaled sphere.

	ray := rt.ray(m.point(0, 0, -5), m.vector(0, 0, 1))

	sphere := rt.sphere()
	sphere.transform = m.mat4_scale(2)

	xs := rt.intersect(&sphere, ray)
	defer delete(xs)

	testing.expect(t, len(xs) == 2)
	testing.expectf(t, xs[0].t == 3, "%v != %v", xs[0].t, 3)
	testing.expectf(t, xs[1].t == 7, "%v != %v", xs[1].t, 7)
}

@(test)
ray_intersect_translated_sphere :: proc(t: ^testing.T) {
	// Scenario: Intersecting a ray with a translated sphere.

	ray := rt.ray(m.point(0, 0, -5), m.vector(0, 0, 1))

	sphere := rt.sphere()
	sphere.transform = m.mat4_translate(m.vector(5, 0, 0))

	xs := rt.intersect(&sphere, ray)
	defer delete(xs)

	testing.expect(t, len(xs) == 0)
	testing.expect(t, xs == nil)
}

@(test)
precompute_intersection_outside :: proc(t: ^testing.T) {
	// Scenario: Precomputing the state of an intersection.
	// Note: The ray (eye) sits outside of the shape being intersected.

	ray := rt.ray(m.point(0, 0, -5), m.vector(0, 0, 1))

	shape := rt.sphere()

	intersection := rt.intersection(4, &shape)

	comps := rt.ray_prepare_computations(ray, intersection)

	testing.expect(t, comps.t == intersection.t)
	testing.expect(t, comps.shape == intersection.shape)
	testing.expect(t, comps.point == m.point(0, 0, -1))
	testing.expect(t, comps.eye == m.vector(0, 0, -1))
	testing.expect(t, comps.normal == m.vector(0, 0, -1))
	testing.expect(t, !comps.inside)
}

@(test)
precompute_intersection_inside :: proc(t: ^testing.T) {
	// Scenario: Precomputing the state of an intersection.
	// Note: The ray (eye) sits inside of the shape being intersected; as a
	// result, the normal returned by `ray_prepare_computations()` is flipped.

	ray := rt.ray(m.point(0, 0, 0), m.vector(0, 0, 1))

	shape := rt.sphere()

	intersection := rt.intersection(1, &shape)

	comps := rt.ray_prepare_computations(ray, intersection)

	testing.expect(t, comps.t == intersection.t)
	testing.expect(t, comps.shape == intersection.shape)
	testing.expect(t, comps.point == m.point(0, 0, 1))
	testing.expect(t, comps.eye == m.vector(0, 0, -1))
	testing.expect(t, comps.normal == m.vector(0, 0, -1))
	testing.expect(t, comps.inside)
}
