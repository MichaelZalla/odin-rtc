package rt

import m "math"

Ray :: struct {
	origin:    m.Point,
	direction: m.Vector,
}

ray :: proc(origin: m.Point, direction: m.Vector) -> Ray {
	return Ray{origin, direction}
}

position :: proc(ray: Ray, t: m.real) -> m.Point {
	return ray.origin + m.Point(ray.direction * t)
}

ray_transform :: proc(ray: Ray, transform: m.Mat4) -> Ray {
	return Ray{transform * ray.origin, transform * ray.direction}
}

RayIntersectionResult :: struct {
	point:      m.Point,
	over_point: m.Point,
	eye:        m.Vector,
	normal:     m.Vector,
	t:          m.real,
	object:     ^Sphere,
	inside:     bool,
}

ray_prepare_computations :: proc(ray: Ray, intersection: Intersection) -> RayIntersectionResult {
	point := position(ray, intersection.t)
	eye := -ray.direction
	normal := sphere_normal_at(intersection.object, point)
	inside := m.dot(eye, normal) < 0

	if inside {
		normal = -normal
	}

	over_point := point + normal * m.EPSILON

	return RayIntersectionResult {
		point,
		over_point,
		eye,
		normal,
		intersection.t,
		intersection.object,
		inside,
	}
}
