

#THIS IS ATTEMPTING TO ALLOW FOR A MORE FLEXIBLE INSERT PROCESS
def update_dimension_tables_2(db, database, dimension_table_list, print_details=False):


	for dimension_table in dimension_table_list:
		table = dimension_table[0]
		fields = dimension_table[1]
		from_table = dimension_table[2]
		alias = dimension_table[3]

		sql = """
WITH DATA AS (
SELECT DISTINCT
    @FIELDS AS @ALIAS
FROM 
    @FROM_SQL i
)

INSERT INTO @LOOKUP_TABLE
SELECT
	@ALIAS
FROM 
    DATA d

WHERE NOT EXISTS
    (
        SELECT
            @ALIAS
        FROM
            @LOOKUP_TABLE s
        WHERE 
            s.@ALIAS = d.@ALIAS
    )
;	
			"""

		tablename = "LOOKUP_"+table

		sql = sql.replace("@LOOKUP_TABLE", tablename)
		sql = sql.replace("@FIELDS", fields)
		sql = sql.replace("@ALIAS", alias)
		sql = sql.replace("@FROM_SQL", from_table)

		#print(sql)
		query_database2('Update Dimension Table '+table, sql, db, database, print_details=print_details) #, ignore_errors=True



def create_date_table(db, database, print_details=False):

	sql = """
IF OBJECT_ID(N'LOOKUP_dates') IS NOT NULL
	DROP TABLE LOOKUP_dates


SET DATEFIRST 1;

DECLARE
@date DATE =  CONVERT(DATE,'01/01/2015')
;

WITH 
CTE_DatesTable AS
(
	SELECT @date AS date
	UNION ALL
	SELECT DATEADD(DAY, 1, date)
	FROM CTE_DatesTable
	WHERE DATEADD(DAY, 1, date) < DATEADD(MONTH,240,@date)
)


SELECT
	DATEPART(YEAR,date) as year,
	DATEPART(QUARTER,date) as quarter,
	DATENAME(dw,date) AS day,
	DATEPART(dw,date) AS daynumber,    
	CONVERT(DATE,DATEADD(mm, DATEDIFF(mm, 0, date), 0)) month,
	CONVERT(DATE,DATEADD(day, -1*(DATEPART(WEEKDAY, date)-1), date)) week,
	date,
	0 AS publicholiday
INTO
	LOOKUP_dates
FROM
	CTE_DatesTable d

OPTION 
	(MAXRECURSION 0);


ALTER TABLE LOOKUP_dates
ADD ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY

CREATE INDEX idx_date ON LOOKUP_dates (year, quarter, day, daynumber, month, week, date, id)	


UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'01/01/2015');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/03/2015');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/06/2015');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/04/2015');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/25/2015');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'08/31/2015');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/25/2015');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/28/2015');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'01/01/2016');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'03/25/2016');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'03/28/2016');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/02/2016');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/30/2016');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'08/29/2016');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/26/2016');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/27/2016');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'01/02/2017');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/14/2017');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/17/2017');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/01/2017');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/29/2017');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'08/28/2017');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/25/2017');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/26/2017');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'01/01/2018');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'03/30/2018');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/02/2018');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/07/2018');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/28/2018');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'08/27/2018');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/25/2018');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/26/2018');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'01/01/2019');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/19/2019');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/22/2019');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/06/2019');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/27/2019');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'08/26/2019');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/25/2019');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/26/2019');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'01/01/2020');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/10/2020');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/13/2020');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/08/2020');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/25/2020');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'08/31/2020');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/25/2020');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/28/2020');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'01/01/2021');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/02/2021');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/05/2021');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/03/2021');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/31/2021');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'08/30/2021');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/27/2021');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/28/2021');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'01/03/2022');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/15/2022');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/18/2022');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/02/2022');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/30/2022');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'08/29/2022');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/26/2022');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/27/2022');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'01/02/2023');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/07/2023');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/10/2023');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/01/2023');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/29/2023');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'08/28/2023');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/25/2023');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/26/2023');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'01/01/2024');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'03/29/2024');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/01/2024');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/06/2024');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/27/2024');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'08/26/2024');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/25/2024');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/26/2024');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'01/01/2025');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/18/2025');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/21/2025');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/05/2025');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/26/2025');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'08/25/2025');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/25/2025');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/26/2025');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'01/01/2026');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/03/2026');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/06/2026');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/04/2026');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/25/2026');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'08/31/2026');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/25/2026');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/28/2026');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'01/01/2027');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'03/26/2027');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'03/29/2027');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/03/2027');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/31/2027');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'08/30/2027');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/27/2027');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/28/2027');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'01/03/2028');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/14/2028');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/17/2028');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/01/2028');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/29/2028');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'08/28/2028');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/25/2028');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/26/2028');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'01/01/2029');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'03/30/2029');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/02/2029');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/07/2029');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/28/2029');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'08/27/2029');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/25/2029');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/26/2029');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'01/01/2030');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/19/2030');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'04/22/2030');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/06/2030');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'05/27/2030');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'08/26/2030');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/25/2030');
UPDATE LOOKUP_dates SET publicholiday = 1 WHERE date = CONVERT(DATE,'12/26/2030');


		
			"""

	drop_sql = "DROP TABLE LOOKUP_dates"
	query_database2('Drop Date Table ', drop_sql, db, database, print_details=print_details, ignore_errors=True)
	query_database2('Create Date Table ', sql, db, database, print_details=print_details) #, ignore_errors=True

	#don't think this index is being used at all


##########################################################################################################
##########################################################################################################
##########################################################################################################
##########################################################################################################
##########################################################################################################
##########################################################################################################
##########################################################################################################


def create_dimension_tables_2(db, database, dimension_table_list, print_details=False):


	for dimension_table in dimension_table_list:
		table = dimension_table[0]
		fields = dimension_table[1]
		from_table = dimension_table[2]
		alias = dimension_table[3]

		sql = """
IF OBJECT_ID(N'@LOOKUP_TABLE') IS NOT NULL
	drop table @LOOKUP_TABLE

SELECT DISTINCT
	@FIELDS AS @ALIAS
INTO 
	@LOOKUP_TABLE 
FROM 
	@FROM_SQL

ALTER TABLE @LOOKUP_TABLE
ADD ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY

CREATE INDEX @IDX_NAME ON @LOOKUP_TABLE (id, @ALIAS)			
			"""

		tablename = "LOOKUP_"+table

		sql = sql.replace("@LOOKUP_TABLE", tablename)
		sql = sql.replace("@FIELDS", fields)
		sql = sql.replace("@ALIAS", alias)		
		sql = sql.replace("@FROM_SQL", from_table)
		sql = sql.replace("@IDX_NAME", "IDX_"+table)

		drop_sql = "DROP TABLE "+tablename
		query_database2('Drop Dimension Table '+table, drop_sql, db, database, print_details=print_details, ignore_errors=True)
		query_database2('Create Dimension Table '+table, sql, db, database, print_details=print_details) #, ignore_errors=True
		#print(sql)