package tests

import "core:testing"

import rt "../src"
import m "../src/math"

@(test)
material_create_default :: proc(t: ^testing.T) {
	// Scenario: The default material.

	mat := rt.material()

	testing.expect(t, mat.color == rt.White)
	testing.expect(t, mat.ambient == 0.1)
	testing.expect(t, mat.diffuse == 0.9)
	testing.expect(t, mat.specular == 0.9)
	testing.expect(t, mat.specular_exponent == 200.0)
}

@(test)
sphere_material_default :: proc(t: ^testing.T) {
	// Scenario: A sphere has a default material.

	s := rt.sphere()
	mat := s.material

	testing.expect(t, mat == rt.material())
}

@(test)
sphere_material_edit :: proc(t: ^testing.T) {
	// Scenario: A sphere may be assigned a material.

	s := rt.sphere()

	mat := rt.material()
	mat.ambient = 1

	s.material = mat

	testing.expect(t, s.material.ambient == 1)
}

@(test)
sphere_material_stripe_pattern :: proc(t: ^testing.T) {
	// Scenario: Lighting with a pattern applied to a material.

	mat := rt.material()

	// Give the material a stripe pattern.
	mat.pattern = rt.stripe_pattern()

	// Ambient only.
	mat.ambient = 1.0
	mat.diffuse = 0.0
	mat.specular = 0.0

	// Set up a lighting scenario.
	eye_vector := m.vector(0, 0, -1)
	normal_vector := m.vector(0, 0, -1)
	point_light := rt.point_light(m.point(0, 0, -10), rt.White)

	c1 := rt.lighting(&mat, &point_light, m.point(0.9, 0, 0), eye_vector, normal_vector, false)
	c2 := rt.lighting(&mat, &point_light, m.point(1.1, 0, 0), eye_vector, normal_vector, false)

	testing.expect(t, m.tuple_eq(c1, rt.White))
	testing.expect(t, m.tuple_eq(c2, rt.Black))
}
