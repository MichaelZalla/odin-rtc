package pit_chapter_05

import linalg "core:math/linalg"

import rt "../../../src"
import fs "../../../src/fs"
import m "../../../src/math"

main :: proc() {
	WIDTH :: 640
	HEIGHT :: 480

	render_circle :: proc(canvas: ^rt.Canvas, sphere: rt.Sphere) {

		world_to_screen :=
			m.mat4_translate(m.vector(m.real(canvas.center.x), m.real(canvas.center.y), 0)) *
			m.mat4_scale(
				m.vector(
					(m.real(canvas.width) / 2) * canvas.aspect_ratio,
					-(m.real(canvas.height) / 2),
					0,
				),
			)

		screen_to_world :=
			m.mat4_scale(
				m.vector(
					1 / (m.real(canvas.width) / 2) * canvas.aspect_ratio,
					1 / -(m.real(canvas.height) / 2),
					0,
				),
			) *
			m.mat4_translate(-m.vector(m.real(canvas.center.x), m.real(canvas.center.y), 0))

		sphere := sphere
		sphere.transform = m.mat4_scale(0.8)

		black := rt.color(0, 0, 0)
		red := rt.color(1, 0, 0)

		for y in 0 ..< HEIGHT {
			for x in 0 ..< WIDTH {
				coord := m.point(m.real(x), m.real(y), -5)

				origin := screen_to_world * coord
				direction := m.vector(0, 0, 1)

				ray := rt.ray(origin, direction)

				xs := rt.intersect(&sphere, ray)
				defer delete(xs)

				hit := rt.hit(xs)

				color := black if hit == nil else red

				rt.canvas_pixel_set(canvas, x, y, color)
			}
		}
	}

	canvas := rt.canvas(WIDTH, HEIGHT)
	defer rt.canvas_free(canvas)

	sphere := rt.sphere()

	render_circle(&canvas, sphere)

	path := fs.get_absolute_path("/examples/putting-it-together/chapter-05/circle.ppm")

	success := rt.canvas_to_ppm_file(&canvas, path)
}
