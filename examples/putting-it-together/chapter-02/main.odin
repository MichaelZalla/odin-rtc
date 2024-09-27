package pit_chapter_02

import "core:fmt"
import "core:math"
import os "core:os"
import "core:strings"

import rt "../../../src"
import fs "../../../src/fs"
import m "../../../src/math"

import chapter_01 "../chapter-01"

main :: proc() {
	gravity := m.vector(0, -0.1, 0)
	wind := m.vector(-0.01, 0, 0)

	environment := chapter_01.Environment{gravity, wind}

	initial_position := m.point(0, 1, 0)
	initial_velocity := m.norm(m.vector(1, 1.8, 0)) * 11.25

	projectile := chapter_01.Projectile{initial_position, initial_velocity}

	c := rt.canvas(900, 550)
	defer rt.canvas_free(c)

	t := 0
	red := rt.color(1, 0, 0)

	// fmt.printfln("Start:\t\t%s", chapter_01.position_to_string(&projectile.position))

	for ; projectile.position.y > 0; t += 1 {
		chapter_01.tick(&environment, &projectile)

		// fmt.printfln("Tick %2d:\t%s", t, chapter_01.position_to_string(&projectile.position))

		screen_x := int(projectile.position.x)
		screen_y := c.height - int(projectile.position.y)

		// fmt.printfln("(x,y)=(%v, %v)", screen_x, screen_y)

		if screen_x > 0 && screen_x < c.width && screen_y > 0 && screen_y < c.height {
			rt.canvas_pixel_set(&c, screen_x, screen_y, red)
		}
	}

	path := fs.get_absolute_path("/examples/putting-it-together/chapter-02/projectile.ppm")

	success := rt.canvas_to_ppm_file(&c, path)
}
