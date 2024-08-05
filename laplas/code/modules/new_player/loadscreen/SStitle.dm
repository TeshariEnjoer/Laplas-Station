GLOBAL_LIST_EMPTY(startup_messages)
/datum/controller/subsystem/title
	name = "Title Screen"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_TITLE

	var/icon/startup_splash

	/// The current title screen being displayed, as a file path text.
	var/current_title_screen
	/// The current notice text, or null.
	var/current_notice
	/// The preamble html that includes all styling and layout.
	var/title_html
	/// The list of possible title screens to rotate through, as file path texts.
	var/title_screens = list()

	/// average realtime seconds it takes to load the map we're currently running
	var/average_completion_time = DEFAULT_TITLE_MAP_LOADTIME
	/// a given startup message => average timestamp in realtime seconds
	var/list/startup_message_timings = list()
	/// Raw data to update later
	var/list/progress_json = list()
	/// The reference realtime that we're treating as 0 for this run
	var/progress_reference_time = 0
	/// A list of station traits that have lobby buttons
	var/list/available_lobby_station_traits = list()



/datum/controller/subsystem/title/Initialize()
	title_html = DEFAULT_TITLE_HTML

	var/list/provisional_title_screens = flist("[global.config.directory]/title_screens/images/")
	var/list/local_title_screens = list()

	for(var/screen in provisional_title_screens)
		var/list/formatted_list = splittext(screen, "+")
		if((LAZYLEN(formatted_list) == 1 && (formatted_list[1] != "exclude" && formatted_list[1] != "blank.png" && formatted_list[1] != "startup_splash")))
			local_title_screens += screen

		if(LAZYLEN(formatted_list) > 1 && lowertext(formatted_list[1]) == "startup_splash")
			var/file_path = "[global.config.directory]/title_screens/images/[screen]"
			ASSERT(fexists(file_path))
			startup_splash = new(fcopy_rsc(file_path))

	// Progress stuff
	check_progress_reference_time()
	load_progress_json()

	if(startup_splash)
		change_title_screen(startup_splash)
	else
		change_title_screen(DEFAULT_TITLE_LOADING_SCREEN)

	if(length(local_title_screens))
		for(var/i in local_title_screens)
			var/file_path = "[global.config.directory]/title_screens/images/[i]"
			ASSERT(fexists(file_path))
			var/icon/title2use = new(fcopy_rsc(file_path))
			title_screens += title2use

	return ..()

/**
 * Make sure reference time is set up. If not, this is now time 0.
 */
/datum/controller/subsystem/title/proc/check_progress_reference_time()
	if(!progress_reference_time)
		progress_reference_time = world.timeofday

/**
 * Handle and clean up leaving startup
 */
/datum/controller/subsystem/title/proc/check_finish_progress()
	//It's the first time we're firing out of startup -> pregame
	if(progress_json && SSticker.current_state == GAME_STATE_PREGAME)
		save_progress_json()

/**
 * Load the progress info json and setup that part of the SS.
*/
/datum/controller/subsystem/title/proc/load_progress_json()
	var/json_file = file(TITLE_PROGRESS_CACHE_FILE)
	if(!fexists(json_file))
		return

	// Load map progress cache info
	progress_json = json_decode(file2text(json_file))

	// Different format. Purge everything.
	if(progress_json["_version"] != TITLE_PROGRESS_CACHE_VERSION)
		progress_json.Cut()
		return

	average_completion_time = DEFAULT_TITLE_MAP_LOADTIME
	startup_message_timings = list()

/datum/controller/subsystem/title/proc/save_progress_json()
	var/json_file = file(TITLE_PROGRESS_CACHE_FILE)
	var/list/map_info = list()

	progress_json["_version"] = TITLE_PROGRESS_CACHE_VERSION

	map_info["total"] = world.timeofday - progress_reference_time
	map_info["messages"] = startup_message_timings
//	progress_json[SSmapping.config.map_name] = map_info

	fdel(json_file)
	WRITE_FILE(json_file, json_encode(progress_json))

	progress_json = null

/datum/controller/subsystem/title/Recover()
	startup_splash = SStitle.startup_splash
	file_path = SStitle.file_path

	current_title_screen = SStitle.current_title_screen
	current_notice = SStitle.current_notice
	title_html = SStitle.title_html
	title_screens = SStitle.title_screens

	average_completion_time = SStitle.average_completion_time
	startup_message_timings = SStitle.startup_message_timings
	progress_json = SStitle.progress_json
	progress_reference_time = SStitle.progress_reference_time

/**
 * Show the title screen to all new players.
 */
/datum/controller/subsystem/title/proc/show_title_screen()
	for(var/mob/dead/new_player/new_player in GLOB.new_player_list)
		INVOKE_ASYNC(new_player, TYPE_PROC_REF(/mob/dead/new_player, show_title_screen))

/**
 * Adds a notice to the main title screen in the form of big red text!
 */
/datum/controller/subsystem/title/proc/set_notice(new_title)
	current_notice = new_title ? sanitize_text(new_title) : null
	show_title_screen()

/**
 * Changes the title screen to a new image.
 */
/datum/controller/subsystem/title/proc/change_title_screen(new_screen)
	if(new_screen)
		current_title_screen = new_screen
	else
		if(LAZYLEN(title_screens))
			current_title_screen = pick(title_screens)
		else
			current_title_screen = DEFAULT_TITLE_SCREEN_IMAGE

	check_finish_progress()
	show_title_screen()

/**
 * Update a user's character setup name.
 * Arguments:
 * * user - The user being updated
 * * name - the real name of the current slot.
 */
/datum/controller/subsystem/title/proc/update_character_name(mob/dead/new_player/user, name)
	if(!(istype(user) && user.title_screen_is_ready))
		return

	user.client << output(name, "title_browser:update_current_character")

/**
 * Adds a startup message to the splashscreen.
 *
 * Arguments:
 * * msg - the message to show users.
 * * warning - optional: TRUE to indicate this is an error/warning
 */
/proc/add_startup_message(msg, warning)
	// Remove the # second(s) / #s part of the message.
	var/static/regex/msg_key_regex = new(@"[0-9.]+( second)?s?!", "ig")

	// HTML displayed to user
	var/msg_html = {"<p class="terminal_text">[warning ? "☒ " : ""][msg]</p>"}
	// Key used to cache the timing info
	var/msg_key = msg_key_regex.Replace(msg, "#")

	GLOB.startup_messages += msg_html

	// If we ran before SStitle initialized, set the ref time now.
	SStitle.check_progress_reference_time()

	// Add or update message history info.
	var/old_timing = SStitle.startup_message_timings[msg_key]
	var/new_timing
	if(!old_timing)
		// new message
		new_timing = world.timeofday - SStitle.progress_reference_time
	else
		// old message. Latest time is worth 1/4 the "average"
		new_timing = 0.75 * old_timing + 0.25 * (world.timeofday - SStitle.progress_reference_time)
	SStitle.startup_message_timings[msg_key] = new_timing

	for(var/mob/dead/new_player/new_player in GLOB.new_player_list)
		if(!new_player.title_screen_is_ready)
			continue

		new_player.client << output(msg_html, "title_browser:append_terminal_text")
		new_player.client << output(list2params(list(new_timing, SStitle.average_completion_time)), "title_browser:update_loading_progress")

/**
 * Controls of titles screen
 */
/client/verb/fix_title_screen()
	set name = "Fix Lobby Screen"
	set desc = "Lobbyscreen broke? Press this."
	set category = "OOC"

	if(istype(mob, /mob/dead/new_player))
		var/mob/dead/new_player/new_player = mob
		new_player.show_title_screen()
	else
		winset(src, "title_browser", "is-disabled=true;is-visible=false")
		winset(src, "status_bar", "is-visible=true")
