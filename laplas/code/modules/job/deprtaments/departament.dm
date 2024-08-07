/// Singleton representing a category of jobs forming a department.
/datum/job_department
	/// Department as displayed on different menus.
	var/department_name = "UNASSIGNED"
	/// Bitflags associated to the specific department.
	var/department_bitflags = NONE
	/// Typepath of the job datum leading this department.
	var/datum/job/department_head = null
	/// Experience granted by playing in a job of this department.
	var/department_experience_type = null
	/// The order in which this department appears on menus, in relation to other departments.
	var/display_order = 0
	/// The header color to be displayed in the ban panel, classes defined in banpanel.css
	var/label_class = "undefineddepartment"
	/// The color used in TGUI or similar menus.
	var/ui_color = "#ffffff"
	/// Job singleton datums associated to this department. Populated on job initialization.
	var/list/department_jobs = list()
	/// The single access associated with the head of staff of this department.
	var/head_of_staff_access
	/// A list of generic access flags people in this department generally have.
	var/list/department_access = list()

/// Handles adding jobs to the department and setting up the job bitflags.
/datum/job_department/proc/add_job(datum/job/job)
	department_jobs += job
	job.departments_bitflags |= department_bitflags
