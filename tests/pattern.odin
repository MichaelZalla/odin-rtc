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

@(test)
stripe_pattern_object_transform :: proc(t: ^testing.T) {
	// Scenario: Stripes with an object transform.

	object := rt.sphere()

	// Scales our object by a uniform factor of 2.
	object.transform = m.mat4_scale(2)

	pattern := rt.stripe_pattern()

	c := rt.stripe_color_at_object(&pattern, &object, m.point(1.5, 0, 0))

	testing.expect(t, m.tuple_eq(c, rt.White))
}

@(test)
stripe_pattern_pattern_transform :: proc(t: ^testing.T) {
	// Scenario: Stripes with a pattern transform.

	object := rt.sphere()

	pattern := rt.stripe_pattern()

	pattern.transform = m.mat4_scale(2)

	c := rt.stripe_color_at_object(&pattern, &object, m.point(1.5, 0, 0))

	testing.expect(t, m.tuple_eq(c, rt.White))
}

@(test)
stripe_pattern_object_and_pattern_transform :: proc(t: ^testing.T) {
	// Scenario: Stripes with an object transform and a pattern transform.

	object := rt.sphere()
	object.transform = m.mat4_scale(2)

	pattern := rt.stripe_pattern()
	pattern.transform = m.mat4_translate(m.vector(0.5, 0, 0))

	c := rt.stripe_color_at_object(&pattern, &object, m.point(2.5, 0, 0))

	testing.expect(t, m.tuple_eq(c, rt.White))
}
