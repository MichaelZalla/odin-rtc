package tests

import math "core:math"
import "core:testing"

import rt "../src"
import m "../src/math"

@(test)
point_light_create :: proc(t: ^testing.T) {
	// Scenario: A point light has a position and an intensity.

	position := m.point(0, 0, 0)
	intensity := rt.White

	light := rt.point_light(position, intensity)

	testing.expect(t, light.position == position)
	testing.expect(t, light.intensity == intensity)
}

@(test)
lighting_eye_is_between_light_and_surface :: proc(t: ^testing.T) {
	// Scenario: Lighting with the eye between light and surface.

	material := rt.material()
	fragment_pos := m.point(0, 0, 0)

	eye := m.vector(0, 0, -1)
	normal := m.vector(0, 0, -1)
	light := rt.point_light(m.point(0, 0, -10), rt.White)

	result := rt.lighting(&material, &light, fragment_pos, eye, normal)

	testing.expect(t, result == rt.color(1.9))
}

@(test)
lighting_eye_is_45_between_light_and_surface :: proc(t: ^testing.T) {
	// Scenario: Lighting with the eye between light and surface, eye at 45 deg.

	material := rt.material()
	fragment_pos := m.point(0, 0, 0)

	sqrt_2_over_2 := math.sqrt(m.real(2.0)) / 2

	eye := m.vector(0, sqrt_2_over_2, -sqrt_2_over_2)
	normal := m.vector(0, 0, -1)
	light := rt.point_light(m.point(0, 0, -10), rt.White)

	result := rt.lighting(&material, &light, fragment_pos, eye, normal)

	testing.expect(t, result == rt.color(1))
}

@(test)
lighting_light_is_45_between_eye_and_surface :: proc(t: ^testing.T) {
	// Scenario: Lighting with the light between eye and surface, light at 45 deg.

	material := rt.material()
	fragment_pos := m.point(0, 0, 0)

	sqrt_2_over_2 := math.sqrt(m.real(2.0)) / 2

	eye := m.vector(0, 0, -1)
	normal := m.vector(0, 0, -1)
	light := rt.point_light(m.point(0, 10, -10), rt.White)

	result := rt.lighting(&material, &light, fragment_pos, eye, normal)

	testing.expect(t, m.tuple_eq(result, rt.color(0.7364)))
}

@(test)
lighting_eye_aligned_with_light_reflection_vector :: proc(t: ^testing.T) {
	// Scenario: Lighting with the eye aligned with the light reflection vector.

	material := rt.material()
	fragment_pos := m.point(0, 0, 0)

	sqrt_2_over_2 := math.sqrt(m.real(2.0)) / 2

	eye := m.vector(0, -sqrt_2_over_2, -sqrt_2_over_2)
	normal := m.vector(0, 0, -1)
	light := rt.point_light(m.point(0, 10, -10), rt.White)

	result := rt.lighting(&material, &light, fragment_pos, eye, normal)

	testing.expect(t, m.tuple_eq(result, rt.color(1.6364)))
}

@(test)
lighting_light_behind_surface :: proc(t: ^testing.T) {
	// Scenario: Lighting with the light sitting behind the surface.

	material := rt.material()
	fragment_pos := m.point(0, 0, 0)

	eye := m.vector(0, 0, -1)
	normal := m.vector(0, 0, -1)
	light := rt.point_light(m.point(0, 0, 10), rt.White)

	result := rt.lighting(&material, &light, fragment_pos, eye, normal)

	testing.expect(t, m.tuple_eq(result, rt.color(0.1)))
}
