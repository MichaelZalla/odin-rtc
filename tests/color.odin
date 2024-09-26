package tests

import "core:math"
import "core:testing"

import rt "../src"
import m "../src/math"

@(test)
color_tuple :: proc(t: ^testing.T) {
	// Scenario: A color is a (red, green, blue) tuple.

	c := rt.color(-0.5, 0.4, 1.7)

	testing.expect(t, c.r == -0.5)
	testing.expect(t, c.g == 0.4)
	testing.expect(t, c.b == 1.7)
}

@(test)
color_addition :: proc(t: ^testing.T) {
	// Scenario: Adding colors.

	c1 := rt.color(0.9, 0.6, 0.75)
	c2 := rt.color(0.7, 0.1, 0.25)

	sum := c1 + c2
	expected_sum := rt.color(1.6, 0.7, 1.0)

	testing.expect(t, m.tuple_eq(sum, expected_sum))
}

@(test)
color_subtraction :: proc(t: ^testing.T) {
	// Scenario: Subtracting colors.

	c1 := rt.color(0.9, 0.6, 0.75)
	c2 := rt.color(0.7, 0.1, 0.25)

	difference := c1 - c2
	expected_difference := rt.color(0.2, 0.5, 0.5)

	testing.expect(t, m.tuple_eq(difference, expected_difference))
}

@(test)
color_scalar_multiply :: proc(t: ^testing.T) {
	// Scenario: Multiplying colors by a scalar.

	c := rt.color(0.2, 0.3, 0.4)

	testing.expect(t, m.tuple_eq(m.Tuple(c * 2), m.tuple(0.4, 0.6, 0.8, 0)))
}

@(test)
color_color_multiply :: proc(t: ^testing.T) {
	// Scenario: Multiplying colors (i.e., Hadamard product).

	c1 := rt.color(1, 0.2, 0.4)
	c2 := rt.color(0.9, 1, 0.1)

	product := c1 * c2
	expected_product := rt.color(0.9, 0.2, 0.04)

	testing.expect(t, m.tuple_eq(product, expected_product))
}
