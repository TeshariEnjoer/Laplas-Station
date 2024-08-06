/obj/docking_port/mobile/mathership

/obj/docking_port/mobile/mathership/Initialize(mapload, datum/overmap/ship/controlled/mathership/new_ship)
	. = ..()

/obj/docking_port/mobile/mathership/proc/after_linkup()
	//Init gravgens

/obj/docking_port/mobile/mathership/load(datum/map_template/shuttle/source_template)
	for(var/thing in shuttle_areas)
		var/area/A = shuttle_areas[thing]
		if(!istype(A, /area/ship/))
			continue
		var/area/ship/SA = A
		SA.link_to_shuttle(src)
		shuttle_areas |= SA

/obj/docking_port/mobile/mathership/linkup(obj/docking_port/stationary/dock, datum/overmap/ship/controlled/mathership/new_ship)
	current_ship = new_ship
	docked = dock
	dock.docked = src
	for(var/area/ship/SA in shuttle_areas)
		SA.connect_to_shuttle(src, dock)
		for(var/atom/A in SA)
			A.connect_to_shuttle(src, dock)

