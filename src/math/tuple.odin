package rtc_math

import "core:fmt"
import "core:simd"

Tuple :: distinct [4]f64

tuple :: proc(x, y, z, w: real) -> Tuple {
	return Tuple{x, y, z, w}
}

tuple_eq :: proc(a, b: Tuple) -> bool {
	delta := b - a

	// https://pkg.odin-lang.org/core/simd/#from_array
	delta_simd := simd.abs(simd.from_array(delta))

	epsilon_simd: #simd[4]real : {EPSILON, EPSILON, EPSILON, EPSILON}

	// https://pkg.odin-lang.org/core/simd/#lanes_gt
	neq_simd := simd.lanes_gt(delta_simd, epsilon_simd)

	result := simd.reduce_max(neq_simd)

	return result == 0
}
