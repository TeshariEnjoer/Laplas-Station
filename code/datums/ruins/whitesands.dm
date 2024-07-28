// Hey! Listen! Update _maps\map_catalogue.txt with your new ruins!

/datum/map_template/ruin/whitesands
	prefix = "_maps/RandomRuins/SandRuins/"
	ruin_type = RUINTYPE_SAND

/datum/map_template/ruin/whitesands/medipen_plant
	name = "Abandoned Medipen Factory"
	id = "medipenplant"
	description = "A once prosperous autoinjector manufacturing plant."
	suffix = "whitesands_surface_medipen_plant.dmm"

/datum/map_template/ruin/whitesands/pubbyslopcrash
	name = "Pubby Slop Crash"
	id = "ws-pubbyslopcrash"
	description = "A failed attempt of the Nanotrasen nutrional replacement program"
	suffix = "whitesands_surface_pubbyslopcrash.dmm"

//////////OUTSIDE SETTLEMENTS/RUINS//////////
/datum/map_template/ruin/whitesands/survivors/saloon
	name = "Hermit Saloon"
	id = "ws-saloon"
	description = "A western style saloon, most popular spot for the hermits to gather planetside"
	suffix = "whitesands_surface_camp_saloon.dmm"

/datum/map_template/ruin/whitesands/survivors/combination //combined extra large ruin of several other whitesands survivor ruins
	name = "Wasteland Survivor Village"
	id = "ws-combination"
	description = "A small encampment of nomadic survivors of the First Colony, and their descendants. By all accounts, feral and without allegance to anyone but themselves."
	suffix = "whitesands_surface_camp_combination.dmm"
	allow_duplicates = FALSE

