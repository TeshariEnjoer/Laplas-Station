SUBSYSTEM_DEF(abstract_overmap)
	name = "Abstract overmap"
	wait = 3 SECONDS
	init_order = INIT_ORDER_OVERMAP
	flags = SS_KEEP_TIMING|SS_NO_TICK_CHECK

	/// Map hidth in kilometrs.
	var/map_size_x = 5000
	/// Map height in kilometrs.
	var/map_size_y = 5000
	/// Map generation type, similar to standart shiptest map generation.
	var/generation_type
	/// Maximum amount of planets that can generate on the map.
	var/max_planets = 3
	/// Maximum amount of outposts that can generate on the map.
	var/max_outposts = 2

	///Key what used for acess to abstract overmap server.
	VAR_PROTECTED/http_key = null

	///List of all overmap objects.
	VAR_PRIVATE/list/overmap_objects
	///List of all simulated ships. All ships in this list are fully initialized.
	VAR_PRIVATE/list/controlled_ships
	///List of spawned outposts. The default spawn location is the first index.
	VAR_PRIVATE/list/outposts

	var/map_server_status = MAP_SERVER_STATUS_DISABLED
	///Path to server main script
	var/main_path

/datum/controller/subsystem/abstract_overmap/Initialize(start_timeofday)
	. = ..()
	if(!generate_secure_key())
		CRASH("[name] failed to install new secure key!")
	init_map()


/datum/controller/subsystem/abstract_overmap/proc/init_map()
	. = ""
	. += "key = [http_key],"
	. += "size_x = [map_size_x],"
	. += "size_y = [map_size_y],"
	. += "generation_type [generation_type],"
	. += "max_planets [max_planets],"
	. += "max_outposts [max_outposts],"
	var/response = ABSTRACT_MAP_REQUEST(ABSTRACT_MAP_INIT, args)



/datum/controller/subsystem/abstract_overmap/proc/reset_key()
	var/response = ABSTRACT_MAP_REQUEST(ABSTRACT_MAP_RESET_KEY, http_key)
	if(response == AM_RESPONSE_SUCESS)
		return TRUE

/datum/controller/subsystem/abstract_overmap/proc/generate_secure_key()
	if(http_key)
		reset_key()
	var/new_key = "[rand(1, 99999999)][pick("A, B, C, D")]"
	var/response = ABSTRACT_MAP_REQUEST(ABSTRACT_MAP_SET_KEY, new_key)

	if(response == AM_RESPONSE_SUCESS)
		http_key = new_key
		return TRUE
	CRASH(response)
