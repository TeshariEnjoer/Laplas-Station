GLOBAL_LIST_EMPTY(mathership_areas)

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

	INIT_ANNOUNCE("Initialized map [name] in [(REALTIMEOFDAY - load_start_time)/10] seconds!")
	return MT.cached_map

/datum/controller/subsystem/overmap/proc/InitializeMathership()
	var/map_name = CONFIG_GET(string/default_mathership)
	var/full_path = "_maps/shuttles/matherships/[map_name].dmm"

	var/datum/parsed_map/ship_map = SSmapping.load_map_as_template(map_name, full_path)
	if(!ship_map)
		return

	var/datum/map_template/shuttle/mathership/ship = new()
	var/datum/space_level/ship_level
	for(var/datum/space_level/SL as anything in SSmapping.z_list)
		if(SL.name == map_name)
			ship_level = SL
			break
	var/datum/virtual_level/ship_vlevel = ship_level.virtual_levels[1]


	var/turf/T = ship_vlevel.get_unreserved_bottom_left_turf()
	var/obj/docking_port/mobile/mathership/port = new(T)
	if(!port)
		CRASH("Mathership [ship.name], failed to find docking port")

	var/datum/overmap/ship/controlled/mathership/vessel = new(get_unused_overmap_square(), ship, FALSE)
	vessel.connect_new_shuttle_port(port)
	port.load(ship, ship_map)
	port.linkup(port, vessel)
