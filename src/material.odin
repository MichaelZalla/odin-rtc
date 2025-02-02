package rt

import m "math"

Material :: struct {
	color:             Color,
	pattern:           Maybe(^Pattern),
	ambient:           m.real,
	diffuse:           m.real,
	specular:          m.real,
	specular_exponent: m.real,
	reflectivity:      m.real,
}

material :: proc(
	color: Color = White,
	pattern: Maybe(^Pattern) = nil,
	ambient: m.real = 0.1,
	diffuse: m.real = 0.9,
	specular: m.real = 0.9,
	specular_exponent: m.real = 200.0,
	reflectivity: m.real = 0.0,
) -> Material {
	return Material{color, pattern, ambient, diffuse, specular, specular_exponent, reflectivity}
}
