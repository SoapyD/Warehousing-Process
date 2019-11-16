
def update_warehouse(table_name, temporary_table_name, wh_query, wh_combined_table, delete_staging,
	print_internal=False, print_details=False):

	run = True
	if run == True:
		run_update_warehouse(table_name, temporary_table_name, wh_query, wh_combined_table, delete_staging,
		print_internal, print_details)
	else:
		u_print("WARNING: Warehousing turned off")

def run_update_warehouse(table_name, temporary_table_name, wh_query, wh_combined_table, delete_staging,
	print_internal=False, print_details=False):
	
	if print_details == True:
		u_print('########################################')
		
	u_print('RUNNING WAREHOUSE UPDATE')
	
	if print_details == True:
		u_print('########################################')

	project = 'incident'

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
	output_database = 'LF-SQL-WH'
	
	table_list = [temporary_table_name]
	#THEN CONNECT TO THE TEMPORARY TABLES WE'VE JUST PULLED FROM
	setup_external_tables(source_db, source_database, output_db, output_database, 
		table_list, create_credential=False, print_details=print_details)		


	###################################################################################
	################################CREATE A COMBINED DATA TABLE
	###################################################################################
	
	if print_details == True:
		u_print("Starting Combined Incident Table Process")
	
	#DELETE THE COMBINED TABLE
	drop_sql = "DROP TABLE "+wh_combined_table
	query_database2('Drop Incident Combined Table',drop_sql, output_db, output_database, print_details=print_details, ignore_errors=True)

	sql = get_sql_query('_CREATE_temp_incident_combined', warehousing_path+"/sql/"+project+"/")
	sql = sql.lower() #MAKE THE SQL LOWER CASE IN CASE ANY UPPER CASES HAVE SNUCK THROUGH
	sql = sql.replace('temp_incident_combined', wh_combined_table) #REPLACE THE COMBINED TABLE NAME WITH THE TEMP WH COMBINED NAME	
	query_database2('Creating Temp Table', sql, output_db, output_database, print_details=print_details)
	

	#BUILD THE COMBINED TABLE
	sql_queries = [wh_query]

	for query in sql_queries:
		process_start_time = datetime.datetime.now()

		sql = get_sql_query(query, warehousing_path+"/sql/"+project+"/")
		
		#replace table name with temporary field name

		sql = sql.lower() #MAKE THE SQL LOWER CASE IN CASE ANY UPPER CASES HAVE SNUCK THROUGH
		sql = sql.replace(table_name.lower()+" ", temporary_table_name+" ") #REPLACE THE USUAL TABLE WITH WITH THE TEMPORARY WAREHOUSE NAME
		sql = sql.replace('temp_incident_combined', wh_combined_table) #REPLACE THE COMBINED TABLE NAME WITH THE TEMP WH COMBINED NAME

		if print_details == True:
			u_print("PROCESSING: "+query)
		
		#print(sql)
		query_database2('Run Query: '+query,sql, output_db, output_database, print_details=print_details)

		process_end_time = datetime.datetime.now()
		
		if print_details == True:
			u_print('Time Taken: '+str(process_end_time - process_start_time))

	if print_details == True:
		u_print("Combined Incident Table Created")
		u_print("###########################")	

	###################################################################################
	################################UPDATE LOOKUP TABLES
	###################################################################################
	
	if print_details == True:
		u_print("Starting Dimension Tables process")
	
	process_start_time = datetime.datetime.now()

	dimension_table_list = [
		['status',"ISNULL(status,'')",wh_combined_table,"status"],
		['source',"ISNULL(source,'')",wh_combined_table,"source"],
		['company',"ISNULL(company,'')", wh_combined_table,"company"],
		['typeofincident',"ISNULL(typeofincident,'')", wh_combined_table,"typeofincident"],
		['ownerteam',"ISNULL(ownerteam,'')", wh_combined_table,"ownerteam"],
		['system',"ISNULL(system,'')", wh_combined_table,"system"],
		['businessunit',"ISNULL(businessunit,'')", wh_combined_table,"businessunit"],
		['location',"ISNULL(location,'')", wh_combined_table,"location"],
		['causecode',"ISNULL(causecode,'')", wh_combined_table,"causecode"],
		['service',"ISNULL(service,'')", wh_combined_table,"service"],
		['category',"ISNULL(category,'')", wh_combined_table,"category"],
		['subcategory',"ISNULL(subcategory,'')", wh_combined_table,"subcategory"],
	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	update_dimension_tables_2(output_db, output_database, dimension_table_list, print_details)
	

	field_string = """
CASE
WHEN ISNUMERIC(left(@owner,1)) = 1 THEN ''
WHEN CHARINDEX('@', @owner) > 0 THEN ISNULL(LOWER(LEFT(REPLACE(@owner,'.',' '), CHARINDEX('@', @owner) - 1)),'')
ELSE ISNULL(LOWER(REPLACE(@owner,'.',' ')),'')
END"""
	
	#WE THEN HAVE TO RUN THE ABOVE FOR ALL RESOLVER BASED FIELDS, UPDATING THE SAME LOOKUP_OWNER FIELD
	dimension_table_list = [
		['owner',field_string.replace("@owner", 'i.owner'),wh_combined_table,'owner'],
		['owner',field_string.replace("@owner", 'i.createdby'),wh_combined_table,'owner'],
		['owner',field_string.replace("@owner", 'ISNULL(i.resolvedby,i.closedby)'),wh_combined_table,'owner'],
		['owner',field_string.replace("@owner", 'i.closedby'),wh_combined_table,'owner'],
		['owner',field_string.replace("@owner", 'i.lastmodby'),wh_combined_table,'owner'],
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

	sql = get_sql_query("_MAIN_incident_detail_UPDATE", warehousing_path+"/sql/"+project+"/")	
	sql = sql.lower()
	sql = sql.replace('temp_incident_combined', wh_combined_table) #REPLACE THE COMBINED TABLE NAME WITH THE TEMP WH COMBINED NAME			
	query_database2('UPDATE RECORDS',sql, output_db, output_database, print_details=print_details)

	sql = get_sql_query("_MAIN_incident_detail_INSERT", warehousing_path+"/sql/"+project+"/")	
	sql = sql.lower()
	sql = sql.replace('temp_incident_combined', wh_combined_table) #REPLACE THE COMBINED TABLE NAME WITH THE TEMP WH COMBINED NAME			
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