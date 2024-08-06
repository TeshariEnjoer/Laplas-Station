/datum/overmap/ship/controlled/mathership

	join_mode = SHIP_JOIN_MODE_OPEN
	ship_flags = SHIP_FLAG_MATHERSHIP | SHIP_FLAG_MOVEABLE
	/// Ships that are in the mothership
	var/list/datum/overmap/ship/landet_ships = list()


/datum/overmap/ship/controlled/mathership/Initialize(position, datum/map_template/shuttle/creation_template, create_shuttle)
	..()
	var/datum/virtual_level/vlevel = SSmapping.get_vlevel_by_name(creation_template.name)
	var/obj/docking_port/mobile/mathership/port = new(vlevel.get_center())

	port.register()
	port.shuttle_areas = vlevel.get_areas()
	connect_new_shuttle_port(port)
	port.load(creation_template)
	port.linkup(port, src)
	Rename("[creation_template.name]", TRUE)

/datum/overmap/ship/controlled/mathership/connect_new_shuttle_port(obj/docking_port/mobile/new_port)
	if(shuttle_port)
		CRASH("Attempted to connect a new port to a ship that already has a port!")
	shuttle_port = new_port
	shuttle_port.name = name
	for(var/area/shuttle_area as anything in shuttle_port.shuttle_areas)
		shuttle_area.rename_area("[name] [initial(shuttle_area.name)]")
