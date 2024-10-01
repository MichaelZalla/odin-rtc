package rt

import "core:math"
import "core:math/linalg"

import m "math"

Camera :: struct {
	h_size:      int,
	v_size:      int,
	half_width:  m.real,
	half_height: m.real,
	pixel_size:  m.real,
	fov:         m.real,
	transform:   m.Mat4,
}

camera :: proc(h_size: int, v_size: int, fov: m.real) -> Camera {
	half_view := math.tan(fov / 2)

	half_width: m.real
	half_height: m.real

	aspect_ratio := m.real(h_size) / m.real(v_size)

	if aspect_ratio >= 1 {
		// Horizontal aspect ratio.
		half_width = half_view
		half_height = half_view / aspect_ratio
	} else {
		// Vertical aspect ratio.
		half_width = half_view * aspect_ratio
		half_height = half_view
	}

	pixel_size := (half_width * 2) / m.real(h_size)

	return Camera{h_size, v_size, half_width, half_height, pixel_size, fov, 1}
}

camera_ray_for_pixel :: proc(camera: Camera, x: int, y: int) -> Ray {
	// The offset from the edge of the canvas to the pixel's center.
	x_centered := m.real(x) + 0.5
	y_centered := m.real(y) + 0.5

	// Screen to NDC space.
	ndc_x := x_centered * camera.pixel_size
	ndc_y := y_centered * camera.pixel_size

	// The pre-transformed, world-space coordinates of the pixel.
	// Note: Camera looks towards +Z, so -X points to the right!
	world_x := camera.half_width - ndc_x
	world_y := camera.half_height - ndc_y

	// Transform both the ray origin and the canvas point.
	// Note: The canvas sits as z = -1!
	camera_transform_inverse := linalg.inverse(camera.transform)
	origin := camera_transform_inverse * m.point(0, 0, 0)
	point := camera_transform_inverse * m.point(world_x, world_y, -1)

	// Compute the ray's direction.
	direction := m.norm(m.vector(point - origin))

	return Ray{origin, direction}
}

camera_render_world :: proc(camera: Camera, world: World) -> Canvas {
	canvas := canvas(camera.h_size, camera.v_size)

	for y in 0 ..< camera.v_size {
		for x in 0 ..< camera.h_size {
			ray := camera_ray_for_pixel(camera, x, y)

			color := world_color_at(world, ray)

			canvas_pixel_set(&canvas, x, y, color)
		}
	}

	return canvas
}

look_at :: proc(view_position: m.Point, target: m.Point, up: m.Vector) -> m.Mat4 {
	view_position_to_target := m.vector(target - view_position)

	forward := m.norm(view_position_to_target)
	left := m.cross(forward, m.norm(up))
	true_up := m.cross(left, forward)

	orientation := m.Mat4 {
		left.x,
		left.y,
		left.z,
		0,
		true_up.x,
		true_up.y,
		true_up.z,
		0,
		-forward.x,
		-forward.y,
		-forward.z,
		0,
		0,
		0,
		0,
		1,
	}

	translation := m.mat4_translate(m.vector(-view_position))

	return orientation * translation
}
