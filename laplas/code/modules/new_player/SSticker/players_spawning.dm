/datum/controller/subsystem/ticker/proc/create_characters()
	for(var/i in GLOB.new_player_list)
		var/mob/dead/new_player/player = i
		if(player.ready == PLAYER_READY_TO_PLAY && player.mind)
			GLOB.joined_player_list += player.ckey
/*
			var/atom/destination = player.mind.assigned_role.get_roundstart_spawn_point()
			if(!destination)
				player.show_title_screen()
				continue
			player.create_character(destination)
		else
			player.show_title_screen()
*/

		CHECK_TICK
