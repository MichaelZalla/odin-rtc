package rt

import "core:math"
import linalg "core:math/linalg"

import m "math"

Pattern :: struct {
	transform: m.Mat4,
	a:         Color,
	b:         Color,
}

stripe_pattern :: proc(a: Color = White, b: Color = Black) -> Pattern {
	return Pattern{1, a, b}
}

stripe_color_at :: proc(pattern: ^Pattern, point: m.Point) -> Color {
	modulo := math.remainder(math.floor(point.x), 2.0)

	if m.float_eq(modulo, 0.0) {
		return pattern.a
	}

	return pattern.b
}

stripe_color_at_object :: proc(pattern: ^Pattern, object: ^Shape, point: m.Point) -> Color {
	world_to_object := linalg.inverse_transpose(object.transform)
	object_to_pattern := linalg.inverse_transpose(pattern.transform)

	object_point := point * world_to_object
	pattern_point := object_point * object_to_pattern

	return stripe_color_at(pattern, pattern_point)
}
