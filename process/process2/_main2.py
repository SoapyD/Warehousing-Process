
import os
path = os.getcwd() #get the current path
string_pos = path.index('Python') #find the python folder
base_path = path[:string_pos]+'Python\\' #create a base filepath string
exec(open(base_path+"Functions\\functions.py").read()) #load the master password file

this_dir = base_path+"Warehousing-Process\\"
warehousing_path = base_path+"Warehousing-Process"

exec(open(this_dir+"setup_external_tables.py").read())
exec(open(this_dir+"setup_dimension_tables.py").read())

exec(open(this_dir+"process\\process2\\setup_warehouse2.py").read())
exec(open(this_dir+"process\\process2\\update_warehouse2.py").read())

exec(open(this_dir+"process\\process2\\setup_warehouse_lflive2.py").read())
exec(open(this_dir+"process\\process2\\update_warehouse_lflive2.py").read())

exec(open(this_dir+"process\\process2\\setup_warehouse_telephony2.py").read())
exec(open(this_dir+"process\\process2\\update_warehouse_telephony2.py").read())

exec(open(this_dir+"process\\process2\\setup_warehouse_problem2.py").read())
exec(open(this_dir+"process\\process2\\update_warehouse_problem2.py").read())

exec(open(this_dir+"process\\process2\\update_warehouse_data_tables2.py").read())

global error_count
