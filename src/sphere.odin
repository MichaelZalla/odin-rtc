package rt

import m "math"

Sphere :: struct {
	center: m.Point,
	radius: m.real,
}

sphere :: proc() -> Sphere {
	return Sphere{m.point(0, 0, 0), 1}
}
