
#define MAX_STARTUP_MESSAGES 2

/mob/dead/new_player/proc/get_title_html()
	var/dat = SStitle.title_html
	if(SSticker.current_state == GAME_STATE_STARTUP)
		dat += {"<img src="loading_screen.gif" class="bg" alt="">"}
		dat += {"<div class="container_terminal" id="terminal"></div>"}

		dat += {"
		<script language="JavaScript">
			var terminal = document.getElementById("terminal");
			var terminal_lines = \[
		"}

		for(var/message in GLOB.startup_messages)
			dat += {""[replacetext(message, "\"", "\\\"")]","}

		dat += {"
			\];

			function append_terminal_text(text) {
				if(text) {
					terminal_lines.push(text);
				}
				while(terminal_lines.length > [MAX_STARTUP_MESSAGES]) {
					terminal_lines.shift();
				}

				terminal.innerHTML = terminal_lines.join("");
			}

			append_terminal_text();
		</script>
		"}

	else
		dat += {"<img src="skyrat_title_screen.png" class="bg" alt="">"}

		if(SStitle.current_notice)
			dat += {"
			<div class="container_notice">
				<p class="menu_notice">[SStitle.current_notice]</p>
			</div>
		"}

		dat += {"<div class="container_nav">"}

		if(!SSticker || SSticker.current_state <= GAME_STATE_PREGAME)
			dat += {"<a id="ready" class="menu_button" href='?src=[text_ref(src)];toggle_ready=1'>[ready == PLAYER_READY_TO_PLAY ? "<span class='checked'>☑</span> READY" : "<span class='unchecked'>☒</span> READY"]</a>"}
		else
			dat += {"
				<a class="menu_button" href='?src=[text_ref(src)];late_join=1'>JOIN GAME</a>
				<a class="menu_button" href='?src=[text_ref(src)];view_manifest=1'>CREW MANIFEST</a>
				<a class="menu_button" href='?src=[text_ref(src)];observe=1'>OBSERVE</a>
				<a class="menu_button" href='?src=[text_ref(src)];character_setup=1'>SETUP CHARACTER (<span id="character_slot">[uppertext(client.prefs.real_name)]</span>)</a>
				<a class="menu_button" href='?src=[text_ref(src)];game_options=1'>GAME OPTIONS</a>
			"}

		dat += "</div>"
		dat += {"
		<script language="JavaScript">
			var ready_int = 0;
			var ready_mark = document.getElementById("ready");
			var ready_marks = \[ "<span class='unchecked'>☒</span> READY", "<span class='checked'>☑</span> READY" \];
			function toggle_ready(setReady) {
				if(setReady) {
					ready_int = setReady;
					ready_mark.innerHTML = ready_marks\[ready_int\];
				}
				else {
					ready_int++;
					if (ready_int === ready_marks.length)
						ready_int = 0;
					ready_mark.innerHTML = ready_marks\[ready_int\];
				}
			}
			var character_name_slot = document.getElementById("character_slot");
			function update_current_character(name) {
				character_name_slot.textContent = name.toUpperCase();
			}

			function append_terminal_text() {}
		</script>
		"}

	dat += {"
		<script>
			var ready_request = new XMLHttpRequest();
			ready_request.open("GET", "?src=[text_ref(src)];title_is_ready=1", true);
			ready_request.send();
		</script>
	"}

	dat += "</body></html>"

	return dat
