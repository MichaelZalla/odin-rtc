package pit_chapter_01

import "core:fmt"
import "core:strings"

import m "../../../src/math"

Projectile :: struct {
	position: m.Point,
	velocity: m.Vector,
}

Environment :: struct {
	gravity, wind: m.Vector,
}

tick :: proc(env: ^Environment, projectile: ^Projectile) {
	projectile := projectile

	position := m.point(m.tuple(projectile.position) + m.tuple(projectile.velocity))

	velocity := projectile.velocity + env.gravity + env.wind

	projectile.position = position
	projectile.velocity = velocity
}

position_to_string :: proc(position: ^m.Point) -> string {
	sb := strings.builder_make()

	return fmt.sbprintf(&sb, "Position=(%.1f, %.1f, %.1f)", position.x, position.y, position.z)
}

main :: proc() {
	environment := Environment{m.vector(0, -0.1, 0), m.vector(-0.01, 0, 0)}

	projectile := Projectile{m.point(0, 1, 0), m.norm(m.vector(1, 1, 0))}

	t := 0

	fmt.printfln("Start:\t\t%s", position_to_string(&projectile.position))

	for ; projectile.position.y > 0; t += 1 {
		tick(&environment, &projectile)

		fmt.printfln("Tick %2d:\t%s", t, position_to_string(&projectile.position))
	}
}
