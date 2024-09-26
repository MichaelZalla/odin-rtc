package tests

import "core:math"
import "core:testing"

import m "../src/math"

@(test)
tuple_is_xyzw :: proc(t: ^testing.T) {
	t1 := m.Tuple{1, 2, 3, 4}

	assert(t1.x == 1)
	assert(t1.y == 2)
	assert(t1.z == 3)
	assert(t1.w == 4)
}

@(test)
tuple_can_be_compared_for_equality :: proc(t: ^testing.T) {
	epsilon := m.EPSILON

	t1 := m.Tuple{0, 0, 0, 1}
	t2 := m.Tuple{epsilon, epsilon, epsilon, 1}
	t3 := m.Tuple{epsilon * 2, epsilon * 2, epsilon * 2, 1}

	assert(m.tuple_eq(t1, t2))
	assert(m.tuple_eq(t2, t3))
	assert(!m.tuple_eq(t1, t3))
}

@(test)
point_is_a_tuple :: proc(t: ^testing.T) {
	// Scenario: A tuple with w=1 is a point.

	t1 := m.tuple(4.3, -4.2, 3.1, 1.0)

	assert(m.is_point(t1))
	assert(!m.is_vector(t1))
}

@(test)
point_creates_tuples :: proc(t: ^testing.T) {
	// Scenario: point() creates tuples with w=1.

	t1 := m.tuple(4.3, -4.2, 3.1, 1.0)
	p1 := m.point(t1)

	assert(m.is_point(p1))
	assert(!m.is_vector(p1))

	assert(m.tuple_eq(t1, m.Tuple(p1)))

	assert(p1.x == 4.3)
	assert(p1.y == -4.2)
	assert(p1.z == 3.1)
	assert(p1.w == 1)

	p2 := m.point_xyz(p1.x, p1.y, p1.z)

	assert(m.tuple_eq(p1, p2))
}

@(test)
vector_is_a_tuple :: proc(t: ^testing.T) {
	// Scenario: A tuple with w=0 is a vector.

	t1 := m.tuple(4.3, -4.2, 3.1, 0.0)

	assert(m.is_vector(t1))
	assert(!m.is_point(t1))
}

@(test)
vector_creates_tuples :: proc(t: ^testing.T) {
	// Scenario: vector() creates tuples with w=0.

	t1 := m.tuple(4.3, -4.2, 3.1, 0.0)
	v1 := m.vector(t1)

	assert(m.is_vector(v1))
	assert(!m.is_point(v1))
	assert(m.tuple_eq(t1, m.Tuple(v1)))

	assert(v1.x == 4.3)
	assert(v1.y == -4.2)
	assert(v1.z == 3.1)
	assert(v1.w == 0)

	v2 := m.vector_xyz(v1.x, v1.y, v1.z)

	assert(m.tuple_eq(v1, v2))
}

@(test)
tuple_addition :: proc(t: ^testing.T) {
	// Scenario: Adding two tuples.

	// Note: It's sensible to add two vectors, or to add a vector to a point;
	// adding a point to another point, however, isn't meaningful, and would
	// have the consequence of setting `w` to 2!

	a1 := m.tuple(3, -2, 5, 1)
	a2 := m.tuple(-2, 3, 1, 0)

	sum := a1 + a2

	expected_sum := m.tuple(1, 1, 6, 1)

	assert(m.tuple_eq(sum, expected_sum))
	assert(m.is_point(sum))
	assert(!m.is_vector(sum))
}

@(test)
subtract_point_from_point :: proc(t: ^testing.T) {
	// Scenario: Subtracting two points produces a vector.

	// Note: Subtracting one point from another has the effect of setting `w` to
	// zero—meaning that the result of subtracting two points will be a vector!

	p1 := m.point(3, 2, 1)
	p2 := m.point(5, 6, 7)

	difference := p1 - p2 // Vector.

	expected_difference := m.vector(-2, -4, -6)

	assert(m.tuple_eq(m.Tuple(difference), m.Tuple(expected_difference)))

	assert(m.is_vector(difference))
	assert(!m.is_point(difference))
}

@(test)
subtract_vector_from_point :: proc(t: ^testing.T) {
	// Scenario: Subtracting a vector from a point produces a point.

	p := m.point(3, 2, 1)
	v := m.vector(5, 6, 7)

	difference := m.Tuple(p) - m.Tuple(v) // Point.

	expected_difference := m.point(-2, -4, -6)

	assert(m.tuple_eq(difference, m.Tuple(expected_difference)))

	assert(m.is_point(difference))
	assert(!m.is_vector(difference))
}

@(test)
subtract_vector_from_vector :: proc(t: ^testing.T) {
	// Scenario: Subtracting a vector from a vector produces a vector.

	v1 := m.vector(3, 2, 1)
	v2 := m.vector(5, 6, 7)

	difference := v1 - v2 // Vector.

	expected_difference := m.vector(-2, -4, -6)

	assert(m.tuple_eq(difference, expected_difference))

	assert(m.is_vector(difference))
	assert(!m.is_point(difference))
}

@(test)
subtract_vector_from_zero_vector :: proc(t: ^testing.T) {
	// Scenario: Subtracting a vector from the zero vector.

	zero := m.vector(0, 0, 0)
	v := m.vector(1, -2, 3)

	assert(m.tuple_eq(zero - v, m.vector(-1, 2, -3)))
}

@(test)
negate_tuple :: proc(t: ^testing.T) {
	// Scenario: Negating a tuple.

	a := m.tuple(1, -2, 3, -4)

	assert(m.tuple_eq(-a, m.tuple(-1, 2, -3, 4)))
}

@(test)
multiply_tuple_by_scalar :: proc(t: ^testing.T) {
	// Scenario: Multiplying a tuple by a scalar.

	a := m.tuple(1, -2, 3, -4)

	assert(m.tuple_eq(a * 3.5, m.tuple(3.5, -7, 10.5, -14)))
}

@(test)
multiply_tuple_by_fraction :: proc(t: ^testing.T) {
	// Scenario: Multiplying a tuple by a fraction.

	a := m.tuple(1, -2, 3, -4)

	assert(m.tuple_eq(a * 0.5, m.tuple(0.5, -1, 1.5, -2)))
}

@(test)
divide_tuple_by_scalar :: proc(t: ^testing.T) {
	// Scenario: Dividing a tuple by a scalar.

	a := m.tuple(1, -2, 3, -4)

	assert(m.tuple_eq(a / 2, m.tuple(0.5, -1, 1.5, -2)))
}

@(test)
magnitude_of_vector :: proc(t: ^testing.T) {
	// Scenario: Computing the magnitude of the vector (1, 0, 0).

	right := m.vector(1, 0, 0)

	assert(m.float_eq(m.mag(right), 1))

	up := m.vector(0, 1, 0)

	assert(m.float_eq(m.mag(up), 1))

	forward := m.vector(0, 0, 1)

	assert(m.float_eq(m.mag(forward), 1))

	a := m.vector(1, 2, 3)

	assert(m.float_eq(m.mag(a), math.sqrt(f64(14))))

	b := m.vector(-1, -2, -3)

	assert(m.float_eq(m.mag(b), math.sqrt(f64(14))))
}

@(test)
normalize_vector_1 :: proc(t: ^testing.T) {
	// Scenario: Normalizing the vector (4, 0, 0) yields the unit vector (1, 0, 0).

	v := m.vector(4, 0, 0)

	assert(m.tuple_eq(m.norm(v), m.vector(1, 0, 0)))
}

@(test)
normalize_vector_2 :: proc(t: ^testing.T) {
	// Scenario: Normalizing the vector (1, 2, 3) yields the unit vector
	// (1/√14, 2/√14, 3/√14).

	v := m.vector(1, 2, 3)

	sqrt_14 := m.real(math.sqrt(f64(14)))

	expected_norm := m.vector(1 / sqrt_14, 2 / sqrt_14, 3 / sqrt_14)

	actual_norm := m.norm(v)

	assert(m.tuple_eq(actual_norm, expected_norm))

	assert(m.float_eq(m.mag(actual_norm), 1))
}

@(test)
vector_dot_product :: proc(t: ^testing.T) {
	// Scenario: The dot product of 2 vectors.

	a := m.vector(1, 2, 3)
	b := m.vector(2, 3, 4)

	assert(m.float_eq(m.dot(a, b), 20))
}

@(test)
vector_cross_product :: proc(t: ^testing.T) {
	// Scenario: The cross product of 2 vectors.

	a := m.vector(1, 2, 3)
	b := m.vector(2, 3, 4)

	assert(m.tuple_eq(m.cross(a, b), m.vector(-1, 2, -1)))
	assert(m.tuple_eq(m.cross(b, a), m.vector(1, -2, 1)))
}

@(test)
color_tuple :: proc(t: ^testing.T) {
	// Scenario: A color is a (red, green, blue) tuple.

	c := m.color(-0.5, 0.4, 1.7)

	assert(c.r == -0.5)
	assert(c.g == 0.4)
	assert(c.b == 1.7)
}

@(test)
color_addition :: proc(t: ^testing.T) {
	// Scenario: Adding colors.

	c1 := m.color(0.9, 0.6, 0.75)
	c2 := m.color(0.7, 0.1, 0.25)

	sum := c1 + c2
	expected_sum := m.color(1.6, 0.7, 1.0)

	assert(m.tuple_eq(sum, expected_sum))
}

@(test)
color_subtraction :: proc(t: ^testing.T) {
	// Scenario: Subtracting colors.

	c1 := m.color(0.9, 0.6, 0.75)
	c2 := m.color(0.7, 0.1, 0.25)

	difference := c1 - c2
	expected_difference := m.color(0.2, 0.5, 0.5)

	assert(m.tuple_eq(difference, expected_difference))
}

@(test)
color_scalar_multiply :: proc(t: ^testing.T) {
	// Scenario: Multiplying colors by a scalar.

	c := m.color(0.2, 0.3, 0.4)

	assert(m.tuple_eq(m.Tuple(c * 2), m.tuple(0.4, 0.6, 0.8, 0)))
}

@(test)
color_color_multiply :: proc(t: ^testing.T) {
	// Scenario: Multiplying colors.

	c1 := m.color(1, 0.2, 0.4)
	c2 := m.color(0.9, 1, 0.1)

	product := c1 * c2
	expected_product := m.color(0.9, 0.2, 0.04)

	assert(m.tuple_eq(product, expected_product))
}
