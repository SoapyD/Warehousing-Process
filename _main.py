
import os
path = os.getcwd() #get the current path
string_pos = path.index('Python') #find the python folder
base_path = path[:string_pos]+'Python\\' #create a base filepath string
exec(open(base_path+"Functions\\functions.py").read()) #load the master password file

this_dir = base_path+"Warehousing-Process\\"

exec(open(this_dir+"setup_external_tables.py").read())
exec(open(this_dir+"setup_dimension_tables.py").read())
exec(open(this_dir+"setup_warehouse.py").read())
exec(open(this_dir+"update_warehouse.py").read())
exec(open(this_dir+"setup_warehouse2.py").read())
exec(open(this_dir+"update_warehouse2.py").read())

exec(open(this_dir+"setup_warehouse_lflive.py").read())
exec(open(this_dir+"update_warehouse_lflive.py").read())

exec(open(this_dir+"setup_dimensions.py").read())

global error_count
