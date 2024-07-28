
/obj/item/mine
	name = "mine"
	desc = "An anti-personnel mine. This one explodes into nothing and does nothing. Why can you see this? You should't be able to see this. Stop looking at this."
	icon = 'icons/obj/landmine.dmi'
	w_class = WEIGHT_CLASS_SMALL
	throw_speed = 3
	throw_range = 5
	lefthand_file = 'icons/mob/inhands/misc/devices_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/devices_righthand.dmi'
	icon_state = "mine"
	item_state = "assembly"//when we get custom sprites replace this. please
	base_icon_state = "mine"

	/// Is our mine live?
	var/armed = FALSE
	/// Is our mine currently exploding?
	var/triggered = FALSE

	/// Sets a delay for mines going live after being planted
	var/arm_delay = 5 SECONDS
	/// Use to set a delay after activation to trigger the explosion.
	var/blast_delay = 1 DECISECONDS

	var/manufacturer = MANUFACTURER_NONE


/obj/item/mine/Initialize(mapload)
	. = ..()
	if(armed)
		now_armed()


/obj/item/mine/examine(mob/user)
	. = ..()
	if(!armed)
		. += span_info("It appears to be inactive...")
	else
		. += span_info("It looks ready to explode.")

	if(manufacturer)
		. += span_notice("It has <b>[manufacturer]</b> engraved on it.")

/obj/item/mine/update_icon_state()
	. = ..()
	icon_state = "[base_icon_state][triggered ? "_exploding" : null][!armed && anchored ? "_arming" : null][armed && anchored && !triggered ? "_armed" : null]"

//mines have a small chance to be triggered by damage, but they take longer to explode
/obj/item/mine/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir)
	. = ..()
	if(prob(35) & obj_integrity > 0)
		blast_delay = blast_delay * 2
		trigger_mine()

//insert your horrible fate here
/obj/item/mine/proc/mine_effect(mob/victim)
	return

//handles controlled deactivation
/obj/item/mine/proc/disarm()
	if(triggered) //no turning back now
		return
	anchored = FALSE
	armed = FALSE
	update_appearance(UPDATE_ICON_STATE)
	return

//using an unarmed mine inhand deploys it.
/obj/item/mine/attack_self(mob/user)
	if(!armed)
		user.visible_message(span_danger("[user] deploys the [src]."), span_notice("You deploy the [src]."))

		user.dropItemToGround(src)
		anchored = TRUE
		playsound(src, 'sound/machines/click.ogg', 60, TRUE)

		if(arm_delay)
			armed = FALSE
			update_appearance(UPDATE_ICON_STATE)
			addtimer(CALLBACK(src, PROC_REF(now_armed)), arm_delay)
		else
			armed = TRUE
		message_admins("[key_name(user)] has placed \a [src] at ([x],[y],[z]).")

//let them know the mine's done cooking
/obj/item/mine/proc/now_armed()
	armed = TRUE
	update_appearance(UPDATE_ICON_STATE)
	playsound(src, 'sound/machines/nuke/angry_beep.ogg', 55, FALSE, 1)
	visible_message("<span class='danger'>\The [src] beeps softly, indicating it is now active.<span>", vision_distance = COMBAT_MESSAGE_RANGE)

/// Can this mine trigger on the passed movable?
/obj/item/mine/proc/can_trigger(atom/movable/on_who)
	//var/badtype = typecacheof(list(/obj/effect, /obj/item/mine))
	if(triggered || !isturf(loc) || !armed || iseffect(on_who) || istype(on_who, /obj/item/mine))
		return FALSE
	//if(on_who == badtype)//no recursive self triggering. Bad landmine
	//	return FALSE
	return TRUE

/// When something sets off a mine
/obj/item/mine/proc/trigger_mine(atom/movable/triggerer)
	if(obj_integrity <= 0)
		return
	if(triggered) //too busy detonating to detonate again
		return
	if(triggerer)
		triggerer.visible_message(span_danger("[icon2html(src, viewers(src))] [triggerer] sets off \the [src]. It's gonna blow!"), span_danger("[icon2html(src, viewers(src))] \The [src] activates."))
	else
		visible_message(span_danger("[icon2html(src, viewers(src))] \the [src] begins to flash bright red!"))
	triggered = TRUE
	update_appearance(UPDATE_ICON_STATE)
	if(blast_delay >= 5 DECISECONDS)
		playsound(src, 'sound/items/mine_activate.ogg', 70, FALSE)
	else
		playsound(src, 'sound/items/mine_activate_short.ogg', 80, FALSE)
	light_color = "#FF0000"
	light_power = 5
	light_range = 3
	if(!blast_delay)//addtimer gets mad if the delay is 0
		blast_now(triggerer)
	else
		addtimer(CALLBACK(src, PROC_REF(blast_now), triggerer), blast_delay)

//NOW we actually blow up
/obj/item/mine/proc/blast_now(atom/movable/triggerer)
	var/datum/effect_system/spark_spread/sporks = new /datum/effect_system/spark_spread
	sporks.set_up(3, 1, src)
	sporks.start()
	if(ismob(triggerer))
		mine_effect(triggerer)
	else
		mine_effect()
	visible_message(span_danger("[icon2html(src, viewers(src))] \the [src] detonates!"))
	SEND_SIGNAL(src, COMSIG_MINE_TRIGGERED, triggerer)
	if(triggered)//setting triggered to false in mine_effect() creates a reusable mine
		qdel(src)

//trying to pick up a live mine is probably up there when it comes to terrible ideas
/obj/item/mine/attack_hand(mob/user)
	if(armed)
		user.visible_message(span_warning("[user] extends their hand towards \the [src]!"), span_userdanger("You extend your arms to pick up \the [src], knowing that it will likely blow up when you touch it!"))
		if(do_after(user, 5 SECONDS, target = src))//SO SO generous. You can still step back from the edge.
			if(prob(10))
				user.visible_message(span_notice("[user] picks up \the [src], which miraculously doesn't explode!"), span_notice("You pick up \the [src], which miraculously doesn't explode!"))
				disarm()
			else
				user.visible_message(span_danger("[user] attempts to pick up \the [src] only to hear a beep as it activates in their hand!"), span_danger("You attempt to pick up \the [src] only to hear a beep as it activates in your hands!"))
				anchored = FALSE
				trigger_mine(user)
				return . =..()
		else
			user.visible_message(span_notice("[user] withdraws their hand from \the [src]."), span_notice("You decide against picking up \the [src]."))
	. =..()

//just don't.
/obj/item/mine/attackby(obj/item/I, mob/user)
	if(!armed)
		to_chat(user, span_notice("You smack \the [src] with [I]. Thankfully, nothing happens."))
		return
	else//please stop hitting the live mine with a rock
		if(user.a_intent != INTENT_HARM)//are you SURE you want to hit the live mine with a rock
			user.visible_message(user, span_notice("[user] gently pokes \the [src] with [I]. Nothing seems to happen."), span_notice("You gently prod \the [src] with [I]. Thankfully, nothing happens."))
		else//at this point it's just natural selection
			user.visible_message(span_danger("[user] hits \the [src] with [I], activating it!"), span_userdanger("[icon2html(src, viewers(src))]You hit \the [src] with [I]. The light goes red."))
			trigger_mine(user)

//
//PRESSURE BASED MINE:
//Mine that explodes when stepped on.
/obj/item/mine/pressure
	name = "dummy landmine"
	/// When true, mines trigger instantly on being stepped upon
	var/hair_trigger = FALSE
	/// Has the mine loc been entered?
	var/clicked = FALSE
	/// Prevents a mine from being screwdrivable (e.g. cannot be disarmed)
	var/sealed = FALSE
	/// Disables the mine without disarming it. perfect for practical jokes
	var/dud = FALSE

	/// Are the wires exposed?
	var/open_panel = FALSE

	/// Who's got their foot on the mine's pressure plate
	/// Stepping on the mine will set this to the first mob who stepped over it
	/// The mine will not detonate via movement unless the first mob steps off of it
	var/datum/weakref/foot_on_mine

/obj/item/mine/pressure/Initialize()
	. = ..()
	var/static/list/loc_connections = list(
		COMSIG_ATOM_ENTERED = PROC_REF(on_entered),
		COMSIG_ATOM_EXITED = PROC_REF(on_exited),
	)
	AddElement(/datum/element/connect_loc, loc_connections)
	wires = new /datum/wires/mine(src)

/obj/item/mine/pressure/examine(mob/user)
	. = ..()
	if(hair_trigger)
		. += span_danger("It's been rigged to detonate as soon as someone steps on it.")
	else
		var/atom/movable/unlucky_sod = foot_on_mine?.resolve()
		if(user == unlucky_sod)
			. += span_bolddanger("The pressure plate is depressed. Any movement you make will set it off now.")
		else if(!isnull(unlucky_sod))
			. += span_danger("The pressure plate is depressed by [unlucky_sod]. Any move they make'll set it off now.")

//step 1: the mistake
/obj/item/mine/pressure/proc/on_entered(datum/source, atom/movable/arrived)
	SIGNAL_HANDLER
	if(!can_trigger(arrived))
		return
	// All other movment types rn can easily avoid it
	if(!(arrived.movement_type == GROUND))
		return
	// Someone already on it
	if(foot_on_mine?.resolve())
		return

	if(dud == FALSE)//we don't actually need this if the mine's been disabled
		foot_on_mine = WEAKREF(arrived)

	if(ismob(arrived))
		var/mob/living/fool = arrived
		fool.do_alert_animation(fool)
		if(!hair_trigger)
			fool.Immobilize(25 DECISECONDS, TRUE)
			to_chat(fool, span_userdanger("You step on \the [src] and freeze."))
	visible_message(span_danger("[icon2html(src, viewers(src))] *click*"))
	if(dud == FALSE)//see wirecutting
		clicked = TRUE
		if(hair_trigger)
			trigger_mine(arrived)
	playsound(src, 'sound/machines/click.ogg', 100, TRUE)

//step 2: the consequences
/obj/item/mine/pressure/proc/on_exited(datum/source, atom/movable/gone)
	SIGNAL_HANDLER
	if(hair_trigger)
		return
	if(!clicked)
		return
	if(!can_trigger(gone))
		return
	// Check that the guy who's on it is stepping off
	if(foot_on_mine && !IS_WEAKREF_OF(gone, foot_on_mine))
		return
	INVOKE_ASYNC(src, PROC_REF(trigger_mine), gone)
	foot_on_mine = null

/obj/item/mine/pressure/disarm()
	clicked = FALSE
	. = ..()

/obj/item/mine/pressure/hitby(atom/movable/AM, skipcatch, hitpush, blocked, datum/thrownthing/throwingdatum)
	trigger_mine(AM)
	..()

//handles disarming(and failing to disarm)
/obj/item/mine/pressure/attackby(obj/item/I, mob/user)
	if(I.tool_behaviour == TOOL_SCREWDRIVER)
		if(sealed)
			to_chat(user, "<span class='notice'>You can't see any way to access \the [src]'s wiring.</span>")
			return
		open_panel = !open_panel
		update_appearance(UPDATE_ICON_STATE)
		to_chat(user, "<span class='notice'>You [open_panel ? "reveal" : "hide"] \the [src]'s wiring.</span>")
		I.play_tool_sound(src, 50)
		return
	else if(is_wire_tool(I) && open_panel)
		wires.interact(user)
		return
	else
		. = ..()

//
//PROXIMITY MINES
//Mines that explode when someone moves nearby. Simpler, because I don't have to worry about saving step info or disarming logic
//

/obj/item/mine/proximity
	name = "dummy proximity mine"
	blast_delay = 15 DECISECONDS
	arm_delay = 10 SECONDS//clear the area
	///needed for the proximity checks.
	var/datum/proximity_monitor/proximity_monitor
	var/proximity_range = 2

/obj/item/mine/proximity/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSfastprocess, src)

/obj/item/mine/proximity/examine(mob/user)
	. = ..()
	if(armed)
		. += span_danger("It's been rigged to detonate as soon as someone moves nearby...")
	else
		. += span_notice("When armed, it activates based on the proximity of living targets.")

/obj/item/mine/proximity/now_armed()
	. = ..()
	proximity_monitor = new(src, proximity_range)
	light_color = "#FF0000"
	light_power = 1
	light_range = 1

/obj/item/mine/proximity/disarm()
	. = ..()
	QDEL_NULL(proximity_monitor)

/obj/item/mine/proximity/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	QDEL_NULL(proximity_monitor)
	. = ..()

/obj/item/mine/proximity/HasProximity(atom/movable/triggerer)
	if(!iscarbon(triggerer))//let's keep these on player movements for now.
		return
	if(!can_trigger(triggerer))
		return
	var/mob/living/clueless = triggerer
	clueless.do_alert_animation(clueless)
	trigger_mine(triggerer)
	QDEL_NULL(proximity_monitor)
	return

//
//LANDMINE TYPES
//Rylie please help me make these more immersive
//

/obj/item/mine/pressure/explosive
	name = "\improper G-80 Landmine"
	desc = "An anti-infantry explosive produced during the corporate wars. Watch your step."

	//customize explosive power
	var/range_devastation = 0
	var/range_heavy = 1
	var/range_light = 5
	var/range_flame = 1

	//using this to indicate pb
	var/range_flash = 1

	//customize shrapnel. Magnitude zero prevents them from spawning
	var/shrapnel_type = /obj/projectile/bullet/shrapnel
	var/shrapnel_magnitude = 3

	/// If TRUE, we spawn extra pellets to eviscerate a person still sitting on it, otherwise it just spawns a ring of pellets around the tile we're on (making setting it off an offensive move)
	var/shred_triggerer = TRUE

	manufacturer = MANUFACTURER_SCARBOROUGH

/obj/item/mine/pressure/explosive/mine_effect(mob/victim)
	explosion(loc, range_devastation, range_heavy, range_light, range_flash, 1, 0, range_flame, 0, 1)
	if(shrapnel_magnitude > 0)
		AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_magnitude)


/obj/item/mine/pressure/explosive/rusty
	name = "\improper Rusted Landmine"
	desc = "An anti-infantry explosive, designed to go off underfoot. This one has seen better days."
	manufacturer = MANUFACTURER_NONE
	range_heavy = 0
	range_light = 3
	shrapnel_type = /obj/projectile/bullet/shrapnel/rusty


/obj/item/mine/pressure/explosive/fire
	name = "\improper G-82 Incindeary"
	desc = "An anti-infantry explosive produced during the corporate wars. Transforms into superheated slag and a ball of fire on detonation. "

	range_flame = 6
	range_light = 3
	range_flash = 3

	shrapnel_type = /obj/projectile/bullet/shrapnel/hot
	shrapnel_magnitude = 4

/obj/item/mine/pressure/explosive/fire/mine_effect(mob/victim)
	if(victim.is_holding(src))//in case it's been picked up
		for(var/turf/T in view(4,victim))
			T.IgniteTurf(15)
			new /obj/effect/hotspot(T)
	else
		for(var/turf/T in view(4,src))
			T.IgniteTurf(15)
			new /obj/effect/hotspot(T)
	. = ..()


/obj/item/mine/pressure/explosive/heavy
	name = "\improper G-81 Anti-Tank Mine"
	desc = "An immense anti-vehicle explosive built during the corporate wars. Someone has recklessly switched out the detonator for one that activates for lighter targets."
	w_class = WEIGHT_CLASS_BULKY
	range_heavy = 6
	range_light = 9
	shrapnel_magnitude = 7
	shrapnel_type = /obj/projectile/bullet/shrapnel/mega
	blast_delay = 50//run.
	sealed = TRUE//unless we specifically give it to people disarmed, we probably don't want them stealing this


/obj/item/mine/pressure/explosive/shrapnel
	name = "\improper G-84 Fragmentation"
	desc = "An anti-infantry explosive built during the corporate wars. Metal banding inside creates additional deadly shrapnel on detonation. "

	range_heavy = 1
	range_light = 4

	shrapnel_magnitude = 6
	shred_triggerer = TRUE

/obj/item/mine/pressure/explosive/rad
	name = "\improper G-85 Fission"
	desc = "An anti-infantry explosive produced during the corporate wars. This one detonates a small microfission core, creating a bloom of deadly radiation. "
	range_light = 4
	range_flame = 2
	shrapnel_magnitude = 7
	shrapnel_type = /obj/projectile/bullet/shrapnel/spicy
	var/radpower = 750

/obj/item/mine/pressure/explosive/rad/mine_effect(mob/victim)
	radiation_pulse(src, radpower, 1)
	. = ..()

//put this on military ships for disarming practice
/obj/item/mine/pressure/training
	name = "\improper G-MTH Defusal Trainer"
	desc = "A mothballed anti-personnel explosive, equipped with VISCERAL DEFUSAL ACTION for training purposes. Though Scarborough was forced to decomission their stockpiles of mines as part of the ceasefire, the deployed minefields remain."
	arm_delay = 2 SECONDS
	manufacturer = MANUFACTURER_SCARBOROUGH

/obj/item/mine/pressure/training/mine_effect(mob/living/victim)
	src.say("BOOM! Better luck next time!")
	src.visible_message(span_notice("The mine resets itself for another disarming attempt."))
	triggered = FALSE
	disarm()
	. = ..()

/obj/item/mine/pressure/gas
	name = "chilled vapor mine"
	desc = "A non-lethal security deterrent."
	var/gas_amount = 500
	var/gas_type = "water_vapor"
	hair_trigger = TRUE

/obj/item/mine/pressure/gas/mine_effect(mob/victim)
	atmos_spawn_air("[gas_type]=[gas_amount]")


/obj/item/mine/proximity/explosive
	name = "\improper G-80P Bouncer"
	desc = "An anti-infantry explosive produced during the corporate wars. This one has been rearmed with a proximity movement detector."

	var/range_devastation = 0
	var/range_heavy = 2
	var/range_light = 4
	var/range_flame = 1

	var/range_flash = 1

	var/shrapnel_type = /obj/projectile/bullet/shrapnel
	var/shrapnel_magnitude = 5

	manufacturer = MANUFACTURER_SCARBOROUGH

/obj/item/mine/proximity/explosive/mine_effect(mob/victim)
	explosion(loc, range_devastation, range_heavy, range_light, range_flash, 1, 0, range_flame, 0, 1)
	if(shrapnel_magnitude > 0)
		AddComponent(/datum/component/pellet_cloud, projectile_type=shrapnel_type, magnitude=shrapnel_magnitude)


//like all real 'less' than lethal crowd control options this is, in fact, not very good at being nonlethal
/obj/item/mine/proximity/explosive/sting
	name = "\improper'Stinger' Crowd Management Device"
	desc = "A \"less\" than lethal crowd control weapon, designed to demoralise and scatter anti-NT protestors. The bands of ballistic gel inside strike targets and incapacitate without causing serious maiming. In Theory."

	range_heavy = 0
	range_light = 1
	range_flash = 3
	range_flame = 0

	shrapnel_magnitude = 8
	shrapnel_type = /obj/projectile/bullet/pellet/stingball
	manufacturer = MANUFACTURER_NANOTRASEN_OLD


/obj/item/mine/proximity/explosive/plasma
	name = "\improper Etherbor EP-3"
	desc = "An anti-infantry explosive designed by the PGF for denial of territory to enemy forces. Radiates high energy plasma to eradicate nearby targets."
	range_light = 2
	range_flame = 3
	range_heavy = 0
	shrapnel_magnitude = 8
	shrapnel_type = /obj/projectile/energy/plasmabolt
	manufacturer = MANUFACTURER_PGF

/obj/item/mine/proximity/explosive/plasma/mine_effect(mob/victim)
	if(victim.is_holding(src))//in case it's been picked up
		for(var/turf/T in view(3,victim))
			T.IgniteTurf(25, "green")
	else
		for(var/turf/T in view(3,src))
			T.IgniteTurf(25, "green")
	. = ..()

//Manhacks... so pretty...
/obj/item/mine/proximity/spawner
	name = "debug spawner mine"
	desc = "Real no Virus. 100% free. Coders hate him!"
	var/spawn_type = null //manhacks go here :)
	var/spawn_number = 5

/obj/item/mine/proximity/spawner/mine_effect(mob/victim)
	if(isturf(loc))
		var/turf/T = get_turf(src)
		playsound(T, 'sound/effects/phasein.ogg', 100, TRUE)
		spawn_and_random_walk(spawn_type, T, spawn_number, walk_chance=50, admin_spawn=((flags_1 & ADMIN_SPAWNED_1) ? TRUE : FALSE))
	. = ..()

/obj/item/mine/proximity/spawner/manhack
	name = "\improper P-83 Lacerator"
	desc = "An anti-infantry device produced during the corporate wars. The explosive payload has been swapped out for 'viscerator'-type antipersonnel drones."
	spawn_type = /mob/living/simple_animal/hostile/viscerator

//
//GIMMICK MINES//
//pretty much exclusively for adminbus & code dependencies
//

/obj/item/mine/pressure/kickmine
	name = "\improper A-00 'Adminbus'"
	desc = "An Anti-Griefer proximity expulsive. Delivers Justice."
	blast_delay = null//funnier this way
	hair_trigger = TRUE

/obj/item/mine/pressure/kickmine/mine_effect(mob/victim)
	if(isliving(victim) && victim.client && Adjacent(victim))
		to_chat(victim, span_userdanger("You have been kicked from the game. Take this time to think about what you've done."))
		qdel(victim.client)

/obj/item/mine/pressure/sound
	name = "sonic mine"
	desc = "A potent tool of psychological warfare."
	var/sound = 'sound/effects/adminhelp.ogg'
	blast_delay = null
	hair_trigger = TRUE

/obj/item/mine/pressure/sound/mine_effect(mob/victim)
	playsound(loc, sound, 100, TRUE)

/obj/item/mine/pressure/pickup
	name = "pickup mine"
	desc = "does nothing"
	icon = 'icons/obj/marg.dmi'
	icon_state = "marg"
	density = FALSE
	var/duration = 0
	pixel_x = -8
	pixel_y = 1
	anchored = TRUE
	armed = TRUE
	blast_delay = null
	hair_trigger = TRUE

/obj/item/mine/pressure/pickup/Initialize()
	. = ..()
	animate(src, time = 20, loop = -1)

/obj/item/mine/pressure/pickup/trigger_mine(mob/victim)
	if(triggered)
		return
	triggered = TRUE
	invisibility = INVISIBILITY_ABSTRACT
	mine_effect(victim)
	qdel(src)


/obj/item/mine/pressure/pickup/bloodbath
	name = "bloody orb"
	desc = "Embrace righteous fury."
	duration = 1200 //2min
	color = "#FF0000"
	var/mob/living/doomslayer
	var/obj/item/chainsaw/doomslayer/chainsaw

/obj/item/mine/pressure/pickup/bloodbath/mine_effect(mob/living/carbon/victim)
	if(!victim.client || !istype(victim))
		return
	to_chat(victim, "<span class='reallybig redtext'>RIP AND TEAR</span>")

	INVOKE_ASYNC(src, PROC_REF(blood_delusion), victim)

	chainsaw = new(victim.loc)
	victim.log_message("entered a marg frenzy", LOG_ATTACK)

	ADD_TRAIT(chainsaw, TRAIT_NODROP, CHAINSAW_FRENZY_TRAIT)
	victim.drop_all_held_items()
	victim.put_in_hands(chainsaw, forced = TRUE)
	chainsaw.attack_self(victim)
	victim.reagents.add_reagent(/datum/reagent/medicine/adminordrazine,25)
	to_chat(victim, "<span class='warning'>KILL, KILL, KILL! YOU HAVE NO ALLIES ANYMORE, KILL THEM ALL!</span>")

	var/datum/client_colour/colour = victim.add_client_colour(/datum/client_colour/bloodlust)
	QDEL_IN(colour, 11)
	doomslayer = victim
	RegisterSignal(src, COMSIG_PARENT_QDELETING, PROC_REF(end_blood_frenzy))
	QDEL_IN(WEAKREF(src), duration)

/obj/item/mine/pressure/pickup/bloodbath/proc/end_blood_frenzy()
	if(doomslayer)
		to_chat(doomslayer, "<span class='notice'>Your bloodlust seeps back into the bog of your subconscious and you regain self control.</span>")
		doomslayer.log_message("exited a blood frenzy", LOG_ATTACK)
	if(chainsaw)
		qdel(chainsaw)

/obj/item/mine/pressure/pickup/bloodbath/proc/blood_delusion(mob/living/carbon/victim)
	new /datum/hallucination/delusion(victim, TRUE, "demon", duration, 0)

/obj/item/mine/pressure/pickup/healing
	name = "healing orb"
	desc = "Your wounds shall be undone."

/obj/item/mine/pressure/pickup/healing/mine_effect(mob/living/carbon/victim)
	if(!victim.client || !istype(victim))
		return
	to_chat(victim, "<span class='notice'>You feel great!</span>")
	victim.revive(full_heal = TRUE, admin_revive = TRUE)

/obj/item/mine/pressure/pickup/speed
	name = "quick orb"
	desc = "Quickens you."
	duration = 300

/obj/item/mine/pressure/pickup/speed/mine_effect(mob/living/carbon/victim)
	if(!victim.client || !istype(victim))
		return
	to_chat(victim, "<span class='notice'>You feel fast!</span>")
	victim.add_movespeed_modifier(/datum/movespeed_modifier/yellow_orb)
	addtimer(CALLBACK(src, PROC_REF(finish_effect), victim), duration)

/obj/item/mine/pressure/pickup/speed/proc/finish_effect(mob/living/carbon/victim)
	victim.remove_movespeed_modifier(/datum/movespeed_modifier/yellow_orb)
	to_chat(victim, "<span class='notice'>You slow down.</span>")



//
//mapping tool that generates "live" variants of all mine subtypes, which are anchored and ready to blow.
//Add new mine variants you make below as a LIVE_MINE_HELPER define containing their subtyping.
//

#define LIVE_MINE_HELPER(mine_type)		\
	/obj/item/mine/##mine_type/live {		\
		anchored = TRUE;					\
		armed = TRUE;						\
	}

LIVE_MINE_HELPER(pressure/explosive)
LIVE_MINE_HELPER(pressure/explosive/fire)
LIVE_MINE_HELPER(pressure/explosive/rusty)
LIVE_MINE_HELPER(pressure/explosive/rad)
LIVE_MINE_HELPER(pressure/explosive/heavy)
LIVE_MINE_HELPER(pressure/explosive/shrapnel)

LIVE_MINE_HELPER(proximity/explosive)
LIVE_MINE_HELPER(proximity/explosive/sting)
LIVE_MINE_HELPER(proximity/spawner/manhack)
LIVE_MINE_HELPER(proximity/explosive/plasma)

LIVE_MINE_HELPER(pressure/gas)
LIVE_MINE_HELPER(pressure/kickmine)
LIVE_MINE_HELPER(pressure/sound)

//
// spawners (random mines, minefields, non-guaranteed mine)
//

/obj/effect/spawner/lootdrop/mine
	name = "live mine spawner (random)"
	lootcount = 1
	fan_out_items = TRUE
	loot = list(
		/obj/item/mine/pressure/explosive/live = 10,
		/obj/item/mine/pressure/explosive/shrapnel/live = 3,
		/obj/item/mine/pressure/explosive/rad/live = 3,
		/obj/item/mine/pressure/explosive/fire/live = 3)

/obj/effect/spawner/minefield
	name = "minefield spawner"
	var/minerange = 9
	var/minetype = /obj/item/mine/pressure/explosive/rusty/live

/obj/effect/spawner/minefield/Initialize(mapload)
	. = ..()
	for(var/turf/open/T in view(minerange,loc))
		if(prob(5))
			new minetype(T)

/obj/effect/spawner/minefield/random
	name = "random minefield spawner"
	minetype = /obj/effect/spawner/lootdrop/mine

/obj/effect/spawner/minefield/manhack
	name = "manhack field spawner"
	minetype = /obj/item/mine/proximity/spawner/manhack/live
