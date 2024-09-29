package tests

import testing "core:testing"

import rt "../src"
import m "../src/math"

@(test)
ray_create_query :: proc(t: ^testing.T) {
	// Scenario: Creating and querying a ray.

	origin := m.point(1, 2, 3)
	direction := m.vector(4, 5, 6)

	r := rt.ray(origin, direction)

	testing.expect(t, r.origin == origin)
	testing.expect(t, r.direction == direction)
}

@(test)
ray_position_for_t :: proc(t: ^testing.T) {
	// Scenario: Computing a point from a distance.

	r := rt.ray(m.point(2, 3, 4), m.vector(1, 0, 0))

	testing.expect(t, rt.position(r, 0) == m.point(2, 3, 4))
	testing.expect(t, rt.position(r, 1) == m.point(3, 3, 4))
	testing.expect(t, rt.position(r, -1) == m.point(1, 3, 4))
	testing.expect(t, rt.position(r, 2.5) == m.point(4.5, 3, 4))
}

@(test)
ray_translate :: proc(t: ^testing.T) {
	// Scenario: Translating a ray.

	r := rt.ray(m.point(1, 2, 3), m.vector(0, 1, 0))
	translate := m.mat4_translate(m.vector(3, 4, 5))

	r2 := rt.ray_transform(r, translate)

	testing.expect(t, r2.origin == m.point(4, 6, 8))
	testing.expect(t, r2.direction == m.vector(0, 1, 0))
}

@(test)
ray_scale :: proc(t: ^testing.T) {
	// Scenario: Scaling a ray.

	r := rt.ray(m.point(1, 2, 3), m.vector(0, 1, 0))
	scale := m.mat4_scale(m.vector(2, 3, 4))
	r2 := rt.ray_transform(r, scale)

	testing.expect(t, r2.origin == m.point(2, 6, 12))
	testing.expect(t, r2.direction == m.vector(0, 3, 0))
}

@(test)
ray_intersect_scaled_sphere :: proc(t: ^testing.T) {
	// Scenario: Intersecting a ray with a scaled sphere.

	r := rt.ray(m.point(0, 0, -5), m.vector(0, 0, 1))
	s := rt.sphere()

	s.transform = m.mat4_scale(2)

	xs := rt.intersect(&s, r)
	defer delete(xs)

	testing.expect(t, len(xs) == 2)
	testing.expectf(t, xs[0].t == 3, "%v != %v", xs[0].t, 3)
	testing.expectf(t, xs[1].t == 7, "%v != %v", xs[1].t, 7)
}

@(test)
ray_intersect_translated_sphere :: proc(t: ^testing.T) {
	// Scenario: Intersecting a ray with a translated sphere.

	r := rt.ray(m.point(0, 0, -5), m.vector(0, 0, 1))
	s := rt.sphere()

	s.transform = m.mat4_translate(m.vector(5, 0, 0))

	xs := rt.intersect(&s, r)
	defer delete(xs)

	testing.expect(t, len(xs) == 0)
	testing.expect(t, xs == nil)
}
