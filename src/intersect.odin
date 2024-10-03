package rt

import math "core:math"
import linalg "core:math/linalg"

import m "math"

Intersection :: struct {
	t:     m.real,
	shape: ^Shape,
}

intersection :: proc(t: m.real, shape: ^Shape) -> Intersection {
	return Intersection{t, shape}
}

intersections :: proc(intersections: ..Intersection) -> (result: [dynamic]Intersection) {
	for i in intersections {
		append(&result, i)
	}
	return
}

shape_intersect :: proc(shape: ^Shape, ray: Ray) -> [dynamic]Intersection {
	local_ray := ray_transform(ray, m.Mat4(linalg.inverse(shape.transform)))

	shape.last_local_ray = local_ray

	return shape.vtable.intersect_local(shape, local_ray)
}

intersect :: proc {
	shape_intersect,
}
