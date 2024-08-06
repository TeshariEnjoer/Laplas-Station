/datum/map_template/shuttle/mathership
	keep_cached_map = TRUE
	limit = 1
	enabled = TRUE
	unique_ship_access = FALSE

	var/list/sotred_areas
/**
	Load data from JSON file and prepare template for deployment
 */
/datum/map_template/shuttle/mathership/New(path, rename, cache)
	. = ..()

	/// Reading configs
	var/config_file = file("config/laplas_configs/mathership_config.json")
	config_file = file2text(config_file )

	var/list/data = json_decode(config_file)
	if(!data)
		stack_trace("map config is not json: [mappath]")

	if(istext(data["map_name"]))
		name = data["map_name"]
	file_name = data["map_path"]
	if(istext(data["map_short_name"]))
		short_name = data["map_short_name"]
	else
		short_name = copytext(name, 1, 20)

	if(istext(data["prefix"]))
		prefix = data["prefix"]
	if(istext(data["faction_name"]))
		faction_name = data["faction_name"]
	else
		faction_name = ship_prefix_to_faction(prefix)
	category = faction_name
	if(islist(data["namelists"]))
		name_categories = data["namelists"]
	if(isnum(data[ "unique_ship_access" ] && data["unique_ship_access"]))
		unique_ship_access = data[ "unique_ship_access" ]
	if(istext(data["description"]))
		description = data["description"]
	if(islist(data["tags"]))
		tags = data["tags"]
	job_slots = list()
	var/list/job_slot_list = data["job_slots"]
	for(var/job in job_slot_list)
		var/datum/job/job_slot
		var/value = job_slot_list[job]
		var/slots
		if(isnum(value))
			job_slot = GLOB.name_occupations[job]
			slots = value
		else if(islist(value))
			var/datum/outfit/job_outfit = text2path(value["outfit"])
			if(isnull(job_outfit))
				stack_trace("Invalid job outfit! [value["outfit"]] on [name]'s config! Defaulting to assistant clothing.")
				job_outfit = /datum/outfit/job/assistant
			job_slot = new /datum/job(job, job_outfit)
			job_slot.display_order = length(job_slots)
			job_slot.wiki_page = value["wiki_page"]
			job_slot.officer = value["officer"]
			slots = value["slots"]

		if(!job_slot || !slots)
			stack_trace("Invalid job slot entry! [job]: [value] on [name]'s config! Excluding job.")
			continue
		job_slots[job_slot] = slots

	if(isnum(data["spawn_time_coeff"]))
		spawn_time_coeff = data["spawn_time_coeff"]
	if(isnum(data["officer_time_coeff"]))
		officer_time_coeff = data["officer_time_coeff"]
	if(isnum(data["starting_funds"]))
		starting_funds = data["starting_funds"]
	if(isnum(data["space_spawn"]) && data["space_spawn"])
		space_spawn = TRUE

/**
	To avoid overloading the game during the creation of such a large ship, we will use some tricks.
 */
/datum/map_template/shuttle/mathership/load(turf/T, centered, register)
	var/datum/parsed_map/parsed = cached_map || new(file(mappath))
	cached_map = keep_cached_map ? parsed : null
	if(!parsed.load(T.x, T.y, T.z, cropMap=TRUE, no_changeturf=(SSatoms.initialized == INITIALIZATION_INSSATOMS), placeOnTop=should_place_on_top))
		return

	sotred_areas = parsed.loaded_areas
