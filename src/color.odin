package rt

import m "math"

// Color

Color :: distinct m.Tuple

Black :: Color{0, 0, 0, 0}
White :: Color{1, 1, 1, 0}

Red :: Color{1, 0, 0, 0}
Green :: Color{0, 1, 0, 0}
Blue :: Color{0, 0, 1, 0}

color_scalar :: proc(v: m.real) -> Color {
	return Color{v, v, v, 0}
}

color_rgb :: proc(r, g, b: m.real) -> Color {
	return Color{r, g, b, 0}
}

color_tuple :: proc(t: $T/m.Tuple) -> Color {
	return Color{t.r, t.g, t.b, 0}
}

color :: proc {
	color_scalar,
	color_rgb,
	color_tuple,
}
