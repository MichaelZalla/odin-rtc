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

	point_to_light := light.position - point

	distance := m.mag(point_to_light)

	shadow_ray := ray(point, m.norm(point_to_light))

	xs := world_intersect_ray(world, shadow_ray)
	defer delete(xs)

	hit := hit(xs)

	if hit == nil {
		return false
	} else {
		hit := hit.?
		return hit.t < distance
	}
}

world_shade_hit :: proc(world: World, x: RayIntersectionResult) -> Color {
	material := x.shape.material
	light := world.light.?

	in_shadow := world_point_is_shadowed(world, x.over_point)

	result := lighting(&material, &light, x.over_point, x.eye, x.normal, in_shadow)

	return result
}

world_color_at :: proc(world: World, ray: Ray) -> Color {
	xs := world_intersect_ray(world, ray)
	defer delete(xs)

	hit := hit(xs)

	if hit == nil {
		return Black
	} else {
		comps := ray_prepare_computations(ray, hit.?)

		color := world_shade_hit(world, comps)

		return color
	}
}
