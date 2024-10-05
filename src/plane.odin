package rt

import "core:math"

import m "math"

Plane :: struct {
	using shape: Shape,
	point:       m.Point,
	direction:   m.Vector,
}

plane_vtable :: ShapeVTable{plane_intersect_local, plane_normal_local}

plane :: proc() -> Plane {
	return Plane{shape_vtable(plane_vtable), m.point(0, 0, 0), m.vector(0, 1, 0)}
}

plane_intersect_local :: proc(shape: ^Shape, local_ray: Ray) -> [dynamic]Intersection {
	plane := transmute(^Plane)shape

	if math.abs(local_ray.direction.y) < m.EPSILON {
		return nil
	}

	t := -local_ray.origin.y / local_ray.direction.y

	intersection := Intersection{t, plane}

	return [dynamic]Intersection{intersection}
}

plane_normal_local :: proc(shape: ^Shape, local_point: m.Point) -> m.Vector {
	plane := transmute(^Plane)shape

	return m.point(0, 1, 0)
}
