package rt

import m "math"

// Color

Color :: distinct m.Tuple

color_rgb :: proc(r, g, b: m.real) -> Color {
	return Color{r, g, b, 0}
}

color_tuple :: proc(t: $T/m.Tuple) -> Color {
	return Color{t.r, t.g, t.b, 0}
}

color :: proc {
	color_rgb,
	color_tuple,
}
