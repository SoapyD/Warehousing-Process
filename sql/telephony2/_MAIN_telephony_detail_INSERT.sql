
--DELETE THE DATA FOR ANYTHING THAT SHARES THE SAME SOURCE AND DATETIME AS THE UPLOAD
DECLARE @min DATETIME = (SELECT min(datetime) d FROM TEMP_telephony_combined)
DECLARE @max DATETIME = (SELECT max(datetime) d FROM TEMP_telephony_combined)
DECLARE @source NVARCHAR(100) = (SELECT DISTINCT source FROM TEMP_telephony_combined)

DELETE FROM DETAIL_telephony
WHERE
datetime between @min AND @MAX
AND source = @source;


--REPOPULATE THAT DATE RANGE
INSERT DETAIL_telephony
SELECT
	NULLIF(recid,'') AS recid
	,NULLIF(tel.ddi,'') AS ddi
	,NULLIF(com.ID,'') AS ddi_id
	,ringtime
	,totalduration
	,NULLIF(agentid,'') AS agentid
	,NULLIF(agentname,'') AS agentname
	,NULLIF(groupid,'') AS groupid
	,NULLIF(groupname,'') AS groupname
	,NULLIF(datetime,'') AS datetime
	,NULLIF(CONVERT(DATE,datetime),'') AS date_Format
	,NULLIF(calltype,'') AS calltype
	,NULLIF(source,'') AS source
FROM	
	[dbo].[TEMP_telephony_combined] tel
	LEFT JOIN dbo.LOOKUP_ddi com ON com.ddi = tel.ddi

WHERE	
	tel.datetime is not null

ORDER BY
	tel.[datetime]
;