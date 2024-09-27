package rt_math

import linalg "core:math/linalg"

mat2 :: distinct matrix[2, 2]real
mat3 :: distinct matrix[3, 3]real
mat4 :: distinct matrix[4, 4]real

mat3_eq :: proc(lhs: ^mat3, rhs: ^mat3) -> bool {
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

mat4_eq :: proc(lhs: ^mat4, rhs: ^mat4) -> bool {
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

mat3_submatrix :: proc(a: ^mat3, row: int, column: int) -> mat2 {
	dimension :: 3

	result := mat2{}

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

mat4_submatrix :: proc(a: ^mat4, row: int, column: int) -> mat3 {
	dimension :: 4

	result := mat3{}

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

mat3_cofactor :: proc(a: mat3, row: int, column: int) -> real {
	sign, minor: real

	sign = 1 if (row + column) % 2 == 0 else -1

	minor = linalg.matrix_minor(a, row, column)

	return minor * sign
}

mat4_invertible :: proc(a: mat4) -> bool {
	determinant := linalg.determinant(a)

	return determinant != 0
}
