package rt_fs

import os "core:os"
import "core:strings"

get_absolute_path :: proc(relative_path: string) -> string {
	paths := [2]string{os.get_current_directory(), relative_path}

	return strings.concatenate(paths[:])
}
