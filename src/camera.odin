package rt

import m "math"

look_at :: proc(view_position: m.Point, target: m.Point, up: m.Vector) -> m.Mat4 {
	view_position_to_target := m.vector(target - view_position)

	forward := m.norm(view_position_to_target)
	left := m.cross(forward, m.norm(up))
	true_up := m.cross(left, forward)

	orientation := m.Mat4 {
		left.x,
		left.y,
		left.z,
		0,
		true_up.x,
		true_up.y,
		true_up.z,
		0,
		-forward.x,
		-forward.y,
		-forward.z,
		0,
		0,
		0,
		0,
		1,
	}

	translation := m.mat4_translate(m.vector(-view_position))

	return orientation * translation
}
