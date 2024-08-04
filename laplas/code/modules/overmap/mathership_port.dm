/obj/docking_port/mobile/mathership

/obj/docking_port/mobile/mathership/Initialize(mapload, datum/overmap/ship/controlled/mathership/new_ship)
	. = ..()
	if(istype(loc, /area/ship))
		var/area/ship/SA
		SA.important_objects |= src

/obj/docking_port/mobile/mathership/load(datum/map_template/shuttle/source_template, datum/parsed_map/cached_map)
	shuttle_areas = list()
	for(var/thing in cached_map.loaded_areas)
		var/area/A = cached_map.loaded_areas[thing]
		if(!istype(A, /area/ship/))
			continue
		var/area/ship/SA = A
		SA.link_to_shuttle(src)
		SA.find_importanat_objects()
		shuttle_areas |= SA
	qdel(cached_map)

/obj/docking_port/mobile/mathership/linkup(obj/docking_port/stationary/dock, datum/overmap/ship/controlled/mathership/new_ship)
	current_ship = new_ship
	docked = dock
	dock.docked = src
	for(var/area/ship/SA in shuttle_areas)
		SA.connect_to_shuttle(src, dock)
		for(var/atom/A in SA.important_objects)
			if(!istype(A))
				SA.important_objects -= A
			A.connect_to_shuttle(src, dock)
