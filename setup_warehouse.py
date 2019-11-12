

def setup_warehouse():
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
	#output_database = 'LF-SQL-DEV'
	source_db = 1 #REPORTING DATABASE
	source_database = 'LF-SQL-RPT01'


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

	sql = get_sql_query('_CREATE_temp_incident_combined', "sql/incident/")
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

		sql = get_sql_query(query, "sql/incident/")
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
		['status',"ISNULL(status,'')",'TEMP_incident_combined',"status"],
		['source',"ISNULL(source,'')",'TEMP_incident_combined',"source"],
		['company',"ISNULL(company,'')",'TEMP_incident_combined',"company"],
		['typeofincident',"ISNULL(typeofincident,'')",'TEMP_incident_combined',"typeofincident"],
		['ownerteam',"ISNULL(ownerteam,'')",'TEMP_incident_combined',"ownerteam"],
		['system',"ISNULL(system,'')",'TEMP_incident_combined',"system"],
		['businessunit',"ISNULL(businessunit,'')",'TEMP_incident_combined',"businessunit"],
		['location',"ISNULL(location,'')",'TEMP_incident_combined',"location"],
		['causecode',"ISNULL(causecode,'')",'TEMP_incident_combined',"causecode"],
		['service',"ISNULL(service,'')",'TEMP_incident_combined',"service"],
		['category',"ISNULL(category,'')",'TEMP_incident_combined',"category"],
		['subcategory',"ISNULL(subcategory,'')",'TEMP_incident_combined',"subcategory"],
	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	create_dimension_tables_2(output_db, output_database, dimension_table_list, print_details)
	

	#NOW WE HAVE TO CREATE THE OWNER DIMENSION TABLE WHICH IS A BIT MORE COMPLICATED

	field_string = """
CASE
WHEN ISNUMERIC(left(@owner,1)) = 1 THEN ''
WHEN CHARINDEX('@', @owner) > 0 THEN ISNULL(LOWER(LEFT(REPLACE(@owner,'.',' '), CHARINDEX('@', @owner) - 1)),'')
ELSE ISNULL(LOWER(REPLACE(@owner,'.',' ')),'')
END"""

	
	dimension_table_list = [
		['owner',field_string.replace("@owner", 'owner'),'TEMP_incident_combined','owner'],
	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	create_dimension_tables_2(output_db, output_database, dimension_table_list, print_details)

	
	#WE THEN HAVE TO RUN THE ABOVE FOR ALL RESOLVER BASED FIELDS, UPDATING THE SAME LOOKUP_OWNER FIELD
	dimension_table_list = [
		['owner',field_string.replace("@owner", 'i.createdby'),'TEMP_incident_combined','owner'],
		['owner',field_string.replace("@owner", 'ISNULL(i.resolvedby,i.closedby)'),'TEMP_incident_combined','owner'],
		['owner',field_string.replace("@owner", 'i.closedby'),'TEMP_incident_combined','owner'],
		['owner',field_string.replace("@owner", 'i.lastmodby'),'TEMP_incident_combined','owner'],
	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	update_dimension_tables_2(output_db, output_database, dimension_table_list, print_details)


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
	drop_sql = "DROP TABLE DETAIL_incident"
	query_database2('Drop Detail Table', drop_sql, 
		output_db, output_database, print_details=print_details, ignore_errors=True)		

	#CREATE THE INCIDENT TABLE
	sql = get_sql_query('_CREATE_incident_detail', "sql/incident/")
	query_database2('Creating Main Incident Detail Table', sql, 
		output_db, output_database, print_details=print_details)	
	

	#POPULATE THE TABLE
	sql = get_sql_query('_MAIN_incident_detail', "sql/incident/")
	query_database2('Producing Main Incident Detail Table', sql, 
		output_db, output_database, print_details=print_details)	

	u_print("Details Table Created")
	process_end_time = datetime.datetime.now()
	u_print('Time Taken: '+str(process_end_time - process_start_time))	
	u_print("###########################")	

	u_print("Starting Details Index process")
	process_start_time = datetime.datetime.now()

	sql = get_sql_query('_MAIN_incident_detail_IDX', "sql/incident/")
	query_database2('Producing Main Incident Detail index', sql, output_db, output_database, print_details=print_details)	

	u_print("Details Index Created")
	process_end_time = datetime.datetime.now()
	u_print('Time Taken: '+str(process_end_time - process_start_time))	
	u_print("###########################")	
	""""""

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