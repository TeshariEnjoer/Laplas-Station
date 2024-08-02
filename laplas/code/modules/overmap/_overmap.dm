/datum/controller/subsystem/overmap/proc/spawn_mathership()
	var/datum/parsed_map/pm = SSmapping.init_mathership()
	if(!istype(pm))
		return
	var/list/spawn_loc = list(
		"x" = rand(0, 40),
		"y" = rand(0, 40)
	)
	var/datum/overmap/ship/controlled/mathership/S = new(spawn_loc)
