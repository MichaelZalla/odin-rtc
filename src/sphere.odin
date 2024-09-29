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

sphere_normal_at :: proc(sphere: ^Sphere, point: m.Point) -> m.Vector {
	// Note: Assumes that `point` does in fact sit on the sphere's surface.

	return m.norm(point - sphere.center)
}
