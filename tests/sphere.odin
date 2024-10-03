package tests

import math "core:math"
import linalg "core:math/linalg"
import "core:testing"

import rt "../src"
import m "../src/math"

@(test)
sphere_normal_x_axis :: proc(t: ^testing.T) {
	// Scenario: The normal for a point on a sphere intersecting the x-axis.

	sphere := rt.sphere()
	normal := rt.normal_at(&sphere, m.point(1, 0, 0))

	testing.expect(t, normal == m.vector(1, 0, 0))
}

@(test)
sphere_normal_y_axis :: proc(t: ^testing.T) {
	// Scenario: The normal for a point on a sphere intersecting the y-axis.

	sphere := rt.sphere()
	normal := rt.normal_at(&sphere, m.point(0, 1, 0))

	testing.expect(t, normal == m.vector(0, 1, 0))
}

@(test)
sphere_normal_z_axis :: proc(t: ^testing.T) {
	// Scenario: The normal for a point on a sphere intersecting the z-axis.

	sphere := rt.sphere()
	normal := rt.normal_at(&sphere, m.point(0, 0, 1))

	testing.expect(t, normal == m.vector(0, 0, 1))
}

@(test)
sphere_normal_non_axis :: proc(t: ^testing.T) {
	// Scenario: The normal for a point on a sphere not intersecting an axis.

	sqrt_3_over_3 := math.sqrt(m.real(3)) / 3

	sphere := rt.sphere()
	normal := rt.normal_at(&sphere, m.point(sqrt_3_over_3, sqrt_3_over_3, sqrt_3_over_3))

	testing.expect(t, normal == m.vector(sqrt_3_over_3, sqrt_3_over_3, sqrt_3_over_3))
}

@(test)
sphere_normal_is_normalized :: proc(t: ^testing.T) {
	// Scenario: The normal is a a normalized vector.

	sqrt_3_over_3 := math.sqrt(m.real(3)) / 3

	sphere := rt.sphere()
	normal := rt.normal_at(&sphere, m.point(sqrt_3_over_3, sqrt_3_over_3, sqrt_3_over_3))

	testing.expect(t, m.norm(normal) == normal)
}
