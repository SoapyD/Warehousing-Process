UPDATE DETAIL_incident
SET
	recid = t2.recid,
	number = t2.number,
	problem_id = t2.problem_id,
	parentincident_id = t2.parentincident_id,	
	
	subject = t2.subject,
	symptom = t2.symptom,
	resolution = t2.resolution,
	technicalresolution = t2.technicalresolution,
	--t2.problemlink,
	--t2.masterincidentlink,

	--DIMENSION IDS
	system_id = t2.system_id,
	company_id = t2.company_id,
	businessunit_id = t2.businessunit_id,
	typeofincident_id = t2.typeofincident_id,

	status_id = t2.status_id,
	source_id = t2.source_id,
	ownerteam_id = t2.ownerteam_id,
	location_id = t2.location_id,
	causecode_id = t2.causecode_id,
	
	service_id = t2.service_id,
	category_id = t2.category_id,
	subcategory_id = t2.subcategory_id,

	--DIMENSIONS
	priority = t2.priority,
	isvip = t2.isvip,
	breachstatus = t2.breachstatus,
	l1passed = t2.l1passed,
	l2passed = t2.l2passed,
	l3passed = t2.l3passed,		
	breachpassed = t2.breachpassed,
	response_breachpassed = t2.response_breachpassed,
	remoteresolution = t2.remoteresolution,
	repeatissue = t2.repeatissue,
	numberofusersaffected = t2.numberofusersaffected,
	reopen_check = t2.reopen_check,
	
	fcr = t2.fcr,
	fcr_scoped = t2.fcr_scoped,
	fcr_achieved = t2.fcr_achieved,


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
	breachdatetime = t2.breachdatetime,
	breachdate_id = t2.breachdate_id,

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
	i.problem_id,
	i.parentincident_id,

	i.subject,
	i.symptom,
	i.resolution,
	i.technicalresolution,


	--DIMENSION IDS
	ISNULL(sys.id,NULL) as system_id,
	ISNULL(com.id,NULL) as company_id,
	ISNULL(bus.id,NULL) as businessunit_id,
	ISNULL(typ.id,NULL) as typeofincident_id,

	ISNULL(sta.id,NULL) as status_id,
	ISNULL(sou.id,NULL) as source_id,
	ISNULL(owt.id,NULL) as ownerteam_id,
	ISNULL(loc.id,NULL) as location_id,	
	ISNULL(cau.id,NULL) as causecode_id,

	ISNULL(ser.id,NULL) as service_id,
	ISNULL(cat.id,NULL) as category_id,
	ISNULL(sub.id,NULL) as subcategory_id,

	--DIMENSIONS
	CONVERT(INT,priority) as priority,
	CONVERT(INT,isvip) AS isvip,
	CONVERT(INT,breachstatus) as breachstatus,
	CONVERT(INT,l1passed) as l1passed,
	CONVERT(INT,l2passed) as l2passed,
	CONVERT(INT,l3passed) as l3passed,		
	CONVERT(INT,breachpassed) as breachpassed,
	CONVERT(INT,response_breachpassed) AS response_breachpassed,
	CONVERT(INT,remoteresolution) AS remoteresolution,
	CONVERT(INT,repeatissue) AS repeatissue,
	
	CASE WHEN numberofusersaffected IS NULL THEN '' 
	ELSE numberofusersaffected END AS numberofusersaffected,
	
	CASE WHEN ISNULL(reopencount,0) > 0 THEN 1
	ELSE 0 END as reopen_check,

	CONVERT(INT,fcr) as fcr,
    CASE
	WHEN 
	typ.typeofincident = 'Failure' AND
	sou.source IN ('Phone','LF Live','Chat','Chat Media','littlefish live') AND
	com.company NOT IN ('Littlefish') AND
	sta.status IN ('Closed','Resolved')
	THEN 1 ELSE 0
	END as fcr_scoped,
    CASE
	WHEN 
	i.fcr = 1 AND
	typ.typeofincident = 'Failure' AND
	sou.source IN ('Phone','LF Live','Chat','Chat Media','littlefish live') AND
	com.company NOT IN ('Littlefish') AND
	sta.status IN ('Closed','Resolved')
	THEN 1 ELSE 0
	END as fcr_achieved,

	--OWNER DIMENSIONS
	/*
	customer
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
	breachdatetime,
	ISNULL(bre_d.id,NULL) as breachdate_id,

	--FACTS
	targetclockduration,
	totalrunningduration,
	response_targetclockduration,
	response_totalrunningduration,
	reopencount


    ) T2
    ON (T1.recid = T2.recid AND T1.system_id = T2.system_id)