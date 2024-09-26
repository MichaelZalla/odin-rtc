package rt_math

real :: f64

EPSILON :: 0.00001

float_eq :: proc(a, b: real) -> bool {
	return abs(a - b) < EPSILON
}
