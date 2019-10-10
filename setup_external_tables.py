
def drop_master_credential(output_db, output_database, table_list, print_details):

	#print(table_list)

	for table in table_list:
		#run = True
		#if run == True:
		try:
			drop_sql = "DROP EXTERNAL TABLE "+table
			#print(drop_sql)
			query_database2('drop External Table '+table,drop_sql, output_db, output_database, print_details=print_details, ignore_errors=True)
		except:
			if print_details == True:
				print("no External Table "+table+" to Drop")


	sql = 'DROP EXTERNAL DATA SOURCE RemoteReferenceData'
	query_database2('drop Data Source',sql, output_db, output_database, print_details=print_details) #, ignore_errors=True

	sql = 'DROP DATABASE SCOPED CREDENTIAL SQL_Credential'
	query_database2('drop Credential',sql, output_db, output_database, print_details=print_details) #, ignore_errors=True

	sql = 'drop MASTER KEY'
	query_database2('drop Master Key',sql, output_db, output_database, print_details=print_details) #, ignore_errors=True


def create_master_credential(output_db, output_database, print_details):
	sql = "CREATE MASTER KEY ENCRYPTION BY PASSWORD = '"+rpt_password+"';"
	query_database2('create Master Key',sql, output_db, output_database, print_details=print_details)

	sql = "CREATE DATABASE SCOPED CREDENTIAL SQL_Credential\n"
	sql += "WITH IDENTITY = '"+rpt_username+"',\n"
	sql += "SECRET = '"+rpt_password+"';"
	query_database2('create Credential',sql, output_db, output_database, print_details=print_details)

	sql = "CREATE EXTERNAL DATA SOURCE RemoteReferenceData\n"
	sql += "WITH\n"
	sql += "(\n"
	sql += "TYPE=RDBMS,\n"
	sql += "LOCATION='"+rpt_server+"',\n"
	sql += "DATABASE_NAME='LF-SQL-RPT01',\n"
	sql += "CREDENTIAL= SQL_Credential\n"
	sql += ");\n"
	query_database2('create Data Source',sql, output_db, output_database, print_details=print_details)


def return_table_fields(db, database, table, print_details):

	sql = "SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = N'"+table+"';"
	#print(sql)
	df = query_database(sql, db, database)

	return df

def create_external_tables(
	source_db, source_database, output_db, output_database, 
	table, print_details):

	import math

	df = return_table_fields(source_db, source_database, table, print_details)

	if df.empty == False:

		sql = 'CREATE EXTERNAL TABLE '+table+'(\n'

		for row in df.iterrows(): 
		    data = row[1]
		    sql += data['COLUMN_NAME'] + " " + data['DATA_TYPE']

		    #print(data['DATA_TYPE'])
		    #print(data['CHARACTER_MAXIMUM_LENGTH'])	    
		    
		    if math.isnan(data['CHARACTER_MAXIMUM_LENGTH']) == False:
		    	sql += "(" + str(int(data['CHARACTER_MAXIMUM_LENGTH'])) + "),\n"
		    else:
		    	sql += ",\n"

		sql += ")\n"
		sql += "WITH (DATA_SOURCE = RemoteReferenceData)"
		#print(sql)

		try:
			drop_sql = "DROP EXTERNAL TABLE "+table
			query_database2('drop External Table '+table,drop_sql, output_db, output_database, print_details=print_details, ignore_errors=True)
		except:
			if print_details == True:
				print("no External Table to Drop")

		query_database2('create External Table '+table,sql, output_db, output_database, print_details=print_details)



def setup_external_tables(
	source_db, source_database, output_db, output_database,
	table_list, create_credential=False, print_details=False):

	if create_credential == True:
		try:
			drop_master_credential(output_db, output_database, table_list, print_details)
			u_print("Master Credentials Dropped")
			u_print("###########################")
		except:
			if (print_details == True):
				u_print("No Credentials to Drop")
				u_print("###########################")
		try:
			create_master_credential(output_db, output_database, print_details)
			u_print("Master Credentials Created")
			u_print("###########################")
		except Exception as e:
			u_print("Could Not Create Master Credentials")
			u_print(e)
			u_print("###########################")


	for table in table_list:
		create_external_tables(source_db, source_database, output_db, output_database, table, print_details)

	if print_details == True:
		u_print("External Tables Created")
		u_print("###########################")