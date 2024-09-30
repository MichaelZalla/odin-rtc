package tests

import "core:testing"

import rt "../src"

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
