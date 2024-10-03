package rt

import "core:math/linalg"

import m "math"

ShapeVTable :: struct {
	intersect_local: proc(shape: ^Shape, local_ray: Ray) -> [dynamic]Intersection,
	normal_local:    proc(shape: ^Shape, local_point: m.Point) -> m.Vector,
}

Shape :: struct {
	transform:      m.Mat4,
	material:       Material,
	vtable:         ShapeVTable,
	last_local_ray: Maybe(Ray),
}

shape_transform_material_vtable :: proc(
	transform: m.Mat4,
	material: Material,
	vtable: ShapeVTable,
) -> Shape {
	return Shape{transform, material, vtable, nil}
}

shape_vtable :: proc(vtable: ShapeVTable) -> Shape {
	return Shape{m.Mat4(1), material(), vtable, nil}
}

shape_default_vtable := ShapeVTable{proc(shape: ^Shape, local_ray: Ray) -> [dynamic]Intersection {
		panic("Invalid shape.")
	}, proc(shape: ^Shape, local_point: m.Point) -> m.Vector {
		panic("Invalid shape.")
	}}

shape_default :: proc() -> Shape {
	return Shape{m.Mat4(1), material(), shape_default_vtable, nil}
}

shape :: proc {
	shape_transform_material_vtable,
	shape_vtable,
}

shape_normal :: proc(shape: ^Shape, point: m.Point) -> m.Vector {
	local_point := linalg.matrix4_inverse(shape.transform) * point

	local_normal := shape.vtable.normal_local(shape, local_point)

	normal := linalg.matrix4_inverse_transpose(shape.transform) * local_normal
	normal.w = 0

	return m.norm(normal)
}

normal_at :: proc {
	shape_normal,
}
