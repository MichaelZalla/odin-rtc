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
