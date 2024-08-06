GLOBAL_LIST_EMPTY(mathership_areas)
/datum/controller/subsystem/overmap/proc/load_world()
	//First create mathership
	var/datum/map_template/shuttle/mathership/main_ship = new()
	if(!SSmapping.load_virtual_map(main_ship.name, main_ship.file_name, VTRAITS_MATHERSHIP))
		CRASH("Failed to spawn [main_ship.name], by path [main_ship.file_name]")
	new /datum/overmap/ship/controlled/mathership(get_unused_overmap_square(), main_ship, FALSE)
