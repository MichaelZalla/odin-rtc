package tests

import "core:testing"

import rt "../src"
import m "../src/math"

@(test)
look_at_default :: proc(t: ^testing.T) {
	// Scenario: The look-at matrix for the default orientation.

	view_position := m.point(0, 0, 0)
	target := m.point(0, 0, -1)
	up := m.vector(0, 1, 0)

	look_at := rt.look_at(view_position, target, up)

	testing.expect(t, look_at == 1)
}

@(test)
look_at_positive_z :: proc(t: ^testing.T) {
	// Scenario: A look-at matrix looking in the positive Z direction.

	view_position := m.point(0, 0, 0)
	target := m.point(0, 0, 1)
	up := m.vector(0, 1, 0)

	look_at := rt.look_at(view_position, target, up)

	testing.expect(t, look_at == m.mat4_scale(m.vector(-1, 1, -1)))
}

@(test)
look_at_translation :: proc(t: ^testing.T) {
	// Scenario: The look-at matrix moves the world.

	view_position := m.point(0, 0, 8)
	target := m.point(0, 0, 0)
	up := m.vector(0, 1, 0)

	look_at := rt.look_at(view_position, target, up)

	testing.expect(t, look_at == m.mat4_translate(m.vector(0, 0, -8)))
}

@(test)
look_at_arbitrary :: proc(t: ^testing.T) {
	// Scenario: An arbitrary look-at matrix.

	view_position := m.point(1, 3, 2)
	target := m.point(4, -2, 8)
	up := m.vector(1, 1, 0)

	look_at := rt.look_at(view_position, target, up)

	expected_look_at := m.Mat4 {
		-0.50709,
		0.50709,
		0.67612,
		-2.36643,
		0.76772,
		0.60609,
		0.12122,
		-2.82843,
		-0.35857,
		0.59761,
		-0.71714,
		0,
		0,
		0,
		0,
		1.00000,
	}

	testing.expect(t, m.mat4_eq(&look_at, &expected_look_at))
}
