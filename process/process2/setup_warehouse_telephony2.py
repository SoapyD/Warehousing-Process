

def setup_warehouse_telephony2(output_database):
	u_print('########################################')
	u_print('RUNNING WAREHOUSE SETUP')
	u_print('########################################')

	"""
	THE WAREHOUSE SETUP USES THE BASE TABLES IN THE INITIAL DATABASE TO FORMAT THE INITIAL TABLES THAT'LL
	BE UPDATED HEREAFTER
	"""
	project = 'telephony2'

	print_internal = True
	print_details = True


	start_time = datetime.datetime.now() #need for process time u_printing

	output_db = 1 #REPORTING DATABASE

	source_db = 1 #REPORTING DATABASE
	source_database = 'LF-SQL-RPT01'


	u_print("Running Telephony v2 Setup Method")
	u_print("")

	""""""
	###################################################################################
	################################SETUP EXTERNAL TABLES
	###################################################################################

	#FIRST CREATE THE CREDENTIALS AND EXTERNAL TABLES WE'LL BE PULLING DATA FROM
	

	table_list = [
		"TELEPHONYEXTRACT_call",
		"RINGCENTRAL_completedcontacts",
		"RINGCENTRAL_agents",
		"DDI_link"							
	]

	setup_external_tables(source_db, source_database, output_db, output_database, 
		table_list, create_credential=False, print_details=print_details)
	

	###################################################################################
	################################CREATE A COMBINED DATA TABLE
	###################################################################################
	
	
	u_print("Starting Combined Telephony Table Process")
	#DELETE THE COMBINED TABLE
	drop_sql = "DROP TABLE TEMP_telephony_combined"
	query_database2('Drop Telephony Combined Table',drop_sql, output_db, output_database, 
		print_details=print_details, ignore_errors=True)

	sql = get_sql_query('_CREATE_temp_telephony_combined', "sql/"+project+"/")
	query_database2('Creating Temp Table', sql, output_db, output_database, print_details=print_details)
	

	#BUILD THE COMBINED TABLE
	sql_queries = [
		"MYCALLS_telephony",
		"RINGCENTRAL_telephony",	
	]

	for query in sql_queries:
		process_start_time = datetime.datetime.now()

		sql = get_sql_query(query, "sql/"+project+"/")
		u_print("PROCESSING: "+query)
		query_database2('Run Query: '+query,sql, output_db, output_database, print_details=print_details)

		process_end_time = datetime.datetime.now()
		u_print('Time Taken: '+str(process_end_time - process_start_time))

	u_print("Combined Telephony Table Created")
	u_print("###########################")	
	

	###################################################################################
	################################SETUP LOOKUP TABLES
	###################################################################################
	
	
	u_print("Starting Dimension Tables process")
	process_start_time = datetime.datetime.now()

	dimension_table_list = [
		['ddi',"ISNULL(ddi,'')",'TEMP_telephony_combined',"ddi"],
	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	create_dimension_tables_2(output_db, output_database, dimension_table_list, print_details)

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

	#CREATE THE telephony TABLE
	sql = get_sql_query('_CREATE_telephony_detail', "sql/"+project+"/")
	query_database2('Creating Main Telephony Detail Table', sql, 
		output_db, output_database, print_details=print_details)	
	
	#POPULATE THE TABLE
	sql = get_sql_query('_MAIN_telephony_detail', "sql/"+project+"/")
	query_database2('Producing Main Telephony Detail Table', sql, 
		output_db, output_database, print_details=print_details)	

	u_print("Details Table Created")
	process_end_time = datetime.datetime.now()
	u_print('Time Taken: '+str(process_end_time - process_start_time))	
	u_print("###########################")	

	###################################################################################
	################################CREATE THE INDEX
	###################################################################################


	
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