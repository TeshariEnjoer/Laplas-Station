/mob/dead/new_player
	var/title_screen_is_ready

/mob/dead/new_player/Topic(href, href_list[])
	if(src != usr)
		return

	if(!client)
		return

	if(client.interviewee)
		return FALSE


	if(href_list["observe"])
		play_lobby_button_sound()
		make_me_an_observer()
		return


	if(href_list["view_manifest"])
		play_lobby_button_sound()
		ViewManifest()
		return

	if(href_list["character_setup"])
		play_lobby_button_sound()
		client.prefs.ShowChoices(src)
		return

	if(href_list["game_options"])
		play_lobby_button_sound()
		return

	if(href_list["toggle_ready"])
		play_lobby_button_sound()
		ready = !ready
		client << output(ready, "title_browser:toggle_ready")
		return

	if(href_list["late_join"])
		play_lobby_button_sound()
		LateChoices()

	if(href_list["title_is_ready"])
		title_screen_is_ready = TRUE
		return


/mob/dead/new_player/Login()
	. = ..()
	show_title_screen()

/**
 * Shows the titlescreen to a new player.
 */
/mob/dead/new_player/proc/show_title_screen()
	if (client?.interviewee)
		return

	winset(src, "title_browser", "is-disabled=false;is-visible=true")
	winset(src, "status_bar", "is-visible=false")

	var/datum/asset/assets = get_asset_datum(/datum/asset/simple/lobby) //Sending pictures to the client
	assets.send(src)

	update_title_screen()

/**
 * Hard updates the title screen HTML, it causes visual glitches if used.
 */
/mob/dead/new_player/proc/update_title_screen()
	var/dat = get_title_html()

	src << browse(SStitle.current_title_screen, "file=loading_screen.gif;display=0")
	src << browse(dat, "window=title_browser")

/datum/asset/simple/lobby
	assets = list(
		"FixedsysExcelsior3.01Regular.ttf" = 'html/browser/FixedsysExcelsior3.01Regular.ttf',
	)

/**
 * Removes the titlescreen entirely from a mob.
 */
/mob/dead/new_player/proc/hide_title_screen()
	if(client?.mob)
		winset(client, "title_browser", "is-disabled=true;is-visible=false")

/mob/dead/new_player/proc/play_lobby_button_sound()
	SEND_SOUND(src, sound('laplas/sounds/effects/save.ogg'))
