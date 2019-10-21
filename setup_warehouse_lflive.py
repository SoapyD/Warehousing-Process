#import os
#exec(open("_main.py").read())


def setup_warehouse_lflive():
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


	###################################################################################
	################################SETUP EXTERNAL TABLES
	###################################################################################

	#FIRST CREATE THE CREDENTIALS AND EXTERNAL TABLES WE'LL BE PULLING DATA FROM
	

	table_list = [
		'lfliveextract_session',
		'lfliveextract_sessionincident',
		'lfliveextract_he_sessionincident',
		'lfliveextract_fsa_sessionincident',
		'lfliveextract_mhclg_sessionincident',
		'lfliveextract_croydon_sessionincident',
		'lfliveextract_enwl_sessionincident',
		'lfliveextract_sessionpostback',
		'lfliveextract_completedsurvey',
		'lfliveextract_completedsurveyresponse',
		'lfliveextract_answers'
	]

	setup_external_tables(source_db, source_database, output_db, output_database, 
		table_list, create_credential=False, print_details=print_details)	

	
	###################################################################################
	################################CREATE A COMBINED DATA TABLE
	###################################################################################

	#BUILD THE COMBINED TABLE
	sql_queries = [
		"lfliveextract_session",
		"lfliveextract_nps",
	]

	for query in sql_queries:
		process_start_time = datetime.datetime.now()

		sql = get_sql_query(query, "sql/lflive/")
		u_print("PROCESSING: "+query)
		query_database2('Run Query: '+query,sql, output_db, output_database, print_details=print_details)

		process_end_time = datetime.datetime.now()
		u_print('Time Taken: '+str(process_end_time - process_start_time))

		u_print("TEMP Table Created")
		process_end_time = datetime.datetime.now()
		u_print('Time Taken: '+str(process_end_time - process_start_time))	
		u_print("###########################")	

	###################################################################################
	################################SETUP DETAILS TABLE
	###################################################################################
	
		
	#BUILD THE COMBINED TABLE
	sql_queries = [
		"_MAIN_session_detail",
		"_MAIN_nps_detail",
	]

	for query in sql_queries:	
		u_print("Starting Detail_Session Table process")
		process_start_time = datetime.datetime.now()		

		sql = get_sql_query(query, "sql/lflive/")
		query_database2('Running Query: '+query, sql, 
			output_db, output_database, print_details=print_details)	

		u_print("Details Table Created")
		process_end_time = datetime.datetime.now()
		u_print('Time Taken: '+str(process_end_time - process_start_time))	
		u_print("###########################")	


		u_print("Starting Details Index process")
		process_start_time = datetime.datetime.now()

		sql = get_sql_query(query+'_IDX', "sql/lflive/")
		query_database2('Producing Detail index', sql, output_db, output_database, print_details=print_details)	

		u_print("Details Index Created")
		process_end_time = datetime.datetime.now()
		u_print('Time Taken: '+str(process_end_time - process_start_time))	
		u_print("###########################")	


	
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