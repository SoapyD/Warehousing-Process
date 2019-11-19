import os

exec(open("process\\process2\\_main2.py").read())



output_database = 'LF-SQL-WH'

#setup_warehouse(output_database)
setup_warehouse_lflive(output_database)


#UPDATES NEED TO HAVE DATABASE PASSED TO THEM