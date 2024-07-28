/turf/open/floor/plating/dirt
	gender = PLURAL
	name = "dirt"
	desc = "Upon closer examination, it's still dirt."
	icon = 'icons/turf/floors.dmi'
	icon_state = "dirt"
	planetary_atmos = TRUE
	attachment_holes = FALSE
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	baseturfs = /turf/open/floor/plating/dirt

/turf/open/floor/plating/dirt/dark
	icon_state = "greenerdirt"
	baseturfs = /turf/open/floor/plating/dirt/dark

/turf/open/floor/plating/dirt/try_replace_tile(obj/item/stack/tile/T, mob/user, params)
	return

/turf/open/floor/plating/dirt/jungle
	slowdown = 0.5
	baseturfs = /turf/open/floor/plating/dirt/jungle
	initial_gas_mix = OPENTURF_DEFAULT_ATMOS

/turf/open/floor/plating/dirt/jungle/lit
	baseturfs = /turf/open/floor/plating/dirt/jungle/lit
	light_range = 2
	light_power = 1
	light_color = COLOR_VERY_LIGHT_GRAY

/turf/open/floor/plating/dirt/jungle/dark
	icon_state = "greenerdirt"
	baseturfs = /turf/open/floor/plating/dirt/jungle/dark

/turf/open/floor/plating/dirt/jungle/dark/lit
	light_range = 2
	light_power = 1

/turf/open/floor/plating/dirt/jungle/wasteland //Like a more fun version of living in Arizona.
	name = "cracked earth"
	desc = "Looks a bit dry."
	icon = 'icons/turf/floors.dmi'
	icon_state = "wasteland"
	slowdown = 1
	baseturfs = /turf/open/floor/plating/dirt/jungle/wasteland
	var/floor_variance = 15

/turf/open/floor/plating/dirt/jungle/wasteland/lit
	baseturfs = /turf/open/floor/plating/dirt/jungle/wasteland/lit
	light_range = 2
	light_power = 1


/turf/open/floor/plating/dirt/jungle/wasteland/Initialize(mapload, inherited_virtual_z)
	.=..()
	if(prob(floor_variance))
		icon_state = "[initial(icon_state)][rand(0,12)]"

/turf/open/floor/plating/dirt/icemoon
	initial_gas_mix = ICEMOON_DEFAULT_ATMOS
	baseturfs = /turf/open/floor/plating/dirt/icemoon
	planetary_atmos = TRUE

/turf/open/floor/plating/grass/jungle
	name = "jungle grass"
	planetary_atmos = TRUE
	desc = "Greener on the other side."
	icon_state = "junglegrass"
	base_icon_state = "junglegrass"
	baseturfs = /turf/open/floor/plating/dirt/jungle
	smooth_icon = 'icons/turf/floors/junglegrass.dmi'
	baseturfs = /turf/open/floor/plating/grass/jungle

/turf/open/floor/plating/grass/jungle/lit
	baseturfs = /turf/open/floor/plating/dirt/jungle/lit
	light_range = 2
	light_power = 1

/turf/open/water/jungle/lit
	light_range = 2
	light_power = 0.8
	light_color = LIGHT_COLOR_BLUEGREEN

/turf/open/floor/plating/dirt/old
	icon_state = "oldsmoothdirt"

/turf/open/floor/plating/dirt/old/lit
	light_power = 1
	light_range = 2

/turf/open/floor/plating/dirt/old/dark
	icon_state =  "oldsmoothdarkdirt"

/turf/open/floor/plating/dirt/old/dark/lit
	light_power = 1
	light_range = 2


/turf/open/floor/plating/dirt/dry/lit
	light_power = 1
	light_range = 2

