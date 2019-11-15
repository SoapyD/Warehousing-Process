

def setup_warehouse2(output_database):
	u_print('########################################')
	u_print('RUNNING WAREHOUSE SETUP')
	u_print('########################################')

	"""
	THE WAREHOUSE SETUP USES THE BASE TABLES IN THE INITIAL DATABASE TO FORMAT THE INITIAL TABLES THAT'LL
	BE UPDATED HEREAFTER
	"""
	project = 'incident2'

	print_internal = True
	print_details = True


	start_time = datetime.datetime.now() #need for process time u_printing

	output_db = 1 #REPORTING DATABASE

	source_db = 1 #REPORTING DATABASE
	source_database = 'LF-SQL-RPT01'


	u_print("Running Incident v2 Setup Method")
	u_print("")

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
	################################CREATE A COMBINED DATA TABLE
	###################################################################################
	
	
	u_print("Starting Combined Incident Table Process")
	#DELETE THE COMBINED TABLE
	drop_sql = "DROP TABLE TEMP_incident_combined"
	query_database2('Drop Incident Combined Table',drop_sql, output_db, output_database, 
		print_details=print_details, ignore_errors=True)

	sql = get_sql_query('_CREATE_temp_incident_combined', "sql/"+project+"/")
	query_database2('Creating Temp Table', sql, output_db, output_database, print_details=print_details)
	

	#BUILD THE COMBINED TABLE
	sql_queries = [
		"heatsm_incident",
		"heatsm_request",

		"enwl_incident",
		"enwl_request",

		"he_incident",
		"he_request",
		
		"fsa_incident",
		"fsa_request",
		
		"mhclg_incident",
		"mhclg_request",
		
		"croydon_incident",
		"croydon_request",		
	]

	for query in sql_queries:
		process_start_time = datetime.datetime.now()

		sql = get_sql_query(query, "sql/"+project+"/")
		u_print("PROCESSING: "+query)
		query_database2('Run Query: '+query,sql, output_db, output_database, print_details=print_details)

		process_end_time = datetime.datetime.now()
		u_print('Time Taken: '+str(process_end_time - process_start_time))

	u_print("Combined Incident Table Created")
	u_print("###########################")	
	

	###################################################################################
	################################SETUP LOOKUP TABLES
	###################################################################################
	
	
	u_print("Starting Dimension Tables process")
	process_start_time = datetime.datetime.now()

	dimension_table_list = [
		['company',"ISNULL(company,'')",'TEMP_incident_combined',"company"],
	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	create_dimension_tables_2(output_db, output_database, dimension_table_list, print_details)
	
	#CREATE THE TOP ORGS TABLE

	#NOW WE NEED TO POPULATE THE DATE TABLE, WHICH SHOULD COVER EVERY DAY FOR THE NEXT FEW YEARS
	create_date_table(output_db, output_database, print_details)

	u_print("Dimension Tables Created")

	process_end_time = datetime.datetime.now()
	u_print('Time Taken: '+str(process_end_time - process_start_time))

	u_print("###########################")	
		

	###################################################################################
	################################SETUP DETAILS TABLE
	###################################################################################
	""""""

	
	u_print("Starting Details Table process")
	process_start_time = datetime.datetime.now()

	
	#TABLE DROPPED IN THE MAIN SCRIPT
	#drop_sql = "DROP TABLE DETAIL_incident"
	#query_database2('Drop Detail Table', drop_sql, 
	#	output_db, output_database, print_details=print_details, ignore_errors=True)		

	#CREATE THE INCIDENT TABLE
	sql = get_sql_query('_CREATE_incident_detail', "sql/"+project+"/")
	query_database2('Creating Main Incident Detail Table', sql, 
		output_db, output_database, print_details=print_details)	
	
	#POPULATE THE TABLE
	sql = get_sql_query('_MAIN_incident_detail', "sql/"+project+"/")
	query_database2('Producing Main Incident Detail Table', sql, 
		output_db, output_database, print_details=print_details)	

	u_print("Details Table Created")
	process_end_time = datetime.datetime.now()
	u_print('Time Taken: '+str(process_end_time - process_start_time))	
	u_print("###########################")	

	###################################################################################
	################################CREATE THE INDEX
	###################################################################################

	"""
	u_print("Starting Details Index process")
	process_start_time = datetime.datetime.now()

	sql = get_sql_query('_MAIN_incident_detail_IDX', "sql/"+project+"/")
	query_database2('Producing Main Incident Detail index', sql, output_db, output_database, print_details=print_details)	

	u_print("Details Index Created")
	process_end_time = datetime.datetime.now()
	u_print('Time Taken: '+str(process_end_time - process_start_time))	
	u_print("###########################")	
	"""


	
	finish_time = datetime.datetime.now()
	u_print('')
	u_print('########################################')
	u_print('PROCESS COMPLETE')

	u_print('Number of Errors: '+str(error_count))
	u_print('Start: '+str(start_time))
	u_print('End: '+str(finish_time))
	u_print('Time Taken: '+str(finish_time - start_time))
	u_print('########################################')
	"""
	#save_process(start_time, finish_time, str(finish_time - start_time), "Web-Service-Reader", 'hourly')
	"""