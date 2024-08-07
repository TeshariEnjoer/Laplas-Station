/obj/machinery/gravity_generator/connect_to_shuttle(obj/docking_port/mobile/port, obj/docking_port/stationary/dock)
	. = ..()
	port.gravgen_list += src
