package rt

import m "math"

Sphere :: struct {
	center:    m.Point,
	radius:    m.real,
	transform: m.Mat4,
}

sphere :: proc() -> Sphere {
	return Sphere{m.point(0, 0, 0), 1, 1}
}
