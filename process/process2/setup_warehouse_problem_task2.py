

def setup_warehouse_problem_task2(output_database):
	u_print('########################################')
	u_print('RUNNING WAREHOUSE SETUP')
	u_print('########################################')

	"""
	THE WAREHOUSE SETUP USES THE BASE TABLES IN THE INITIAL DATABASE TO FORMAT THE INITIAL TABLES THAT'LL
	BE UPDATED HEREAFTER
	"""
	project = 'problem_task2'

	print_internal = True
	print_details = True


	start_time = datetime.datetime.now() #need for process time u_printing

	output_db = 1 #REPORTING DATABASE

	source_db = 1 #REPORTING DATABASE
	source_database = 'LF-SQL-RPT01'


	u_print("Running Problem Task v2 Setup Method")
	u_print("")

	""""""
	###################################################################################
	################################SETUP EXTERNAL TABLES
	###################################################################################

	#FIRST CREATE THE CREDENTIALS AND EXTERNAL TABLES WE'LL BE PULLING DATA FROM
	

	table_list = [
		"heatsm_task",
		"heatsm_problem",

		"enwl_task",
		"enwl_problem",

		"he_problem",
		"he_problem_task",

		"fsa_problem",	
		"fsa_problem_task",

		"mhclg_problem",	
		"mhclg_problem_task",

		"croydon_problem",
		"croydon_problem_task",		
	]

	setup_external_tables(source_db, source_database, output_db, output_database, 
		table_list, create_credential=False, print_details=print_details)
	

	###################################################################################
	################################CREATE A COMBINED DATA TABLE
	###################################################################################
	
	
	u_print("Starting Combined Problem Task Table Process")
	#DELETE THE COMBINED TABLE
	drop_sql = "DROP TABLE TEMP_problem_task_combined"
	query_database2('Drop Problem Task Combined Table',drop_sql, output_db, output_database, 
		print_details=print_details, ignore_errors=True)

	sql = get_sql_query('_CREATE_temp_problem_task_combined', "sql/"+project+"/")
	query_database2('Creating Temp Table', sql, output_db, output_database, print_details=print_details)
	

	#BUILD THE COMBINED TABLE
	sql_queries = [
		"heatsm_problem_task",

		#"enwl_problem_task",

		"he_problem_task",
		
		"fsa_problem_task",
		
		"mhclg_problem_task",
		
		"croydon_problem_task",		
	]

	for query in sql_queries:
		process_start_time = datetime.datetime.now()

		sql = get_sql_query(query, "sql/"+project+"/")
		u_print("PROCESSING: "+query)
		query_database2('Run Query: '+query,sql, output_db, output_database, print_details=print_details)

		process_end_time = datetime.datetime.now()
		u_print('Time Taken: '+str(process_end_time - process_start_time))

	u_print("Combined Problem Task Table Created")
	u_print("###########################")	
	

	###################################################################################
	################################SETUP LOOKUP TABLES
	###################################################################################
	
	"""
	u_print("Starting Dimension Tables process")
	process_start_time = datetime.datetime.now()

	dimension_table_list = [
		['company',"ISNULL(company,'')", 'TEMP_problem_task_combined',"company"],
	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	update_dimension_tables_2(output_db, output_database, dimension_table_list, print_details)

	u_print("Dimension Tables Created")

	process_end_time = datetime.datetime.now()
	u_print('Time Taken: '+str(process_end_time - process_start_time))

	u_print("###########################")	
	"""

	###################################################################################
	################################SETUP DETAILS TABLE
	###################################################################################
	""""""

	
	u_print("Starting Details Table process")
	process_start_time = datetime.datetime.now()
		

	#CREATE THE INCIDENT TABLE
	sql = get_sql_query('_CREATE_problem_task_detail', "sql/"+project+"/")
	query_database2('Creating Main Problem Task Detail Table', sql, 
		output_db, output_database, print_details=print_details)	
	
	#POPULATE THE TABLE
	sql = get_sql_query('_MAIN_problem_task_detail', "sql/"+project+"/")
	query_database2('Producing Main Problem Task Detail Table', sql, 
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