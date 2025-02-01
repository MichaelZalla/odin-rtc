#+feature dynamic-literals

package pit_chapter_09

import "core:math/linalg"

import rt "../../../src"
import fs "../../../src/fs"
import m "../../../src/math"

PI :: linalg.PI

ground: rt.Plane
left_wall: rt.Plane
right_wall: rt.Plane

big_sphere: rt.Sphere
middle_sphere: rt.Sphere
small_sphere: rt.Sphere

make_scene_world :: proc() -> rt.World {
	world := rt.world()

	world.light = rt.point_light(m.point(-10, 5, -7), rt.White)

	return world
}

make_camera :: proc() -> rt.Camera {
	camera := rt.camera(1600, 900, PI / 2)

	view_position := m.point(0, 0, -3.25)
	target := m.point(0.25, 0, 0)
	up := m.vector(0, 1, 0)

	camera.transform = rt.look_at(view_position, target, up)

	return camera
}

main :: proc() {
	world := make_scene_world()
	defer rt.world_free(world)

	// Ground plane
	ground = rt.plane()
	ground.transform = m.mat4_translate(m.vector(0, -1, 0))
	ground.material.color = rt.color(1, 0.9, 0.9)
	ground.material.specular = 0

	// Left wall
	left_wall = rt.plane()
	left_wall.transform =
		m.mat4_translate(m.vector(0, -1, 5)) * m.mat4_rotate_y(PI / 4) * m.mat4_rotate_z(PI / 2)
	left_wall.material = ground.material

	// Right wall
	right_wall = rt.plane()
	right_wall.transform =
		m.mat4_translate(m.vector(0, -1, 5)) * m.mat4_rotate_y(-PI / 4) * m.mat4_rotate_z(PI / 2)
	right_wall.material = ground.material

	// Big sphere
	big_sphere = rt.sphere()
	big_sphere.transform = m.mat4_translate(m.vector(-0.5, 1 - 1, 0.5))
	big_sphere.material.color = rt.color(0.1, 1, 0.5)
	big_sphere.material.diffuse = 0.7
	big_sphere.material.specular = 0.3

	// Middle sphere
	middle_sphere = rt.sphere()
	middle_sphere.transform = m.mat4_translate(m.vector(1.5, 0.5 - 1, -0.5)) * m.mat4_scale(0.5)
	middle_sphere.material.color = rt.color(0.5, 1, 0.1)
	middle_sphere.material.diffuse = 0.7
	middle_sphere.material.specular = 0.3

	// Small sphere
	small_sphere = rt.sphere()
	small_sphere.transform = m.mat4_translate(m.vector(-1.5, 0.33 - 1, -0.3)) * m.mat4_scale(0.33)
	small_sphere.material.color = rt.color(1, 0.8, 0.1)
	small_sphere.material.diffuse = 0.7
	small_sphere.material.specular = 0.3

	world.shapes = [dynamic]^rt.Shape {
		&ground,
		&left_wall,
		&right_wall,
		&big_sphere,
		&middle_sphere,
		&small_sphere,
	}

	camera := make_camera()

	canvas := rt.camera_render_world(camera, world)

	path := fs.get_absolute_path("/examples/putting-it-together/chapter-09/scene-with-planes.ppm")

	s := rt.canvas_to_ppm_string(&canvas)

	rt.canvas_to_ppm_file(&canvas, path)
}
