

INSERT Detail_Incident_v2
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
		,replace(left(nullif(COALESCE(inc.[resolvedby],inc.[closedby]),''),len(COALESCE(inc.[resolvedby],inc.[closedby]))-charindex('@',reverse(COALESCE(inc.[resolvedby],inc.[closedby])))),'.',' ') AS [ResolvedClosedBy_Format]	
		,convert(date,COALESCE(inc.[resolveddatetime],inc.[closeddatetime])) AS ResolvedClosedDate_Format
		,COALESCE(inc.[resolveddatetime],inc.[closeddatetime]) AS ResolvedClosedDatetime
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

WHERE NOT EXISTS
	(
		SELECT 
			recid, 
			system 
		FROM 
			DETAIL_incident d 
			LEFT JOIN LOOKUP_system s ON (s.id = d.system_id)
		WHERE 
			d.recid = i.recid AND s.system = i.system
	)

ORDER BY
	inc.[createddatetime]
;