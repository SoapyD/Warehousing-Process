

def setup_warehouse():
	u_print('########################################')
	u_print('RUNNING WAREHOUSE SETUP')
	u_print('########################################')

	"""
	THE WAREHOUSE SETUP USES THE BASE TABLES IN THE INITIAL DATABASE TO FORMAT THE INITIAL TABLES THAT'LL
	BE UPDATED HEREAFTER
	"""

	print_internal = True
	print_details = False


	start_time = datetime.datetime.now() #need for process time u_printing

	###################################################################################
	################################SETUP EXTERNAL TABLES
	###################################################################################

	#FIRST CREATE THE CREDENTIALS AND EXTERNAL TABLES WE'LL BE PULLING DATA FROM

	
	output_db = 1 #REPORTING DATABASE
	output_database = 'LF-SQL-WH'
	source_db = 1 #REPORTING DATABASE
	source_database = 'LF-SQL-RPT01'
	
	
	table_list = [
		"heatsm_incident",
		"heatsm_employee",
		"heatsm_servicereq",
		"heatsm_task",

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
		table_list, create_credential=True, print_details=print_details)
	

	###################################################################################
	################################CREATE A COMBINED DATA TABLE
	###################################################################################
	
	
	u_print("Starting Combined Incident Table Process")
	#DELETE THE COMBINED TABLE
	drop_sql = "DROP TABLE TEMP_incident_combined"
	query_database2('Drop Incident Combined Table',drop_sql, output_db, output_database, 
		print_details=print_details, ignore_errors=True)

	sql = get_sql_query('_CREATE_temp_incident_combined', "sql/")
	query_database2('Creating Temp Table', sql, output_db, output_database, print_details=print_details)
	

	#BUILD THE COMBINED TABLE
	sql_queries = [
		"heatsm_incident",
		"he_incident",
		"fsa_incident",
		"mhclg_incident",
		"croydon_incident",
		"heatsm_request",
		"he_request",
		"fsa_request",
		"mhclg_request",
		"croydon_request",		
	]

	for query in sql_queries:
		process_start_time = datetime.datetime.now()

		sql = get_sql_query(query, "sql/")
		u_print("PROCESSING: "+query)
		query_database2('Run Query: '+query,sql, output_db, output_database, print_details=print_details)

		process_end_time = datetime.datetime.now()
		u_print('Time Taken: '+str(process_end_time - process_start_time))

	u_print("Combined Incident Table Created")
	u_print("###########################")	
	''''''
	
	###################################################################################
	################################SETUP LOOKUP TABLES
	###################################################################################
	
	
	u_print("Starting Dimension Tables process")
	process_start_time = datetime.datetime.now()

	dimension_table_list = [
		['status',"status",'TEMP_incident_combined'],
		['source',"source",'TEMP_incident_combined'],
		['company',"company",'TEMP_incident_combined'],
		['typeofincident',"typeofincident",'TEMP_incident_combined'],
		['ownerteam',"ownerteam",'TEMP_incident_combined'],
		['system',"system",'TEMP_incident_combined'],
		['businessunit',"businessunit",'TEMP_incident_combined'],
		['location',"location",'TEMP_incident_combined'],
		['causecode',"causecode",'TEMP_incident_combined'],
		['service',"service",'TEMP_incident_combined'],
		['category',"category",'TEMP_incident_combined'],
		['subcategory',"subcategory",'TEMP_incident_combined'],
	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	create_dimension_tables(output_db, output_database, dimension_table_list, print_details)
	
	#POPULATE THE DATE TABLE
	create_date_table(output_db, output_database, print_details)

	u_print("Dimension Tables Created")

	process_end_time = datetime.datetime.now()
	u_print('Time Taken: '+str(process_end_time - process_start_time))

	u_print("###########################")	
	

	###################################################################################
	################################SETUP DETAILS TABLE
	###################################################################################
	
	
	u_print("Starting Details Table process")
	process_start_time = datetime.datetime.now()

	#drop_sql = "DROP TABLE DETAIL_incident"
	#query_database2('Drop Detail Table', drop_sql, 
	#	output_db, output_database, print_details=print_details, ignore_errors=True)		

	sql = get_sql_query('_MAIN_incident_detail', "sql/")
	query_database2('Producing Main Incident Detail Table', sql, 
		output_db, output_database, print_details=print_details)	

	u_print("Details Table Created")
	process_end_time = datetime.datetime.now()
	u_print('Time Taken: '+str(process_end_time - process_start_time))	
	u_print("###########################")	

	u_print("Starting Details Index process")
	process_start_time = datetime.datetime.now()

	sql = get_sql_query('_MAIN_incident_detail_IDX', "sql/")
	query_database2('Producing Main Incident Detail index', sql, output_db, output_database, print_details=print_details)	

	u_print("Details Index Created")
	process_end_time = datetime.datetime.now()
	u_print('Time Taken: '+str(process_end_time - process_start_time))	
	u_print("###########################")	
	

	###################################################################################
	################################SETUP AGGREGATION TABLE
	###################################################################################
	
	"""
	u_print("Starting Aggregation Table process")

	#sql = get_sql_query('_MAIN_incident_aggregation', "sql/")
	#query_database2('Producing Main Incident Aggregation Table', sql, output_db, output_database, print_details=print_details)	

	u_print("Aggregation Table Created")
	u_print("###########################")	

	

	u_print("Starting Aggregation Index process")

	#sql = get_sql_query('_MAIN_incident_aggregation_IDX', "sql/")
	#query_database2('Producing Main Incident Aggregation index', sql, output_db, output_database, print_details=print_details)	

	u_print("Aggregation Index Created")
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