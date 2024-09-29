package tests

import testing "core:testing"

import rt "../src"
import m "../src/math"

@(test)
hit_when_all_in_front :: proc(t: ^testing.T) {
	// Scenario: The hit, when all intersections are in front of the ray.

	s := rt.sphere()

	i1 := rt.intersection(1, &s)
	i2 := rt.intersection(2, &s)

	xs := rt.intersections(i2, i1)
	defer delete(xs)

	hit := rt.hit(xs)

	testing.expect(t, hit == xs[1]) // i1
}

@(test)
hit_when_some_in_front :: proc(t: ^testing.T) {
	// Scenario: The hit, when some intersections are behind the ray.

	s := rt.sphere()

	i1 := rt.intersection(-1, &s)
	i2 := rt.intersection(1, &s)

	xs := rt.intersections(i2, i1)
	defer delete(xs)

	hit := rt.hit(xs)

	testing.expect(t, hit == xs[0]) // i2
}

@(test)
hit_when_none_in_front :: proc(t: ^testing.T) {
	// Scenario: The hit, when all intersections are behind the ray.

	s := rt.sphere()

	i1 := rt.intersection(-2, &s)
	i2 := rt.intersection(-1, &s)

	xs := rt.intersections(i2, i1)
	defer delete(xs)

	hit := rt.hit(xs)

	testing.expect(t, hit == nil) // No hit(s).
}

@(test)
hit_always_lowest_nonnegative_t :: proc(t: ^testing.T) {
	// Scenario: The hit is always the lowest non-negative intersection (t-value).

	s := rt.sphere()

	i1 := rt.intersection(5, &s)
	i2 := rt.intersection(7, &s)
	i3 := rt.intersection(-3, &s)
	i4 := rt.intersection(2, &s)

	xs := rt.intersections(i1, i2, i3, i4)
	defer delete(xs)

	hit := rt.hit(xs)

	testing.expect(t, hit == xs[3]) // i4
}
