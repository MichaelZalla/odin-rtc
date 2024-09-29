package tests

import math "core:math"
import "core:testing"

import rt "../src"
import m "../src/math"

@(test)
sphere_transform_default :: proc(t: ^testing.T) {
	// Scenario: A sphere's default transform.

	s := rt.sphere()
	identity: m.Mat4 = 1

	testing.expect(t, s.transform == identity)
}

@(test)
sphere_transform_edit :: proc(t: ^testing.T) {
	// Scenario: Chagning a sphere's transform.

	s := rt.sphere()
	translate := m.mat4_translate(m.vector(2, 3, 4))

	s.transform = translate

	testing.expect(t, s.transform == translate)
}

@(test)
sphere_normal_x_axis :: proc(t: ^testing.T) {
	// Scenario: The normal for a point on a sphere intersecting the x-axis.

	s := rt.sphere()
	n := rt.sphere_normal_at(&s, m.point(1, 0, 0))

	testing.expect(t, n == m.vector(1, 0, 0))
}

@(test)
sphere_normal_y_axis :: proc(t: ^testing.T) {
	// Scenario: The normal for a point on a sphere intersecting the y-axis.

	s := rt.sphere()
	n := rt.sphere_normal_at(&s, m.point(0, 1, 0))

	testing.expect(t, n == m.vector(0, 1, 0))
}

@(test)
sphere_normal_z_axis :: proc(t: ^testing.T) {
	// Scenario: The normal for a point on a sphere intersecting the z-axis.

	s := rt.sphere()
	n := rt.sphere_normal_at(&s, m.point(0, 0, 1))

	testing.expect(t, n == m.vector(0, 0, 1))
}

@(test)
sphere_normal_non_axis :: proc(t: ^testing.T) {
	// Scenario: The normal for a point on a sphere not intersecting an axis.

	sqrt_3_over_3 := math.sqrt(m.real(3)) / 3

	s := rt.sphere()
	n := rt.sphere_normal_at(&s, m.point(sqrt_3_over_3, sqrt_3_over_3, sqrt_3_over_3))

	testing.expect(t, n == m.vector(sqrt_3_over_3, sqrt_3_over_3, sqrt_3_over_3))
}

@(test)
sphere_normal_is_normalized :: proc(t: ^testing.T) {
	// Scenario: The normal is a a normalized vector.

	sqrt_3_over_3 := math.sqrt(m.real(3)) / 3

	s := rt.sphere()
	n := rt.sphere_normal_at(&s, m.point(sqrt_3_over_3, sqrt_3_over_3, sqrt_3_over_3))

	testing.expect(t, m.norm(n) == n)
}
