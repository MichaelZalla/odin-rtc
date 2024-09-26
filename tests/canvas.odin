package tests

import "core:log"
import "core:testing"

import rt "../src"
import m "../src/math"

@(test)
canvas_create :: proc(t: ^testing.T) {
	// Scenario: Creating a canvas.

	c := rt.canvas(10, 20)
	defer rt.canvas_free(c)

	testing.expect(t, c.width == 10)
	testing.expect(t, c.height == 20)

	black := rt.color(0, 0, 0)

	for pixel, i in c.pixels {
		testing.expect(t, m.tuple_eq(pixel, black))
	}
}

@(test)
canvas_read_write_pixels :: proc(t: ^testing.T) {
	// Scenario: Writing pixels to a canvas.

	c := rt.canvas(10, 20)
	defer rt.canvas_free(c)

	red := rt.color(1, 0, 0)

	rt.canvas_pixel_set(&c, 2, 3, red)

	testing.expect(t, m.tuple_eq(rt.canvas_pixel_get(&c, 2, 3), red))
}
