SUBSYSTEM_DEF(abstract_overmap)
	name = "Abstract overmap"
	wait = 3 SECONDS
	init_order = -26
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
	var/list/overmap_objects = list()
	///List of all simulated ships. All ships in this list are fully initialized.
	var/list/controlled_ships = list()
	///List of spawned outposts. The default spawn location is the first index.
	var/list/stations = list()

	var/map_server_status = MAP_SERVER_STATUS_DISABLED
	///Path to server main script
	var/main_path

	var/last_claimed_id = "obj-0"
	var/last_claimed_id_number = 0
	var/last_unclaimed_id = 0

/datum/controller/subsystem/abstract_overmap/Initialize(start_timeofday)
	. = ..()
	if(!ping())
		return
	add_startup_message("Abstract map server online - begining initialization!")
	if(!generate_secure_key())
		CRASH("[name] failed to install new secure key!")

//	init_map()

/datum/controller/subsystem/abstract_overmap/fire(resumed)
	for(var/datum/overmap_object/OB in overmap_objects)
		if(!OB.is_static && OB.get_speed() > 0)
			INVOKE_ASYNC(OB, TYPE_PROC_REF(/datum/overmap_object, sync))

//Pings the overmap server
/datum/controller/subsystem/abstract_overmap/proc/ping()
	var/response = abstract_map_request(ABSTRACT_MAP_PING, "")
	if(response == AM_RESPONSE_SUCESS)
		message_admins("Abstarct map online")


/datum/controller/subsystem/abstract_overmap/proc/init_map()
	. = ""
	. += "size_x = [map_size_x],"
	. += "size_y = [map_size_y],"
	. += "generation_type [generation_type],"
	. += "max_planets [max_planets],"
	. += "max_outposts [max_outposts],"
	var/response = abstract_map_request(ABSTRACT_MAP_INIT, .)


/datum/controller/subsystem/abstract_overmap/proc/reset_key()
	var/response = abstract_map_request(ABSTRACT_MAP_RESET_KEY, "")
	if(response == AM_RESPONSE_SUCESS)
		return TRUE

/datum/controller/subsystem/abstract_overmap/proc/abstract_map_request(function, data)
	set waitfor = FALSE

	var/datum/http_request/request = new()
	request.prepare(RUSTG_HTTP_METHOD_GET, DEFAULT_ABSTRACT_MAP_URL + function , "[http_key]," + data, list("Accept" = "text/plain"))
	request.begin_async()
	UNTIL(request.is_complete())

	var/datum/http_response/response = request.into_response()
	if(response.status_code != 200)
		CRASH(response.body)
	qdel(request)
	return response.body

/datum/controller/subsystem/abstract_overmap/proc/generate_secure_key()
	if(http_key)
		reset_key()
	var/new_key = "[rand(1, 99999999)][pick("A, B, C, D")]"
	var/response = abstract_map_request(ABSTRACT_MAP_SET_KEY, new_key)

	if(response == AM_RESPONSE_SUCESS)
		http_key = new_key
		return TRUE
	CRASH(response)

/datum/controller/subsystem/abstract_overmap/proc/get_last_unclaimed_id()
	var/check_id = last_claimed_id
	if(check_id in overmap_objects[last_unclaimed_id])
		var/finding = TRUE
		while(finding)
			last_claimed_id_number += 1
			check_id = "obj-[last_claimed_id_number]"
			if(!(check_id in overmap_objects))
				finding = FALSE
	return check_id

/datum/controller/subsystem/abstract_overmap/proc/get_random_overmap_position(center_offset)
	var/list/position
	var/response = abstract_map_request(ABSTRACT_MAP_GET_RANDOM_POSITION, "[center_offset]")
	position = list(
		"x" = response["x"],
		"y" = response["y"]
	)
	return position

/datum/controller/subsystem/abstract_overmap/proc/spawn_overmap_object(datum/overmap_object/new_object, x, y)
	. = ""
	. += "name = [new_object.name],"
	. += "id = [new_object.id],"
	. += "x = [x],"
	. += "y = [y],"
	. += "texture_path = [new_object.overmap_texture_path],"
	. += "class_type = [new_object.class_type],"
	. += "width = [new_object.width],"
	. += "height = [new_object.height],"
	var/response = abstract_map_request(ABSTRACT_MAP_SPAWN_OBJECT, .)
	if(!response)
		return FALSE

	overmap_objects[new_object.id] = new_object
	return TRUE

/datum/controller/subsystem/abstract_overmap/proc/remove_overmap_object(id)
	return abstract_map_request(ABSTRACT_MAP_REMOVE_OBJECT, "[id]")
