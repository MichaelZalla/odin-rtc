package rt

import log "core:log"
import math "core:math"

import m "math"

intersect_sphere :: proc(sphere: Sphere, ray: Ray) -> (bool, [dynamic]m.real) {
	sphere_to_ray := m.Vector(ray.origin - sphere.center)

	a := m.dot(ray.direction, ray.direction)
	b := m.dot(ray.direction, sphere_to_ray) * 2
	c := m.dot(sphere_to_ray, sphere_to_ray) - 1

	two_a := 2 * a

	discriminant := b * b - 2 * two_a * c

	if discriminant < 0 {
		return false, nil
	}

	discriminant_sqrt := math.sqrt(discriminant)

	r1 := (-b - discriminant_sqrt) / two_a
	r2 := (-b + discriminant_sqrt) / two_a

	return true, [dynamic]m.real{r1, r2}
}

intersect :: proc {
	intersect_sphere,
}
