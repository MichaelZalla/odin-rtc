package rt_profile

import runtime "base:runtime"
import time "core:time"

simple_benchmark_fn_global: proc()

simple_benchmark :: proc(fn: proc()) -> time.Benchmark_Options {
	ROUNDS :: 1e4

	setup :: proc(_: ^time.Benchmark_Options, _: runtime.Allocator) -> time.Benchmark_Error {
		return time.Benchmark_Error.Okay
	}

	bench :: proc(options: ^time.Benchmark_Options, _: runtime.Allocator) -> time.Benchmark_Error {
		for i in 0 ..< options.rounds {
			simple_benchmark_fn_global()
		}

		return time.Benchmark_Error.Okay
	}

	teardown :: proc(_: ^time.Benchmark_Options, _: runtime.Allocator) -> time.Benchmark_Error {
		return time.Benchmark_Error.Okay
	}

	simple_benchmark_fn_global = fn

	options := time.Benchmark_Options{}
	options.rounds = ROUNDS
	options.setup = setup
	options.bench = bench
	options.teardown = teardown

	time.benchmark(&options)

	return options
}
