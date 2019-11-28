


UPDATE DETAIL_problem
SET
    recid = T2.recid,
    number = T2.number,
    system = T2.system,
    company = T2.company,
    company_id = T2.company_id,    
    location = T2.location,
    customer = T2.customer,
    subject = T2.subject,
    priority = T2.priority,
    status = T2.status,
    source = T2.source,
    category = T2.category,
    subcategory = T2.subcategory,
    ownerteam = T2.ownerteam,
    owner_Format = T2.owner_Format,
    problemsource = T2.problemsource,
    createdby_Format = T2.createdby_Format,
    createddatetime = T2.createddatetime,
    createddate_Format = T2.createddate_Format,
    closedby_Format = T2.closedby_Format,
    closeddatetime = T2.closeddatetime,
    closeddate_Format = T2.closeddate_Format,
    lastmodby_Format = T2.lastmodby_Format,
    lastmoddatetime = T2.lastmoddatetime,
    lastmoddate_Format = T2.lastmoddate_Format,
    duedate = T2.duedate,
    worknotes = T2.worknotes,
    businessunit = T2.businessunit

FROM   
	DETAIL_problem T1
    JOIN 
    (

SELECT
		NULLIF(prb.[recid],'') AS [recid]
		,NULLIF(prb.[number],'') AS [number]
		,NULLIF(prb.[system],'') AS [system]
		,NULLIF(prb.[company],'') AS [Company]
		,com.[ID] AS [Company_ID]		
		,NULLIF(prb.[location],'') AS [location]
		,NULLIF(prb.[customer],'') AS [customer]
		,NULLIF(prb.[subject],'') AS [subject]
		,NULLIF(prb.[priority],'') AS [priority]
		,NULLIF(prb.[status],'') AS [status]
		,NULLIF(prb.[source],'') AS [source]
		,NULLIF(prb.[category],'') AS [category]
		,NULLIF(prb.[subcategory],'') AS [subcategory]
		,NULLIF(prb.[ownerteam],'') AS [ownerteam]
		,replace(LEFT(prb.[owner],len(prb.[owner])-charindex('@',reverse(prb.[owner]))),'.',' ') AS [owner_Format]
		,NULLIF(prb.[problemsource],'') AS [problemsource]		
		,replace(LEFT(prb.[createdby],len(prb.[createdby])-charindex('@',reverse(prb.[createdby]))),'.',' ') AS [createdby_Format]
		,NULLIF(prb.[createddatetime],'') AS [createddatetime]
		,CONVERT(DATE,prb.[createddatetime]) AS [createddate_Format]
		,replace(LEFT(NULLIF(prb.[closedby],''),len(prb.[closedby])-charindex('@',reverse(prb.[closedby]))),'.',' ') AS [closedby_Format]
		,NULLIF(prb.[closeddatetime],'') AS [closeddatetime]
		,CONVERT(DATE,prb.[closeddatetime]) AS [closeddate_Format]
		,replace(LEFT(NULLIF(prb.[lastmodby],''),len(prb.[lastmodby])-charindex('@',reverse(prb.[lastmodby]))),'.',' ') AS [lastmodby_Format]
		,NULLIF(prb.[lastmoddatetime],'') AS [lastmoddatetime]
		,CONVERT(DATE,prb.[lastmoddatetime]) AS [lastmoddate_Format]
		,NULLIF(duedate,'') AS duedate
    	,NULLIF(worknotes,'') AS worknotes
    	,NULLIF(businessunit,'') AS businessunit

FROM	
	[dbo].[TEMP_problem_combined] prb
	LEFT JOIN dbo.LOOKUP_company com ON com.company = prb.company

    ) T2
    ON (T1.recid = T2.recid AND T1.system = T2.system)