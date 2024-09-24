package tests

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
