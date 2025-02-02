package rt

import "core:slice"

import m "math"

World :: struct {
	shapes: [dynamic]^Shape,
	light:  Maybe(PointLight),
}

world :: proc() -> World {
	shapes := [dynamic]^Shape{}
	light: Maybe(PointLight) = nil

	return World{shapes, light}
}

world_default :: proc() -> World {
	light := point_light(m.point(-10, 10, -10), White)

	shapes := [dynamic]^Shape{}

	return World{shapes, light}
}

world_free :: proc(world: World) {
	delete(world.shapes)
}

world_intersect_ray :: proc(world: World, ray: Ray) -> [dynamic]Intersection {
	result := [dynamic]Intersection{}

	for shape in world.shapes {
		xs := intersect(shape, ray)
		defer delete(xs)

		for x in xs {
			append(&result, x)
		}
	}

	slice.sort_by_key(result[:], proc(x: Intersection) -> m.real {return x.t})

	return result
}

world_point_is_shadowed :: proc(world: World, point: m.Point) -> bool {
	light := world.light.?

	// Measures the distance from the point to the light source.

	point_to_light := light.position - point

	distance_to_light := m.mag(point_to_light)

	// Creates a shadow ray from the point toward the light source.

	shadow_ray := ray(point, m.norm(point_to_light))

	// Intersects the shadow ray with the world.

	xs := world_intersect_ray(world, shadow_ray)
	defer delete(xs)

	// Checks if the shadow ray hit something before reaching the light.

	hit := hit(xs)

	if hit == nil {
		return false
	} else {
		hit := hit.?
		return hit.t < distance_to_light
	}
}

world_shade_hit :: proc(world: World, x: RayIntersectionResult, remaining: int = 5) -> Color {
	material := x.shape.material
	light := world.light.?

	in_shadow := world_point_is_shadowed(world, x.over_point)

	surface_color := lighting(&material, x.shape, &light, x.over_point, x.eye, x.normal, in_shadow)

	reflected_color := reflected_color(world, x, remaining)

	return surface_color + reflected_color
}

world_color_at :: proc(world: World, ray: Ray, remaining: int = 5) -> Color {
	xs := world_intersect_ray(world, ray)
	defer delete(xs)

	hit := hit(xs)

	if hit == nil {
		return Black
	} else {
		comps := ray_prepare_computations(ray, hit.?)

		color := world_shade_hit(world, comps, remaining)

		return color
	}
}
