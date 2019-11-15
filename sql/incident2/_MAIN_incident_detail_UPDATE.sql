


UPDATE Detail_Incident_v2
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
	Detail_Incident_v2 T1
    JOIN 
    (


SELECT	--row_number() over(order by inc.[createddatetime]) AS ID
		nullif(inc.[recid],'') AS [recid]
		,nullif(inc.[number],'') AS [number]
		,nullif(inc.[system],'') AS [system]
		,nullif(inc.[company],'') AS [Company]
		,com.[ID] AS [Company_ID]
		,nullif(inc.[businessunit],'') AS [businessunit]
		,nullif(inc.[isvip],'') AS [isvip]
		,nullif(inc.[location],'') AS [location]
		,nullif(inc.[customer],'') AS [customer]
		,nullif(inc.[subject],'') AS [subject]
		,nullif(inc.[symptom],'') AS [symptom]
		,nullif(inc.[priority],'') AS [priority]
		,nullif(inc.[status],'') AS [status]
		,nullif(inc.[source],'') AS [source]
		,nullif(inc.[service],'') AS [service]
		,nullif(inc.[category],'') AS [category]
		,nullif(inc.[subcategory],'') AS [subcategory]
		,nullif(inc.[fcr],'') AS [fcr]
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
		,nullif(inc.[ownerteam],'') AS [ownerteam]
		,replace(left(inc.[owner],len(inc.[owner])-charindex('@',reverse(inc.[owner]))),'.',' ') AS [owner_Format]
		,nullif(inc.[causecode],'') AS [causecode]
		,replace(left(inc.[createdby],len(inc.[createdby])-charindex('@',reverse(inc.[createdby]))),'.',' ') AS [createdby_Format]
		,nullif(inc.[createddatetime],'') AS [createddatetime]
		,convert(date,inc.[createddatetime]) AS [createddate_Format]
		,nullif(inc.[resolvingteam],'') AS [resolvingteam]
		,replace(left(nullif(inc.[resolvedby],''),len(inc.[resolvedby])-charindex('@',reverse(inc.[resolvedby]))),'.',' ') AS [resolvedby_Format]
		,nullif(inc.[resolveddatetime],'') AS [resolveddatetime]
		,convert(date,inc.[resolveddatetime]) AS [resolveddate_Format]
		,replace(left(nullif(inc.[closedby],''),len(inc.[closedby])-charindex('@',reverse(inc.[closedby]))),'.',' ') AS [closedby_Format]
		,nullif(inc.[closeddatetime],'') AS [closeddatetime]
		,convert(date,inc.[closeddatetime]) AS [closeddate_Format]
		,replace(left(nullif(inc.[lastmodby],''),len(inc.[lastmodby])-charindex('@',reverse(inc.[lastmodby]))),'.',' ') AS [lastmodby_Format]
		,nullif(inc.[lastmoddatetime],'') AS [lastmoddatetime]
		,convert(date,inc.[lastmoddatetime]) AS [lastmoddate_Format]
		,convert(date,concat(inc.[resolveddatetime],inc.[closeddatetime])) AS ResolvedClosedDate_Format
		,concat(inc.[resolveddatetime],inc.[closeddatetime]) AS ResolvedClosedDatetime
		,nullif(inc.[breachstatus],'') AS [breachstatus]
		,nullif(inc.[l1dateTime],'') AS [l1dateTime]
		,nullif(inc.[l1passed],'') AS [l1passed]
		,nullif(inc.[L2dateTime],'') AS [L2dateTime]
		,nullif(inc.[l2passed],'') AS [l2passed]
		,nullif(inc.[l3dateTime],'') AS [l3dateTime]
		,nullif(inc.[l3passed],'') AS [l3passed]
		,nullif(inc.[breachdatetime],'') AS [breachdatetime]
		,nullif(inc.[breachpassed],'') AS [breachpassed]
		,nullif(inc.[targetclockduration],'') AS [targetclockduration]
		,nullif(inc.[totalrunningduration],'') AS [totalrunningduration]
		,nullif(inc.[response_breachpassed],'') AS [response_breachpassed]
		,nullif(inc.[response_targetclockduration],'') AS [response_targetclockduration]
		,nullif(inc.[response_totalrunningduration],'') AS [response_totalrunningduration]
		,nullif(inc.[typeofincident],'') AS [typeofincident]
		,inc.[reopencount]
		,CASE WHEN inc.[reopencount] = 0 THEN NULL ELSE 1 END AS [reopencount_Flag]
		,nullif(inc.[remoteresolution],'') AS [remoteresolution]
		,nullif(inc.[resolution],'') AS [resolution]
		,nullif(inc.[technicalresolution],'') AS [technicalresolution]
		,nullif(inc.[numberofusersaffected],'') AS [numberofusersaffected]
		,nullif(inc.[repeatissue],'') AS [repeatissue]
		,nullif(inc.[problem_id],'') AS [problem_id]
		,nullif(inc.[parentincident_id],'') AS [parentincident_id]
FROM	
	[dbo].[TEMP_incident_combined] inc
	LEFT JOIN dbo.LOOKUP_company com ON com.company = inc.company

    ) T2
    ON (T1.recid = T2.recid AND T1.system_id = T2.system_id)