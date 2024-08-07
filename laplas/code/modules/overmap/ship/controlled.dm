/datum/overmap/ship/controlled
	//bit field for ship flags
	var/ship_flags = SHIP_FLAG_LANDABLE | SHIP_FLAG_MOVEABLE | SHIP_FLAG_DOCKABLE

	//Job stuff

	/// List of all jobs of the ship.
	var/list/datum/job/all_occupations = list()
	/// List of jobs that can be joined through the starting menu. [Key(job tittles) - value(job datum)]
	var/list/datum/job/joinable_occupations = list()
	/// List of all departments with joinable jobs. [Key(departament name) - value(departament datum)]
	var/list/datum/job_department/joinable_departments = list()

	var/list/level_order = list(JP_HIGH,JP_MEDIUM,JP_LOW)
	var/list/chain_of_command = list(
		JOB_CAPTAIN = 1,
		JOB_HEAD_OF_PERSONNEL = 2,
		JOB_RESEARCH_DIRECTOR = 3,
		JOB_CHIEF_ENGINEER = 4,
		JOB_CHIEF_MEDICAL_OFFICER = 5,
		JOB_HEAD_OF_SECURITY = 6,
		JOB_QUARTERMASTER = 7,
	)

