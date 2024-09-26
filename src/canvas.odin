package rt

Canvas :: struct {
	width:  int,
	height: int,
	pixels: []Color,
}

canvas_width_height :: proc(width, height: int) -> Canvas {
	black := color(0, 0, 0)

	pixels := make([]Color, width * height)

	return Canvas{width, height, pixels}
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
