

def update_warehouse_data_tables2(print_internal=False, print_details=False):
	if print_details == True:
		u_print('########################################')
		
	u_print('RUNNING WAREHOUSE DATA TABLES UPDATE')

	if print_details == True:
		u_print('########################################')
		

	"""
	THE WAREHOUSE SETUP USES THE BASE TABLES IN THE INITIAL DATABASE TO FORMAT THE INITIAL TABLES THAT'LL
	BE UPDATED HEREAFTER
	"""
	project = 'data_tables2'

	#print_internal = True
	#print_details = True


	start_time = datetime.datetime.now() #need for process time u_printing


	source_db = 1 #REPORTING DATABASE
	source_database = 'LF-SQL-RPT01'
	output_db = 3 #WAREHOUSE DATABASE
	output_database = 'LF-SQL-WH'


	u_print("Running Data Table v2 Setup Method")
	u_print("")

	""""""
	###################################################################################
	################################SETUP EXTERNAL TABLES
	###################################################################################

	#FIRST CREATE THE CREDENTIALS AND EXTERNAL TABLES WE'LL BE PULLING DATA FROM
	

	table_list = [
		"HEATSM_organizationalunit",
		"DDI_Link",										
	]

	setup_external_tables(source_db, source_database, output_db, output_database, 
		table_list, create_credential=False, print_details=print_details)
	

	###################################################################################
	################################UPDATE DETAILS TABLE
	###################################################################################
	""""""

	if print_details == True:	
		u_print("Update Details Table process")
	
	process_start_time = datetime.datetime.now()
		
	
	#POPULATE THE TABLE
	sql = get_sql_query('_CREATE_detail_orgunit', warehousing_path+"/sql/"+project+"/")
	query_database2('Checking Orgunit Detail Table', sql, 
		output_db, output_database, print_details=print_details)	

	sql = get_sql_query('update_detail_table_orgunit', warehousing_path+"/sql/"+project+"/")
	query_database2('Updating Orgunit Detail Table', sql, 
		output_db, output_database, print_details=print_details)	

	if print_details == True:	
		u_print("Detail Tables Updated")
	
	process_end_time = datetime.datetime.now()

	if print_details == True:
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