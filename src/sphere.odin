package rt

import "core:math"
import linalg "core:math/linalg"

import m "math"

Sphere :: struct {
	using shape: Shape,
	center:      m.Point,
	radius:      m.real,
}

sphere_vtable :: ShapeVTable{sphere_intersect_local, sphere_normal_local}

sphere :: proc() -> Sphere {
	return Sphere{shape_vtable(sphere_vtable), m.point(0, 0, 0), 1}
}

sphere_intersect_local :: proc(shape: ^Shape, local_ray: Ray) -> [dynamic]Intersection {
	sphere := transmute(^Sphere)shape

	// Computes the vector from the sphere's center to the ray's origin.
	sphere_to_ray := m.Vector(local_ray.origin - sphere.center)

	a := m.dot(local_ray.direction, local_ray.direction)
	b := m.dot(local_ray.direction, sphere_to_ray) * 2
	c := m.dot(sphere_to_ray, sphere_to_ray) - 1

	two_a := 2 * a

	discriminant := b * b - 2 * two_a * c

	if discriminant < 0 {
		return nil
	}

	discriminant_sqrt := math.sqrt(discriminant)

	r1 := (-b - discriminant_sqrt) / two_a
	r2 := (-b + discriminant_sqrt) / two_a

	i1 := Intersection{r1, sphere}
	i2 := Intersection{r2, sphere}

	return [dynamic]Intersection{i1, i2}
}

sphere_normal_local :: proc(shape: ^Shape, local_point: m.Point) -> m.Vector {
	sphere := transmute(^Sphere)shape

	// Note: Assumes that `point` does in fact sit on the sphere's surface.
	// Note: Assumes that `sphere` is centered at the origin in its local space.

	return m.norm(local_point - m.point(0, 0, 0))
}
