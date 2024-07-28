/obj/item/gun/ballistic/shotgun
	name = "shotgun"
	desc = "You feel as if you should make a 'adminhelp' if you see one of these, along with a 'github' report. You don't really understand what this means though."
	item_state = "shotgun"
	fire_sound = 'sound/weapons/gun/shotgun/shot.ogg'
	vary_fire_sound = FALSE
	fire_sound_volume = 90
	rack_sound = 'sound/weapons/gun/shotgun/rack.ogg'
	load_sound = 'sound/weapons/gun/shotgun/insert_shell.ogg'
	w_class = WEIGHT_CLASS_BULKY
	force = 10
	flags_1 =  CONDUCT_1
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/internal/shot
	semi_auto = FALSE
	internal_magazine = TRUE
	casing_ejector = FALSE
	bolt_wording = "pump"
	cartridge_wording = "shell"
	tac_reloads = FALSE
	pickup_sound =  'sound/items/handling/shotgun_pickup.ogg'
	fire_delay = 0.7 SECONDS
	pb_knockback = 2
	manufacturer = MANUFACTURER_HUNTERSPRIDE

	gun_firemodes = list(FIREMODE_SEMIAUTO)
	default_firemode = FIREMODE_SEMIAUTO
	fire_select_icon_state_prefix = "sg_"

	wield_slowdown = 0.45
	wield_delay = 0.8 SECONDS

	spread = 4
	spread_unwielded = 10
	recoil = 1
	recoil_unwielded = 4

/obj/item/gun/ballistic/shotgun/blow_up(mob/user)
	if(chambered && chambered.BB)
		process_fire(user, user, FALSE)
		return TRUE
	for(var/obj/item/ammo_casing/ammo in magazine.stored_ammo)
		if(ammo.BB)
			process_chamber(FALSE, FALSE)
			process_fire(user, user, FALSE)
			return TRUE
	return FALSE

/obj/item/gun/ballistic/shotgun/calculate_recoil(mob/user, recoil_bonus = 0)
	var/gunslinger_bonus = -1
	var/total_recoil = recoil_bonus
	if(HAS_TRAIT(user, TRAIT_GUNSLINGER)) //gunslinger bonus
		total_recoil += gunslinger_bonus
		total_recoil = clamp(total_recoil,0,INFINITY)

	return ..(user, total_recoil)

// BRIMSTONE SHOTGUN //

/obj/item/gun/ballistic/shotgun/brimstone
	name = "HP Brimstone"
	desc = "A simple and sturdy pump-action shotgun sporting a 5-round capacity, manufactured by Hunter's Pride. Found widely throughout the Frontier in the hands of hunters, pirates, police, and countless others. Chambered in 12g."
	sawn_desc = "A stockless and shortened pump-action shotgun. The worsened recoil and accuracy make it a poor sidearm anywhere beyond punching distance."
	fire_sound = 'sound/weapons/gun/shotgun/brimstone.ogg'
	icon = 'icons/obj/guns/manufacturer/hunterspride/48x32.dmi'
	lefthand_file = 'icons/obj/guns/manufacturer/hunterspride/lefthand.dmi'
	righthand_file = 'icons/obj/guns/manufacturer/hunterspride/righthand.dmi'
	mob_overlay_icon = 'icons/obj/guns/manufacturer/hunterspride/onmob.dmi'

	icon_state = "brimstone"
	item_state = "brimstone"

	gun_firemodes = list(FIREMODE_FULLAUTO)
	default_firemode = FIREMODE_FULLAUTO

	mag_type = /obj/item/ammo_box/magazine/internal/shot/lethal
	manufacturer = MANUFACTURER_HUNTERSPRIDE
	fire_delay = 0.05 SECONDS //slamfire
	rack_delay = 0.2 SECONDS

	can_be_sawn_off = TRUE


/obj/item/gun/ballistic/shotgun/brimstone/sawoff(mob/user)
	. = ..()
	if(.)
		weapon_weight = WEAPON_MEDIUM
		wield_slowdown = 0.25
		wield_delay = 0.3 SECONDS //OP? maybe

		spread = 18
		spread_unwielded = 25
		recoil = 5 //your punishment for sawing off an short shotgun
		recoil_unwielded = 8
		item_state = "illestren_factory_sawn" // i couldnt care about making another sprite, looks close enough
		mob_overlay_state = item_state

/obj/item/gun/ballistic/shotgun/brimstone/no_mag
	spawnwithmagazine = FALSE
// HELLFIRE SHOTGUN //

/obj/item/gun/ballistic/shotgun/hellfire
	name = "HP Hellfire"
	desc = "A hefty pump-action riot shotgun with a seven-round tube, manufactured by Hunter's Pride. Especially popular among the Frontier's police forces. Chambered in 12g."
	icon = 'icons/obj/guns/manufacturer/hunterspride/48x32.dmi'
	lefthand_file = 'icons/obj/guns/manufacturer/hunterspride/lefthand.dmi'
	righthand_file = 'icons/obj/guns/manufacturer/hunterspride/righthand.dmi'
	mob_overlay_icon = 'icons/obj/guns/manufacturer/hunterspride/onmob.dmi'
	icon_state = "hellfire"
	item_state = "hellfire"

	mag_type = /obj/item/ammo_box/magazine/internal/shot/riot
	sawn_desc = "Come with me if you want to live."
	can_be_sawn_off = TRUE
	rack_sound = 'sound/weapons/gun/shotgun/rack_alt.ogg'
	fire_delay = 0.1 SECONDS

/obj/item/gun/ballistic/shotgun/hellfire/sawoff(mob/user)
	. = ..()
	if(.)
		var/obj/item/ammo_box/magazine/internal/tube = magazine
		tube.max_ammo = 5 //this makes the gun so much worse

		weapon_weight = WEAPON_MEDIUM
		wield_slowdown = 0.25
		wield_delay = 0.3 SECONDS //OP? maybe

		spread = 8
		spread_unwielded = 15
		recoil = 3 //or not
		recoil_unwielded = 5
		item_state = "dshotgun_sawn" // ditto
		mob_overlay_state = item_state

/obj/item/gun/ballistic/shotgun/hellfire/no_mag
	spawnwithmagazine = FALSE
// Automatic Shotguns//
/obj/item/gun/ballistic/shotgun/automatic
	spread = 4
	spread_unwielded = 16
	recoil = 1
	recoil_unwielded = 4
	wield_delay = 0.65 SECONDS
	manufacturer = MANUFACTURER_NANOTRASEN

/obj/item/gun/ballistic/shotgun/automatic/shoot_live_shot(mob/living/user)
	..()
	rack()

//im not sure what to do with the combat shotgun, as it's functionally the same as the semi auto shotguns except it automattically racks instead of being semi-auto

/obj/item/gun/ballistic/shotgun/automatic/combat
	name = "combat shotgun"
	desc = "A semi-automatic shotgun with tactical furniture and six-shell capacity underneath."
	icon_state = "cshotgun"
	item_state = "shotgun_combat"
	fire_delay = 0.5 SECONDS
	mag_type = /obj/item/ammo_box/magazine/internal/shot/com
	w_class = WEIGHT_CLASS_BULKY

/obj/item/gun/ballistic/shotgun/automatic/combat/compact
	name = "compact combat shotgun"
	desc = "A compact version of the semi-automatic combat shotgun. For close encounters."
	icon_state = "cshotgunc"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/com/compact
	w_class = WEIGHT_CLASS_NORMAL
	weapon_weight = WEAPON_MEDIUM

//Dual Feed Shotgun

/obj/item/gun/ballistic/shotgun/automatic/dual_tube
	name = "cycler shotgun"
	desc = "An advanced shotgun with two separate magazine tubes, allowing you to quickly toggle between ammo types."

	icon = 'icons/obj/guns/manufacturer/nanotrasen_sharplite/48x32.dmi'
	lefthand_file = 'icons/obj/guns/manufacturer/nanotrasen_sharplite/lefthand.dmi'
	righthand_file = 'icons/obj/guns/manufacturer/nanotrasen_sharplite/righthand.dmi'
	mob_overlay_icon = 'icons/obj/guns/manufacturer/nanotrasen_sharplite/onmob.dmi'

	icon_state = "cycler"

	mag_type = /obj/item/ammo_box/magazine/internal/shot/tube
	w_class = WEIGHT_CLASS_HUGE
	var/toggled = FALSE
	var/obj/item/ammo_box/magazine/internal/shot/alternate_magazine
	semi_auto = TRUE

/obj/item/gun/ballistic/shotgun/automatic/dual_tube/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to pump it.</span>"

/obj/item/gun/ballistic/shotgun/automatic/dual_tube/Initialize()
	. = ..()
	if (!alternate_magazine)
		alternate_magazine = new mag_type(src)

/obj/item/gun/ballistic/shotgun/automatic/dual_tube/attack_self(mob/living/user)
	if(!chambered && magazine.contents.len)
		rack()
	else
		toggle_tube(user)

/obj/item/gun/ballistic/shotgun/automatic/dual_tube/proc/toggle_tube(mob/living/user)
	var/current_mag = magazine
	var/alt_mag = alternate_magazine
	magazine = alt_mag
	alternate_magazine = current_mag
	toggled = !toggled
	if(toggled)
		to_chat(user, "<span class='notice'>You switch to tube B.</span>")
	else
		to_chat(user, "<span class='notice'>You switch to tube A.</span>")

/obj/item/gun/ballistic/shotgun/automatic/dual_tube/AltClick(mob/living/user)
	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	rack()

// Bulldog shotgun //

/obj/item/gun/ballistic/shotgun/bulldog //TODO: REPATH TO LIKE /obj/item/gun/ballistic/shotgun/automatic/bulldog
	name = "\improper Bulldog Shotgun"
	desc = "A semi-automatic, magazine-fed shotgun designed for combat in tight quarters, manufactured by Scarborough Arms. A historical favorite of various Syndicate factions, especially the Gorlex Marauders."
	icon = 'icons/obj/guns/manufacturer/scarborough/48x32.dmi'
	lefthand_file = 'icons/obj/guns/manufacturer/scarborough/lefthand.dmi'
	righthand_file = 'icons/obj/guns/manufacturer/scarborough/righthand.dmi'
	mob_overlay_icon = 'icons/obj/guns/manufacturer/scarborough/onmob.dmi'
	icon_state = "bulldog"
	item_state = "bulldog"

	weapon_weight = WEAPON_MEDIUM
	mag_type = /obj/item/ammo_box/magazine/m12g
	burst_size = 1
	fire_delay = 0.4 SECONDS // this NEEDS the old delay.
	fire_sound = 'sound/weapons/gun/shotgun/bulldog.ogg'
	show_magazine_on_sprite = TRUE
	empty_indicator = TRUE
	empty_alarm = TRUE
	unique_mag_sprites_for_variants = TRUE
	semi_auto = TRUE
	internal_magazine = FALSE
	casing_ejector = TRUE
	tac_reloads = TRUE
	pickup_sound =  'sound/items/handling/rifle_pickup.ogg'
	manufacturer = MANUFACTURER_SCARBOROUGH

	load_sound = 'sound/weapons/gun/rifle/ar_reload.ogg'
	load_empty_sound = 'sound/weapons/gun/rifle/ar_reload.ogg'
	eject_sound = 'sound/weapons/gun/rifle/ar_unload.ogg'
	eject_empty_sound = 'sound/weapons/gun/rifle/ar_unload.ogg'

	rack_sound = 'sound/weapons/gun/rifle/ar_cock.ogg'

	spread = 4
	spread_unwielded = 16
	recoil = 1
	recoil_unwielded = 4
	wield_slowdown = 0.6
	wield_delay = 0.65 SECONDS

EMPTY_GUN_HELPER(shotgun/bulldog)

/obj/item/gun/ballistic/shotgun/bulldog/inteq
	name = "\improper Mastiff Shotgun"
	desc = "A variation of the Bulldog, seized from Syndicate armories by deserting troopers then modified to IRMG's standards."
	icon_state = "bulldog-inteq"
	item_state = "bulldog-inteq"
	mag_type = /obj/item/ammo_box/magazine/m12g
	manufacturer = MANUFACTURER_INTEQ

EMPTY_GUN_HELPER(shotgun/bulldog/inteq)

/obj/item/gun/ballistic/shotgun/bulldog/suns
	name = "\improper Bulldog-C Shotgun"
	desc = "A variation of the Bulldog manufactured by Scarborough Arms for SUNS. Its shorter barrel is intended to provide additional maneuverability in personal defense scenarios."
	icon_state = "bulldog_suns"
	item_state = "bulldog_suns"

/obj/item/gun/ballistic/shotgun/bulldog/minutemen //TODO: REPATH
	name = "\improper CM-15"
	desc = "A standard-issue shotgun of CLIP, most often used by boarding crews. Only compatible with specialized 8-round magazines."
	icon = 'icons/obj/guns/manufacturer/clip_lanchester/48x32.dmi'
	lefthand_file = 'icons/obj/guns/manufacturer/clip_lanchester/lefthand.dmi'
	righthand_file = 'icons/obj/guns/manufacturer/clip_lanchester/righthand.dmi'
	mob_overlay_icon = 'icons/obj/guns/manufacturer/clip_lanchester/onmob.dmi'

	mag_type = /obj/item/ammo_box/magazine/cm15_mag
	icon_state = "cm15"
	item_state = "cm15"
	empty_alarm = FALSE
	empty_indicator = FALSE
	unique_mag_sprites_for_variants = FALSE
	manufacturer = MANUFACTURER_MINUTEMAN
	fire_select_icon_state_prefix = "clip_"
	adjust_fire_select_icon_state_on_safety = TRUE

/////////////////////////////
// DOUBLE BARRELED SHOTGUN //
/////////////////////////////

/obj/item/gun/ballistic/shotgun/doublebarrel
	name = "double-barreled shotgun"
	desc = "A classic break action shotgun, hand-made in a Hunter's Pride workshop. Both barrels can be fired in quick succession or even simultaneously. Guns like this have been popular with hunters, sporters, and criminals for millennia. Chambered in 12g."
	sawn_desc = "A break action shotgun cut down to the size of a sidearm. While the recoil is even harsher, it offers a lot of power in a very small package. Chambered in 12g."

	icon = 'icons/obj/guns/manufacturer/hunterspride/48x32.dmi'
	lefthand_file = 'icons/obj/guns/manufacturer/hunterspride/lefthand.dmi'
	righthand_file = 'icons/obj/guns/manufacturer/hunterspride/righthand.dmi'
	mob_overlay_icon = 'icons/obj/guns/manufacturer/hunterspride/onmob.dmi'

	base_icon_state = "dshotgun"

	icon_state = "dshotgun"
	item_state = "dshotgun"

	rack_sound = 'sound/weapons/gun/shotgun/dbshotgun_break.ogg'
	bolt_drop_sound = 'sound/weapons/gun/shotgun/dbshotgun_close.ogg'

	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	force = 10
	flags_1 = CONDUCT_1
	slot_flags = ITEM_SLOT_BACK
	mag_type = /obj/item/ammo_box/magazine/internal/shot/dual

	obj_flags = UNIQUE_RENAME
	unique_reskin = list("Default" = "dshotgun",
						"Stainless Steel" = "dshotgun_white",
						"Stained Green" = "dshotgun_green"
						)
	semi_auto = TRUE
	can_be_sawn_off = TRUE
	bolt_type = BOLT_TYPE_NO_BOLT
	pb_knockback = 3 // it's a super shotgun!
	manufacturer = MANUFACTURER_HUNTERSPRIDE
	bolt_wording = "barrel"

	burst_delay = 0.05 SECONDS
	burst_size = 2
	gun_firemodes = list(FIREMODE_SEMIAUTO, FIREMODE_BURST)
	default_firemode = FIREMODE_SEMIAUTO

/obj/item/gun/ballistic/shotgun/doublebarrel/unique_action(mob/living/user)
	if (bolt_locked == FALSE)
		to_chat(user, "<span class='notice'>You snap open the [bolt_wording] of \the [src].</span>")
		playsound(src, rack_sound, rack_sound_volume, rack_sound_vary)
		chambered = null
		var/num_unloaded = 0
		for(var/obj/item/ammo_casing/casing_bullet in get_ammo_list(FALSE, TRUE))
			casing_bullet.forceMove(drop_location())
			var/angle_of_movement =(rand(-3000, 3000) / 100) + dir2angle(turn(user.dir, 180))
			casing_bullet.AddComponent(/datum/component/movable_physics, _horizontal_velocity = rand(450, 550) / 100, _vertical_velocity = rand(400, 450) / 100, _horizontal_friction = rand(20, 24) / 100, _z_gravity = PHYSICS_GRAV_STANDARD, _z_floor = 0, _angle_of_movement = angle_of_movement, _bounce_sound = casing_bullet.bounce_sfx_override)

			num_unloaded++
			SSblackbox.record_feedback("tally", "station_mess_created", 1, casing_bullet.name)
		if (num_unloaded)
			playsound(user, eject_sound, eject_sound_volume, eject_sound_vary)
			update_appearance()
		bolt_locked = TRUE
		update_appearance()
		return
	drop_bolt(user)

/obj/item/gun/ballistic/shotgun/doublebarrel/drop_bolt(mob/user = null)
	playsound(src, bolt_drop_sound, bolt_drop_sound_volume, FALSE)
	if (user)
		to_chat(user, "<span class='notice'>You snap the [bolt_wording] of \the [src] closed.</span>")
	chamber_round()
	bolt_locked = FALSE
	update_appearance()

/obj/item/gun/ballistic/shotgun/doublebarrel/can_shoot()
	if (bolt_locked)
		return FALSE
	return ..()

/obj/item/gun/ballistic/shotgun/doublebarrel/attackby(obj/item/A, mob/user, params)
	if (!bolt_locked)
		to_chat(user, "<span class='notice'>The [bolt_wording] is shut closed!</span>")
		return
	return ..()

/obj/item/gun/ballistic/shotgun/doublebarrel/update_icon_state()
	. = ..()
	if(current_skin)
		icon_state = "[unique_reskin[current_skin]][sawn_off ? "_sawn" : ""][bolt_locked ? "_open" : ""]"
	else
		icon_state = "[base_icon_state || initial(icon_state)][sawn_off ? "_sawn" : ""][bolt_locked ? "_open" : ""]"


/obj/item/gun/ballistic/shotgun/doublebarrel/AltClick(mob/user)
	. = ..()
	if(unique_reskin && !current_skin && user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY) && (!bolt_locked))
		reskin_obj(user)

/obj/item/gun/ballistic/shotgun/doublebarrel/sawoff(mob/user)
	. = ..()
	if(.)
		weapon_weight = WEAPON_MEDIUM
		wield_slowdown = 0.25
		wield_delay = 0.3 SECONDS //OP? maybe

		spread = 8
		spread_unwielded = 15
		recoil = 3 //or not
		recoil_unwielded = 5
		item_state = "dshotgun_sawn"
		mob_overlay_state = item_state

/obj/item/gun/ballistic/shotgun/doublebarrel/no_mag
	spawnwithmagazine = FALSE

// sawn off beforehand
/obj/item/gun/ballistic/shotgun/doublebarrel/presawn
	name = "sawn-off double-barreled shotgun"
	desc = "A break action shotgun cut down to the size of a sidearm. While the recoil is even harsher, it offers a lot of power in a very small package. Chambered in 12g."
	sawn_off = TRUE
	weapon_weight = WEAPON_MEDIUM
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT

	wield_slowdown = 0.25
	wield_delay = 0.3 SECONDS //OP? maybe

	spread = 8
	spread_unwielded = 15
	recoil = 3 //or not
	recoil_unwielded = 5
	item_state = "dshotgun_sawn"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/dual/lethal

/obj/item/gun/ballistic/shotgun/doublebarrel/roumain
	name = "HP antique double-barreled shotgun"
	desc = "A special-edition shotgun hand-made by Hunter's Pride with a high-quality walnut stock inlaid with brass scrollwork. Shotguns like this are very rare outside of the Saint-Roumain Militia's ranks. Otherwise functionally identical to a common double-barreled shotgun. Chambered in 12g."
	sawn_desc = "A special-edition Hunter's Pride shotgun, cut down to the size of a sidearm by some barbarian. The brass inlay on the stock and engravings on the barrel have been obliterated in the process, destroying any value beyond its use as a crude sidearm."
	base_icon_state = "dshotgun_srm"
	icon_state = "dshotgun_srm"
	item_state = "dshotgun_srm"
	unique_reskin = null

/obj/item/gun/ballistic/shotgun/doublebarrel/roumain/sawoff(mob/user)
	. = ..()
	if(.)
		item_state = "dshotgun_srm_sawn"

// IMPROVISED SHOTGUN //

/obj/item/gun/ballistic/shotgun/doublebarrel/improvised
	name = "improvised shotgun"
	desc = "A length of pipe and miscellaneous bits of scrap fashioned into a rudimentary single-shot shotgun."
	icon = 'icons/obj/guns/projectile.dmi'
	lefthand_file = GUN_LEFTHAND_ICON
	righthand_file = GUN_RIGHTHAND_ICON
	mob_overlay_icon = null

	base_icon_state = "ishotgun"
	icon_state = "ishotgun"
	item_state = "ishotgun"
	w_class = WEIGHT_CLASS_BULKY
	force = 10
	slot_flags = null
	mag_type = /obj/item/ammo_box/magazine/internal/shot/improvised
	sawn_desc = "I'm just here for the gasoline."
	unique_reskin = null
	var/slung = FALSE

	gun_firemodes = list(FIREMODE_SEMIAUTO)
	default_firemode = FIREMODE_SEMIAUTO

/obj/item/gun/ballistic/shotgun/doublebarrel/improvised/attackby(obj/item/A, mob/user, params)
	..()
	if(istype(A, /obj/item/stack/cable_coil) && !sawn_off)
		var/obj/item/stack/cable_coil/C = A
		if(C.use(10))
			slot_flags = ITEM_SLOT_BACK
			to_chat(user, "<span class='notice'>You tie the lengths of cable to the shotgun, making a sling.</span>")
			slung = TRUE
			update_appearance()
		else
			to_chat(user, "<span class='warning'>You need at least ten lengths of cable if you want to make a sling!</span>")

/obj/item/gun/ballistic/shotgun/doublebarrel/improvised/update_icon_state()
	. = ..()
	if(slung)
		item_state = "ishotgunsling"
	if(sawn_off)
		item_state = "ishotgun_sawn"

/obj/item/gun/ballistic/shotgun/doublebarrel/improvised/update_overlays()
	. = ..()
	if(slung)
		. += "ishotgunsling"
	if(sawn_off)
		. += "ishotgun_sawn"

/obj/item/gun/ballistic/shotgun/doublebarrel/improvised/sawoff(mob/user)
	. = ..()
	if(. && slung) //sawing off the gun removes the sling
		new /obj/item/stack/cable_coil(get_turf(src), 10)
		slung = 0
		update_appearance()

/obj/item/gun/ballistic/shotgun/doublebarrel/improvised/sawn
	name = "sawn-off improvised shotgun"
	desc = "A single-shot shotgun. Better not miss."
	icon_state = "ishotgun_sawn"
	item_state = "ishotgun_sawn"
	w_class = WEIGHT_CLASS_NORMAL
	sawn_off = TRUE
	slot_flags = ITEM_SLOT_BELT

/obj/item/gun/ballistic/shotgun/automatic/combat/compact/compact
	name = "compact compact combat shotgun"
	desc = "A compact version of the compact version of the semi automatic combat shotgun. For when you want a gun the same size as your brain."
	icon_state = "cshotguncc"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/com/compact/compact
	w_class = WEIGHT_CLASS_SMALL
	sawn_desc = "You know, this isn't funny anymore."
	can_be_sawn_off = TRUE

/obj/item/gun/ballistic/shotgun/automatic/combat/compact/compact/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(prob(0 + (magazine.ammo_count() * 20)))	//minimum probability of 20, maximum of 60
		playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)
		to_chat(user, "<span class='userdanger'>[src] blows up in your face!</span>")
		if(prob(25))
			user.take_bodypart_damage(0,75)
			explosion(src, 0, 0, 1, 1)
			user.dropItemToGround(src)
		else
			user.take_bodypart_damage(0,50)
			user.dropItemToGround(src)
		return 0
	..()

/obj/item/gun/ballistic/shotgun/automatic/combat/compact/compact/compact
	name = "compact compact compact combat shotgun"
	desc = "A compact version of the compact version of the compact version of the semi automatic combat shotgun. <i>It's a miracle it works...</i>"
	icon_state = "cshotgunccc"
	mag_type = /obj/item/ammo_box/magazine/internal/shot/com/compact/compact/compact
	w_class = WEIGHT_CLASS_TINY
	sawn_desc = "<i>Sigh.</i> This is a trigger attached to a bullet."
	can_be_sawn_off = TRUE

/obj/item/gun/ballistic/shotgun/automatic/combat/compact/compact/compact/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(prob(50))	//It's going to blow up.
		playsound(user, fire_sound, fire_sound_volume, vary_fire_sound)
		if(prob(50))
			to_chat(user, "<span class='userdanger'>Fu-</span>")
			user.take_bodypart_damage(100)
			explosion(src, 0, 0, 1, 1)
			user.dropItemToGround(src)
		else
			to_chat(user, "<span class='userdanger'>[src] blows up in your face! What a surprise.</span>")
			user.take_bodypart_damage(100)
			user.dropItemToGround(src)
		return 0
	..()

//god fucking bless brazil
/obj/item/gun/ballistic/shotgun/doublebarrel/brazil
	name = "six-barreled \"TRABUCO\" shotgun"
	desc = "Dear fucking god, what the fuck even is this!? The recoil caused by the sheer act of firing this thing would probably kill you, if the gun itself doesn't explode in your face first! Theres a green flag with a blue circle and a yellow diamond around it. Some text in the circle says: \"ORDEM E PROGRESSO.\""
	base_icon_state = "shotgun_brazil"
	icon_state = "shotgun_brazil"
	icon = 'icons/obj/guns/48x32guns.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/64x_guns_left.dmi'
	righthand_file = 'icons/mob/inhands/weapons/64x_guns_right.dmi'
	item_state = "shotgun_qb"
	w_class = WEIGHT_CLASS_BULKY
	force = 15 //blunt edge and really heavy
	attack_verb = list("bludgeoned", "smashed")
	mag_type = /obj/item/ammo_box/magazine/internal/shot/sex
	burst_size = 6
	burst_delay = 0.04 SECONDS //?? very weird number
	pb_knockback = 12
	unique_reskin = null
	recoil = 10
	recoil_unwielded = 30
	weapon_weight = WEAPON_LIGHT
	fire_sound = 'sound/weapons/gun/shotgun/quadfire.ogg'
	rack_sound = 'sound/weapons/gun/shotgun/quadrack.ogg'
	load_sound = 'sound/weapons/gun/shotgun/quadinsert.ogg'
	fire_sound_volume = 50
	rack_sound_volume = 50
	can_be_sawn_off = FALSE
	manufacturer = MANUFACTURER_BRAZIL
	gun_firemodes = list(FIREMODE_BURST)
	default_firemode = FIREMODE_BURST

/obj/item/gun/ballistic/shotgun/doublebarrel/brazil/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	if(prob(0 + (magazine.ammo_count() * 10)))
		if(prob(10))
			to_chat(user, "<span class='userdanger'>Something isn't right. \the [src] doesn't fire for a brief moment. Then, the following words come to mind: \
			Ó Pátria amada, \n\
			Idolatrada, \n\
			Salve! Salve!</span>")

			message_admins("A [src] misfired and exploded at [ADMIN_VERBOSEJMP(src)], which was fired by [user].") //logging
			log_admin("A [src] misfired and exploded at [ADMIN_VERBOSEJMP(src)], which was fired by [user].")
			user.take_bodypart_damage(0,50)
			explosion(src, 0, 2, 4, 6, TRUE, TRUE)
	..()
/obj/item/gun/ballistic/shotgun/doublebarrel/brazil/death
	name = "Force of Nature"
	desc = "So you have chosen death."
	base_icon_state = "shotgun_e"
	icon_state = "shotgun_e"
	burst_size = 100
	fire_delay = 0.01 SECONDS
	pb_knockback = 40
	recoil = 100
	recoil_unwielded = 200
	recoil_backtime_multiplier = 1
	fire_sound_volume = 100
	mag_type = /obj/item/ammo_box/magazine/internal/shot/hundred

//Lever-Action Rifles
/obj/item/gun/ballistic/shotgun/flamingarrow
	name = "HP Flaming Arrow"
	desc = "A sturdy and lightweight lever-action rifle with hand-stamped Hunter's Pride marks on the receiver. A popular choice among Frontier homesteaders for hunting small game and rudimentary self-defense. Chambered in .38."
	sawn_desc = "A lever-action rifle that has been sawed down and modified for extra portability. While surprisingly effective as a sidearm, the more important benefit is how much cooler it looks."
	base_icon_state = "flamingarrow"
	icon_state = "flamingarrow"
	item_state = "flamingarrow"
	icon = 'icons/obj/guns/manufacturer/hunterspride/48x32.dmi'
	lefthand_file = 'icons/obj/guns/manufacturer/hunterspride/lefthand.dmi'
	righthand_file = 'icons/obj/guns/manufacturer/hunterspride/righthand.dmi'
	mob_overlay_icon = 'icons/obj/guns/manufacturer/hunterspride/onmob.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	mag_type = /obj/item/ammo_box/magazine/internal/shot/winchester
	fire_sound = 'sound/weapons/gun/rifle/flamingarrow.ogg'
	rack_sound = 'sound/weapons/gun/rifle/skm_cocked.ogg'
	bolt_wording = "lever"
	cartridge_wording = "bullet"
	can_be_sawn_off = TRUE

	wield_slowdown = 0.5
	wield_delay = 0.65 SECONDS

	spread = -5
	spread_unwielded = 7

	recoil = 0
	recoil_unwielded = 2

/obj/item/gun/ballistic/shotgun/flamingarrow/no_mag
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/shotgun/flamingarrow/update_icon_state()
	. = ..()
	if(current_skin)
		icon_state = "[unique_reskin[current_skin]][sawn_off ? "_sawn" : ""]"
	else
		icon_state = "[base_icon_state || initial(icon_state)][sawn_off ? "_sawn" : ""]"


/obj/item/gun/ballistic/shotgun/flamingarrow/rack(mob/user = null)
	. = ..()
	if(!wielded)
		SpinAnimation(7,1)

/obj/item/gun/ballistic/shotgun/flamingarrow/process_fire(atom/target, mob/living/user, message = TRUE, params = null, zone_override = "", bonus_spread = 0)
	var/fan = FALSE
	if(HAS_TRAIT(user, TRAIT_GUNSLINGER) && !semi_auto && wielded_fully && loc == user && !safety)
		fan = TRUE
		fire_delay = 0.35 SECONDS
	. = ..()
	fire_delay = src::fire_delay
	if(fan)
		rack()
		to_chat(user, "<span class='notice'>You quickly rack the [bolt_wording] of \the [src]!</span>")
		balloon_alert_to_viewers("quickly racks!")
		fire_delay = 0 SECONDS

/obj/item/gun/ballistic/shotgun/flamingarrow/sawoff(mob/user)
	. = ..()
	if(.)
		var/obj/item/ammo_box/magazine/internal/tube = magazine
		tube.max_ammo = 7

		item_state = "flamingarrow_sawn"
		mob_overlay_state = item_state
		weapon_weight = WEAPON_MEDIUM

		wield_slowdown = 0.25
		wield_delay = 0.2 SECONDS //THE COWBOY RIFLE

		spread = 4
		spread_unwielded = 12

		recoil = 0
		recoil_unwielded = 3

/obj/item/gun/ballistic/shotgun/flamingarrow/factory
	desc = "A sturdy and lightweight lever-action rifle with hand-stamped Hunter's Pride marks on the receiver. This example has been kept in excellent shape and may as well be fresh out of the workshop. Chambered in .38."
	icon_state = "flamingarrow_factory"
	base_icon_state = "flamingarrow_factory"
	item_state = "flamingarrow_factory"

/obj/item/gun/ballistic/shotgun/flamingarrow/factory/sawoff(mob/user)
	. = ..()
	if(.)
		item_state = "flamingarrow_factory_sawn"
		mob_overlay_state = item_state

/obj/item/gun/ballistic/shotgun/flamingarrow/bolt
	name = "HP Flaming Bolt"
	desc = "A sturdy, excellently-made lever-action rifle. This one appears to be a genuine antique, kept in incredibly good condition despite its advanced age. Chambered in .38."
	base_icon_state = "flamingbolt"
	icon_state = "flamingbolt"
	item_state = "flamingbolt"

/obj/item/gun/ballistic/shotgun/flamingarrow/bolt/sawoff(mob/user)
	. = ..()
	if(.)
		item_state = "flamingbolt_sawn"
		mob_overlay_state = item_state

//Elephant Gun
/obj/item/gun/ballistic/shotgun/doublebarrel/twobore
	name = "HP Huntsman"
	desc = "A comically huge double-barreled rifle replete with brass inlays depicting flames and naturalistic scenes, clearly meant for the nastiest monsters the Frontier has to offer. If you want an intact trophy, don't aim for the head. Chambered in two-bore."
	icon = 'icons/obj/guns/manufacturer/hunterspride/48x32.dmi'
	lefthand_file = 'icons/obj/guns/manufacturer/hunterspride/lefthand.dmi'
	righthand_file = 'icons/obj/guns/manufacturer/hunterspride/righthand.dmi'
	mob_overlay_icon = 'icons/obj/guns/manufacturer/hunterspride/onmob.dmi'
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	base_icon_state = "huntsman"
	icon_state = "huntsman"
	item_state = "huntsman"
	unique_reskin = null
	attack_verb = list("bludgeoned", "smashed")
	mag_type = /obj/item/ammo_box/magazine/internal/shot/twobore
	w_class = WEIGHT_CLASS_BULKY
	force = 20 //heavy ass elephant gun, why wouldnt it be
	recoil = 4
	pb_knockback = 12
	fire_sound = 'sound/weapons/gun/shotgun/quadfire.ogg'
	rack_sound = 'sound/weapons/gun/shotgun/quadrack.ogg'
	load_sound = 'sound/weapons/gun/shotgun/quadinsert.ogg'

	can_be_sawn_off = FALSE
	fire_sound_volume = 80
	rack_sound_volume = 50
	manufacturer = MANUFACTURER_HUNTERSPRIDE

	gun_firemodes = list(FIREMODE_SEMIAUTO) //no dual burst for you
	default_firemode = FIREMODE_SEMIAUTO

//Break-Action Rifle
/obj/item/gun/ballistic/shotgun/doublebarrel/beacon
	name = "HP Beacon"
	desc = "A single-shot break-action rifle made by Hunter's Pride and sold to civilian hunters. Boasts excellent accuracy and stopping power. Uses .45-70 ammo."
	sawn_desc= "A single-shot break-action pistol chambered in .45-70. A bit difficult to aim."
	base_icon_state = "beacon"
	icon_state = "beacon"
	item_state = "beacon"
	unique_reskin = null
	inhand_x_dimension = 32
	inhand_y_dimension = 32
	mag_type = /obj/item/ammo_box/magazine/internal/shot/beacon
	fire_sound = 'sound/weapons/gun/revolver/shot_hunting.ogg'
	w_class = WEIGHT_CLASS_BULKY
	weapon_weight = WEAPON_MEDIUM
	force = 10
	obj_flags = UNIQUE_RENAME
	semi_auto = TRUE
	can_be_sawn_off = TRUE
	pb_knockback = 3
	wield_slowdown = 0.7
	spread_unwielded = 15
	spread = 0
	recoil = 0
	recoil_unwielded = 5

	gun_firemodes = list(FIREMODE_SEMIAUTO)
	default_firemode = FIREMODE_SEMIAUTO

/obj/item/gun/ballistic/shotgun/doublebarrel/beacon/sawoff(mob/user)
	. = ..()
	if(.)
		item_state = "beacon_sawn"
		mob_overlay_state = item_state
		wield_slowdown = 0.5
		wield_delay = 0.5 SECONDS

		spread_unwielded = 20 //mostly the hunting revolver stats
		spread = 6
		recoil = 2
		recoil_unwielded = 4

/obj/item/gun/ballistic/shotgun/doublebarrel/beacon/no_mag
	spawnwithmagazine = FALSE

/obj/item/gun/ballistic/shotgun/doublebarrel/beacon/factory
	desc = "A single-shot break-action rifle made by Hunter's Pride and sold to civilian hunters. This example has been kept in excellent shape and may as well be fresh out of the workshop. Uses .45-70 ammo."
	sawn_desc= "A single-shot break-action pistol chambered in .45-70. A bit difficult to aim."
	base_icon_state = "beacon_factory"
	icon_state = "beacon_factory"
	item_state = "beacon_factory"

/obj/item/gun/ballistic/shotgun/doublebarrel/beacon/factory/sawoff(mob/user)
	. = ..()
	if(.)
		item_state = "beacon_factory_sawn"
		mob_overlay_state = item_state

//pre sawn off beacon
/obj/item/gun/ballistic/shotgun/doublebarrel/beacon/presawn
	name = "sawn-off HP Beacon"
	sawn_desc= "A single-shot break-action pistol chambered in .45-70. A bit difficult to aim."
	sawn_off = TRUE
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT

	weapon_weight = WEAPON_MEDIUM

	item_state = "beacon_sawn"
	mob_overlay_state = "beacon_sawn"
	wield_slowdown = 0.5
	wield_delay = 0.5 SECONDS

	spread_unwielded = 20 //mostly the hunting revolver stats
	spread = 6
	recoil = 2
	recoil_unwielded = 4
