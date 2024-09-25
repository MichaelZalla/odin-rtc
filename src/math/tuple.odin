package rtc_math

import "core:fmt"
import "core:math"
import "core:simd"

Tuple :: distinct [4]f64

tuple_xyzw :: proc(x, y, z, w: real) -> Tuple {
	return Tuple{x, y, z, w}
}

tuple_t :: proc(t: $T/Tuple) -> Tuple {
	return Tuple(t)
}

tuple :: proc {
	tuple_xyzw,
	tuple_t,
}

tuple_eq :: proc(a, b: $T/Tuple) -> bool {
	delta := b - a

	// https://pkg.odin-lang.org/core/simd/#from_array
	delta_simd := simd.abs(simd.from_array(delta))

	epsilon_simd: #simd[4]real : {EPSILON, EPSILON, EPSILON, EPSILON}

	// https://pkg.odin-lang.org/core/simd/#lanes_gt
	neq_simd := simd.lanes_gt(delta_simd, epsilon_simd)

	result := simd.reduce_max(neq_simd)

	return result == 0
}

// Point

Point :: distinct Tuple

point_xyz :: proc(x, y, z: real) -> Point {
	return Point{x, y, z, 1}
}

point_tuple :: proc(t: Tuple) -> Point {
	return Point{t.x, t.y, t.z, 1}
}

point :: proc {
	point_xyz,
	point_tuple,
}

is_point :: proc(t: $T/Tuple) -> bool {
	return float_eq(t.w, 1)
}

// Vector

Vector :: distinct Tuple

vector_xyz :: proc(x, y, z: real) -> Vector {
	return Vector{x, y, z, 0}
}

vector_tuple :: proc(t: Tuple) -> Vector {
	return Vector{t.x, t.y, t.z, 0}
}

vector :: proc {
	vector_xyz,
	vector_tuple,
}

is_vector :: proc(t: $T/Tuple) -> bool {
	return float_eq(t.w, 0)
}

vector_mag :: proc(v: Vector) -> real {
	return math.sqrt(v.x * v.x + v.y * v.y + v.z * v.z)
}

vector_norm :: proc(v: Vector) -> Vector {
	mag := vector_mag(v)

	return vector(v.x / mag, v.y / mag, v.z / mag)
}
