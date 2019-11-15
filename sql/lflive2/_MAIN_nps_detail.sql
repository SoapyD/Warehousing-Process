
IF OBJECT_ID(N'DETAIL_nps') IS NOT NULL
    drop table DETAIL_nps

SELECT
    s.recid+'_i_'+ISNULL(REPLACE(s.incidentnumber,'.0',''),'zz') AS recid,
	s.type,
	s.id,
	s.rescuesessionid,
	s.comments,
	s.nps,
	s.npstype,
    ISNULL(i.id,NULL) AS incident_id,
	REPLACE(s.incidentnumber,'.0','') AS incidentnumber,

    --DIMENSION IDS
    ISNULL(sys.id,NULL) as system_id,

    --s.technicianname,
    CASE
    WHEN rdb.owner = '' THEN NULL
    ELSE rdb.id 
    END as technician_id,
    s.databasename,

	--DATE DIMENSIONS
	s.submittedat,
    submit_d.id AS submitteddate_id,

	--s.duplicate_check,
    --IF NO INCIDENT NUMBER APPEARS, MARK IT AS ZZ SO IT'LL APPEAR AT THE BOTTOM OF ANY NPS CORRECTIONS
    ROW_NUMBER() OVER (PARTITION BY ISNULL(rescuesessionid,s.incidentnumber), s.databasename 
        ORDER BY s.[submittedat] DESC, s.recid --RECID
        ) AS duplicate_check

INTO
	DETAIL_nps
FROM
	TEMP_nps s

    --DIMENSION IDS
    LEFT JOIN LOOKUP_system sys ON (sys.system = ISNULL(s.system,''))
    LEFT JOIN DETAIL_incident i ON (sys.id = i.system_id AND i.number = s.incidentnumber)

    --DATE JOINS
    LEFT JOIN LOOKUP_dates submit_d ON (submit_d.date = CONVERT(DATE,s.submittedat))

    --OWNER JOINS 
    LEFT JOIN LOOKUP_owner rdb ON (rdb.owner = ISNULL(s.technicianname,''))   
