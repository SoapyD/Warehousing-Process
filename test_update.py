import os

exec(open("_main.py").read())


def run_test():
	print_internal = True
	print_details = True

	output_db = 1 #REPORTING DATABASE
	output_database = 'LF-SQL-WH'
	source_db = 1 #REPORTING DATABASE
	source_database = 'LF-SQL-RPT01'


	field_string = """
CASE
WHEN ISNUMERIC(left(@owner,1)) = 1 THEN ''
WHEN CHARINDEX('@', @owner) > 0 THEN LOWER(LEFT(REPLACE(@owner,'.',' '), CHARINDEX('@', @owner) - 1))
ELSE ISNULL(LOWER(REPLACE(@owner,'.',' ')),'')
END"""


	dimension_table_list = [
		['owner',field_string.replace("@owner", 'owner'),'TEMP_incident_combined','owner'],
	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	create_dimension_tables_2(output_db, output_database, dimension_table_list, print_details)

	dimension_table_list = [

		['owner',field_string.replace("@owner", 'i.createdby'),'TEMP_incident_combined','owner'],
		['owner',field_string.replace("@owner", 'ISNULL(i.resolvedby,i.closedby)'),'TEMP_incident_combined','owner'],
		['owner',field_string.replace("@owner", 'i.closedby'),'TEMP_incident_combined','owner'],
		['owner',field_string.replace("@owner", 'i.lastmodby'),'TEMP_incident_combined','owner'],

	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	update_dimension_tables_2(output_db, output_database, dimension_table_list, print_details)

	#CREATE A FUSION TABLE


def run_test_2():
	print_internal = True
	print_details = True

	output_db = 1 #REPORTING DATABASE
	output_database = 'LF-SQL-WH'
	source_db = 1 #REPORTING DATABASE
	source_database = 'LF-SQL-RPT01'


	dimension_table_list = [
		["owner","ISNULL(REPLACE(owner,'.',' '),'')","TEMP_incident_combined","owner"],
	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	create_dimension_tables_2(output_db, output_database, dimension_table_list, print_details)

	#WE THEN HAVE TO RUN THE ABOVE FOR ALL RESOLVER BASED FIELDS, UPDATING THE SAME LOOKUP_OWNER FIELD
	dimension_table_list = [
		['owner',"ISNULL(REPLACE(i.createdby,'.',' '),'')",'TEMP_incident_combined','owner'],
		['owner',"ISNULL(REPLACE(ISNULL(i.resolvedby,i.closedby),'.',' '),'')",'TEMP_incident_combined','owner'],
		['owner',"ISNULL(REPLACE(i.closedby,'.',' '),'')",'TEMP_incident_combined','owner'],
		['owner',"ISNULL(REPLACE(i.lastmodby,'.',' '),'')",'TEMP_incident_combined','owner'],
	]

	#CREATE AND POPULATE THE LOOKUP TABLES
	update_dimension_tables_2(output_db, output_database, dimension_table_list, print_details)

	#CREATE A FUSION TABLE


run_test()