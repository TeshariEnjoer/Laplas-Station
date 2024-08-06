GLOBAL_LIST_INIT(virtual_levels, list())

/datum/controller/subsystem/mapping/proc/get_map_areas_by_vlevel(name)
	var/datum/virtual_level/vlevel = GLOB.virtual_levels[name]
	if(!vlevel)
		CRASH("Trying to get unexisted virtual level! [name]")
	return vlevel.get_areas()

/datum/controller/subsystem/mapping/proc/load_virtual_map(name, path, traits, default_traits = ZTRAITS_STATION)
	var/load_start_time = REALTIMEOFDAY
	var/datum/virtual_level/map_level
	var/datum/map_zone/MZ = new(name)
	var/datum/space_level/SL = SSmapping.add_new_zlevel(name, allocation_type = ALLOCATION_FORBID)

	if(!traits)
		message_admins("Trying to load map: [name] with no traits!")
		traits = default_traits

	ship_level = new("[name]", traits, MZ, 1, 1, QUADRANT_MAP_SIZE, QUADRANT_MAP_SIZE, SL.z_value)
	load_map(path)

/datum/controller/subsystem/mapping/proc/load_map_as_template(name, path)
	var/load_start_time = REALTIMEOFDAY

	var/datum/map_template/MT = new(path)
	var/datum/space_level/SL = SSmapping.add_new_zlevel(name, allocation_type = ALLOCATION_FORBID)
	var/datum/map_zone/MZ = new("[name]")
	var/datum/virtual_level/ship_vlevel = new("[name]", VTRAITS_MOTHERSHIP, MZ, 1, 1, QUADRANT_MAP_SIZE, QUADRANT_MAP_SIZE, SL.z_value)
	if(!ship_vlevel)
		CRASH("failed to allocate an area for ship [name]")
	ship_vlevel.fill_in(/turf/open/space)
	MT.keep_cached_map = TRUE
	MT.load(ship_vlevel.get_unreserved_bottom_left_turf(), FALSE, TRUE)

	add_startup_message("Loadet map [name] in [(REALTIMEOFDAY - load_start_time)/10] seconds!")
	return TRUE

/datum/virtual_level
	//List of all areas inside vlevel
	var/list/area/areas = list()

/datum/virtual_level/New(passed_name, list/passed_traits, datum/map_zone/passed_map, lx, ly, hx, hy, passed_z)
	GLOB.virtual_level += ("[name]" = src)
	if(SSticker.current_state == GAME_STATE_STARTUP)
		add_startup_message("Loading virtual level [name]!")
	..()

/datum/virtual_level/Destroy()
	. = ..()
	GLOB.virtual_level -= src
	areas = null

/datum/virtual_level/proc/load_areas()
	var/list/turf/turfs = list()
	turfs = block(locate(low_x, low_y, z_value), locate(high_x, high_y, z_value))
	for(var/turf/T in turfs)
		var/area/A = T.loc
		if(!A || areas[A])
			continue
		add_area(A)

/datum/virtual_level/proc/add_area(area/area_to_add)
	if(!area_to_add)
		return
	areas? |= area_to_add

/datum/virtual_level/proc/remove_area(area/area_to_remove)
	if(area?.[area_to_remove])
		area -= area_to_remove

/datum/virtual_level/proc/get_areas()
	return areas
