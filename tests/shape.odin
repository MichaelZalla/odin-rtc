package tests

import "core:math"
import "core:math/linalg"
import "core:testing"

import rt "../src"
import m "../src/math"

@(test)
shape_default_transform :: proc(t: ^testing.T) {
	// Scenario: The default transformation for a shape.

	shape := rt.sphere()

	testing.expect(t, shape.transform == m.Mat4(1))
}

@(test)
shape_default_transform_edit :: proc(t: ^testing.T) {
	// Scenario: Updating a shape's transform.

	shape := rt.sphere()

	translation := m.mat4_translate(m.vector(2, 3, 4))

	shape.transform = translation

	testing.expect(t, shape.transform == translation)
}

@(test)
shape_default_material :: proc(t: ^testing.T) {
	// Scenario: The default materialation for a shape.

	shape := rt.sphere()

	testing.expect(t, shape.material == rt.material())
}

@(test)
shape_default_material_edit :: proc(t: ^testing.T) {
	// Scenario: Assigning a material to a shape.

	shape := rt.sphere()

	bright := rt.material()
	bright.ambient = 1

	shape.material = bright

	testing.expect(t, shape.material == bright)
}

@(test)
ray_intersect_scaled_shape :: proc(t: ^testing.T) {
	// Scenario: Intersecting a ray with a scaled shape.

	ray := rt.ray(m.point(0, 0, -5), m.vector(0, 0, 1))
	shape := rt.sphere()

	shape.transform = m.mat4_scale(2)

	xs := rt.intersect(&shape, ray)
	defer delete(xs)

	local_ray := shape.last_local_ray.?

	testing.expect(t, m.tuple_eq(local_ray.origin, m.point(0, 0, -2.5)))
	testing.expect(t, m.tuple_eq(local_ray.direction, m.vector(0, 0, 0.5)))
}

@(test)
ray_intersect_translated_shape :: proc(t: ^testing.T) {
	// Scenario: Intersecting a ray with a translated shape.

	ray := rt.ray(m.point(0, 0, -5), m.vector(0, 0, 1))
	shape := rt.sphere()

	shape.transform = m.mat4_translate(m.vector(5, 0, 0))

	xs := rt.intersect(&shape, ray)
	defer delete(xs)

	local_ray := shape.last_local_ray.?

	testing.expect(t, m.tuple_eq(local_ray.origin, m.point(-5, 0, -5)))
	testing.expect(t, m.tuple_eq(local_ray.direction, m.vector(0, 0, 1)))
}

@(test)
shape_normal_translated :: proc(t: ^testing.T) {
	// Scenario: Computing the normal on a translated shape.

	shape := rt.sphere()

	translation := m.mat4_translate(m.vector(0, 1, 0))

	shape.transform = translation

	n := rt.normal_at(&shape, m.point(0, 1.70711, -0.70711))

	testing.expect(t, m.tuple_eq(n, m.vector(0, 0.70711, -0.70711)))
}

@(test)
shape_normal_rotated_and_scaled :: proc(t: ^testing.T) {
	// Scenario: Computing the normal on a rotated and scaled shape.

	shape := rt.sphere()

	scale_and_rotation := m.mat4_scale(m.vector(1, 0.5, 1)) * m.mat4_rotate_z(linalg.PI / 5)

	shape.transform = scale_and_rotation

	sqrt_2_over_2 := math.sqrt(m.real(2.0)) / 2

	n := rt.normal_at(&shape, m.point(0, sqrt_2_over_2, -sqrt_2_over_2))

	testing.expect(t, m.tuple_eq(n, m.vector(0, 0.97014, -0.24254)))
}
