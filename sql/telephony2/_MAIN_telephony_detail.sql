/*
IF OBJECT_ID(N'DETAIL_telephony') IS NOT NULL
    drop table DETAIL_telephony
*/


insert into [dbo].[DETAIL_telephony]
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


ALTER TABLE [dbo].[DETAIL_telephony] ADD CONSTRAINT PK_tel_ID PRIMARY KEY (ID);

CREATE NONCLUSTERED INDEX IDX_created_tel
ON [dbo].[DETAIL_telephony] ([date_Format])
INCLUDE ([ddi],[ringtime], totalduration,[agentname],[calltype])

/*
CREATE NONCLUSTERED INDEX IDX_inc_check ON [dbo].[DETAIL_telephony] ([recid],[system]); --TO GET WHEN UPDATING RECORDS

CREATE NONCLUSTERED INDEX IDX_inc_lookup ON [dbo].[DETAIL_telephony] ([number],[system]); --TO GET CORE INC DATA
*/