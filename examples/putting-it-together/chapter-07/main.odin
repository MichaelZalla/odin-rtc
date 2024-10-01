package pit_chapter_07

import "core:math/linalg"

import rt "../../../src"
import fs "../../../src/fs"
import m "../../../src/math"

PI :: linalg.PI

make_scene_world :: proc() -> rt.World {
	// Ground plane

	ground := rt.sphere()
	ground.transform = m.mat4_scale(m.vector(10, 0.01, 10))

	ground.material.color = rt.color(1, 0.9, 0.9)
	ground.material.specular = 0

	// Left wall

	left_wall := rt.sphere()

	left_wall.transform =
		m.mat4_translate(m.vector(0, 0, 5)) *
		m.mat4_rotate_y(-PI / 4) *
		m.mat4_rotate_x(PI / 2) *
		m.mat4_scale(m.vector(10, 0.01, 10))

	left_wall.material = ground.material

	// Right wall

	right_wall := rt.sphere()

	right_wall.transform =
		m.mat4_translate(m.vector(0, 0, 5)) *
		m.mat4_rotate_y(PI / 4) *
		m.mat4_rotate_x(PI / 2) *
		m.mat4_scale(m.vector(10, 0.01, 10))

	right_wall.material = ground.material

	// Big sphere

	big_sphere := rt.sphere()

	big_sphere.transform = m.mat4_translate(m.vector(-0.5, 1, 0.5))

	big_sphere.material.color = rt.color(0.1, 1, 0.5)
	big_sphere.material.diffuse = 0.7
	big_sphere.material.specular = 0.3

	// Middle sphere

	middle_sphere := rt.sphere()

	middle_sphere.transform = m.mat4_translate(m.vector(1.5, 0.5, -0.5)) * m.mat4_scale(0.5)

	middle_sphere.material.color = rt.color(0.5, 1, 0.1)
	middle_sphere.material.diffuse = 0.7
	middle_sphere.material.specular = 0.3

	// Small sphere

	small_sphere := rt.sphere()

	small_sphere.transform = m.mat4_translate(m.vector(-1.5, 0.33, -0.75)) * m.mat4_scale(0.33)

	small_sphere.material.color = rt.color(1, 0.8, 0.1)
	small_sphere.material.diffuse = 0.7
	small_sphere.material.specular = 0.3

	// World and lighting

	world := rt.world()

	world.light = rt.point_light(m.point(-10, 10, -10), rt.White)

	world.objects = [dynamic]rt.Sphere {
		ground,
		left_wall,
		right_wall,
		big_sphere,
		middle_sphere,
		small_sphere,
	}

	return world
}

make_camera :: proc() -> rt.Camera {
	camera := rt.camera(1080, 720, PI / 2)

	view_position := m.point(0, 1.5, -5)
	target := m.point(0, 1, 0)
	up := m.vector(0, 1, 0)

	camera.transform = rt.look_at(view_position, target, up)

	return camera
}

main :: proc() {
	world := make_scene_world()
	defer rt.world_free(world)

	camera := make_camera()

	canvas := rt.camera_render_world(camera, world)

	path := fs.get_absolute_path("/examples/putting-it-together/chapter-07/scene.ppm")

	rt.canvas_to_ppm_file(&canvas, path)
}
