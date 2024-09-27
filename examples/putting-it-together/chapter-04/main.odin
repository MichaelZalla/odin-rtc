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
		reflect_over_x := m.mat4_scale(m.vector(1, -1, 1))
		reflect_over_y := m.mat4_scale(m.vector(-1, 1, 1))

		twelve := m.point(0, 1, 0)
		six := reflect_over_x * twelve
		three := m.point(1, 0, 0)
		nine := reflect_over_y * three

		ANGLE_DELTA :: linalg.TAU / 12
		rotate_hour_clockwise := m.mat4_rotate_z(-ANGLE_DELTA)

		one := rotate_hour_clockwise * twelve
		five := reflect_over_x * one
		eleven := reflect_over_y * one
		seven := reflect_over_x * eleven

		two := rotate_hour_clockwise * rotate_hour_clockwise * twelve
		four := reflect_over_x * two
		ten := reflect_over_y * two
		eight := reflect_over_x * ten

		return [dynamic]m.Point {
			one,
			two,
			three,
			four,
			five,
			six,
			seven,
			eight,
			nine,
			ten,
			eleven,
			twelve,
		}
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
