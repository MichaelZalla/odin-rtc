package rt

import "core:fmt"
import math "core:math"
import os "core:os"
import "core:strings"

import m "math"

Canvas :: struct {
	width:        int,
	height:       int,
	aspect_ratio: m.real,
	center:       m.Point,
	pixels:       []Color,
}

canvas_width_height :: proc(width, height: int) -> Canvas {
	center := m.point(m.real(width) / 2, m.real(height) / 2, 0)

	aspect_ratio := m.real(width) / m.real(height)

	black := color(0, 0, 0)

	pixels := make([]Color, width * height)

	return Canvas{width, height, aspect_ratio, center, pixels}
}

canvas :: proc {
	canvas_width_height,
}

canvas_free :: proc(c: Canvas) {
	delete(c.pixels)
}

canvas_pixel_get :: proc(c: ^Canvas, x, y: int) -> Color {
	index := y * c.width + x

	assert(index < len(c.pixels), "Called canvas_pixel_get() with invalid X or Y coordinate!")

	return c.pixels[index]
}

canvas_pixel_set :: proc(c: ^Canvas, x, y: int, color: Color) {
	index := y * c.width + x

	assert(index < len(c.pixels), "Called canvas_pixel_set() with invalid X or Y coordinate!")

	c.pixels[index] = color
}

canvas_fill :: proc(c: ^Canvas, color: Color) {
	for y in 0 ..< c.height {
		for x in 0 ..< c.width {
			canvas_pixel_set(c, x, y, color)
		}
	}
}

canvas_to_ppm_string :: proc(c: ^Canvas) -> string {
	sb := strings.builder_make()

	// Writes PPM headers.

	strings.write_string(&sb, "P3\n")

	fmt.sbprintf(&sb, "%i %i\n", c.width, c.height)

	strings.write_string(&sb, "255\n")

	// Writes PPM pixel data.

	@(static) PPM_MAX_LINE_LENGTH := 70

	// A row of pixel data is one or more lines of text. Each row must wrap
	// according to `PPM_MAX_LINE_LENGTH`. Lines should not end with whitespace.

	// Rows are separated by newlines.

	chars_written_for_line := 0

	for y in 0 ..< c.height {
		for x in 0 ..< c.width {
			// Reads in 3 color channels.

			pixel := canvas_pixel_get(c, x, y)

			// Maps our floating-point [0..1] value range to the integer range
			// [0, 255]. Any fractional part is truncated (e.g., `27.25f` -> `27`).

			// Integer values are clamped.

			r := int(math.min(255, math.max(0, pixel.r * 256)))
			g := int(math.min(255, math.max(0, pixel.g * 256)))
			b := int(math.min(255, math.max(0, pixel.b * 256)))

			// For each color channel…

			for i in 0 ..< 3 {
				v: int

				// R, G, or B

				if i == 0 do v = r
				else if i == 1 do v = g
				else do v = b

				// Determine how many bytes are needed to represent the mapped value.

				sb2 := strings.builder_make()

				s := fmt.sbprintf(&sb2, "%v", v)
				defer delete(s)

				// All channel values are preceded by a space (` `), except for the
				// first channel (R) for the first pixel in the row.

				precede_with_space := !(x == 0 && i == 0)

				// Here, `total_len` accounts for with-space vs. without-space.

				total_len := len(s) + (precede_with_space ? 1 : 0)

				// Can we fit this channel value (write) on the current line of text?

				if total_len > PPM_MAX_LINE_LENGTH - chars_written_for_line {
					// No. Begin a new line and write the channel value without a space.

					strings.write_byte(&sb, '\n')
					strings.write_string(&sb, s)
					chars_written_for_line = 0
				} else {
					// Here, all written values are preceded by a space, except for the
					// first channel (`R`) of the first pixel in the row.

					if precede_with_space {
						strings.write_byte(&sb, ' ')
					}

					strings.write_string(&sb, s)

					// Accumulate `total_len` into our byte counter.
					chars_written_for_line += total_len
				}
			}
		}

		// All new pixel rows begin a new line of text.

		strings.write_byte(&sb, '\n')
		chars_written_for_line = 0
	}

	result := strings.to_string(sb)

	return result
}

canvas_to_ppm_file :: proc(c: ^Canvas, path: string) -> bool {
	ppm := canvas_to_ppm_string(c)

	bytes := transmute([]u8)ppm

	return os.write_entire_file(path, bytes[:])
}
