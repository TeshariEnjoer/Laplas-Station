/datum/overmap_object
	/// The name of this overmap datum, propogated to the token, docking port, and areas.
	var/name
	/// The ID of overmap object
	var/id = 0
	/// The class type of the object on overmap server
	var/class_type = "object"


	/* OVERMAP SERVER, SYNDEC VARRIBLES */
	/// The x position of this datum on the overmap. //overmap-side
	VAR_PROTECTED/x = 0
	/// The y position of this datum on the overmap. //overmap-side
	VAR_PROTECTED/y = 0
	/// The speed of object, updating with overmap server. //overmap-side
	VAR_PROTECTED/speed = 0
	/// The speed with objecrt rotate is. //overmap-side
	VAR_PROTECTED/rotation_speed = 0
	/// Angle of object. //overmap-side
	VAR_PROTECTED/angle = 0

	/// The size of object sprite, also changes physicaly size of object
	var/width = 32
	var/height = 32

	/// Movement process would'nt effect on static objects, gravitational forces still workds. //overmap-side
	var/is_static = FALSE

	/// The time, in deciseconds, needed for this object to call
	var/dock_time
	/// The current docking timer ID.
	var/dock_timer_id
	/// Whether or not the overmap object is currently docking.
	var/docking

	/// List of all datums docked in this datum.
	var/list/datum/overmap_object/contents
	/// The datum this datum is docked to.
	var/datum/overmap_object/docked_to

	/// The icon state the token will be set to on init.
	var/overmap_texture_path = "assets/object.png"

	/// The current docking ticket of this object, if any
	var/datum/docking_ticket/current_docking_ticket

/datum/overmap_object/New(position, ...)
	SHOULD_NOT_OVERRIDE(TRUE)
	contents = list()

	Initialize(arglist(args))

/datum/overmap_object/Destroy(force, ...)
	var/result = SSabstract_overmap.remove_overmap_object(id)
	if(!result == AM_RESPONSE_SUCESS)
		CRASH("Trying to remove overmap ojbect: [src.name] - [src.id], but get error: [result]")
	SSabstract_overmap.overmap_objects -= src
	if(current_docking_ticket)
		QDEL_NULL(current_docking_ticket)
	if(docked_to)
//		docked_to.post_undocked()
		docked_to.contents -= src
	QDEL_LIST(contents)
	return ..()

/datum/overmap_object/proc/Initialize(position, name, class_type, texture_path, ...)
	PROTECTED_PROC(TRUE)

	if(!position)
		position = SSabstract_overmap.get_random_overmap_position(rand(8000, 10000))

	var/new_x
	var/new_y
	if(islist(position))
		new_x = position["x"]
		new_y = position["y"]
	src.name = name
	src.class_type = class_type
	src.overmap_texture_path = texture_path
	id = SSabstract_overmap.get_last_unclaimed_id()

	SSabstract_overmap.spawn_overmap_object(src, new_x, new_y)
	return

/datum/overmap_object/proc/sync(sync_depth = SYNC_TYPE_PHYSIC)
	SHOULD_NOT_OVERRIDE(TRUE)
	set waitfor = FALSE

	var/raw_data = SSabstract_overmap.abstract_map_request(ABSTRACT_MAP_SYNC, "type = [sync_depth], id = [id]")
	var/list/params_list = splittext(raw_data, ",")
	for (var/param in params_list)
		param = trim(param)
		var/list/pair = splittext(param, "=")
		var/name = trim(pair[1])
		var/value = text2num(trim(pair[2]))
		if(name == "speed")
			speed = text2num(value)
		else if(name == "angle")
			angle = text2num(value)
		else if(name == "rotation_speed")
			rotation_speed = text2num(value)
		else if(name == "x")
			x = text2num(value)
		else if(name == "y")
			y = text2num(value)


/// Will push the object in current angle.
/datum/overmap_object/proc/apply_thrust(force)
	SHOULD_CALL_PARENT(TRUE)
	var/response = SSabstract_overmap.abstract_map_request(ABSTRACT_MAP_MOVE_OBJECT, "move_type = thrust", "value = [force]")
	try
		speed = text2num(response)
	catch
		speed = 0
	sync()

/datum/overmap_object/proc/apply_brake(force)
	SHOULD_CALL_PARENT(TRUE)
	var/response = SSabstract_overmap.abstract_map_request(ABSTRACT_MAP_MOVE_OBJECT, "move_type = brake", "value = [force]")
	try
		speed = text2num(response)
	catch
		speed = 0
	sync()

/// Sets object new angle.
/datum/overmap_object/proc/set_angle(new_angle)
	SHOULD_CALL_PARENT(TRUE)
	var/response = SSabstract_overmap.abstract_map_request(ABSTRACT_MAP_MOVE_OBJECT, "move_type = set_rotation", "value = [new_angle]")
	try
		angle = text2num(response)
	catch
		angle = 0
	sync()

/// Sets object rotation speed, positive number will rotate in right side, negative in left.
/datum/overmap_object/proc/apply_rotation(rotation_speed)
	SHOULD_CALL_PARENT(TRUE)
	var/response = SSabstract_overmap.abstract_map_request(ABSTRACT_MAP_MOVE_OBJECT, "move_type = apply_rotation", "value = [rotation_speed]")
	try
		rotation_speed = text2num(response)
	catch
		rotation_speed = 0
	sync()

/datum/overmap_object/proc/get_speed()
	return speed

/datum/overmap_object/proc/get_angle()
	return angle

/datum/overmap_object/proc/get_rotation_speed()
	return rotation_speed

/datum/overmap_object/proc/Rename(new_name, force)
	new_name = sanitize_name(new_name)
	if(!new_name || new_name == name)
		return FALSE
	name = new_name
	return


//DOCKING CODE, mostly similar to default shiptest docking code

/**
 * Docks the overmap datum to another overmap datum, putting it in the other's contents and removing it from the overmap.
 * Sets X and Y equal to null. Does not check for distance or nulls.
 *
 * * dock_target - abstract object to dock to. Cannot be null.
 */

/datum/overmap_object/proc/Dock(datum/overmap_object/dock_target, force = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if(!istype(dock_target))
		CRASH("Overmap datum [src] tried to dock to an invalid overmap datum.")
	if(docked_to)
		CRASH("Overmap datum [src] tried to dock to [dock_target] when it is already docked to another overmap datum ([docked_to])!.")

	if(docking || current_docking_ticket)
		return "Already docking!"
	docking = TRUE

	var/datum/docking_ticket/ticket = dock_target.pre_docked(src)
	var/ticket_error = ticket?.docking_error
	if(!ticket || ticket_error)
		qdel(ticket)
		docking = FALSE
		return ticket_error || "Unknown docking error!"
	if(!pre_dock(dock_target, ticket))
		qdel(ticket)
		docking = FALSE
		return ticket_error

	start_dock(dock_target, ticket)

	if(dock_time && !force)
		dock_timer_id = addtimer(CALLBACK(src, PROC_REF(complete_dock), dock_target, ticket), dock_time)
	else
		complete_dock(dock_target, ticket)


/**
 * Called at the very start of a [datum/overmap/proc/Dock] call, on the **TARGET of the docking attempt**. If it returns FALSE, the docking will be aborted.
 * Called before [datum/overmap/proc/pre_dock] is called on the dock requester.
 *
 * * dock_requester - The overmap datum trying to dock with this one. Cannot be null.
 *
 * Returns - A docking ticket that will be passed to [datum/overmap/proc/pre_dock] on the dock requester.
 */

/datum/overmap_object/proc/pre_docked(datum/overmap/dock_requester)
	RETURN_TYPE(/datum/docking_ticket)
	return new /datum/docking_ticket(_docking_error = "[src] cannot be docked to.")



/**
 * Called at the very start of a [datum/overmap/proc/Dock] call. If it returns FALSE, the docking will be aborted.
 * Will only be called after [datum/overmap/proc/pre_docked] has been called and returned TRUE.
 *
 * * dock_target - The overmap datum to dock to. Cannot be null.
 * * ticket - The docking ticket that was returned from the [datum/overmap/proc/pre_docked] call.
 */

/datum/overmap_object/proc/pre_dock(datum/overmap_object/dock_target, datum/docking_ticket/ticket)
	return FALSE

/**
 * For defining custom actual docking behaviour. Called after both [datum/overmap/proc/pre_dock] and [datum/overmap/proc/pre_docked] have been called and they both returned TRUE.
 *
 * * dock_target - The overmap datum to dock to. Cannot be null.
 * * ticket - The docking ticket that was returned from the [datum/overmap/proc/pre_docked] call.
 */
/datum/overmap_object/proc/start_dock(datum/overmap/dock_target, datum/docking_ticket/ticket)
	return

/**
 * Called after [datum/overmap/proc/start_dock], either instantly or after a time depending on the [datum/overmap/var/dock_time] variable.
 * Return result is ignored.
 *
 * * dock_target - The overmap datum that has been docked to. Cannot be null.
 * * ticket - The docking ticket that was returned from the [datum/overmap/proc/pre_docked] call.
 */
/datum/overmap_object/proc/complete_dock(datum/overmap_object/dock_target, datum/docking_ticket/ticket)
	SHOULD_CALL_PARENT(TRUE)
	if(isnum(x) && isnum(y))
		SSovermap.overmap_container[x][y] -= src
	x = null
	y = null
	dock_target.contents |= src
	docked_to = dock_target

	dock_target.post_docked(src)
	docking = FALSE

	//Clears the docking ticket from both sides
	qdel(current_docking_ticket)

	SEND_SIGNAL(src, COMSIG_OVERMAP_DOCK, dock_target)

/**
 * Called at the very end of a [datum/overmap/proc/Dock] call, on the **TARGET of the docking attempt**. Return value is ignored.
 *
 * * dock_requester - The overmap datum trying to dock with this one. Cannot be null.
 */
/datum/overmap_object/proc/post_docked(datum/overmap_object/dock_requester)
	return

/**
 * Undocks from the object this datum is docked to currently, and places it back on the overmap at the position of the object that was previously docked to.
 */
/datum/overmap_object/proc/Undock(force = FALSE)
	SHOULD_CALL_PARENT(TRUE)
	if(!docked_to)
		CRASH("Overmap datum [src] tried to undock() but is not docked to anything.")

	if(docking)
		return
	docking = TRUE

	if(dock_time && !force)
		dock_timer_id = addtimer(CALLBACK(src, PROC_REF(complete_undock)), dock_time)
	else
		complete_undock()

/**
 * Called after [datum/overmap/proc/Undock], either instantly or after a time depending on the [datum/overmap/var/dock_time] variable.
 * Return result is ignored.
 */
/datum/overmap_object/proc/complete_undock()
	SHOULD_CALL_PARENT(TRUE)
	var/datum/overmap/container = docked_to
	while(container && !container.x || !container.y)
		container = container.docked_to
	SSovermap.overmap_container[container.x][container.y] += src
	x = container.x
	y = container.y
	docked_to.contents -= src
	var/datum/overmap/old_docked_to = docked_to
	docked_to = null
	INVOKE_ASYNC(old_docked_to, PROC_REF(post_undocked), src)
	docking = FALSE
	SEND_SIGNAL(src, COMSIG_OVERMAP_UNDOCK, old_docked_to)

/**
 * Called at the very end of a [datum/overmap/proc/Unock] call (non-blocking/asynchronously), on the **TARGET of the undocking attempt**. Return result is ignored.
 *
 * * dock_requester - The overmap datum trying to undock from this one. Cannot be null.
 */
/datum/overmap_object/proc/post_undocked(datum/overmap/ship/controlled/dock_requester)
	return

/**
 * Helper proc for docking. Alters the position and orientation of a stationary docking port to ensure that any mobile port small enough can dock within its bounds
 */
/datum/overmap_object/proc/adjust_dock_to_shuttle(obj/docking_port/stationary/dock_to_adjust, obj/docking_port/mobile/shuttle)
	log_shuttle("[src] [REF(src)] DOCKING: ADJUST [dock_to_adjust] [REF(dock_to_adjust)] TO [shuttle][REF(shuttle)]")
	// the shuttle's dimensions where "true height" measures distance from the shuttle's fore to its aft
	var/shuttle_true_height = shuttle.height
	var/shuttle_true_width = shuttle.width
	// if the port's location is perpendicular to the shuttle's fore, the "true height" is the port's "width" and vice-versa
	if(EWCOMPONENT(shuttle.port_direction))
		shuttle_true_height = shuttle.width
		shuttle_true_width = shuttle.height

	// the dir the stationary port should be facing (note that it points inwards)
	var/final_facing_dir = angle2dir(dir2angle(shuttle_true_height > shuttle_true_width ? EAST : NORTH)+dir2angle(shuttle.port_direction)+180)

	var/list/old_corners = dock_to_adjust.return_coords() // coords for "bottom left" / "top right" of dock's covered area, rotated by dock's current dir
	var/list/new_dock_location // TBD coords of the new location
	if(final_facing_dir == dock_to_adjust.dir)
		new_dock_location = list(old_corners[1], old_corners[2]) // don't move the corner
	else if(final_facing_dir == angle2dir(dir2angle(dock_to_adjust.dir)+180))
		new_dock_location = list(old_corners[3], old_corners[4]) // flip corner to the opposite
	else
		var/combined_dirs = final_facing_dir | dock_to_adjust.dir
		if(combined_dirs == (NORTH|EAST) || combined_dirs == (SOUTH|WEST))
			new_dock_location = list(old_corners[1], old_corners[4]) // move the corner vertically
		else
			new_dock_location = list(old_corners[3], old_corners[2]) // move the corner horizontally
		// we need to flip the height and width
		var/dock_height_store = dock_to_adjust.height
		dock_to_adjust.height = dock_to_adjust.width
		dock_to_adjust.width = dock_height_store

	dock_to_adjust.dir = final_facing_dir
	if(shuttle.height > dock_to_adjust.height || shuttle.width > dock_to_adjust.width)
		CRASH("Shuttle cannot fit in dock!")

	// offset for the dock within its area
	var/new_dheight = round((dock_to_adjust.height-shuttle.height)/2) + shuttle.dheight
	var/new_dwidth = round((dock_to_adjust.width-shuttle.width)/2) + shuttle.dwidth

	// use the relative-to-dir offset above to find the absolute position offset for the dock
	switch(final_facing_dir)
		if(NORTH)
			new_dock_location[1] += new_dwidth
			new_dock_location[2] += new_dheight
		if(SOUTH)
			new_dock_location[1] -= new_dwidth
			new_dock_location[2] -= new_dheight
		if(EAST)
			new_dock_location[1] += new_dheight
			new_dock_location[2] -= new_dwidth
		if(WEST)
			new_dock_location[1] -= new_dheight
			new_dock_location[2] += new_dwidth

	dock_to_adjust.forceMove(locate(new_dock_location[1], new_dock_location[2], dock_to_adjust.z))
	dock_to_adjust.dheight = new_dheight
	dock_to_adjust.dwidth = new_dwidth

/datum/overmap_object/dummy
	name = "Dummy oject"

