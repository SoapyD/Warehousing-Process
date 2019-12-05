

INSERT DETAIL_incident
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

WHERE NOT EXISTS
	(
		SELECT 
			recid, 
			system 
		FROM 
			DETAIL_incident d 

		WHERE 
			d.recid = inc.recid AND d.system = inc.system
	)

ORDER BY
	inc.[createddatetime]
;