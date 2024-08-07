GLOBAL_LIST_INIT(virtual_levels, list())

/datum/controller/subsystem/mapping/proc/get_map_areas_by_vlevel(name)
	var/datum/virtual_level/vlevel = GLOB.virtual_levels[name]
	if(!vlevel)
		CRASH("Trying to get unexisted virtual level! [name]")
	return vlevel.get_areas()

/datum/controller/subsystem/mapping/proc/get_vlevel_by_name(name)
	var/datum/virtual_level/vlevel = GLOB.virtual_levels[name]
	if(!vlevel)
		CRASH("Trying to get unexisted virtual level! [name]")
	return vlevel


/**
	Load map in new virtual z level

	- name: name of the new map
	- path: full path to dmm file
	- traits: traits for the new level
 */
/datum/controller/subsystem/mapping/proc/load_virtual_map(name, path, traits, default_traits = ZTRAITS_STATION)
	add_startup_message("Loading map: [name]")
	var/load_start_time = REALTIMEOFDAY
	var/datum/virtual_level/map_level
	var/datum/map_zone/MZ = new(name)
	var/datum/space_level/SL = SSmapping.add_new_zlevel(name, allocation_type = ALLOCATION_FORBID)


	var/dmm_file = file(path)
	if(!fexists(dmm_file))
		CRASH("Failed to find map by path: [path]")
	if(!traits)
		message_admins("Trying to load map: [name] with no traits!")
		traits = default_traits

	map_level = new("[name]", traits, MZ, 1, 1, QUADRANT_MAP_SIZE, QUADRANT_MAP_SIZE, SL.z_value)
	var/turf/T = map_level.get_unreserved_bottom_left_turf()
	var/datum/parsed_map/parsed = new(dmm_file)
	if(!parsed.load(T.x, T.y, T.z, cropMap=FALSE, no_changeturf=(SSatoms.initialized == INITIALIZATION_INSSATOMS)))
		CRASH("Map: [name], isn't loadet!")


	//Initialization atoms
	if(SSatoms.initialized == INITIALIZATION_INSSATOMS)
		return TRUE

	var/list/obj/machinery/atmospherics/atmos_machines = list()
	var/list/obj/structure/cable/cables = list()
	var/list/atom/atoms = list()
	var/bounds = parsed.bounds
	var/list/turfs = block(
		locate(
			bounds[MAP_MINX],
			bounds[MAP_MINY],
			bounds[MAP_MINZ]
			),
		locate(
			bounds[MAP_MAXX],
			bounds[MAP_MAXY],
			bounds[MAP_MAXZ]
			)
		)
	var/list/areas_to_load = list()
	for(var/L in turfs)
		var/turf/B = L
		areas_to_load |= B.loc
		for(var/A in B)
			atoms += A
			if(istype(A, /obj/structure/cable))
				cables += A
				continue
			if(istype(A, /obj/machinery/atmospherics))
				atmos_machines += A

	for(var/area/A as anything in areas_to_load)
		map_level.add_area(A)

	SSmapping.reg_in_areas_in_z(areas_to_load)
	SSatoms.InitializeAtoms(areas_to_load + turfs + atoms, null)
	SSmachines.setup_template_powernets(cables)
	SSair.setup_template_machinery(atmos_machines)
	add_startup_message("Loadet map: [name] in [(REALTIMEOFDAY - load_start_time)/10]")
	return TRUE


/datum/virtual_level
	//List of all areas inside vlevel
	var/list/area/areas = list()

/datum/virtual_level/New(passed_name, list/passed_traits, datum/map_zone/passed_map, lx, ly, hx, hy, passed_z)
	GLOB.virtual_levels[passed_name] = src
	if(SSticker.current_state == GAME_STATE_STARTUP)
		add_startup_message("Loading virtual level [name]!")
	..()

/datum/virtual_level/Destroy()
	GLOB.virtual_levels.Remove(name)
	areas = null
	. = ..()

/datum/virtual_level/proc/load_areas()
	var/list/turf/turfs = list()
	turfs = block(locate(low_x, low_y, z_value), locate(high_x, high_y, z_value))
	for(var/turf/T in turfs)
		var/area/A = T.loc
		if(!A || areas[A])
			continue
		add_area(A)

/datum/virtual_level/proc/add_area(area/area_to_add)
	if(!areas)
		areas = list()
	if(!area_to_add)
		return
	areas |= area_to_add

/datum/virtual_level/proc/remove_area(area/area_to_remove)
	if(areas?[area_to_remove])
		areas -= area_to_remove

/datum/virtual_level/proc/get_areas()
	return areas
