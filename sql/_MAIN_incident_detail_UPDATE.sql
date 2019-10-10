UPDATE DETAIL_incident
SET
	recid = t2.recid,
	number = t2.number,
	
	subject = t2.subject,
	symptom = t2.symptom,
	resolution = t2.resolution,
	technicalresolution = t2.technicalresolution,
	--t2.problemlink,
	--t2.masterincidentlink,
	/**/
	--DIMENSIONS
	status_id = t2.status_id,
	
	source_id = t2.status_id,
	company_id = t2.company_id,
	typeofincident_id = t2.typeofincident_id,
	ownerteam_id = t2.ownerteam_id,
	system_id = t2.system_id,
	businessunit_id = t2.businessunit_id,
	
	service_id = t2.service_id,
	category_id = t2.category_id,
	subcategory_id = t2.subcategory_id,

	--OWNER DIMENSIONS
	/*
	ISNULL(own.id,NULL as owner_id,
	ISNULL(own_cre.id,NULL as createdby_id,
	ISNULL(own_res.id,NULL as resolvedby_id,
	ISNULL(own_clo.id,NULL as closedby_id,
	ISNULL(own_mod.id,NULL as lastmodby_id,		
	*/
	--DATE DIMENSIONS	
	createddatetime = t2.createddatetime,
	createddate_id = t2.createddate_id,
	resolveddatetime = t2.resolveddatetime,
	resolveddate_id = t2.resolveddate_id,
	closeddatetime = t2.closeddatetime,
	closeddate_id = t2.closeddate_id,
	lastmoddatetime = t2.lastmoddatetime,
	lastmoddate_id = t2.lastmoddate_id,
	/**/

	--DEMI FACTS
	priority = t2.priority,
	isvip = t2.isvip,
	fcr = t2.fcr,
	breachstatus = t2.breachstatus,
	l1passed = t2.l1passed,
	l2passed = t2.l2passed,
	l3passed = t2.l3passed,		
	breachpassed = t2.breachpassed,
	response_breachpassed = t2.response_breachpassed,
	remoteresolution = t2.remoteresolution,
	numberofusersaffected = t2.numberofusersaffected,
	repeatissue = t2.repeatissue,

	--FACTS
	targetclockduration = t2.targetclockduration,
	totalrunningduration = t2.totalrunningduration,
	response_targetclockduration = t2.response_targetclockduration,
	response_totalrunningduration = t2.response_totalrunningduration,
	reopencount = t2.reopencount
FROM   
	DETAIL_incident T1
    JOIN 
    (


SELECT
	i.recid,
	i.number,
	
	i.subject,
	i.symptom,
	i.resolution,
	i.technicalresolution,
	--i.problemlink,
	--i.masterincidentlink,
	/**/
	--DIMENSIONS
	ISNULL(sta.id,NULL) as status_id,
	
	ISNULL(sou.id,NULL) as source_id,
	ISNULL(com.id,NULL) as company_id,
	ISNULL(typ.id,NULL) as typeofincident_id,
	ISNULL(owt.id,NULL) as ownerteam_id,
	ISNULL(sys.id,NULL) as system_id,
	ISNULL(bus.id,NULL) as businessunit_id,
	
	ISNULL(ser.id,NULL) as service_id,
	ISNULL(cat.id,NULL) as category_id,
	ISNULL(sub.id,NULL) as subcategory_id,

	--OWNER DIMENSIONS
	/*
	ISNULL(own.id,NULL) as owner_id,
	ISNULL(own_cre.id,NULL) as createdby_id,
	ISNULL(own_res.id,NULL) as resolvedby_id,
	ISNULL(own_clo.id,NULL) as closedby_id,
	ISNULL(own_mod.id,NULL) as lastmodby_id,		
	*/
	--DATE DIMENSIONS	
	createddatetime,
	ISNULL(cre_d.id,NULL) as createddate_id,
	ISNULL(resolveddatetime, closeddatetime) AS resolveddatetime,
	ISNULL(res_d.id,NULL) as resolveddate_id,
	closeddatetime,
	ISNULL(clo_d.id,NULL) as closeddate_id,
	lastmoddatetime,
	ISNULL(upd_d.id,NULL) as lastmoddate_id,
	/**/

	--DEMI FACTS
	CONVERT(INT,priority) as priority,
	CONVERT(INT,isvip) AS isvip,
	CONVERT(INT,fcr) as fcr,
	CONVERT(INT,breachstatus) as breachstatus,
	CONVERT(INT,l1passed) as l1passed,
	CONVERT(INT,l2passed) as l2passed,
	CONVERT(INT,l3passed) as l3passed,		
	CONVERT(INT,breachpassed) as breachpassed,
	CONVERT(INT,response_breachpassed) AS response_breachpassed,
	CONVERT(INT,remoteresolution) AS remoteresolution,
	numberofusersaffected,
	CONVERT(INT,repeatissue) AS repeatissue,

	--FACTS
	targetclockduration,
	totalrunningduration,
	response_targetclockduration,
	response_totalrunningduration,
	reopencount
	/**/
FROM 
	[TEMP_incident_combined] i

	--DIMENSIONS
	LEFT JOIN LOOKUP_status sta ON (sta.status = ISNULL(i.status,''))	
	LEFT JOIN LOOKUP_source sou ON (sou.source = ISNULL(i.source,''))
	LEFT JOIN LOOKUP_company com ON (com.company = ISNULL(i.company,''))
	LEFT JOIN LOOKUP_typeofincident typ ON (typ.typeofincident = ISNULL(i.typeofincident,''))
	LEFT JOIN LOOKUP_ownerteam owt ON (owt.ownerteam = ISNULL(i.ownerteam,''))
	LEFT JOIN LOOKUP_system sys ON (sys.system = ISNULL(i.system,''))
	LEFT JOIN LOOKUP_businessunit bus ON (bus.businessunit = ISNULL(i.businessunit,''))

	LEFT JOIN LOOKUP_service ser ON (ser.service = ISNULL(i.service,''))
	LEFT JOIN LOOKUP_category cat ON (cat.category = ISNULL(i.category,''))
	LEFT JOIN LOOKUP_subcategory sub ON (sub.subcategory = ISNULL(i.subcategory,''))		

	--OWNER DIMENSIONS
	/*
	LEFT JOIN LOOKUP_owner own ON (own.owner = i.owner)
	LEFT JOIN LOOKUP_owner own_cre ON (own_cre.owner = i.createdby)
	LEFT JOIN LOOKUP_owner own_res ON (own_res.owner = i.resolvedby)
	LEFT JOIN LOOKUP_owner own_clo ON (own_clo.owner = i.closedby)
	LEFT JOIN LOOKUP_owner own_mod ON (own_mod.owner = i.lastmodby)			
	*/
	--DATE DIMENSIONS
	LEFT JOIN LOOKUP_dates cre_d ON (cre_d.date = CONVERT(DATE,i.createddatetime))
	LEFT JOIN LOOKUP_dates res_d ON (res_d.date = CONVERT(DATE,ISNULL(resolveddatetime, closeddatetime)))
	LEFT JOIN LOOKUP_dates clo_d ON (clo_d.date = CONVERT(DATE,closeddatetime))
	LEFT JOIN LOOKUP_dates upd_d ON (upd_d.date = CONVERT(DATE,lastmoddatetime))


    ) T2
    ON (T1.recid = T2.recid AND T1.system_id = T2.system_id)