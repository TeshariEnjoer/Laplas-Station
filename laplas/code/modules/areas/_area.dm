/obj
	//Used to identify ship-safe objects that would be bad to lose. Makes it easier to find them on very large ships.
	var/important = FALSE

/obj/machinery
	important = TRUE

/obj/machinery/gravity_generator

/area/ship
	var/list/important_objects = list()

/area/ship/proc/find_importanat_objects()
	for(var/obj/O in src)
		if(O.important)
			important_objects |= O

/obj/machinery/gravity_generator

/obj/machinery/gravity_generator/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	. = ..()
	port.gravgen_list |= WEAKREF(src)
