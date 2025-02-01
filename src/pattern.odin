package rt

import "core:math"
import linalg "core:math/linalg"

import m "math"

PatternVTable :: struct {
	color_at: proc(pattern: ^Pattern, point: m.Point) -> Color,
}

Pattern :: struct {
	transform: m.Mat4,
	vtable:    PatternVTable,
}

pattern_transform_vtable :: proc(transform: m.Mat4, vtable: PatternVTable) -> Pattern {
	return Pattern{transform, vtable}
}

pattern_vtable :: proc(vtable: PatternVTable) -> Pattern {
	return Pattern{1, vtable}
}

pattern_default_vtable := PatternVTable{proc(pattern: ^Pattern, point: m.Point) -> Color {
		return Color{point.x, point.y, point.z, 0}
	}}

pattern_default :: proc() -> Pattern {
	return Pattern{1, pattern_default_vtable}
}

pattern :: proc {
	pattern_transform_vtable,
	pattern_vtable,
	pattern_default,
}

pattern_at_shape :: proc(pattern: ^Pattern, shape: ^Shape, point: m.Point) -> Color {
	world_to_object := linalg.inverse_transpose(shape.transform)
	object_to_pattern := linalg.inverse_transpose(pattern.transform)

	object_point := point * world_to_object
	pattern_point := object_point * object_to_pattern

	return pattern.vtable.color_at(pattern, pattern_point)
}

ColorPattern :: struct {
	using pattern: Pattern,
	a, b:          Color,
}

color_pattern_vtable_colors :: proc(
	color_at: proc(pattern: ^Pattern, point: m.Point) -> Color,
	a: Color,
	b: Color,
) -> ColorPattern {
	vtable := PatternVTable{color_at}

	pattern := Pattern{1, vtable}

	return ColorPattern{pattern, a, b}
}

stripe_pattern :: proc(a: Color = White, b: Color = Black) -> ColorPattern {
	return color_pattern_vtable_colors(proc(pattern: ^Pattern, point: m.Point) -> Color {
			stripe_pattern := transmute(^ColorPattern)pattern

			modulo := math.remainder(math.floor(point.x), 2.0)

			if m.float_eq(modulo, 0.0) {
				return stripe_pattern.a
			}

			return stripe_pattern.b
		}, a, b)
}

linear_gradient_pattern :: proc(a: Color = White, b: Color = Black) -> ColorPattern {
	return color_pattern_vtable_colors(proc(pattern: ^Pattern, point: m.Point) -> Color {
			gradient_pattern := transmute(^ColorPattern)pattern

			alpha := point.x - math.floor(point.x)

			return m.lerp(gradient_pattern.a, gradient_pattern.b, alpha)
		}, a, b)
}
