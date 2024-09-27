package tests_math

import intrinsics "base:intrinsics"
import "core:log"
import linalg "core:math/linalg"
import "core:testing"

import m "../../src/math"

PI_OVER_2 :: linalg.PI / 2
PI_OVER_4 :: linalg.PI / 4

SQRT_2_OVER_2 :: linalg.SQRT_TWO / 2

@(test)
make_mat4 :: proc(t: ^testing.T) {
	// Scenario: Constructing and inspecting a 4x4 matrix.

	a := m.mat4{1, 2, 3, 4, 5.5, 6.5, 7.5, 8.5, 9, 10, 11, 12, 13.5, 14.5, 15.5, 16.5}

	testing.expect(t, a[0, 3] == 4)
	testing.expect(t, a[1, 0] == 5.5)
	testing.expect(t, a[1, 2] == 7.5)
	testing.expect(t, a[2, 2] == 11)
	testing.expect(t, a[3, 0] == 13.5)
	testing.expect(t, a[3, 2] == 15.5)
}

@(test)
make_mat2 :: proc(t: ^testing.T) {
	// Scenario: Represent a 2x2 matrix.

	a := m.mat2{-3, 5, 1, -2}

	testing.expect(t, a[0, 0] == -3)
	testing.expect(t, a[0, 1] == 5)
	testing.expect(t, a[1, 0] == 1)
	testing.expect(t, a[1, 1] == -2)
}

@(test)
make_mat3 :: proc(t: ^testing.T) {
	// Scenario: Represent a 3x4 matrix.

	a := m.mat3{-3, 5, 0, 1, -2, -7, 0, 1, 1}

	testing.expect(t, a[0, 0] == -3)
	testing.expect(t, a[1, 1] == -2)
	testing.expect(t, a[2, 2] == 1)
}

@(test)
mat4_equality_for_identical :: proc(t: ^testing.T) {
	// Scenario: Matrix equality with identical matrices.

	a := m.mat4{1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2}
	b := m.mat4{1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2}

	testing.expect(t, a == b)
}

@(test)
mat4_equality_for_non_identical :: proc(t: ^testing.T) {
	// Scenario: Matrix equality with different matrices.

	a := m.mat4{1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2}
	b := m.mat4{2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2, 1}

	testing.expect(t, a != b)
}

@(test)
mat4_multiply_mat4 :: proc(t: ^testing.T) {
	// Scenario: Multiplying two 4x4 matrices.

	a := m.mat4{1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2}
	b := m.mat4{-2, 1, 2, 3, 3, 2, 1, -1, 4, 3, 6, 5, 1, 2, 7, 8}

	product := a * b
	expected_product := m.mat4{20, 22, 50, 48, 44, 54, 114, 108, 40, 58, 110, 102, 16, 26, 46, 42}

	testing.expectf(t, product == expected_product, "%v != %v", product, expected_product)
}

@(test)
mat4_multiply_tuple :: proc(t: ^testing.T) {
	// Scenario: A 4x4 matrix multiplied by a tuple.

	a := m.mat4{1, 2, 3, 4, 2, 4, 4, 2, 8, 6, 4, 1, 0, 0, 0, 1}
	b := m.tuple(1, 2, 3, 1)

	product := a * b
	expected_product := m.tuple(18, 24, 33, 1)

	testing.expectf(t, product == expected_product, "%v != %v", product, expected_product)
}

@(test)
mat4_multiply_identity :: proc(t: ^testing.T) {
	// Scenario: Multiplying a 4x4 matrix by the identity matrix.

	a := m.mat4{0, 1, 2, 4, 1, 2, 4, 8, 2, 4, 8, 16, 4, 8, 16, 32}

	identity: m.mat4 = 1

	product := a * identity
	expected_product := m.mat4{0, 1, 2, 4, 1, 2, 4, 8, 2, 4, 8, 16, 4, 8, 16, 32}

	testing.expectf(t, product == expected_product, "%v != %v", product, expected_product)
}


@(test)
mat4_transpose :: proc(t: ^testing.T) {
	// Scenario: Transposing a 4x4 matrix.

	a := m.mat4{0, 9, 3, 0, 9, 8, 0, 8, 1, 8, 5, 3, 0, 0, 5, 8}

	transpose := intrinsics.transpose(a)
	expected_transpose := m.mat4{0, 9, 1, 0, 9, 8, 8, 0, 3, 0, 5, 5, 0, 8, 3, 8}

	testing.expectf(t, transpose == expected_transpose, "%v != %v", transpose, expected_transpose)
}

@(test)
mat4_transpose_of_identity :: proc(t: ^testing.T) {
	// Scenario: Transposing the 4x4 identity matrix.

	identity: m.mat4 = 1

	transpose := intrinsics.transpose(identity)
	expected_transpose: m.mat4 = 1

	testing.expectf(t, transpose == expected_transpose, "%v != %v", transpose, expected_transpose)
}

@(test)
mat2_determinant :: proc(t: ^testing.T) {
	// Scenario: Calculating the determinant of a 2x2 matrix.

	a := m.mat2{1, 5, -3, 2}

	testing.expect(t, linalg.determinant(a) == 17)
}

@(test)
mat3_submatrix :: proc(t: ^testing.T) {
	// Scenario: A submatrix of a 3x3 matrix is a 2x2 matrix.

	a := m.mat3{1, 5, 0, -3, 2, 7, 0, 6, -3}

	submatrix := m.mat3_submatrix(&a, 0, 2)
	expected_submatrix := m.mat2{-3, 2, 0, 6}

	testing.expectf(t, submatrix == expected_submatrix, "%v != %v", submatrix, expected_submatrix)
}

@(test)
mat4_submatrix :: proc(t: ^testing.T) {
	// Scenario: A submatrix of a 4x4 matrix is a 2x2 matrix.

	a := m.mat4{-6, 1, 1, 6, -8, 5, 8, 6, -1, 0, 8, 2, -7, 1, -1, 1}

	submatrix := m.mat4_submatrix(&a, 2, 1)
	expected_submatrix := m.mat3{-6, 1, 6, -8, 8, 6, -7, -1, 1}

	testing.expectf(t, submatrix == expected_submatrix, "%v != %v", submatrix, expected_submatrix)
}

@(test)
mat3_minor :: proc(t: ^testing.T) {
	// Scenario: Calculating a minor of a 3x3 matrix.

	a := m.mat3{3, 5, 0, 2, -1, -7, 6, -1, 5}

	submatrix := m.mat3_submatrix(&a, 1, 0)

	testing.expect(t, linalg.determinant(submatrix) == 25)

	testing.expect(t, linalg.matrix_minor(a, 1, 0) == 25)
}

@(test)
mat3_cofactor :: proc(t: ^testing.T) {
	// Scenario: Calculating a cofactor of a 3x3 matrix.

	a := m.mat3{3, 5, 0, 2, -1, -7, 6, -1, 5}

	testing.expect(t, linalg.matrix_minor(a, 0, 0) == -12)
	testing.expect(t, m.mat3_cofactor(a, 0, 0) == -12)

	testing.expect(t, linalg.matrix_minor(a, 1, 0) == 25)
	testing.expect(t, m.mat3_cofactor(a, 1, 0) == -25)
}

@(test)
mat4_cofactor :: proc(t: ^testing.T) {
	// Scenario: Calculating a cofactor of a 4x4 matrix.

	a := m.mat4{-2, -8, 3, 5, -3, 1, 7, 3, 1, 2, -9, 6, -6, 7, 7, -9}

	testing.expect(t, linalg.matrix4_cofactor(a, 0, 0) == 690)
	testing.expect(t, linalg.matrix4_cofactor(a, 1, 0) == 447)
	testing.expect(t, linalg.matrix4_cofactor(a, 2, 0) == 210)
	testing.expect(t, linalg.matrix4_cofactor(a, 3, 0) == 51)

	testing.expect(t, linalg.determinant(a) == -4071)
}

@(test)
mat4_test_invertible_for_invertibility :: proc(t: ^testing.T) {
	// Scenario: Testing an invertible matrix for invertibility.

	a := m.mat4{6, 4, 4, 4, 5, 5, 7, 6, 4, -9, 3, -7, 9, 1, 7, -6}

	testing.expect(t, linalg.determinant(a) == -2120)
	testing.expect(t, m.mat4_invertible(a))
}

@(test)
mat4_test_noninvertible_for_invertibility :: proc(t: ^testing.T) {
	// Scenario: Testing a non-invertible matrix for invertibility.

	a := m.mat4{-4, 2, -2, -3, 9, 6, 2, 6, 0, -5, 1, -5, 0, 0, 0, 0}

	testing.expect(t, linalg.determinant(a) == 0)
	testing.expect(t, m.mat4_invertible(a) == false)
}

@(test)
mat4_inverse_1 :: proc(t: ^testing.T) {
	// Scenario: Calculating the inverse of a 4x4 matrix.

	a := m.mat4{-5, 2, 6, -8, 1, -5, 1, 8, 7, 7, -6, -7, 1, -3, 7, 4}

	inverse := m.mat4(linalg.matrix4_inverse(a))

	expected_inverse := m.mat4 {
		0.21805,
		0.45113,
		0.24060,
		-0.04511,
		-0.80827,
		-1.45677,
		-0.44361,
		0.52068,
		-0.07895,
		-0.22368,
		-0.05263,
		0.19737,
		-0.52256,
		-0.81391,
		-0.30075,
		0.30639,
	}

	testing.expect(t, linalg.determinant(a) == 532)

	testing.expect(t, linalg.matrix4_cofactor(a, 3, 2) == -160)

	testing.expectf(
		t,
		m.float_eq(inverse[3, 2], real(-160) / 532),
		"%v != %v",
		inverse[3, 2],
		real(-160) / 532,
	)

	testing.expect(t, linalg.matrix4_cofactor(a, 2, 3) == 105)

	testing.expectf(
		t,
		m.float_eq(inverse[2, 3], real(105) / 532),
		"%v != %v",
		inverse[2, 3],
		real(105) / 532,
	)

	testing.expectf(
		t,
		m.mat4_eq(&inverse, &expected_inverse),
		"%v != %v",
		inverse,
		expected_inverse,
	)
}

@(test)
mat4_inverse_2 :: proc(t: ^testing.T) {
	// Scenario: Calculating the inverse of a second 4x4 matrix.

	a := m.mat4{8, -5, 9, 2, 7, 5, 6, 1, -6, 0, 9, 6, -3, 0, -9, -4}

	inverse := m.mat4(linalg.inverse(a))

	expected_inverse := m.mat4 {
		-0.15385,
		-0.15385,
		-0.28205,
		-0.53846,
		-0.07692,
		0.12308,
		0.02564,
		0.03077,
		0.35897,
		0.35897,
		0.43590,
		0.92308,
		-0.69231,
		-0.69231,
		-0.76923,
		-1.92308,
	}

	testing.expectf(
		t,
		m.mat4_eq(&inverse, &expected_inverse),
		"%v != %v",
		inverse,
		expected_inverse,
	)
}

@(test)
mat4_inverse_3 :: proc(t: ^testing.T) {
	// Scenario: Calculating the inverse of a third 4x4 matrix.

	a := m.mat4{3, -9, 7, 3, 3, -8, 2, -9, -4, 4, 4, 1, -6, 5, -1, 1}

	b := m.mat4{8, 2, 2, 2, 3, -1, 7, 0, 7, 0, 5, 4, 6, -2, 0, 5}

	product := a * b

	original := product * m.mat4(linalg.inverse(b))

	expected_original := a

	testing.expectf(
		t,
		m.mat4_eq(&original, &expected_original),
		"%v != %v",
		original,
		expected_original,
	)
}

@(test)
mat4_translate_point :: proc(t: ^testing.T) {
	// Scenario: Multiplying by a 4x4 translation matrix.

	transform := m.mat4(linalg.matrix4_translate([3]m.real{5, -3, 2}))

	p := m.point(-3, 4, 5)

	result := transform * p
	expected_result := m.point(2, 1, 7)

	testing.expect(t, result == expected_result)
}

@(test)
mat4_translate_inverse_point :: proc(t: ^testing.T) {
	// Scenario: Multiplying by the inverse of a 4x4 translation matrix.

	transform := m.mat4(linalg.matrix4_translate([3]m.real{5, -3, 2}))
	inverse := m.mat4(linalg.matrix4_inverse(transform))

	p := m.point(-3, 4, 5)

	result := inverse * p
	expected_result := m.point(-8, 7, 3)

	testing.expect(t, result == expected_result)
}

@(test)
mat4_translate_vector :: proc(t: ^testing.T) {
	// Scenario: Translation does not affect vectors.

	translate := m.mat4_translate(m.vector(5, -3, 2))

	v := m.vector(-3, 4, 5)

	testing.expect(t, translate * v == v)
}

@(test)
mat4_scale_point :: proc(t: ^testing.T) {
	// Scenario: A 4x4 scaling matrix applied to a point.

	scale := m.mat4_scale(m.vector(2, 3, 4))

	p := m.point(-4, 6, 8)

	testing.expect(t, scale * p == m.point(-8, 18, 32))
}

@(test)
mat4_scale_vector :: proc(t: ^testing.T) {
	// Scenario: A 4x4 scaling matrix applied to a vector.

	scale := m.mat4_scale(m.vector(2, 3, 4))

	v := m.vector(-4, 6, 8)

	testing.expect(t, scale * v == m.vector(-8, 18, 32))
}

@(test)
mat4_scale_inverse :: proc(t: ^testing.T) {
	// Scenario: Multiplying by the inverse of a 4x4 scaling matrix.

	scale := m.mat4_scale(m.vector(2, 3, 4))
	scale_inverse := m.mat4(linalg.matrix4_inverse(scale))

	v := m.vector(-4, 6, 8)

	testing.expect(t, scale_inverse * v == m.vector(-2, 2, 2))
}

@(test)
mat4_reflection :: proc(t: ^testing.T) {
	// Scenario: Reflection is scaling by a negative value.

	scale := m.mat4_scale(m.vector(-1, 1, 1))

	p := m.point(2, 3, 4)

	testing.expect(t, scale * p == m.point(-2, 3, 4))
}

@(test)
mat4_rotate_x :: proc(t: ^testing.T) {
	// Scenario: Rotating a point around the X axis.

	p := m.point(0, 1, 0)

	half_quarter_x := m.mat4_rotate_x(PI_OVER_4)
	full_quarter_x := m.mat4_rotate_x(PI_OVER_2)

	testing.expect(t, m.tuple_eq(half_quarter_x * p, m.point(0, SQRT_2_OVER_2, SQRT_2_OVER_2)))
	testing.expect(t, m.tuple_eq(full_quarter_x * p, m.point(0, 0, 1)))
}

@(test)
mat4_rotate_inverse_x :: proc(t: ^testing.T) {
	// Scenario: The inverse of an X-rotation rotates in the opposite direction.

	p := m.point(0, 1, 0)

	half_quarter_x := m.mat4_rotate_x(PI_OVER_4)

	inverse := m.mat4(linalg.matrix4_inverse(half_quarter_x))

	testing.expect(t, m.tuple_eq(inverse * p, m.point(0, SQRT_2_OVER_2, -SQRT_2_OVER_2)))
}

@(test)
mat4_rotate_y :: proc(t: ^testing.T) {
	// Scenario: Rotating a point around the Y axis.

	p := m.point(0, 0, 1)

	half_quarter_y := m.mat4_rotate_y(PI_OVER_4)
	full_quarter_y := m.mat4_rotate_y(PI_OVER_2)

	testing.expect(t, m.tuple_eq(half_quarter_y * p, m.point(SQRT_2_OVER_2, 0, SQRT_2_OVER_2)))
	testing.expect(t, m.tuple_eq(full_quarter_y * p, m.point(1, 0, 0)))
}

@(test)
mat4_rotate_z :: proc(t: ^testing.T) {
	// Scenario: Rotating a point around the Y axis.

	p := m.point(0, 1, 0)

	half_quarter_z := m.mat4_rotate_z(PI_OVER_4)
	full_quarter_z := m.mat4_rotate_z(PI_OVER_2)

	testing.expect(t, m.tuple_eq(half_quarter_z * p, m.point(-SQRT_2_OVER_2, SQRT_2_OVER_2, 0)))
	testing.expect(t, m.tuple_eq(full_quarter_z * p, m.point(-1, 0, 0)))
}
