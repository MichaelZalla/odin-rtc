package tests

import "core:testing"

import rt "../src"
import m "../src/math"

@(test)
plane_normal_constant :: proc(t: ^testing.T) {
	// Scenario: The normal of a plane is constant everywhere.

	plane := rt.plane()

	n1 := rt.normal_at(&plane, m.point(0, 0, 0))
	n2 := rt.normal_at(&plane, m.point(10, 0, -10))
	n3 := rt.normal_at(&plane, m.point(-5, 0, 150))

	expected_normal := m.vector(0, 1, 0)

	testing.expect(t, n1 == expected_normal)
	testing.expect(t, n2 == expected_normal)
	testing.expect(t, n3 == expected_normal)
}

@(test)
plane_intersect_for_parallel_ray :: proc(t: ^testing.T) {
	// Scenario: Intersect with a ray parallel to the plane.

	plane := rt.plane()

	ray := rt.ray(m.point(0, 10, 0), m.vector(0, 0, 1))

	xs := rt.plane_intersect_local(&plane, ray)

	testing.expect(t, len(xs) == 0)
}

@(test)
plane_intersect_for_coplanar_ray :: proc(t: ^testing.T) {
	// Scenario: Intersect with a coplanar ray.

	plane := rt.plane()

	ray := rt.ray(m.point(0, 0, 0), m.vector(0, 0, 1))

	xs := rt.plane_intersect_local(&plane, ray)

	testing.expect(t, len(xs) == 0)
}

@(test)
plane_intersect_for_ray_above :: proc(t: ^testing.T) {
	// Scenario: A ray intersecting a plane from above.

	plane := rt.plane()

	ray := rt.ray(m.point(0, 1, 0), m.vector(0, -1, 0))

	xs := rt.plane_intersect_local(&plane, ray)
	defer delete(xs)

	testing.expect(t, len(xs) == 1)
	testing.expect(t, xs[0].t == 1)
	testing.expect(t, xs[0].shape == &plane)
}

@(test)
plane_intersect_for_ray_below :: proc(t: ^testing.T) {
	// Scenario: A ray intersecting a plane from below.

	plane := rt.plane()

	ray := rt.ray(m.point(0, -1, 0), m.vector(0, 1, 0))

	xs := rt.plane_intersect_local(&plane, ray)
	defer delete(xs)

	testing.expect(t, len(xs) == 1)
	testing.expect(t, xs[0].t == 1)
	testing.expect(t, xs[0].shape == &plane)
}
