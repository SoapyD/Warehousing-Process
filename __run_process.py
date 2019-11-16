import os

exec(open("_main.py").read())



output_database = 'LF-SQL-WH'

setup_warehouse(output_database)
setup_warehouse_lflive(output_database)
