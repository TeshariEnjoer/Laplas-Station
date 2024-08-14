/client/proc/spawn_overmap_object()
	set category = "Debug"
	set name = "Spawn overmap object"
	if(!check_rights(R_DEBUG))
		return
	var/name = sanitize_text(input(usr, "Input new object name", "Object name", "Object"))

	var/type = sanitize_text(input(usr, "Input new object class: object, gravitational, ship ", "Object class", "object"))
	var/position_x = text2num(input(usr, "Input new x position for object", "X position", "0"))
	if(!isnum(position_x))
		position_x = 0
	var/position_y = text2num(input(usr, "Input new y position for object", "Y position", "0"))
	if(!isnum(position_y))
		position_x = 0
	var/texture_path = input(usr, "Input texutre path for overmap object, must start from overmap server acess folder: acess/object.png", "Texture path", "assets/object.png")
	var/list/position = list(
		"x" = position_x,
		"y" = position_y
	)
	new /datum/overmap_object(position, name, type, texture_path)
