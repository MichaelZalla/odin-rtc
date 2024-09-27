package pit_chapter_04

import linalg "core:math/linalg"

import rt "../../../src"
import fs "../../../src/fs"
import m "../../../src/math"

main :: proc() {
	DIMENSION :: 480
	DIMENSION_OVER_2 :: DIMENSION / 2

	canvas := rt.canvas(DIMENSION, DIMENSION)
	defer rt.canvas_free(canvas)

	get_clock_points_world_space :: proc() -> [dynamic]m.Point {
		points: [dynamic]m.Point

		midnight := m.point(0, 1, 0)

		angle_theta_delta := linalg.TAU / 12

		for i in 0 ..< 12 {
			rotation := m.mat4_rotate_z(angle_theta_delta * f64(i))

			append(&points, rotation * midnight)
		}

		return points
	}

	plot_world_space_point :: proc(c: ^rt.Canvas, p_world: m.Point, color: rt.Color) {
		world_to_screen :: proc(p_world: m.Point) -> m.Point {
			scale_factor := DIMENSION_OVER_2 * 0.75
			scale := m.mat4_scale(m.vector(scale_factor, -scale_factor, 1))
			translation := m.mat4_translate(m.vector(DIMENSION_OVER_2, DIMENSION_OVER_2, 0))

			return translation * scale * p_world
		}

		p_screen := world_to_screen(p_world)

		if p_screen.x > 0 &&
		   int(p_screen.x) < c.width &&
		   p_screen.y > 0 &&
		   int(p_screen.y) < c.height {
			rt.canvas_pixel_set(c, int(p_screen.x), int(p_screen.y), color)
		}
	}

	clock := get_clock_points_world_space()
	defer delete(clock)

	white := rt.color(1, 1, 1)

	for hour in clock {
		plot_world_space_point(&canvas, hour, white)
	}

	path := fs.get_absolute_path("/examples/putting-it-together/chapter-04/clock.ppm")

	success := rt.canvas_to_ppm_file(&canvas, path)
}
