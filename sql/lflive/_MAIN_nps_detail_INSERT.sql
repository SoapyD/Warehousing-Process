/*
########################################################### MAIN
*/

INSERT DETAIL_nps
SELECT
    s.recid,
	s.type,
	s.id,
	s.rescuesessionid,
	s.comments,
    replace(rdb.owner,'.',' ') as technician,
	s.nps,
	s.npstype,
	s.duplicate_check,
    ISNULL(i.recid,NULL) AS incident_id,
	s.incidentnumber,
    ISNULL(i.customer,'') AS customer,
    ISNULL(i.isvip,'') AS isvip,

    --DIMENSION IDS
    ISNULL(sys.id,NULL) as system_id,
    ISNULL(i.company_id,NULL) AS company_id,
    ISNULL(i.businessunit_id,NULL) AS businessunit_id,
    ISNULL(i.ownerteam_id,NULL) AS ownerteam_id,
	s.databasename,

	--DATE DIMENSIONS
	s.submittedat,
    submit_d.id AS submitteddate_id

FROM
	TEMP_nps s

    --DIMENSION IDS
    LEFT JOIN LOOKUP_system sys ON (sys.system = ISNULL(s.system,''))
    LEFT JOIN DETAIL_incident i ON (sys.id = i.system_id AND i.number = s.incidentnumber)

    --DATE JOINS
    LEFT JOIN LOOKUP_dates submit_d ON (submit_d.date = CONVERT(DATE,s.submittedat))

    --OWNER JOINS 
    LEFT JOIN LOOKUP_owner rdb ON (rdb.id = i.resolvedby_id) 

WHERE NOT EXISTS
	(
		SELECT 
			recid--, 
			--system 
		FROM 
			DETAIL_nps d 
			--LEFT JOIN LOOKUP_system s ON (s.id = d.system_id)
		WHERE 
			d.recid = i.recid --AND s.system = i.system
	)
;