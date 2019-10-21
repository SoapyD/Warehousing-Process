/*
########################################################### MAIN
*/

IF OBJECT_ID(N'DETAIL_incident') IS NOT NULL
    drop table DETAIL_incident
/**/

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

	--NAME DIMENSIONS
	/*
	customer
	ISNULL(own.id,NULL) as owner_id,
	ISNULL(own_cre.id,NULL) as createdby_id,
	ISNULL(own_res.id,NULL) as resolvedby_id,
	ISNULL(own_clo.id,NULL) as closedby_id,
	ISNULL(own_mod.id,NULL) as lastmodby_id,		
	*/
	customer,
	owner,
	createdby,
	resolvedby,
	closedby,
	lastmodby,

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

INTO 
	DETAIL_incident 
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
	LEFT JOIN LOOKUP_location loc ON (loc.location = ISNULL(i.location,''))
	LEFT JOIN LOOKUP_causecode cau ON (cau.causecode = ISNULL(i.causecode,''))

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
	LEFT JOIN LOOKUP_dates bre_d ON (bre_d.date = CONVERT(DATE,breachdatetime))
	;