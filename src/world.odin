package rt

import "core:slice"

import m "math"

World :: struct {
	objects: [dynamic]Sphere,
	light:   Maybe(PointLight),
}

world :: proc() -> World {
	objects := [dynamic]Sphere{}
	light: Maybe(PointLight) = nil

	return World{objects, light}
}

world_default :: proc() -> World {
	light := point_light(m.point(-10, 10, -10), White)

	sphere1 := sphere()
	sphere1.material.color = color(0.8, 1, 0.6)
	sphere1.material.diffuse = 0.7
	sphere1.material.specular = 0.2

	sphere2 := sphere()
	sphere2.transform = m.mat4_scale(0.5)

	objects := [dynamic]Sphere{sphere1, sphere2}

	return World{objects, light}
}

world_free :: proc(world: World) {
	delete(world.objects)
}

world_intersect_ray :: proc(world: World, ray: Ray) -> [dynamic]Intersection {
	result := [dynamic]Intersection{}

	for &object in world.objects {
		xs := intersect(&object, ray)
		defer delete(xs)

		for x in xs {
			append(&result, x)
		}
	}

	slice.sort_by_key(result[:], proc(x: Intersection) -> m.real {return x.t})

	return result
}

world_shade_hit :: proc(world: World, x: RayIntersectionResult) -> Color {
	material := &x.object.material
	light := world.light.?

	result := lighting(material, &light, x.point, x.eye, x.normal, false)

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
