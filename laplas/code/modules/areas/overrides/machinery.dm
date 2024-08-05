/obj/machinery/cryopod
	important = TRUE

/obj/machinery/cryopod/Initialize()
	..()
	if(istype(src.loc, /area/ship))
		var/area/ship/SA = loc
		SA.important_objects |= src

/obj/machinery/cryopod/Destroy()
	. = ..()
	if(istype(src.loc, /area/ship))
		var/area/ship/SA = loc
		SA.important_objects -= src

/obj/machinery/gravity_generator/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	. = ..()
	port.gravgen_list += src
