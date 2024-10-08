package tests

import "core:testing"

import rt "../src"
import m "../src/math"

make_sphere_world :: proc(sphere1: ^rt.Sphere, sphere2: ^rt.Sphere) -> rt.World {
	sphere1.material.color = rt.color(0.8, 1, 0.6)
	sphere1.material.diffuse = 0.7
	sphere1.material.specular = 0.2

	sphere2.transform = m.mat4_scale(0.5)

	world := rt.world_default()

	append(&world.shapes, sphere1)
	append(&world.shapes, sphere2)

	return world
}

@(test)
world_create :: proc(t: ^testing.T) {
	// Scenario: Creating a world.

	w := rt.world()
	defer rt.world_free(w)

	testing.expect(t, len(w.shapes) == 0)
	testing.expect(t, w.light == nil)
}

@(test)
world_default :: proc(t: ^testing.T) {
	// Scenario: The default world.

	light := rt.point_light(m.point(-10, 10, -10), rt.White)

	default_world := rt.world_default()
	defer rt.world_free(default_world)

	testing.expect(t, len(default_world.shapes) == 0)

	testing.expect(t, default_world.light != nil)

	testing.expect(t, default_world.light == light)
}

@(test)
world_intersect_ray :: proc(t: ^testing.T) {
	// Scenario: Intersecting a world with a ray.

	sphere1 := rt.sphere()
	sphere2 := rt.sphere()

	world := make_sphere_world(&sphere1, &sphere2)
	defer rt.world_free(world)

	ray := rt.ray(m.point(0, 0, -5), m.vector(0, 0, 1))

	xs := rt.world_intersect_ray(world, ray)
	defer delete(xs)

	testing.expect(t, len(xs) == 4)

	testing.expect(t, xs[0].t == 4)
	testing.expect(t, xs[1].t == 4.5)
	testing.expect(t, xs[2].t == 5.5)
	testing.expect(t, xs[3].t == 6)
}

@(test)
world_shade_hit_outside :: proc(t: ^testing.T) {
	// Scenario: Shading an intersection between a ray and our world's objects.
	// Note: The ray (eye) sits outside of the object being intersected.

	sphere1 := rt.sphere()
	sphere2 := rt.sphere()

	world := make_sphere_world(&sphere1, &sphere2)
	defer rt.world_free(world)

	ray := rt.ray(m.point(0, 0, -5), m.vector(0, 0, 1))
	object := world.shapes[0]

	intersection := rt.intersection(4, object)

	comps := rt.ray_prepare_computations(ray, intersection)

	color := rt.world_shade_hit(world, comps)
	expected_color := rt.color(0.38066, 0.47583, 0.2855)

	testing.expect(t, m.tuple_eq(color, expected_color))
}

@(test)
world_shade_hit_inside :: proc(t: ^testing.T) {
	// Scenario: Shading an intersection between a ray and our world's objects.
	// Note: The ray (eye) sits inside of the object being intersected; as a
	// result, the normal returned by `ray_prepare_computations()` is flipped.

	sphere1 := rt.sphere()
	sphere2 := rt.sphere()

	world := make_sphere_world(&sphere1, &sphere2)
	defer rt.world_free(world)

	world.light = rt.point_light(m.point(0, 0.25, 0), rt.White)

	ray := rt.ray(m.point(0, 0, 0), m.vector(0, 0, 1))
	object := world.shapes[1]

	intersection := rt.intersection(0.5, object)

	comps := rt.ray_prepare_computations(ray, intersection)

	color := rt.world_shade_hit(world, comps)
	expected_color := rt.color(0.90498, 0.90498, 0.90498)

	testing.expect(t, m.tuple_eq(color, expected_color))
}

@(test)
world_shade_hit_shadow :: proc(t: ^testing.T) {
	// Scenario: `world_shadow_hit()` is passed a hit that is in shadow.

	world := rt.world()
	defer rt.world_free(world)

	world.light = rt.point_light(m.point(0, 0, -10), rt.White)

	s1 := rt.sphere()

	s2 := rt.sphere()
	s2.transform = m.mat4_translate(m.vector(0, 0, 10))

	append(&world.shapes, &s1)
	append(&world.shapes, &s2)

	ray := rt.ray(m.point(0, 0, 5), m.vector(0, 0, 1))

	intersection := rt.intersection(4, &s2)

	comps := rt.ray_prepare_computations(ray, intersection)

	sample := rt.world_shade_hit(world, comps)

	testing.expect(t, m.tuple_eq(sample, rt.color(0.1, 0.1, 0.1)))
}

@(test)
world_color_at_miss :: proc(t: ^testing.T) {
	// Scenario: The color when a ray misses.

	sphere1 := rt.sphere()
	sphere2 := rt.sphere()

	world := make_sphere_world(&sphere1, &sphere2)
	defer rt.world_free(world)

	ray := rt.ray(m.point(0, 0, -5), m.vector(0, 1, 0))

	color := rt.world_color_at(world, ray)

	testing.expect(t, color == rt.Black)
}

@(test)
world_color_at_hit :: proc(t: ^testing.T) {
	// Scenario: The color when a ray hits.

	sphere1 := rt.sphere()
	sphere2 := rt.sphere()

	world := make_sphere_world(&sphere1, &sphere2)
	defer rt.world_free(world)

	ray := rt.ray(m.point(0, 0, -5), m.vector(0, 0, 1))

	color := rt.world_color_at(world, ray)

	testing.expect(t, m.tuple_eq(color, rt.color(0.38066, 0.47583, 0.2855)))
}

@(test)
world_color_at_hit_between_objects :: proc(t: ^testing.T) {
	// Scenario: The color when a ray hits, and there is also an intersection
	// with an object sitting behind the ray.

	sphere1 := rt.sphere()
	sphere2 := rt.sphere()

	world := make_sphere_world(&sphere1, &sphere2)
	defer rt.world_free(world)

	outer := world.shapes[0]
	outer.material.ambient = 1

	inner := world.shapes[1]
	inner.material.ambient = 1

	ray := rt.ray(m.point(0, 0, 0.75), m.vector(0, 0, -1))

	color := rt.world_color_at(world, ray)

	testing.expect(t, m.tuple_eq(color, inner.material.color))
}
