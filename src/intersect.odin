package rt

import math "core:math"
import linalg "core:math/linalg"

import m "math"

Intersection :: struct {
	t:      m.real,
	object: ^Sphere,
}

intersection :: proc(t: m.real, object: ^Sphere) -> Intersection {
	return Intersection{t, object}
}

intersections :: proc(intersections: ..Intersection) -> (result: [dynamic]Intersection) {
	for i in intersections {
		append(&result, i)
	}
	return
}

intersect_sphere :: proc(sphere: ^Sphere, ray: Ray) -> [dynamic]Intersection {
	inverse := m.Mat4(linalg.matrix4_inverse(sphere.transform))
	ray2 := ray_transform(ray, inverse)

	// Computes the vector from the sphere's center to the ray's origin.
	sphere_to_ray := m.Vector(ray2.origin - sphere.center)

	a := m.dot(ray2.direction, ray2.direction)
	b := m.dot(ray2.direction, sphere_to_ray) * 2
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

intersect :: proc {
	intersect_sphere,
}
