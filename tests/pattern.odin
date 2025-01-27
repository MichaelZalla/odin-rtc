package tests

import "core:testing"

import rt "../src"
import m "../src/math"

@(test)
stripe_pattern_colors :: proc(t: ^testing.T) {
	// Scenario: Creating a stripe pattern with default colors.

	pattern := rt.stripe_pattern()

	testing.expect(t, pattern.a == rt.White)
	testing.expect(t, pattern.b == rt.Black)
}

@(test)
stripe_pattern_constant_in_y :: proc(t: ^testing.T) {
	// Scenario: A stripe pattern is constant in Y.

	pattern := rt.stripe_pattern()

	testing.expect(t, rt.stripe_color_at(&pattern, m.point(0, 0, 0)) == rt.White)
	testing.expect(t, rt.stripe_color_at(&pattern, m.point(0, 1, 0)) == rt.White)
	testing.expect(t, rt.stripe_color_at(&pattern, m.point(0, 2, 0)) == rt.White)
}

@(test)
stripe_pattern_constant_in_z :: proc(t: ^testing.T) {
	// Scenario: A stripe pattern is constant in Z.

	pattern := rt.stripe_pattern()

	testing.expect(t, rt.stripe_color_at(&pattern, m.point(0, 0, 0)) == rt.White)
	testing.expect(t, rt.stripe_color_at(&pattern, m.point(0, 0, 1)) == rt.White)
	testing.expect(t, rt.stripe_color_at(&pattern, m.point(0, 0, 2)) == rt.White)
}

@(test)
stripe_pattern_alternating_in_x :: proc(t: ^testing.T) {
	// Scenario: A stripe pattern alternates in X.

	pattern := rt.stripe_pattern()

	testing.expect(t, rt.stripe_color_at(&pattern, m.point(0, 0, 0)) == rt.White)
	testing.expect(t, rt.stripe_color_at(&pattern, m.point(0.9, 0, 0)) == rt.White)
	testing.expect(t, rt.stripe_color_at(&pattern, m.point(1, 0, 0)) == rt.Black)
	testing.expect(t, rt.stripe_color_at(&pattern, m.point(-0.1, 0, 0)) == rt.Black)
	testing.expect(t, rt.stripe_color_at(&pattern, m.point(-1, 0, 0)) == rt.Black)
	testing.expect(t, rt.stripe_color_at(&pattern, m.point(-1.1, 0, 0)) == rt.White)
}
