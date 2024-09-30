package rt

import math "core:math"

import m "math"

PointLight :: struct {
	position:  m.Point,
	intensity: Color,
}

point_light :: proc(position: m.Point, intensity: Color) -> PointLight {
	return PointLight{position, intensity}
}

lighting :: proc(
	material: ^Material,
	light: ^PointLight,
	point: m.Point,
	eye: m.Vector,
	normal: m.Vector,
) -> Color {
	// Combines the surface color with the light's color (i.e., intensity).
	effective_color := material.color * light.intensity

	// Finds the direction to the light source.
	point_to_light := light.position - point
	point_to_light_normalized := m.norm(point_to_light)

	// Computes the ambient contribution.
	ambient := effective_color * material.ambient

	// Computes the similarity (cosine) between `light` and the `normal` vectors.
	light_similarity_to_normal := m.dot(point_to_light_normalized, normal)

	diffuse: Color
	specular: Color

	if light_similarity_to_normal < 0 {
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
