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

/obj/machinery/power/ship_gravity
