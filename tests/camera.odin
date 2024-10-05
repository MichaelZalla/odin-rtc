package tests

import math "core:math"
import "core:math/linalg"
import "core:testing"

import rt "../src"
import m "../src/math"

PI_OVER_2 :: linalg.PI / 2

@(test)
camera_create :: proc(t: ^testing.T) {
	// Scenario: Constructing a camera.

	h_size, v_size := 160, 120

	fov := PI_OVER_2 // 90 degree FOV

	camera := rt.camera(h_size, v_size, fov)

	testing.expect(t, camera.h_size == 160)
	testing.expect(t, camera.v_size == 120)
	testing.expect(t, camera.fov == PI_OVER_2)
	testing.expect(t, camera.transform == 1)
}

@(test)
camera_aspect_ratio_horizontal :: proc(t: ^testing.T) {
	// Scenario: The pixel size for a horizontal canvas.

	camera := rt.camera(200, 125, PI_OVER_2)

	testing.expect(t, m.float_eq(camera.pixel_size, 0.01))
}

@(test)
camera_aspect_ratio_vertical :: proc(t: ^testing.T) {
	// Scenario: The pixel size for a vertical canvas.

	camera := rt.camera(125, 200, PI_OVER_2)

	testing.expect(t, m.float_eq(camera.pixel_size, 0.01))
}

@(test)
camera_cast_ray_center :: proc(t: ^testing.T) {
	// Scenario: Constructing a ray through the center of the canvas.

	camera := rt.camera(201, 101, PI_OVER_2)
	ray := rt.camera_ray_for_pixel(camera, 100, 50)

	testing.expect(t, m.tuple_eq(ray.origin, m.point(0, 0, 0)))
	testing.expect(t, m.tuple_eq(ray.direction, m.vector(0, 0, -1)))
}

@(test)
camera_cast_ray_corner :: proc(t: ^testing.T) {
	// Scenario: Constructing a ray through the center of the canvas.

	camera := rt.camera(201, 101, PI_OVER_2)
	ray := rt.camera_ray_for_pixel(camera, 0, 0)

	testing.expect(t, m.tuple_eq(ray.origin, m.point(0, 0, 0)))
	testing.expect(t, m.tuple_eq(ray.direction, m.vector(0.66519, 0.33259, -0.66851)))
}

@(test)
camera_cast_ray_transformed :: proc(t: ^testing.T) {
	// Scenario: Constructing a ray when a camera is transformed.

	camera := rt.camera(201, 101, PI_OVER_2)
	camera.transform = m.mat4_rotate_y(linalg.PI / 4) * m.mat4_translate(m.vector(0, -2, 5))

	ray := rt.camera_ray_for_pixel(camera, 100, 50)

	testing.expect(t, m.tuple_eq(ray.origin, m.point(0, 2, -5)))
	testing.expect(t, m.tuple_eq(ray.direction, m.vector(sqrt_2_over_2, 0, -sqrt_2_over_2)))
}

@(test)
camera_render_world :: proc(t: ^testing.T) {
	// Scenario: Rendering a world through a given camera.

	sphere1 := rt.sphere()
	sphere2 := rt.sphere()

	world := make_sphere_world(&sphere1, &sphere2)
	defer rt.world_free(world)

	camera := rt.camera(11, 11, PI_OVER_2)

	view_position := m.point(0, 0, -5)
	target := m.point(0, 0, 0)
	up := m.vector(0, 1, 0)

	camera.transform = rt.look_at(view_position, target, up)

	canvas := rt.camera_render_world(camera, world)
	defer rt.canvas_free(canvas)

	sample := rt.canvas_pixel_get(&canvas, 5, 5)
	expected_sample := rt.color(0.38066, 0.47583, 0.2855)

	testing.expect(t, m.tuple_eq(sample, expected_sample))
}

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
