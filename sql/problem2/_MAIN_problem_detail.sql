
insert into [dbo].[DETAIL_problem]
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

WHERE	
	prb.createddatetime is not null
ORDER BY
	prb.[createddatetime]
;



ALTER TABLE [dbo].[DETAIL_problem] ADD CONSTRAINT PK_prb_ID PRIMARY KEY (ID);
/*

CREATE NONCLUSTERED INDEX IDX_created ON [dbo].[DETAIL_incident] (createddate_Format);


CREATE NONCLUSTERED INDEX IDX_inc_check ON [dbo].[DETAIL_incident] ([recid],[system]); --TO GET WHEN UPDATING RECORDS

CREATE NONCLUSTERED INDEX IDX_inc_lookup ON [dbo].[DETAIL_incident] ([number],[system]); --TO GET CORE INC DATA





CREATE NONCLUSTERED INDEX IDX_com
ON [dbo].[DETAIL_incident] (Company)
INCLUDE (createddate_Format,ResolvedClosedDate_Format, customer,businessunit,status,source,typeofincident,ownerteam)

CREATE NONCLUSTERED INDEX IDX_cre
ON [dbo].[DETAIL_incident] (createddate_Format)
INCLUDE (Company,customer,businessunit,status,source,typeofincident,ownerteam)

CREATE NONCLUSTERED INDEX IDX_res
ON [dbo].[DETAIL_incident] (ResolvedClosedDate_Format)
INCLUDE (Company,customer,businessunit,status,source,typeofincident,ownerteam)

CREATE NONCLUSTERED INDEX IDX_detail
ON [dbo].[DETAIL_incident] (id)
INCLUDE (priority, fcr, isvip, subject)
*/