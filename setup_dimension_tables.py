
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
	date
INTO
	LOOKUP_dates
FROM
	CTE_DatesTable d

OPTION 
	(MAXRECURSION 0);


ALTER TABLE LOOKUP_dates
ADD ID INT IDENTITY(1,1) NOT NULL PRIMARY KEY

CREATE INDEX idx_date ON LOOKUP_dates (year, quarter, day, daynumber, month, week, date, id)			
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


