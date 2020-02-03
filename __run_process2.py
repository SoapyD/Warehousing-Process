import os

exec(open("process\\process2\\_main2.py").read())



output_database = 'LF-SQL-WH'

setup_warehouse2(output_database)
setup_warehouse_lflive2(output_database)
setup_warehouse_telephony2(output_database)
setup_warehouse_problem2(output_database)
setup_warehouse_problem_task2(output_database)

#update_warehouse_data_tables2()

#UPDATES NEED TO HAVE DATABASE PASSED TO THEM