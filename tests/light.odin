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
	object := rt.sphere()
	fragment_pos := m.point(0, 0, 0)

	eye := m.vector(0, 0, -1)
	normal := m.vector(0, 0, -1)
	light := rt.point_light(m.point(0, 0, -10), rt.White)

	result := rt.lighting(&material, &object, &light, fragment_pos, eye, normal, false)

	testing.expect(t, result == rt.color(1.9))
}

@(test)
lighting_eye_is_45_between_light_and_surface :: proc(t: ^testing.T) {
	// Scenario: Lighting with the eye between light and surface, eye at 45 deg.

	material := rt.material()
	object := rt.sphere()
	fragment_pos := m.point(0, 0, 0)

	eye := m.vector(0, sqrt_2_over_2, -sqrt_2_over_2)
	normal := m.vector(0, 0, -1)
	light := rt.point_light(m.point(0, 0, -10), rt.White)

	result := rt.lighting(&material, &object, &light, fragment_pos, eye, normal, false)

	testing.expect(t, result == rt.color(1))
}

@(test)
lighting_light_is_45_between_eye_and_surface :: proc(t: ^testing.T) {
	// Scenario: Lighting with the light between eye and surface, light at 45 deg.

	material := rt.material()
	object := rt.sphere()
	fragment_pos := m.point(0, 0, 0)

	eye := m.vector(0, 0, -1)
	normal := m.vector(0, 0, -1)
	light := rt.point_light(m.point(0, 10, -10), rt.White)

	result := rt.lighting(&material, &object, &light, fragment_pos, eye, normal, false)

	testing.expect(t, m.tuple_eq(result, rt.color(0.7364)))
}

@(test)
lighting_eye_aligned_with_light_reflection_vector :: proc(t: ^testing.T) {
	// Scenario: Lighting with the eye aligned with the light reflection vector.

	material := rt.material()
	object := rt.sphere()
	fragment_pos := m.point(0, 0, 0)

	eye := m.vector(0, -sqrt_2_over_2, -sqrt_2_over_2)
	normal := m.vector(0, 0, -1)
	light := rt.point_light(m.point(0, 10, -10), rt.White)

	result := rt.lighting(&material, &object, &light, fragment_pos, eye, normal, false)

	testing.expect(t, m.tuple_eq(result, rt.color(1.6364)))
}

@(test)
lighting_light_behind_surface :: proc(t: ^testing.T) {
	// Scenario: Lighting with the light sitting behind the surface.

	material := rt.material()
	object := rt.sphere()
	fragment_pos := m.point(0, 0, 0)

	eye := m.vector(0, 0, -1)
	normal := m.vector(0, 0, -1)
	light := rt.point_light(m.point(0, 0, 10), rt.White)

	result := rt.lighting(&material, &object, &light, fragment_pos, eye, normal, false)

	testing.expect(t, m.tuple_eq(result, rt.color(0.1)))
}

@(test)
reflected_color_non_reflective_material :: proc(t: ^testing.T) {
	// Scenario: The reflected color for a non-reflective material.

	sphere1 := rt.sphere()
	sphere2 := rt.sphere()

	world := make_sphere_world(&sphere1, &sphere2)
	defer rt.world_free(world)

	ray := rt.ray(m.point(0, 0, 0), m.vector(0, 0, 1))

	// Inner sphere.
	innerSphere := world.shapes[1]
	innerSphere.material.ambient = 1

	intersection := rt.intersection(1, innerSphere)

	comps := rt.ray_prepare_computations(ray, intersection)

	reflected_color := rt.reflected_color(world, comps)

	testing.expect(t, m.tuple_eq(reflected_color, rt.Black))
}

@(test)
reflected_color_reflective_material :: proc(t: ^testing.T) {
	// Scenario: The reflected color for a reflective material.

	sphere1 := rt.sphere()
	sphere2 := rt.sphere()

	world := make_sphere_world(&sphere1, &sphere2)
	defer rt.world_free(world)

	// Configures a semi-reflective ground plane, positioned at Y=-1.

	ground := rt.plane()
	ground.transform = m.mat4_translate(m.vector(0, -1, 0))
	ground.material.reflectivity = 0.5

	append(&world.shapes, &ground)

	// Create a ray that interacts with the world's ground plane and outer sphere.

	ray := rt.ray(m.point(0, 0, -3), m.vector(0, -sqrt_2_over_2, sqrt_2_over_2))

	intersection := rt.intersection(sqrt_2, &ground)

	comps := rt.ray_prepare_computations(ray, intersection)

	// We expect this ray to reflect some of the outer sphere's color (green),
	// as it first hits the semi-reflective ground plane.

	reflected_color := rt.reflected_color(world, comps)

	expected_reflected_color := rt.color(0.19033, 0.23791, 0.14274)

	testing.expect(t, m.tuple_eq(reflected_color, expected_reflected_color))
}

@(test)
reflected_color_limit_recursion :: proc(t: ^testing.T) {
	// Scenario: The reflected color at the maximum recursion depth.

	sphere1 := rt.sphere()
	sphere2 := rt.sphere()

	world := make_sphere_world(&sphere1, &sphere2)
	defer rt.world_free(world)

	ground := rt.plane()
	ground.transform = m.mat4_translate(m.vector(0, -1, 0))
	ground.material.reflectivity = 0.5

	append(&world.shapes, &ground)

	ray := rt.ray(m.point(0, 0, -3), m.vector(0, -sqrt_2_over_2, sqrt_2_over_2))

	intersection := rt.intersection(sqrt_2, &ground)

	comps := rt.ray_prepare_computations(ray, intersection)

	reflected_color := rt.reflected_color(world, comps, 0)

	testing.expect(t, m.tuple_eq(reflected_color, rt.Black))
}
