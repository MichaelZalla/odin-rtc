package tests

import "core:testing"

import rt "../src"
import m "../src/math"

@(test)
pattern_default_transform :: proc(t: ^testing.T) {
	// Scenario: The default pattern transform.

	pattern := rt.pattern_default()

	testing.expect(t, pattern.transform == m.Mat4(1))
}

@(test)
pattern_assign_transform :: proc(t: ^testing.T) {
	// Scenario: Assigning a transform to a pattern.

	pattern := rt.pattern_default()

	pattern.transform = m.mat4_translate(m.vector(1, 2, 3))

	testing.expect(t, pattern.transform == m.mat4_translate(m.vector(1, 2, 3)))
}

@(test)
pattern_object_transform :: proc(t: ^testing.T) {
	// Scenario: A pattern with an object transform.

	shape := rt.sphere()
	shape.transform = m.mat4_scale(2)

	pattern := rt.pattern_default()

	c := rt.pattern_at_shape(&pattern, &shape, m.point(2, 3, 4))

	testing.expect(t, c == rt.color(1, 1.5, 2))
}

@(test)
pattern_transform_object_transform :: proc(t: ^testing.T) {
	// Scenario: A pattern with both an object transform and a pattern transform.

	shape := rt.sphere()
	shape.transform = m.mat4_scale(2)

	pattern := rt.pattern_default()
	pattern.transform = m.mat4_translate(m.vector(0.5, 1, 1.5))

	c := rt.pattern_at_shape(&pattern, &shape, m.point(2.5, 3, 3.5))

	testing.expect(t, c == rt.color(0.75, 0.5, 0.25))
}

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

	testing.expect(t, pattern.vtable.color_at(&pattern, m.point(0, 0, 0)) == rt.White)
	testing.expect(t, pattern.vtable.color_at(&pattern, m.point(0, 1, 0)) == rt.White)
	testing.expect(t, pattern.vtable.color_at(&pattern, m.point(0, 2, 0)) == rt.White)
}

@(test)
stripe_pattern_constant_in_z :: proc(t: ^testing.T) {
	// Scenario: A stripe pattern is constant in Z.

	pattern := rt.stripe_pattern()

	testing.expect(t, pattern.vtable.color_at(&pattern, m.point(0, 0, 0)) == rt.White)
	testing.expect(t, pattern.vtable.color_at(&pattern, m.point(0, 0, 1)) == rt.White)
	testing.expect(t, pattern.vtable.color_at(&pattern, m.point(0, 0, 2)) == rt.White)
}

@(test)
stripe_pattern_alternating_in_x :: proc(t: ^testing.T) {
	// Scenario: A stripe pattern alternates in X.

	pattern := rt.stripe_pattern()

	testing.expect(t, pattern.vtable.color_at(&pattern, m.point(0, 0, 0)) == rt.White)
	testing.expect(t, pattern.vtable.color_at(&pattern, m.point(0.9, 0, 0)) == rt.White)
	testing.expect(t, pattern.vtable.color_at(&pattern, m.point(1, 0, 0)) == rt.Black)
	testing.expect(t, pattern.vtable.color_at(&pattern, m.point(-0.1, 0, 0)) == rt.Black)
	testing.expect(t, pattern.vtable.color_at(&pattern, m.point(-1, 0, 0)) == rt.Black)
	testing.expect(t, pattern.vtable.color_at(&pattern, m.point(-1.1, 0, 0)) == rt.White)
}

@(test)
stripe_pattern_object_transform :: proc(t: ^testing.T) {
	// Scenario: Stripes with an object transform.

	object := rt.sphere()

	// Scales our object by a uniform factor of 2.
	object.transform = m.mat4_scale(2)

	pattern := rt.stripe_pattern()

	c := rt.pattern_at_shape(&pattern, &object, m.point(1.5, 0, 0))

	testing.expect(t, m.tuple_eq(c, rt.White))
}

@(test)
stripe_pattern_pattern_transform :: proc(t: ^testing.T) {
	// Scenario: Stripes with a pattern transform.

	object := rt.sphere()

	pattern := rt.stripe_pattern()

	pattern.transform = m.mat4_scale(2)

	c := rt.pattern_at_shape(&pattern, &object, m.point(1.5, 0, 0))

	testing.expect(t, m.tuple_eq(c, rt.White))
}

@(test)
stripe_pattern_object_and_pattern_transform :: proc(t: ^testing.T) {
	// Scenario: Stripes with an object transform and a pattern transform.

	object := rt.sphere()
	object.transform = m.mat4_scale(2)

	pattern := rt.stripe_pattern()
	pattern.transform = m.mat4_translate(m.vector(0.5, 0, 0))

	c := rt.pattern_at_shape(&pattern, &object, m.point(2.5, 0, 0))

	testing.expect(t, m.tuple_eq(c, rt.White))
}

@(test)
linear_gradient_pattern :: proc(t: ^testing.T) {
	// Scenario: A linear gradient linearly interpolates between two colors.

	pattern := rt.linear_gradient_pattern()

	c1 := pattern.vtable.color_at(&pattern, m.point(0, 0, 0))
	c2 := pattern.vtable.color_at(&pattern, m.point(0.25, 0, 0))
	c3 := pattern.vtable.color_at(&pattern, m.point(0.5, 0, 0))
	c4 := pattern.vtable.color_at(&pattern, m.point(0.75, 0, 0))

	testing.expect(t, c1 == rt.White)
	testing.expect(t, c2 == rt.color(0.75, 0.75, 0.75))
	testing.expect(t, c3 == rt.color(0.5, 0.5, 0.5))
	testing.expect(t, c4 == rt.color(0.25, 0.25, 0.25))
}

@(test)
ring_pattern :: proc(t: ^testing.T) {
	// Scenario: A ring pattern should extend in both X and Z.

	pattern := rt.ring_pattern()

	c1 := pattern.vtable.color_at(&pattern, m.point(0, 0, 0))
	c2 := pattern.vtable.color_at(&pattern, m.point(1, 0, 0))
	c3 := pattern.vtable.color_at(&pattern, m.point(0, 0, 1))
	c4 := pattern.vtable.color_at(&pattern, m.point(0.708, 0, 0.708)) // sqrt(2)/2

	testing.expect(t, c1 == rt.White)
	testing.expect(t, c2 == rt.Black)
	testing.expect(t, c3 == rt.Black)
	testing.expect(t, c4 == rt.Black)
}

@(test)
checkers_pattern_repeat_x :: proc(t: ^testing.T) {
	// Scenario: A checkers pattern should repeat in X.

	pattern := rt.checkers_pattern()

	c1 := pattern.vtable.color_at(&pattern, m.point(0, 0, 0))
	c2 := pattern.vtable.color_at(&pattern, m.point(0.99, 0, 0))
	c3 := pattern.vtable.color_at(&pattern, m.point(1.01, 0, 0))

	testing.expect(t, c1 == rt.White)
	testing.expect(t, c2 == rt.White)
	testing.expect(t, c3 == rt.Black)
}

@(test)
checkers_pattern_repeat_y :: proc(t: ^testing.T) {
	// Scenario: A checkers pattern should repeat in Y.

	pattern := rt.checkers_pattern()

	c1 := pattern.vtable.color_at(&pattern, m.point(0, 0, 0))
	c2 := pattern.vtable.color_at(&pattern, m.point(0, 0.99, 0))
	c3 := pattern.vtable.color_at(&pattern, m.point(0, 1.01, 0))

	testing.expect(t, c1 == rt.White)
	testing.expect(t, c2 == rt.White)
	testing.expect(t, c3 == rt.Black)
}

@(test)
checkers_pattern_repeat_z :: proc(t: ^testing.T) {
	// Scenario: A checkers pattern should repeat in Z.

	pattern := rt.checkers_pattern()

	c1 := pattern.vtable.color_at(&pattern, m.point(0, 0, 0))
	c2 := pattern.vtable.color_at(&pattern, m.point(0, 0, 0.99))
	c3 := pattern.vtable.color_at(&pattern, m.point(0, 0, 1.01))

	testing.expect(t, c1 == rt.White)
	testing.expect(t, c2 == rt.White)
	testing.expect(t, c3 == rt.Black)
}
