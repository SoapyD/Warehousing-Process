UPDATE DETAIL_nps
SET
    recid = T2.recid,
	databasename = T2.databasename,
	type = T2.type,
	surveyid = T2.surveyid,
	rescuesessionid = T2.rescuesessionid,
	comments = T2.comments,
	nps = T2.nps,
	npstype = T2.npstype,

    technicianname_Format = T2.technicianname_Format,    
	--DATE DIMENSIONS
	submittedat = T2.submittedat,
    submittedat_Format = T2.submittedat_Format,

    system = T2.system,
    nps_incidentnumber = T2.nps_incidentnumber,
	incident_id = T2.incident_id,
	duplicate_check = T2.duplicate_check

FROM   
	DETAIL_nps T1
    JOIN 
    (

SELECT
    NULLIF(s.recid+'_i_'+ISNULL(REPLACE(s.incidentnumber,'.0',''),'zz'),'') AS recid
    ,s.databasename AS databasename --DON'T AMEND AS NULLIF REMOVES ZEROES WHICH ARE NEEDED
    ,NULLIF(s.type,'') AS type
    ,NULLIF(s.id,'') AS surveyid
    ,NULLIF(s.rescuesessionid,'') AS rescuesessionid
    ,NULLIF(LEFT(s.comments,250),'') AS comments
    ,NULLIF(s.nps,'') AS nps
    ,NULLIF(s.npstype,'') AS npstype

    ,replace(LEFT(s.technicianname,len(s.technicianname)-charindex('@',reverse(s.technicianname))),'.',' ') AS [technicianname_Format]

    --DATE DIMENSIONS
    ,NULLIF(s.submittedat,'') AS submittedat
    ,NULLIF(CONVERT(DATE,s.submittedat),'') AS submittedat_Format

    ,NULLIF(s.system,'') AS system    
    ,NULLIF(REPLACE(LEFT(s.incidentnumber,30),'.0',''),'') AS nps_incidentnumber
    ,ISNULL(i.id,NULL) AS incident_id

    --s.duplicate_check,
    --IF NO INCIDENT NUMBER APPEARS, MARK IT AS ZZ SO IT'LL APPEAR AT THE BOTTOM OF ANY NPS CORRECTIONS
    ,ROW_NUMBER() OVER (PARTITION BY ISNULL(rescuesessionid,s.incidentnumber), s.databasename 
        ORDER BY s.[submittedat] DESC, s.recid --RECID
        ) AS duplicate_check

FROM
    TEMP_nps s

    LEFT JOIN DETAIL_incident i ON (i.system = s.system AND i.number = s.incidentnumber)   

    ) T2
    ON (T1.recid = T2.recid)