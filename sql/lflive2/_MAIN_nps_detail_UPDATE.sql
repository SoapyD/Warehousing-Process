UPDATE DETAIL_nps
SET
    recid = T2.recid,
	type = T2.type,
	id = T2.id,
	rescuesessionid = T2.rescuesessionid,
	comments = T2.comments,
	nps = T2.nps,
	npstype = T2.npstype,
	duplicate_check = T2.duplicate_check,
    incident_id = T2.incident_id,
	incidentnumber = T2.incidentnumber,
    --customer = T2.customer,
    isvip = T2.isvip,

    --DIMENSION IDS
    system_id = T2.system_id,
    technician_id = T2.technician_id,    
	databasename = T2.databasename,

	--DATE DIMENSIONS
	submittedat = T2.submittedat,
    submitteddate_id = T2.submitteddate_id

FROM   
	DETAIL_nps T1
    JOIN 
    (


SELECT
    s.recid AS recid,
	s.type,
	s.id,
	s.rescuesessionid,
	s.comments,
	s.nps,
	s.npstype,
    ISNULL(i.recid,NULL) AS incident_id,
    REPLACE(s.incidentnumber,'.0','') AS incidentnumber,

    --DIMENSION IDS
    ISNULL(sys.id,NULL) as system_id,
    CASE
    WHEN rdb.owner = '' THEN NULL
    ELSE rdb.id 
    END as technician_id,
	s.databasename,

	--DATE DIMENSIONS
	s.submittedat,
    submit_d.id AS submitteddate_id,
	
    --s.duplicate_check,
    ROW_NUMBER() OVER (PARTITION BY ISNULL(rescuesessionid,s.incidentnumber), s.databasename 
        ORDER BY s.[submittedat] DESC, s.recid--RECID
        ) AS duplicate_check

FROM
	TEMP_nps s

    --DIMENSION IDS
    LEFT JOIN LOOKUP_system sys ON (sys.system = ISNULL(s.system,''))
    --LEFT JOIN DETAIL_incident i ON (sys.id = i.system_id AND i.number = s.incidentnumber)

    --DATE JOINS
    LEFT JOIN LOOKUP_dates submit_d ON (submit_d.date = CONVERT(DATE,s.submittedat))

    --OWNER JOINS 
    LEFT JOIN LOOKUP_owner rdb ON (rdb.owner = ISNULL(s.technicianname,''))    

    ) T2
    ON (T1.recid = T2.recid)-- AND T1.system_id = T2.system_id)