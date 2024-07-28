/mob/living/simple_animal/hostile/human/hermit
	name = "Whitesands Inhabitant"
	desc = "If you can read this, yell at a coder!"
	icon_state = "survivor_base"
	icon_living = "survivor_base"
	atmos_requirements = list("min_oxy" = 1, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 0, "min_co2" = 0, "max_co2" = 999, "min_n2" = 0, "max_n2" = 0)
	loot = list(
		/obj/effect/mob_spawn/human/corpse/damaged/whitesands
	)

/mob/living/simple_animal/hostile/human/hermit/survivor/death(gibbed)
	move_force = MOVE_FORCE_DEFAULT
	move_resist = MOVE_RESIST_DEFAULT
	pull_force = PULL_FORCE_DEFAULT
	..()
	/*
	if(prob(15))
		new /obj/item/mob_trophy/shiny(loc)
		visible_message("<span class='warning'>You notice a glimmering nugget of shiny metal.</span>")
	*/

/mob/living/simple_animal/hostile/human/hermit/survivor
	name = "Hermit Wanderer"
	desc =" A wild-eyed figure, wearing tattered mining equipment and boasting a malformed body, twisted by the heavy metals and high background radiation of the sandworlds."
	loot = list(
		/obj/effect/mob_spawn/human/corpse/damaged/whitesands/survivor
	)

/mob/living/simple_animal/hostile/human/hermit/survivor/random/Initialize()
	. = ..()
	if(prob(35))
		new /mob/living/simple_animal/hostile/human/hermit/ranged/hunter(loc)
		return INITIALIZE_HINT_QDEL
	if(prob(10))
		new /mob/living/simple_animal/hostile/human/hermit/ranged/gunslinger(loc)
		return INITIALIZE_HINT_QDEL

/mob/living/simple_animal/hostile/human/hermit/ranged
	icon_state = "survivor_hunter"
	icon_living = "survivor_hunter"
	projectiletype = null
	casingtype = /obj/item/ammo_casing/aac_300blk/recycled
	projectilesound = 'sound/weapons/gun/rifle/shot.ogg'
	ranged = 1
	rapid_fire_delay = 6
	retreat_distance = 5
	minimum_distance = 5

/mob/living/simple_animal/hostile/human/hermit/ranged/hunter
	name = "Hermit Hunter"
	desc ="A wild-eyed figure. Watch out- he has a gun, and he remembers just enough of his old life to use it!"
	loot = list(
		/obj/effect/mob_spawn/human/corpse/damaged/whitesands/hunter,
	)

/mob/living/simple_animal/hostile/human/hermit/ranged/gunslinger
	name = "Hermit Soldier"
	desc = "The miner's rebellion, though mostly underground, recieved a few good weapon shipments from an off-sector source. You should probably start running."
	icon_state = "survivor_gunslinger"
	icon_living = "survivor_gunslinger"
	projectilesound = 'sound/weapons/gun/smg/shot.ogg'
	speed = 10
	rapid = 4
	rapid_fire_delay = 3
	casingtype = /obj/item/ammo_casing/a545_39/recycled
	loot = list(
		/obj/effect/mob_spawn/human/corpse/damaged/whitesands/gunslinger,
	)

//survivor corpses

/obj/effect/mob_spawn/human/corpse/damaged/whitesands
	uniform = /obj/item/clothing/under/color/random
	belt = /obj/item/storage/belt/fannypack
	shoes = /obj/item/clothing/shoes/workboots/mining
	suit = /obj/item/clothing/suit/hooded/survivor
	l_pocket = /obj/item/radio
	r_pocket = /obj/item/tank/internals/emergency_oxygen/engi
	var/survivor_type //room for alternatives inside the fuckoff grade init.

/obj/effect/mob_spawn/human/corpse/damaged/whitesands/Initialize() //everything here should equal out to 100 for the sake of my sanity.
	mob_species = pickweight(list(
			/datum/species/human = 50,
			/datum/species/lizard = 20,
			/datum/species/ipc = 10,
			/datum/species/elzuose = 10,
			/datum/species/moth = 5,
			/datum/species/spider = 5
		)
	)
	//to-do: learn how to make mobsprites for other survivors

	//gloves are a tossup
	gloves = pickweight(list(
			/obj/item/clothing/gloves/color/black = 60,
			/obj/item/clothing/gloves/explorer = 30,
			/obj/item/clothing/gloves/explorer/old = 10
			)
		)

	//bags are semi-random.
	back = pickweight(list(
			/obj/item/storage/backpack = 20,
			/obj/item/storage/backpack/explorer = 20,
			/obj/item/storage/backpack/satchel = 20,
			/obj/item/storage/backpack/satchel/explorer = 20,
			/obj/item/storage/backpack/messenger = 20
			)
		)

	//as are bag contents
	backpack_contents = list()
	if(prob(70))
		backpack_contents += pickweight(list( //these could stand to be expanded, right now they're just mildly modified miner ones, and I don't know how to plus that up.
			/obj/item/soap = 10,
			/obj/item/stack/marker_beacon/ten = 15,
			/obj/item/mining_scanner = 5,
			/obj/item/extinguisher/mini = 10,
			/obj/item/kitchen/knife/combat = 5,
			/obj/item/flashlight/seclite = 10,
			/obj/item/stack/sheet/sinew = 10,
			/obj/item/stack/sheet/bone = 5,
			/obj/item/stack/sheet/animalhide/goliath_hide = 10,
			/obj/item/stack/sheet/bone = 8,
			/obj/item/reagent_containers/food/drinks/waterbottle = 10,
			/obj/item/reagent_containers/food/drinks/waterbottle/empty = 2,
			)
		)
	if(prob(70))
		backpack_contents += pickweight(list(
			/obj/item/stack/sheet/animalhide/goliath_hide = 20,
			/obj/item/stack/marker_beacon/ten = 10,
			/obj/item/mining_scanner = 20,
			/obj/item/extinguisher/mini = 10,
			/obj/item/kitchen/knife/combat/survival = 10,
			/obj/item/flashlight/seclite = 10,
			/obj/item/stack/sheet/sinew = 10,
			/obj/item/stack/sheet/bone = 10
			)
		)
	if(prob(70))
		backpack_contents += pickweight(list(
			/obj/item/stack/sheet/animalhide/goliath_hide = 5,
			/obj/item/stack/marker_beacon/ten = 5,
			/obj/item/mining_scanner = 5,
			/obj/item/extinguisher/mini = 10,
			/obj/item/kitchen/knife/combat/survival = 12,
			/obj/item/flashlight/seclite = 10,
			/obj/item/stack/sheet/sinew = 5,
			/obj/item/stack/sheet/bone = 5,
			/obj/item/kitchen/knife/combat = 3,
			/obj/item/reagent_containers/food/snacks/rationpack = 30
			)
		)
	if (prob(15)) //mayhaps a medkit
		backpack_contents += pickweight(list(
			/obj/item/storage/firstaid/regular = 50,
			/obj/item/storage/firstaid/brute = 15,
			/obj/item/storage/firstaid/medical = 15,
			/obj/item/storage/firstaid/fire = 10,
			/obj/item/storage/firstaid/advanced = 5,
			/obj/item/storage/firstaid/ancient = 5
			)
		)
	if(prob(30)) //some pens maybe?
		backpack_contents += /obj/item/reagent_containers/hypospray/medipen/survival

	//masks
	mask = pickweight(list(
		/obj/item/clothing/mask/gas = 40,
		/obj/item/clothing/mask/gas/explorer = 20,
		/obj/item/clothing/mask/gas/explorer/old = 20,
		/obj/item/clothing/mask/gas/syndicate = 20,
		)
	)

	//the eyes are the window into the soul.
	if(prob(70))
		glasses = pickweight(list(
			/obj/item/clothing/glasses/heat = 20,
			/obj/item/clothing/glasses/cold = 20,
			/obj/item/clothing/glasses/meson = 40,
			/obj/item/clothing/glasses = 20
			)
		)

	//and of course, ears.
	if(prob(1)) //oh my god they can't hear the sandstorm coming they've got airpods in
		ears = /obj/item/instrument/piano_synth/headphones/spacepods
	else
		ears = pickweight(list(
			/obj/item/radio/headset = 50,
			/obj/item/radio/headset/alt = 50
			)
		)
	//now for the fun stuff
	switch(survivor_type)
		if("survivor")
			//uniforms are random to show varied backgrounds, but similar goal
			uniform = pickweight(list(
				/obj/item/clothing/under/color/random = 65,
				/obj/item/clothing/under/rank/cargo/miner/lavaland = 10,
				/obj/item/clothing/under/rank/prisoner = 10,
				/obj/item/clothing/under/rank/cargo/miner/lavaland/old = 5,
				/obj/item/clothing/under/color/khaki/buster = 5,
				/obj/item/clothing/under/rank/cargo/miner = 5
				)
			)
			//storage is semi-randomized, giving some variety
			belt = 	pickweight(list(
				/obj/item/storage/belt/fannypack = 40,
				/obj/item/storage/belt/mining = 20,
				/obj/item/storage/belt/mining/alt = 15,
				/obj/item/storage/belt/utility = 10,
				/obj/item/storage/belt/bandolier = 9,
				/obj/item/storage/belt/utility/full = 5,
				/obj/item/storage/belt/chameleon= 1,
				)
			)
			if(prob(30))
				l_pocket = /obj/item/reagent_containers/food/snacks/meat/steak/goliath
			if(prob(20))
				r_pocket = /obj/item/spacecash/bundle/smallrand

		if("hunter")
			uniform = pickweight(list(
				/obj/item/clothing/under/color/random = 50,
				/obj/item/clothing/under/rank/cargo/miner/lavaland = 25,
				/obj/item/clothing/under/rank/cargo/miner/lavaland/old = 15,
				/obj/item/clothing/under/rank/security/officer/camo = 5,
				/obj/item/clothing/under/utility = 5
				)
			)
			belt = 	pickweight(list(
				/obj/item/storage/belt/mining = 30,
				/obj/item/storage/belt/fannypack = 20,
				/obj/item/storage/belt/mining/alt = 15,
				/obj/item/storage/belt/mining/primitive = 15,
				/obj/item/storage/belt/bandolier = 10,
				/obj/item/storage/belt/military = 7,
				/obj/item/storage/belt/mining/vendor = 3,
				)
			)
			if(prob(20))
				l_pocket = /obj/item/reagent_containers/food/snacks/meat/steak/goliath
			else if(prob(60))
				l_pocket = /obj/item/ammo_box/aac_300blk_stripper
			if(prob(20))
				new /obj/item/gun/ballistic/rifle/polymer(loc)
			else
				visible_message(span_warning("The hunter's weapon shatters as they impact the ground!"))

		if("gunslinger")
			uniform = pickweight(list(
				/obj/item/clothing/under/rank/cargo/miner/lavaland = 35,
				/obj/item/clothing/under/color/random = 25,
				/obj/item/clothing/under/rank/cargo/miner/lavaland/old = 15,
				/obj/item/clothing/under/rank/security/officer/camo = 10,
				/obj/item/clothing/under/syndicate/camo = 10,
				/obj/item/clothing/under/syndicate/combat = 5
				)
			)
			belt = pickweight(list(
				/obj/item/storage/belt/mining = 30,
				/obj/item/storage/belt/bandolier = 30,
				/obj/item/storage/belt/military = 20,
				/obj/item/storage/belt/fannypack = 15,
				/obj/item/storage/belt/mining/alt = 5,
				/obj/item/storage/belt/mining/primitive = 5
				)
			)
			if(prob(30))
				shoes = /obj/item/clothing/shoes/combat //sometimes there are nicer shoes
			if(prob(50))
				l_pocket = /obj/item/ammo_box/magazine/skm_545_39
			if(prob(20))
				new /obj/item/gun/ballistic/automatic/smg/skm_carbine(loc)
			else
				visible_message(span_warning("The gunslinger's weapon shatters as they impact the ground!"))

	. = ..()


/obj/effect/mob_spawn/human/corpse/damaged/whitesands/survivor
	survivor_type = "survivor"

/obj/effect/mob_spawn/human/corpse/damaged/whitesands/hunter
	survivor_type = "hunter"

/obj/effect/mob_spawn/human/corpse/damaged/whitesands/gunslinger
	survivor_type = "gunslinger"

//hold overs for any admin who may want to spawn their own survivor realmobs

/datum/outfit/whitesands
	name = "Whitesands Survivor"
	uniform = /obj/item/clothing/under/color/random
	back = /obj/item/storage/backpack
	shoes = /obj/item/clothing/shoes/workboots/mining
	suit = /obj/item/clothing/suit/hooded/survivor
	r_pocket = /obj/item/tank/internals/emergency_oxygen/engi
	gloves = /obj/item/clothing/gloves/color/black //randomize a bit
