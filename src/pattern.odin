package rt

import "core:math"

import m "math"

Pattern :: struct {
	a: Color,
	b: Color,
}

stripe_pattern :: proc(a: Color = White, b: Color = Black) -> Pattern {
	return Pattern{a, b}
}

stripe_color_at :: proc(pattern: ^Pattern, point: m.Point) -> Color {
	modulo := math.remainder(math.floor(point.x), 2.0)

	if m.float_eq(modulo, 0.0) {
		return pattern.a
	}

	return pattern.b
}
