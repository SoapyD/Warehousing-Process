
import os
path = os.getcwd() #get the current path
string_pos = path.index('Python') #find the python folder
base_path = path[:string_pos]+'Python\\' #create a base filepath string
exec(open(base_path+"Functions\\functions.py").read()) #load the master password file

this_dir = base_path+"Warehousing-Process\\"

exec(open(this_dir+"setup_external_tables.py").read())
exec(open(this_dir+"setup_dimension_tables.py").read())
exec(open(this_dir+"setup_warehouse.py").read())

global error_count


#setup_warehouse()
def update_warehouse(table_name, temporary_table_name, wh_query, wh_combined_table,
	print_internal=False, print_details=False):
	
	if print_details == True:
		u_print('########################################')
		u_print('RUNNING WAREHOUSE UPDATE')
		u_print('########################################')

	"""
	THE WAREHOUSE SETUP USES THE BASE TABLES IN THE INITIAL DATABASE TO FORMAT THE INITIAL TABLES THAT'LL
	BE UPDATED HEREAFTER
	"""

	#print_internal = True
	#print_details = True


	start_time = datetime.datetime.now() #need for process time u_printing

	###################################################################################
	################################SETUP EXTERNAL TABLES
	###################################################################################

	#FIRST CREATE THE CREDENTIALS AND EXTERNAL TABLES WE'LL BE PULLING DATA FROM

	
	output_db = 1 #REPORTING DATABASE
	output_database = 'LF-SQL-WH'
	source_db = 1 #REPORTING DATABASE
	source_database = 'LF-SQL-RPT01'
	
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

	sql = get_sql_query('_CREATE_temp_incident_combined', warehousing_path+"/sql/")
	sql = sql.lower() #MAKE THE SQL LOWER CASE IN CASE ANY UPPER CASES HAVE SNUCK THROUGH
	sql = sql.replace('temp_incident_combined', wh_combined_table) #REPLACE THE COMBINED TABLE NAME WITH THE TEMP WH COMBINED NAME	
	query_database2('Creating Temp Table', sql, output_db, output_database, print_details=print_details)
	

	#BUILD THE COMBINED TABLE
	sql_queries = [wh_query]

	for query in sql_queries:
		process_start_time = datetime.datetime.now()

		sql = get_sql_query(query, warehousing_path+"/sql/")
		
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
		['status',"status",wh_combined_table],
		['source',"source",wh_combined_table],
		['company',"company", wh_combined_table],
		['typeofincident',"typeofincident", wh_combined_table],
		['ownerteam',"ownerteam", wh_combined_table],
		['system',"system", wh_combined_table],
		['businessunit',"businessunit", wh_combined_table],
		['causecode',"causecode", wh_combined_table],
		['service',"service", wh_combined_table],
		['category',"category", wh_combined_table],
		['subcategory',"subcategory", wh_combined_table],
	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	update_dimension_tables(output_db, output_database, dimension_table_list, print_details)
	
	if print_details == True:
		u_print("Dimension Tables Updated")

	process_end_time = datetime.datetime.now()

	if print_details == True:
		u_print('Time Taken: '+str(process_end_time - process_start_time))
		u_print("###########################")	

	###################################################################################
	################################UPDATE AND INSERT TO DETAILS TABLE
	###################################################################################

	sql = get_sql_query("_MAIN_incident_detail_UPDATE", warehousing_path+"/sql/")	
	sql = sql.lower()
	sql = sql.replace('temp_incident_combined', wh_combined_table) #REPLACE THE COMBINED TABLE NAME WITH THE TEMP WH COMBINED NAME			
	query_database2('UPDATE RECORDS',sql, output_db, output_database, print_details=print_details)

	sql = get_sql_query("_MAIN_incident_detail_INSERT", warehousing_path+"/sql/")	
	sql = sql.lower()
	sql = sql.replace('temp_incident_combined', wh_combined_table) #REPLACE THE COMBINED TABLE NAME WITH THE TEMP WH COMBINED NAME			
	query_database2('INSERT RECORDS',sql, output_db, output_database, print_details=print_details)


	###################################################################################
	################################CLEANUP
	###################################################################################

	drop_sql = "DROP EXTERNAL TABLE "+temporary_table_name
	query_database2('drop External Table '+temporary_table_name,drop_sql, 
		output_db, output_database, print_details=print_details, ignore_errors=True)	

	drop_sql = "DROP TABLE "+wh_combined_table
	query_database2('drop Table '+wh_combined_table,drop_sql, 
		output_db, output_database, print_details=print_details, ignore_errors=True)


	if print_internal == True:
		u_print("Warehousing Complete")
		end_time = datetime.datetime.now() #need for process time u_printing
		u_print('Time Taken: '+str(end_time - start_time))