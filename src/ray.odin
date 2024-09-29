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
