/datum/overmap_cell
	var/x = 0
	var/y = 0
	var/list/content = null

/datum/overmap_cell/New(x, y)
	src.x = x
	src.y = y

/datum/overmap_cell/proc/move_in(any)
	content += any

/datum/overmap_cell/proc/move_out(any)
	content -= any
