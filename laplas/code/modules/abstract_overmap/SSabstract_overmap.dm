SUBSYSTEM_DEF(abstract_overmap)
	name = "Abstract overmap"
	wait = 3 SECONDS
	init_order = INIT_ORDER_OVERMAP
	flags = SS_KEEP_TIMING|SS_NO_TICK_CHECK

	///Key what used for acess to abstract overmap server.
	VAR_PROTECTED/http_key = null
	///URL of abstact overmap server.
	VAR_PROTECTED/http_url

	///List of all overmap objects.
	VAR_PRIVATE/list/overmap_objects
	///List of all simulated ships. All ships in this list are fully initialized.
	VAR_PRIVATE/list/controlled_ships
	///List of spawned outposts. The default spawn location is the first index.
	VAR_PRIVATE/list/outposts

	var/map_server_status
	//Path to server main script
	var/main_path
