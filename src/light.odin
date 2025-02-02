package rt

import math "core:math"

import m "math"

PointLight :: struct {
	position:  m.Point,
	intensity: Color,
}

point_light_position_intensity :: proc(position: m.Point, intensity: Color) -> PointLight {
	return PointLight{position, intensity}
}

point_light_default :: proc() -> PointLight {
	return point_light_position_intensity(m.point(0, 0, 0), White)
}

point_light :: proc {
	point_light_default,
	point_light_position_intensity,
}

lighting :: proc(
	material: ^Material,
	object: ^Shape,
	light: ^PointLight,
	point: m.Point,
	eye: m.Vector,
	normal: m.Vector,
	in_shadow: bool,
) -> Color {
	// Determines the material color at the given point.

	pattern, ok := material.pattern.?

	color: Color

	if ok {
		color = pattern_at_shape(pattern, object, point)
	} else {
		color = material.color
	}

	// Combines the surface color with the light's color (i.e., intensity).
	effective_color := color * light.intensity

	// Finds the direction to the light source.
	point_to_light := light.position - point
	point_to_light_normalized := m.norm(point_to_light)

	// Computes the ambient contribution.
	ambient := effective_color * material.ambient

	// Computes the similarity (cosine) between `light` and the `normal` vectors.
	light_similarity_to_normal := m.dot(point_to_light_normalized, normal)

	diffuse: Color
	specular: Color

	if in_shadow || light_similarity_to_normal < 0 {
		diffuse, specular = Black, Black
	} else {
		// Computes the diffuse contribution.
		diffuse = effective_color * material.diffuse * light_similarity_to_normal

		// Computes the similarity (cosine) between `reflection` and `eye` vectors.
		reflection := m.reflect(-point_to_light_normalized, normal)
		reflection_similarity_to_eye := m.dot(reflection, eye)

		if reflection_similarity_to_eye <= 0 {
			specular = Black
		} else {
			// Computes the specular contribution.
			factor := math.pow(reflection_similarity_to_eye, material.specular_exponent)
			specular = light.intensity * material.specular * factor
		}
	}

	return ambient + diffuse + specular
}

reflected_color :: proc(world: World, x: RayIntersectionResult, remaining: int = 5) -> Color {
	reflectivity := x.shape.material.reflectivity

	if reflectivity == 0 || remaining == 0 {
		return Black
	}

	// Creates a new ray, originating at the hit's location, and pointed in the
	// direction of `reflect`.

	reflected_ray := ray(x.over_point, x.reflect)

	// Finds the color reflected by this reflection ray's next world intersection.

	color := world_color_at(world, reflected_ray, remaining - 1)

	// Attentuates this color by the current shape's (material's) reflectivity.

	return color * reflectivity
}
