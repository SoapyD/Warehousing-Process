


UPDATE DETAIL_incident
SET
	recid = T2.recid,
	number = T2.number,
	system = T2.system,
	Company = T2.Company,
	Company_ID = T2.Company_ID,
	businessunit = T2.businessunit,
	isvip = T2.isvip,
	location = T2.location,
	customer = T2.customer,
	subject = T2.subject,
	symptom = T2.symptom,
	priority = T2.priority,
	status = T2.status,
	source = T2.source,
	service = T2.service,
	category = T2.category,
	subcategory = T2.subcategory,
	fcr = T2.fcr,
	fcr_scoped_Format = T2.fcr_scoped_Format,
	fcr_achieved_Format = T2.fcr_achieved_Format,
	ownerteam = T2.ownerteam,
	owner_Format = T2.owner_Format,
	causecode = T2.causecode,
	createdby_Format = T2.createdby_Format,
	createddatetime = T2.createddatetime,
	createddate_Format = T2.createddate_Format,
	resolvingteam = T2.resolvingteam,
	resolvedby_Format = T2.resolvedby_Format,
	resolveddatetime = T2.resolveddatetime,
	resolveddate_Format = T2.resolveddate_Format,
	closedby_Format = T2.closedby_Format,
	closeddatetime = T2.closeddatetime,
	closeddate_Format = T2.closeddate_Format,
	lastmodby_Format = T2.lastmodby_Format,
	lastmoddatetime = T2.lastmoddatetime,
	lastmoddate_Format = T2.lastmoddate_Format,
	ResolvedClosedBy_Format = T2.ResolvedClosedBy_Format,
	ResolvedClosedDate_Format = T2.ResolvedClosedDate_Format,
	ResolvedClosedDatetime = T2.ResolvedClosedDatetime,
	breachstatus = T2.breachstatus,
	l1dateTime = T2.l1dateTime,
	l1passed = T2.l1passed,
	L2dateTime = T2.L2dateTime,
	l2passed = T2.l2passed,
	l3dateTime = T2.l3dateTime,
	l3passed = T2.l3passed,
	breachdatetime = T2.breachdatetime,
	breachpassed = T2.breachpassed,
	targetclockduration = T2.targetclockduration,
	totalrunningduration = T2.totalrunningduration,
	response_breachpassed = T2.response_breachpassed,
	response_targetclockduration = T2.response_targetclockduration,
	response_totalrunningduration = T2.response_totalrunningduration,
	typeofincident = T2.typeofincident,
	reopencount = T2.reopencount,
	reopencount_Flag = T2.reopencount_Flag,
	remoteresolution = T2.remoteresolution,
	resolution = T2.resolution,
	technicalresolution = T2.technicalresolution,
	numberofusersaffected = T2.numberofusersaffected,
	repeatissue = T2.repeatissue,
	problem_id = T2.problem_id,
	parentincident_id = T2.parentincident_id

FROM   
	DETAIL_incident T1
    JOIN 
    (


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
		,CONVERT(DATE,COALESCE(inc.[resolveddatetime],inc.[closeddatetime])) AS ResolvedClosedDate_Format
		,COALESCE(inc.[resolveddatetime],inc.[closeddatetime]) AS ResolvedClosedDatetime
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
		,inc.[remoteresolution] AS [remoteresolution] --NOT NULLIF AS WE NEED TO KNOW WHEN IT'S JUST NULL OR NOT REMOTE
		,NULLIF(inc.[resolution],'') AS [resolution]
		,NULLIF(inc.[technicalresolution],'') AS [technicalresolution]
		,NULLIF(inc.[numberofusersaffected],'') AS [numberofusersaffected]
		,NULLIF(inc.[repeatissue],'') AS [repeatissue]
		,NULLIF(inc.[problem_id],'') AS [problem_id]
		,NULLIF(inc.[parentincident_id],'') AS [parentincident_id]
FROM	
	[dbo].[TEMP_incident_combined] inc
	LEFT JOIN dbo.LOOKUP_company com ON com.company = inc.company

    ) T2
    ON (T1.recid = T2.recid AND T1.system = T2.system)