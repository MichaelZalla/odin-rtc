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
