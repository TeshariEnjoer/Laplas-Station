/datum/abstract_object
	/// The name of this overmap datum, propogated to the token, docking port, and areas.
	var/name
	/// The ID of overmap object
	var/id
	/// The class type of the object on overmap server
	var/class_type = "object"


	/* OVERMAP SERVER, SYNDEC VARRIBLES */
	/// The x position of this datum on the overmap. //overmap-side
	VAR_FINAL/x
	/// The y position of this datum on the overmap. //overmap-side
	VAR_FINAL/y
	/// The speed of object, updating with overmap server. //overmap-side
	var/speed = 0
	/// The velocity of current object, convert from vector2 on server map. //overmap-side
	var/list/velocity = list(
		"x" = 0,
		"y" = 0
	)
	/// The speed with objecrt rotate is. //overmap-side
	var/rotation_speed
	/// Angle of object. //overmap-side
	var/angle = 0

	/// The size of object sprite, also changes physicaly size of object
	var/width = 32
	var/heigth = 32

	/// Movement process would'nt effect on static objects, gravitational forces still workds. //overmap-side
	var/is_static = FALSE

	/// The time, in deciseconds, needed for this object to call
	var/dock_time
	/// The current docking timer ID.
	var/dock_timer_id
	/// Whether or not the overmap object is currently docking.
	var/docking

	/// List of all datums docked in this datum.
	var/list/datum/abstract_object/contents
	/// The datum this datum is docked to.
	var/datum/abstract_object/docked_to

	/// The icon state the token will be set to on init.
	var/token_icon_name = "object"

	/// The current docking ticket of this object, if any
	var/datum/docking_ticket/current_docking_ticket

/datum/abstract_object/New(position, ...)
	SHOULD_NOT_OVERRIDE(TRUE)
	if(!position)
		position = SSabstract_overmap.get_random_overmap_position(rand(8000, 10000))
	contents = list()
	if(islist(position))
		SSovermap.overmap_container[position["x"]][position["y"]] += src
		x = position["x"]
		y = position["y"]

	Initialize(arglist(args))

/datum/abstract_object/Destroy(force, ...)
	var/result = SSabstract_overmap.remove_overmap_object(id)
	if(!result == AM_RESPONSE_SUCESS)
		CRASH("Trying to remove overmap ojbect: [src.name] - [src.id], but get error: [result]")
	SSabstract_overmap.overmap_objects -= src
	if(current_docking_ticket)
		QDEL_NULL(current_docking_ticket)
	if(docked_to)
		docked_to.post_undocked()
		docked_to.contents -= src
	QDEL_NULL(token)
	QDEL_LIST(contents)
	return ..()

/datum/abstract_object/proc/get_type_data()
	SHOULD_CALL_PARENT(TRUE)
	. = ""
	. = "class_type = [class_type]"
	. = "width = [width]"
	. = "height = [height]"
	. = "static = [is_static]"
	return .

/datum/overmap/proc/Initialize(position, ...)
	PROTECTED_PROC(TRUE)
	id = SSabstract_overmap


	return
