/*
IF OBJECT_ID(N'DETAIL_Incident') IS NOT NULL
    drop table DETAIL_Incident
*/


insert into [dbo].[DETAIL_incident]
SELECT	--row_number() over(order by inc.[createddatetime]) AS ID
		NULLIF(inc.[recid],'') AS [recid]
		,NULLIF(inc.[number],'') AS [number]
		,NULLIF(inc.[system],'') AS [system]
		,NULLIF(inc.[company],'') AS [Company]
		,com.[ID] AS [Company_ID]
		,NULLIF(inc.[businessunit],'') AS [businessunit]
		,NULLIF(inc.[isvip],'') AS [isvip]
		,NULLIF(inc.[location],'') AS [location]
		,NULLIF(inc.[customer],'') AS [customer]
		,NULLIF(inc.[subject],'') AS [subject]
		,NULLIF(inc.[symptom],'') AS [symptom]
		,NULLIF(inc.[priority],'') AS [priority]
		,NULLIF(inc.[status],'') AS [status]
		,NULLIF(inc.[source],'') AS [source]
		,NULLIF(inc.[service],'') AS [service]
		,NULLIF(inc.[category],'') AS [category]
		,NULLIF(inc.[subcategory],'') AS [subcategory]
		,NULLIF(inc.[fcr],'') AS [fcr]
		,CASE WHEN		inc.[typeofincident] = 'Failure'
					AND inc.[source] IN ('Phone','LF Live','Chat','Chat Media','littlefish live')
					AND inc.[company] NOT IN ('Littlefish')
					AND inc.[status] IN ('Closed','Resolved')
		THEN 1 ELSE NULL
		END AS fcr_scoped_Format
		,CASE WHEN	inc.[fcr] = 1
					AND inc.[typeofincident] = 'Failure'
					AND inc.[source] IN ('Phone','LF Live','Chat','Chat Media','littlefish live')
					AND inc.[company] NOT IN ('Littlefish')
					AND inc.[status] IN ('Closed','Resolved')
		THEN 1 ELSE NULL
		END AS fcr_achieved_Format
		,NULLIF(inc.[ownerteam],'') AS [ownerteam]
		,replace(LEFT(inc.[owner],len(inc.[owner])-charindex('@',reverse(inc.[owner]))),'.',' ') AS [owner_Format]
		,NULLIF(inc.[causecode],'') AS [causecode]
		,replace(LEFT(inc.[createdby],len(inc.[createdby])-charindex('@',reverse(inc.[createdby]))),'.',' ') AS [createdby_Format]
		,NULLIF(inc.[createddatetime],'') AS [createddatetime]
		,CONVERT(DATE,inc.[createddatetime]) AS [createddate_Format]
		,NULLIF(inc.[resolvingteam],'') AS [resolvingteam]
		,replace(LEFT(NULLIF(inc.[resolvedby],''),len(inc.[resolvedby])-charindex('@',reverse(inc.[resolvedby]))),'.',' ') AS [resolvedby_Format]
		,NULLIF(inc.[resolveddatetime],'') AS [resolveddatetime]
		,CONVERT(DATE,inc.[resolveddatetime]) AS [resolveddate_Format]
		,replace(LEFT(NULLIF(inc.[closedby],''),len(inc.[closedby])-charindex('@',reverse(inc.[closedby]))),'.',' ') AS [closedby_Format]
		,NULLIF(inc.[closeddatetime],'') AS [closeddatetime]
		,CONVERT(DATE,inc.[closeddatetime]) AS [closeddate_Format]
		,replace(LEFT(NULLIF(inc.[lastmodby],''),len(inc.[lastmodby])-charindex('@',reverse(inc.[lastmodby]))),'.',' ') AS [lastmodby_Format]
		,NULLIF(inc.[lastmoddatetime],'') AS [lastmoddatetime]
		,CONVERT(DATE,inc.[lastmoddatetime]) AS [lastmoddate_Format]
		,replace(LEFT(NULLIF(COALESCE(inc.[resolvedby],inc.[closedby]),''),len(COALESCE(inc.[resolvedby],inc.[closedby]))-charindex('@',reverse(COALESCE(inc.[resolvedby],inc.[closedby])))),'.',' ') AS [ResolvedClosedBy_Format]	
		,COALESCE(inc.[resolveddatetime],inc.[closeddatetime]) AS ResolvedClosedDatetime
		,CONVERT(DATE,COALESCE(inc.[resolveddatetime],inc.[closeddatetime])) AS ResolvedClosedDate_Format
		,NULLIF(inc.[breachstatus],'') AS [breachstatus]
		,NULLIF(inc.[l1dateTime],'') AS [l1dateTime]
		,NULLIF(inc.[l1passed],'') AS [l1passed]
		,NULLIF(inc.[L2dateTime],'') AS [L2dateTime]
		,NULLIF(inc.[l2passed],'') AS [l2passed]
		,NULLIF(inc.[l3dateTime],'') AS [l3dateTime]
		,NULLIF(inc.[l3passed],'') AS [l3passed]
		,NULLIF(inc.[breachdatetime],'') AS [breachdatetime]
		,NULLIF(inc.[breachpassed],'') AS [breachpassed]
		,NULLIF(inc.[targetclockduration],'') AS [targetclockduration]
		,NULLIF(inc.[totalrunningduration],'') AS [totalrunningduration]
		,NULLIF(inc.[response_breachpassed],'') AS [response_breachpassed]
		,NULLIF(inc.[response_targetclockduration],'') AS [response_targetclockduration]
		,NULLIF(inc.[response_totalrunningduration],'') AS [response_totalrunningduration]
		,NULLIF(inc.[typeofincident],'') AS [typeofincident]
		,inc.[reopencount]
		,CASE WHEN inc.[reopencount] = 0 THEN NULL ELSE 1 END AS [reopencount_Flag]
		,NULLIF(inc.[remoteresolution],'') AS [remoteresolution]
		,NULLIF(inc.[resolution],'') AS [resolution]
		,NULLIF(inc.[technicalresolution],'') AS [technicalresolution]
		,NULLIF(inc.[numberofusersaffected],'') AS [numberofusersaffected]
		,NULLIF(inc.[repeatissue],'') AS [repeatissue]
		,NULLIF(inc.[problem_id],'') AS [problem_id]
		,NULLIF(inc.[parentincident_id],'') AS [parentincident_id]
FROM	
	[dbo].[TEMP_incident_combined] inc
	LEFT JOIN dbo.LOOKUP_company com ON com.company = inc.company

WHERE	
	inc.createddatetime is not null
ORDER BY
	inc.[createddatetime]
;


ALTER TABLE [dbo].[DETAIL_incident] ADD CONSTRAINT PK_inc_ID PRIMARY KEY (ID);

--CREATE NONCLUSTERED INDEX IDX_created ON [dbo].[DETAIL_incident] (createddate_Format);


CREATE NONCLUSTERED INDEX IDX_check_inc ON [dbo].[DETAIL_incident] ([recid],[system]); --CHECKED WHEN UPDATING RECORDS



CREATE NONCLUSTERED INDEX IDX_lookup_inc ON [dbo].[DETAIL_incident] ([number],[system]); --TO GET CORE INC DATA for sessions and nps





CREATE NONCLUSTERED INDEX IDX_org_inc
ON [dbo].[DETAIL_incident] (Company)
INCLUDE (createddate_Format, ResolvedClosedDate_Format, customer,businessunit,status,source,typeofincident,ownerteam, 
	priority, BreachPassed, breachstatus, fcr, createdby_Format, owner_Format, resolvedclosedby_Format)

CREATE NONCLUSTERED INDEX IDX_created_inc
ON [dbo].[DETAIL_incident] (createddate_Format)
INCLUDE (Company,customer,businessunit,status,source,typeofincident,ownerteam, 
	priority, BreachPassed, breachstatus, fcr, createdby_Format, owner_Format)

CREATE NONCLUSTERED INDEX IDX_resolved_inc
ON [dbo].[DETAIL_incident] (ResolvedClosedDate_Format)
INCLUDE (Company,customer,businessunit,status,source,typeofincident,ownerteam, 
	priority, BreachPassed, breachstatus, fcr, resolvedclosedby_Format)


/*
CREATE NONCLUSTERED INDEX IDX_detail_inc
ON [dbo].[DETAIL_incident] (id)
INCLUDE (

number,
subject, symptom, resolution, technicalresolution,
problem_id, parentincident_id,

--DIMENSION IDS
system,
--Company,
--businessunit, 
--typeofincident,  
--status, 
--source, 
--ownerteam, 
location,
causecode,
service, 
category, 
subcategory,

--DIMENSIONS
priority,
isvip,
breachstatus, L1Passed, L2Passed, L3Passed, 
breachpassed, response_breachpassed, 

remoteresolution, 
repeatissue, 
numberofusersaffected, 
--reopen_check, #missing

fcr, 
--fcr_scoped, #missing
--fcr_achieved, #missing

--DATE DIMENSIONS
createddatetime, resolveddatetime, closeddatetime, lastmoddatetime,
--lastmoddate_Format, resolveddate_Format, closeddate_Format,

--FACTS
targetclockduration, totalrunningduration,
response_targetclockduration, response_totalrunningduration, 
reopencount,

customer,
owner_Format, createdby_Format, resolvedby_Format, closedby_Format, lastmodby_Format

)



CREATE NONCLUSTERED INDEX IDX_detail_inc
ON [dbo].[DETAIL_incident] (id)
INCLUDE (

priority,
isvip,
breachstatus, L1Passed, L2Passed, L3Passed, 
breachpassed, response_breachpassed,

fcr

)
*/