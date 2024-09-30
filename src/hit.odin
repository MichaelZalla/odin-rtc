package rt

import m "math"

hit :: proc(xs: [dynamic]Intersection) -> Maybe(Intersection) {
	min_positive_t := max(m.real)

	hit: Maybe(Intersection) = nil

	for x in xs {
		if x.t > 0 && x.t < min_positive_t {
			min_positive_t = x.t
			hit = x
		}
	}

	return hit
}
