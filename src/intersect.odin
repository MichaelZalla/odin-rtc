package rt

import math "core:math"
import linalg "core:math/linalg"

import m "math"

Intersection :: struct {
	t:     m.real,
	shape: ^Sphere,
}

intersection :: proc(t: m.real, shape: ^Sphere) -> Intersection {
	return Intersection{t, shape}
}

intersections :: proc(intersections: ..Intersection) -> (result: [dynamic]Intersection) {
	for i in intersections {
		append(&result, i)
	}
	return
}

intersect_sphere_world :: proc(sphere: ^Sphere, ray: Ray) -> [dynamic]Intersection {
	inverse := m.Mat4(linalg.matrix4_inverse(sphere.transform))

	ray_object_space := ray_transform(ray, inverse)

	return intersect_sphere_object(sphere, ray_object_space)
}

intersect_sphere_object :: proc(sphere: ^Sphere, ray: Ray) -> [dynamic]Intersection {
	// Computes the vector from the sphere's center to the ray's origin.
	sphere_to_ray := m.Vector(ray.origin - sphere.center)

	a := m.dot(ray.direction, ray.direction)
	b := m.dot(ray.direction, sphere_to_ray) * 2
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
	intersect_sphere_world,
}
