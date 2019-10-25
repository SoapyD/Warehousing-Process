

def setup_dimensions():
	u_print('########################################')
	u_print('RUNNING WAREHOUSE SETUP')
	u_print('########################################')

	"""
	THE WAREHOUSE SETUP USES THE BASE TABLES IN THE INITIAL DATABASE TO FORMAT THE INITIAL TABLES THAT'LL
	BE UPDATED HEREAFTER
	"""

	print_internal = True
	print_details = True


	start_time = datetime.datetime.now() #need for process time u_printing

	output_db = 1 #REPORTING DATABASE
	output_database = 'LF-SQL-WH'
	source_db = 1 #REPORTING DATABASE
	source_database = 'LF-SQL-RPT01'


	""""""
	###################################################################################
	################################SETUP EXTERNAL TABLES
	###################################################################################

	#FIRST CREATE THE CREDENTIALS AND EXTERNAL TABLES WE'LL BE PULLING DATA FROM
	

	table_list = [
		"heatsm_incident",
		"heatsm_employee",
		"heatsm_servicereq",
		"heatsm_task",

		"enwl_incident",
		"enwl_employee",
		"enwl_servicereq",
		"enwl_task",
		"enwl_frs_data_escalation_watch",

		"he_incident",
		"he_sys_user",
		"he_incident_task",
		"he_task_sla",
		"he_sc_req_item",
		"he_sc_request",
		"he_sc_cat_item",

		"fsa_incident",
		"fsa_sys_user",	
		"fsa_sc_req_item",
		"fsa_sc_request",
		"fsa_sc_cat_item",
		"fsa_sc_task",

		"mhclg_incident",
		"mhclg_sys_user",	
		"mhclg_sc_req_item",
		"mhclg_sc_request",
		"mhclg_sc_cat_item",

		"croydon_incident",
		"croydon_sys_user",
		"croydon_sc_req_item",
		"croydon_sc_request",
		"croydon_sc_cat_item",											
	]

	setup_external_tables(source_db, source_database, output_db, output_database, 
		table_list, create_credential=False, print_details=print_details)
	

	###################################################################################
	################################SETUP LOOKUP TABLES
	###################################################################################
	
	
	u_print("Starting Dimension Tables process")
	process_start_time = datetime.datetime.now()

	dimension_table_list = [
		['status',"status",'TEMP_incident_combined',"status"],
		['source',"source",'TEMP_incident_combined',"source"],
		['company',"company",'TEMP_incident_combined',"company"],
		['typeofincident',"typeofincident",'TEMP_incident_combined',"typeofincident"],
		['ownerteam',"ownerteam",'TEMP_incident_combined',"ownerteam"],
		['system',"system",'TEMP_incident_combined',"system"],
		['businessunit',"businessunit",'TEMP_incident_combined',"businessunit"],
		['location',"location",'TEMP_incident_combined',"location"],
		['causecode',"causecode",'TEMP_incident_combined',"causecode"],
		['service',"service",'TEMP_incident_combined',"service"],
		['category',"category",'TEMP_incident_combined',"category"],
		['subcategory',"subcategory",'TEMP_incident_combined',"subcategory"],
	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	create_dimension_tables_2(output_db, output_database, dimension_table_list, print_details)
	

	#NOW WE HAVE TO CREATE THE OWNER DIMENSION TABLE WHICH IS A BIT MORE COMPLICATED

	dimension_table_list = [
		['owner',"REPLACE(owner,'.',' ')",'TEMP_incident_combined','owner'],
	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	create_dimension_tables_2(output_db, output_database, dimension_table_list, print_details)

	#WE THEN HAVE TO RUN THE ABOVE FOR ALL RESOLVER BASED FIELDS, UPDATING THE SAME LOOKUP_OWNER FIELD
	dimension_table_list = [
		['owner',"REPLACE(i.createdby,'.',' ')",'TEMP_incident_combined','owner'],
		['owner',"REPLACE(ISNULL(i.resolvedby,i.closedby),'.',' ')",'TEMP_incident_combined','owner'],
		['owner',"REPLACE(i.closedby,'.',' ')",'TEMP_incident_combined','owner'],
		['owner',"REPLACE(i.lastmodby,'.',' ')",'TEMP_incident_combined','owner'],
	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	update_dimension_tables_2(output_db, output_database, dimension_table_list, print_details)


	#NOW WE NEED TO POPULATE THE DATE TABLE, WHICH SHOULD COVER EVERY DAY FOR THE NEXT FEW YEARS
	create_date_table(output_db, output_database, print_details)

	u_print("Dimension Tables Created")

	process_end_time = datetime.datetime.now()
	u_print('Time Taken: '+str(process_end_time - process_start_time))

	u_print("###########################")	
		
