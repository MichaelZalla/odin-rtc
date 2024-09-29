package tests

import "core:testing"

import rt "../src"
import m "../src/math"

@(test)
sphere_transform_default :: proc(t: ^testing.T) {
	// Scenario: A sphere's default transform.

	s := rt.sphere()
	identity: m.mat4 = 1

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
