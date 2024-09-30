package rt

import m "math"

Material :: struct {
	color:             Color,
	ambient:           m.real,
	diffuse:           m.real,
	specular:          m.real,
	specular_exponent: m.real,
}

material :: proc(
	color: Color = White,
	ambient: m.real = 0.1,
	diffuse: m.real = 0.9,
	specular: m.real = 0.9,
	specular_exponent: m.real = 200.0,
) -> Material {
	return Material{color, ambient, diffuse, specular, specular_exponent}
}
