package tests

import "core:testing"

import rt "../src"
import m "../src/math"

@(test)
lighting_shadow_basic :: proc(t: ^testing.T) {
	// Scenario: Lighting with the light between eye and surface, light at 45 deg.

	material := rt.material()
	fragment_pos := m.point(0, 0, 0)

	eye := m.vector(0, 0, -1)
	normal := m.vector(0, 0, -1)
	light := rt.point_light(m.point(0, 10, -10), rt.White)

	in_shadow := true

	result := rt.lighting(&material, &light, fragment_pos, eye, normal, in_shadow)

	testing.expect(t, m.tuple_eq(result, rt.color(0.1, 0.1, 0.1)))
}
