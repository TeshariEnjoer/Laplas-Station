SUBSYSTEM_DEF(abstract_overmap)
	name = "Abstract overmap"
	wait = 3 SECONDS
	init_order = INIT_ORDER_OVERMAP
	flags = SS_KEEP_TIMING|SS_NO_TICK_CHECK

	/// Map hidth in kilometrs.
	var/map_width = 1000
	/// Map height in kilometrs.
	var/map_height = 1000
	/// Map generation type, similar to standart shiptest map generation.
	var/generation_type
	/// Maximum amount of planets that can generate on the map.
	var/max_planets = 3
	/// Maximum amount of outposts that can generate on the map.
	var/max_outposts = 2


	///List of all overmap objects.
	VAR_PRIVATE/list/overmap_objects
	///List of all simulated ships. All ships in this list are fully initialized.
	VAR_PRIVATE/list/controlled_ships
	///List of spawned outposts. The default spawn location is the first index.
	VAR_PRIVATE/list/outposts
	///Our actuall map
	VAR_PRIVATE/list/map = list()

	var/map_server_status = MAP_SERVER_STATUS_DISABLED
	///Path to server main script
	var/main_path
	var/client


/datum/controller/subsystem/abstract_overmap/Initialize(start_timeofday)
	. = ..()

	add_startup_message("Begin overmap initizalization!")
	create_map()


/datum/controller/subsystem/abstract_overmap/proc/create_map()
	var/x = 0
	var/y = 0
	while(x < map_width)
		while(y < map_height)
			var/datum/overmap_cell/cell = new(x, y)
			map["[x], [y]"] = cell
			y++
			stoplag()
		x++
