package tests

import math "core:math"
import linalg "core:math/linalg"
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

@(test)
sphere_normal_translated :: proc(t: ^testing.T) {
	// Scenario: Computing the normal on a translated sphere.

	s := rt.sphere()

	xf := m.mat4_translate(m.vector(0, 1, 0))
	s.transform = xf

	n := rt.sphere_normal_at(&s, m.point(0, 1.70711, -0.70711))

	testing.expectf(
		t,
		m.tuple_eq(n, m.vector(0, 0.70711, -0.70711)),
		"%v != %v",
		n,
		m.vector(0, 0.70711, -0.70711),
	)
}

@(test)
sphere_normal_rotated_and_scaled :: proc(t: ^testing.T) {
	// Scenario: Computing the normal on a rotated and scaled sphere.

	s := rt.sphere()

	xf := m.mat4_scale(m.vector(1, 0.5, 1)) * m.mat4_rotate_z(linalg.PI / 5)
	s.transform = xf

	sqrt_2_over_2 := math.sqrt(m.real(2.0)) / 2

	n := rt.sphere_normal_at(&s, m.point(0, sqrt_2_over_2, -sqrt_2_over_2))

	testing.expectf(
		t,
		m.tuple_eq(n, m.vector(0, 0.97014, -0.24254)),
		"%v != %v",
		n,
		m.vector(0, 0.97014, -0.24254),
	)
}
