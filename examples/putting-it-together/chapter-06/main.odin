package pit_chapter_06

import "core:fmt"
import linalg "core:math/linalg"

import rt "../../../src"
import fs "../../../src/fs"
import m "../../../src/math"

main :: proc() {
	Canvas_Size :: 2048

	render_sphere_phong_lighting :: proc(
		canvas: ^rt.Canvas,
		sphere: rt.Sphere,
		light: ^rt.PointLight,
	) {

		world_to_screen :=
			m.mat4_translate(m.vector(m.real(canvas.center.x), m.real(canvas.center.y), 0)) *
			m.mat4_scale(
				m.vector(
					(m.real(canvas.width) / 2) * canvas.aspect_ratio,
					-(m.real(canvas.height) / 2),
					1,
				),
			)

		screen_to_world :=
			m.mat4_scale(
				m.vector(
					1 / (m.real(canvas.width) / 2) * canvas.aspect_ratio,
					1 / -(m.real(canvas.height) / 2),
					1,
				),
			) *
			m.mat4_translate(-m.vector(m.real(canvas.center.x), m.real(canvas.center.y), 0))

		sphere, light := sphere, light

		Wall_Z :: 10
		Wall_Size :: 4

		ray_origin := m.point(0, 0, -5)

		for y in 0 ..< canvas.height {
			for x in 0 ..< canvas.width {

				coord := screen_to_world * m.point(m.real(x), m.real(y), Wall_Z)
				coord.x *= Wall_Size
				coord.y *= Wall_Size

				direction := m.norm(coord - ray_origin)
				ray := rt.ray(ray_origin, direction)

				xs := rt.intersect(&sphere, ray)
				defer delete(xs)

				hit := rt.hit(xs)

				color: rt.Color

				if hit != nil {
					hit_unwrapped := hit.?
					t := hit_unwrapped.t
					object := hit_unwrapped.object

					point := rt.position(ray, t)
					normal := rt.sphere_normal_at(object, point)
					eye := -ray.direction

					color = rt.lighting(&object.material, light, point, eye, normal)
				} else {
					color = rt.Black
				}

				rt.canvas_pixel_set(canvas, x, y, color)
			}
		}
	}

	canvas := rt.canvas(Canvas_Size, Canvas_Size)
	defer rt.canvas_free(canvas)

	sphere := rt.sphere()
	sphere.material.color = rt.color(1, 0.2, 1)

	light := rt.point_light(m.point(-10, 10, -10), rt.White)

	render_sphere_phong_lighting(&canvas, sphere, &light)

	path := fs.get_absolute_path(
		"/examples/putting-it-together/chapter-06/sphere-phong-lighting.ppm",
	)

	success := rt.canvas_to_ppm_file(&canvas, path)
}
