

def update_warehouse_lflive2(table_name, temporary_table_name, wh_query, wh_combined_table, delete_staging,
	print_internal=False, print_details=False):

	run = True
	if run == True:
		run_update_warehouse_lflive2(table_name, temporary_table_name, wh_query, wh_combined_table, delete_staging,
		print_internal, print_details)
	else:
		u_print("WARNING: Warehousing turned off")


def run_update_warehouse_lflive2(table_name, temporary_table_name, wh_query, wh_combined_table, delete_staging,
	print_internal=False, print_details=False):
	
	if print_details == True:
		u_print('########################################')
		
	u_print('RUNNING WAREHOUSE UPDATE')
	
	if print_details == True:
		u_print('########################################')

	"""
	THE WAREHOUSE SETUP USES THE BASE TABLES IN THE INITIAL DATABASE TO FORMAT THE INITIAL TABLES THAT'LL
	BE UPDATED HEREAFTER
	"""
	u_print("Running LFLive v2 Update Method")
	u_print("")

	project_name = 'lflive2'

	start_time = datetime.datetime.now() #need for process time u_printing

	###################################################################################
	################################SETUP EXTERNAL TABLES
	###################################################################################

	#FIRST CREATE THE CREDENTIALS AND EXTERNAL TABLES WE'LL BE PULLING DATA FROM

	
	source_db = 1 #REPORTING DATABASE
	source_database = 'LF-SQL-RPT01'
	output_db = 3 #WAREHOUSE DATABASE
	#output_database = 'LF-SQL-WH'
	output_database = 'LF-SQL-DEV'
	
	table_list = [temporary_table_name]
	#THEN CONNECT TO THE TEMPORARY TABLES WE'VE JUST PULLED FROM
	setup_external_tables(source_db, source_database, output_db, output_database, 
		table_list, create_credential=False, print_details=print_details)		

	type = ''
	replace_name = ''
	if wh_query == 'lfliveextract_session':
		type = 'session'
		replace_name = 'LFLIVEEXTRACT_session '

	if wh_query == 'lfliveextract_nps':
		type = 'nps'
		replace_name = 'LFLIVEEXTRACT_completedsurvey '

	###################################################################################
	################################CREATE A COMBINED DATA TABLE
	###################################################################################
	
	if print_details == True:
		u_print("Starting Combined "+type+" Table Process")
	

	#BUILD THE COMBINED TABLE
	sql_queries = [wh_query]

	for query in sql_queries:
		process_start_time = datetime.datetime.now()

		sql = get_sql_query(query, warehousing_path+"/sql/"+project_name+"/")
		
		#replace table name with temporary field name

		#sql = sql.lower() #MAKE THE SQL LOWER CASE IN CASE ANY UPPER CASES HAVE SNUCK THROUGH
		#sql = sql.replace(table_name.lower()+" ", temporary_table_name+" ") #REPLACE THE USUAL TABLE WITH WITH THE TEMPORARY WAREHOUSE NAME
		sql = sql.replace('TEMP_'+type, wh_combined_table) #REPLACE THE COMBINED TABLE NAME WITH THE TEMP WH COMBINED NAME	
		sql = sql.replace(replace_name, temporary_table_name+" ")

		if print_details == True:
			u_print("PROCESSING: "+query)
		
		#print(sql)
		query_database2('Run Query: '+query,sql, output_db, output_database, print_details=print_details)

		process_end_time = datetime.datetime.now()
		
		if print_details == True:
			u_print('Time Taken: '+str(process_end_time - process_start_time))

	if print_details == True:
		u_print("Combined LFLive Table Created")
		u_print("###########################")	

	###################################################################################
	################################UPDATE LOOKUP TABLES
	###################################################################################

	
	###################################################################################
	################################UPDATE AND INSERT TO DETAILS TABLE
	###################################################################################

	#UPDATE RECORDS
	sql = get_sql_query("_MAIN_"+type+"_detail_UPDATE", warehousing_path+"/sql/"+project_name+"/")	
	sql = sql.replace('TEMP_'+type, wh_combined_table) #REPLACE THE COMBINED TABLE NAME WITH THE TEMP WH COMBINED NAME			
	query_database2('UPDATE RECORDS',sql, output_db, output_database, print_details=print_details)

	#INSERT RECORDS
	sql = get_sql_query("_MAIN_"+type+"_detail_INSERT", warehousing_path+"/sql/"+project_name+"/")	
	sql = sql.replace('TEMP_'+type, wh_combined_table) #REPLACE THE COMBINED TABLE NAME WITH THE TEMP WH COMBINED NAME			
	query_database2('INSERT RECORDS',sql, output_db, output_database, print_details=print_details)

	#UPDATE DUPLICATE CHECK NUMBER
	sql = get_sql_query("_MAIN_"+type+"_detail_UPDATE_DUPLICATES", warehousing_path+"/sql/"+project_name+"/")	
	sql = sql.replace('TEMP_'+type, wh_combined_table) #REPLACE THE COMBINED TABLE NAME WITH THE TEMP WH COMBINED NAME	
	#print(sql)		
	query_database2('UPDATE DUPLICATE CHECK',sql, output_db, output_database, print_details=print_details)


	###################################################################################
	################################CLEANUP
	###################################################################################

	drop_sql = "DROP EXTERNAL TABLE "+temporary_table_name
	query_database2('drop External Table '+temporary_table_name,drop_sql, 
		output_db, output_database, print_details=print_details, ignore_errors=True)	

	if delete_staging == True:
		drop_sql = "DROP TABLE "+wh_combined_table
		query_database2('drop Table '+wh_combined_table,drop_sql, 
			output_db, output_database, print_details=print_details, ignore_errors=True)
	
	""""""

	if print_internal == True:
		u_print("Warehousing Complete")
		end_time = datetime.datetime.now() #need for process time u_printing
		u_print('Time Taken: '+str(end_time - start_time))