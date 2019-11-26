
INSERT INTO DETAIL_nps
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
ORDER BY
    s.submittedat



ALTER TABLE [dbo].[DETAIL_nps] ADD CONSTRAINT PK_nps_ID PRIMARY KEY ([submittedat_Format],ID);

CREATE NONCLUSTERED INDEX IDX_nps_check ON [dbo].[DETAIL_nps] ([recid]); --TO GET WHEN UPDATING RECORDS