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

@(test)
point_shadow_shape_not_in_shadow_path_1 :: proc(t: ^testing.T) {
	// Scenario: A sphere sits outside of the point's shadow path.

	world := rt.world_default()
	defer rt.world_free(world)

	p := m.point(0, 10, 0)

	testing.expect(t, rt.world_point_is_shadowed(world, p) == false)
}

@(test)
point_shadow_shape_not_in_shadow_path_2 :: proc(t: ^testing.T) {
	// Scenario: The light sits between the point and a sphere.

	world := rt.world_default()
	defer rt.world_free(world)

	p := m.point(-20, 20, -20)

	testing.expect(t, rt.world_point_is_shadowed(world, p) == false)
}

@(test)
point_shadow_shape_not_in_shadow_path_3 :: proc(t: ^testing.T) {
	// Scenario: A point sits between the light and a sphere.

	world := rt.world_default()
	defer rt.world_free(world)

	p := m.point(-2, 2, -2)

	testing.expect(t, rt.world_point_is_shadowed(world, p) == false)
}

@(test)
point_shadow_shape_in_shadow_path :: proc(t: ^testing.T) {
	// Scenario: A sphere sits between the point and the light.

	world := rt.world_default()
	defer rt.world_free(world)

	p := m.point(10, -10, 10)

	testing.expect(t, rt.world_point_is_shadowed(world, p))
}
