
def update_warehouse_problem2(table_name, temporary_table_name, wh_query, wh_combined_table, delete_staging,
	print_internal=False, print_details=False):

	run = True
	if run == True:
		run_update_warehouse_problem2(table_name, temporary_table_name, wh_query, wh_combined_table, delete_staging,
		print_internal, print_details)
	else:
		u_print("WARNING: Warehousing turned off")

def run_update_warehouse_problem2(table_name, temporary_table_name, wh_query, wh_combined_table, delete_staging,
	print_internal=False, print_details=False):
	
	if print_details == True:
		u_print('########################################')
		
	u_print('RUNNING WAREHOUSE UPDATE')
	
	if print_details == True:
		u_print('########################################')


	u_print("Running Problem v2 Update Method")
	u_print("")

	project = 'problem2'

	"""
	THE WAREHOUSE SETUP USES THE BASE TABLES IN THE INITIAL DATABASE TO FORMAT THE INITIAL TABLES THAT'LL
	BE UPDATED HEREAFTER
	"""


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


	###################################################################################
	################################CREATE A COMBINED DATA TABLE
	###################################################################################
	
	if print_details == True:
		u_print("Starting Combined Problem Table Process")
	
	#DELETE THE COMBINED TABLE
	drop_sql = "DROP TABLE "+wh_combined_table
	query_database2('Drop Problem Combined Table',drop_sql, output_db, output_database, print_details=print_details, ignore_errors=True)

	sql = get_sql_query('_CREATE_temp_problem_combined', warehousing_path+"/sql/"+project+"/")
	sql = sql.lower() #MAKE THE SQL LOWER CASE IN CASE ANY UPPER CASES HAVE SNUCK THROUGH
	sql = sql.replace('temp_problem_combined', wh_combined_table) #REPLACE THE COMBINED TABLE NAME WITH THE TEMP WH COMBINED NAME	
	query_database2('Creating Temp Table', sql, output_db, output_database, print_details=print_details)
	

	#BUILD THE COMBINED TABLE
	sql_queries = [wh_query]

	for query in sql_queries:
		process_start_time = datetime.datetime.now()

		sql = get_sql_query(query, warehousing_path+"/sql/"+project+"/")
		
		#replace table name with temporary field name

		sql = sql.lower() #MAKE THE SQL LOWER CASE IN CASE ANY UPPER CASES HAVE SNUCK THROUGH
		sql = sql.replace(table_name.lower()+" ", temporary_table_name+" ") #REPLACE THE USUAL TABLE WITH WITH THE TEMPORARY WAREHOUSE NAME
		sql = sql.replace('temp_problem_combined', wh_combined_table) #REPLACE THE COMBINED TABLE NAME WITH THE TEMP WH COMBINED NAME

		if print_details == True:
			u_print("PROCESSING: "+query)
		
		#print(sql)
		query_database2('Run Query: '+query,sql, output_db, output_database, print_details=print_details)

		process_end_time = datetime.datetime.now()
		
		if print_details == True:
			u_print('Time Taken: '+str(process_end_time - process_start_time))

	if print_details == True:
		u_print("Combined Problem Table Created")
		u_print("###########################")	

	###################################################################################
	################################UPDATE LOOKUP TABLES
	###################################################################################
	
	if print_details == True:
		u_print("Starting Dimension Tables process")
	
	process_start_time = datetime.datetime.now()

	dimension_table_list = [
		['company',"ISNULL(company,'')", wh_combined_table,"company"],
	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	update_dimension_tables_2(output_db, output_database, dimension_table_list, print_details)

	if print_details == True:
		u_print("Dimension Tables Updated")

	process_end_time = datetime.datetime.now()

	if print_details == True:
		u_print('Time Taken: '+str(process_end_time - process_start_time))
		u_print("###########################")	

	###################################################################################
	################################UPDATE AND INSERT TO DETAILS TABLE
	###################################################################################

	sql = get_sql_query("_MAIN_problem_detail_UPDATE", warehousing_path+"/sql/"+project+"/")	
	sql = sql.lower()
	sql = sql.replace('temp_problem_combined', wh_combined_table) #REPLACE THE COMBINED TABLE NAME WITH THE TEMP WH COMBINED NAME			
	query_database2('UPDATE RECORDS',sql, output_db, output_database, print_details=print_details)

	sql = get_sql_query("_MAIN_problem_detail_INSERT", warehousing_path+"/sql/"+project+"/")	
	sql = sql.lower()
	sql = sql.replace('temp_problem_combined', wh_combined_table) #REPLACE THE COMBINED TABLE NAME WITH THE TEMP WH COMBINED NAME			
	query_database2('INSERT RECORDS',sql, output_db, output_database, print_details=print_details)


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


	if print_internal == True:
		u_print("Warehousing Complete")
		end_time = datetime.datetime.now() #need for process time u_printing
		u_print('Time Taken: '+str(end_time - start_time))