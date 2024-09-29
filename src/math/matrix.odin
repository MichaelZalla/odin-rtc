package rt_math

import linalg "core:math/linalg"

Mat2 :: distinct matrix[2, 2]real
Mat3 :: distinct matrix[3, 3]real
Mat4 :: distinct matrix[4, 4]real

mat3_eq :: proc(lhs: ^Mat3, rhs: ^Mat3) -> bool {
	dimension :: 3

	for c in 0 ..< dimension {
		for r in 0 ..< dimension {
			difference := rhs[r][c] - lhs[r][c]

			if abs(difference) > EPSILON {
				return false
			}
		}
	}

	return true
}

mat4_eq :: proc(lhs: ^Mat4, rhs: ^Mat4) -> bool {
	dimension :: 4

	for c in 0 ..< dimension {
		for r in 0 ..< dimension {
			difference := rhs[r][c] - lhs[r][c]

			if abs(difference) > EPSILON {
				return false
			}
		}
	}

	return true
}

mat3_submatrix :: proc(a: ^Mat3, row: int, column: int) -> Mat2 {
	dimension :: 3

	result := Mat2{}

	assert(column < dimension && row < dimension)

	mapped_col := 0

	for c in 0 ..< dimension {
		if c == column {
			continue
		}

		mapped_row := 0

		for r in 0 ..< dimension {
			if r == row {
				continue
			}

			result[mapped_col][mapped_row] = a[c][r]

			mapped_row += 1
		}

		mapped_col += 1
	}

	return result
}

mat4_submatrix :: proc(a: ^Mat4, row: int, column: int) -> Mat3 {
	dimension :: 4

	result := Mat3{}

	assert(column < dimension && row < dimension)

	mapped_col := 0

	for c in 0 ..< dimension {
		if c == column {
			continue
		}

		mapped_row := 0

		for r in 0 ..< dimension {
			if r == row {
				continue
			}

			result[mapped_col][mapped_row] = a[c][r]

			mapped_row += 1
		}

		mapped_col += 1
	}

	return result
}

mat3_cofactor :: proc(a: Mat3, row: int, column: int) -> real {
	sign, minor: real

	sign = 1 if (row + column) % 2 == 0 else -1

	minor = linalg.matrix_minor(a, row, column)

	return minor * sign
}

mat4_invertible :: proc(a: Mat4) -> bool {
	determinant := linalg.determinant(a)

	return determinant != 0
}

mat4_translate :: proc(v: Vector) -> Mat4 {
	return Mat4(linalg.matrix4_translate(to_xyz(v)))
}

mat4_scale_uniform :: proc(s: real) -> Mat4 {
	return Mat4(linalg.matrix4_scale([3]real{s, s, s}))
}

mat4_scale_vector :: proc(v: Vector) -> Mat4 {
	return Mat4(linalg.matrix4_scale(to_xyz(v)))
}

mat4_scale :: proc {
	mat4_scale_uniform,
	mat4_scale_vector,
}

mat4_rotate :: proc(axis: Vector, angle_radians: real) -> Mat4 {
	return Mat4(linalg.matrix4_rotate(angle_radians, to_xyz(axis)))
}

mat4_rotate_x :: proc(angle_radians: real) -> Mat4 {
	X_AXIS :: Vector{1, 0, 0, 0}

	return mat4_rotate(X_AXIS, angle_radians)
}

mat4_rotate_y :: proc(angle_radians: real) -> Mat4 {
	Y_AXIS :: Vector{0, 1, 0, 0}

	return mat4_rotate(Y_AXIS, angle_radians)
}

mat4_rotate_z :: proc(angle_radians: real) -> Mat4 {
	Z_AXIS :: Vector{0, 0, 1, 0}

	return mat4_rotate(Z_AXIS, angle_radians)
}

mat4_shear :: proc(x_per_y, x_per_z, y_per_x, y_per_z, z_per_x, z_per_y: real) -> Mat4 {
	return Mat4 {
		//
		1,
		x_per_y,
		x_per_z,
		0,
		//
		y_per_x,
		1,
		y_per_z,
		0,
		//
		z_per_x,
		z_per_y,
		1,
		0,
		//
		0,
		0,
		0,
		1,
	}
}

mat4_reverse_concat :: proc(transforms: [dynamic]Mat4) -> Mat4 {
	identity: Mat4 = 1

	t := identity

	for i in 0 ..< len(transforms) {
		t = transforms[len(transforms) - 1 - i] * t
	}

	return t
}
