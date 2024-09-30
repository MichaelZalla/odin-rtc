package rt

import linalg "core:math/linalg"

import m "math"

Sphere :: struct {
	center:    m.Point,
	radius:    m.real,
	transform: m.Mat4,
	material:  Material,
}

sphere :: proc() -> Sphere {
	return Sphere{m.point(0, 0, 0), 1, 1, material()}
}

sphere_normal_at :: proc(sphere: ^Sphere, point: m.Point) -> m.Vector {
	// Note: Assumes that `point` does in fact sit on the sphere's surface.
	// Note: Assumes that `sphere` is centered at the origin in object space.

	point_object_space := linalg.matrix4_inverse(sphere.transform) * point

	normal_object_space := m.norm(point_object_space - m.point(0, 0, 0))

	normal_world_space := linalg.matrix4_inverse_transpose(sphere.transform) * normal_object_space

	normal_world_space.w = 0

	return m.norm(normal_world_space)
}
