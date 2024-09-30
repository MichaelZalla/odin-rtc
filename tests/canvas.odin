package tests

import "core:log"
import "core:strings"
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

	for pixel, i in c.pixels {
		testing.expect(t, m.tuple_eq(pixel, rt.Black))
	}
}

@(test)
canvas_read_write_pixels :: proc(t: ^testing.T) {
	// Scenario: Writing pixels to a canvas.

	c := rt.canvas(10, 20)
	defer rt.canvas_free(c)

	rt.canvas_pixel_set(&c, 2, 3, rt.Red)

	testing.expect(t, m.tuple_eq(rt.canvas_pixel_get(&c, 2, 3), rt.Red))
}

@(test)
canvas_ppm_header :: proc(t: ^testing.T) {
	// Scenario: Constructing the PPM header.

	c := rt.canvas(5, 3)
	defer rt.canvas_free(c)

	ppm := rt.canvas_to_ppm_string(&c)
	defer delete(ppm)

	lines := strings.split_lines_n(ppm, 4)
	defer delete(lines)

	testing.expectf(t, strings.compare(lines[0], "P3") == 0, "%v != %v", lines[0], "P3")
	testing.expectf(t, strings.compare(lines[1], "5 3") == 0, "%v != %v", lines[1], "5 3")
	testing.expectf(t, strings.compare(lines[2], "255") == 0, "%v != %v", lines[2], "255")
}

@(test)
canvas_ppm_pixel_data :: proc(t: ^testing.T) {
	// Scenario: Constructing the PPM pixel data.

	c := rt.canvas(5, 3)
	defer rt.canvas_free(c)

	c1 := rt.color(1.5, 0, 0)
	c2 := rt.color(0, 0.5, 0)
	c3 := rt.color(-0.5, 0, 1)

	rt.canvas_pixel_set(&c, 0, 0, c1)
	rt.canvas_pixel_set(&c, 2, 1, c2)
	rt.canvas_pixel_set(&c, 4, 2, c3)

	ppm := rt.canvas_to_ppm_string(&c)
	defer delete(ppm)

	lines := strings.split_lines(ppm)
	defer delete(lines)

	testing.expectf(
		t,
		strings.compare(lines[3], "255 0 0 0 0 0 0 0 0 0 0 0 0 0 0") == 0,
		"%v != %v",
		lines[3],
		"255 0 0 0 0 0 0 0 0 0 0 0 0 0 0",
	)
	testing.expectf(
		t,
		strings.compare(lines[4], "0 0 0 0 0 0 0 128 0 0 0 0 0 0 0") == 0,
		"%v != %v",
		lines[4],
		"0 0 0 0 0 0 0 128 0 0 0 0 0 0 0",
	)
	testing.expectf(
		t,
		strings.compare(lines[5], "0 0 0 0 0 0 0 0 0 0 0 0 0 0 255") == 0,
		"%v != %v",
		lines[5],
		"0 0 0 0 0 0 0 0 0 0 0 0 0 0 255",
	)
}

@(test)
canvas_ppm_max_line_length :: proc(t: ^testing.T) {
	// Scenario: Splitting long lines in PPM files.

	c := rt.canvas(10, 2)
	defer rt.canvas_free(c)

	rt.canvas_fill(&c, rt.color(1, 0.8, 0.6))

	ppm := rt.canvas_to_ppm_string(&c)
	defer delete(ppm)

	lines := strings.split_lines(ppm)
	defer delete(lines)

	testing.expectf(
		t,
		strings.compare(
			lines[3],
			"255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204",
		) ==
		0,
		"%v != %v",
		lines[3],
		"255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204",
	)

	testing.expectf(
		t,
		strings.compare(lines[4], "153 255 204 153 255 204 153 255 204 153 255 204 153") == 0,
		"%v != %v",
		lines[4],
		"153 255 204 153 255 204 153 255 204 153 255 204 153",
	)

	testing.expectf(
		t,
		strings.compare(
			lines[5],
			"255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204",
		) ==
		0,
		"%v != %v",
		lines[5],
		"255 204 153 255 204 153 255 204 153 255 204 153 255 204 153 255 204",
	)

	testing.expectf(
		t,
		strings.compare(lines[6], "153 255 204 153 255 204 153 255 204 153 255 204 153") == 0,
		"%v != %v",
		lines[6],
		"153 255 204 153 255 204 153 255 204 153 255 204 153",
	)
}

@(test)
canvas_ppm_terminates_with_newline :: proc(t: ^testing.T) {
	// Scenario: PPM files are terminated by a newline character.

	c := rt.canvas(5, 3)
	defer rt.canvas_free(c)

	rt.canvas_fill(&c, rt.color(1, 0.8, 0.6))

	ppm := rt.canvas_to_ppm_string(&c)
	defer delete(ppm)

	last_byte := ppm[len(ppm) - 1]

	testing.expect(t, last_byte == '\n')
}
