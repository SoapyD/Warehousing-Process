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

	i.customer,
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
	ISNULL(own1.id,own2.id) as owner_id,
	ISNULL(cre1.id,cre2.id) as createdby_id,
	ISNULL(res1.id,res2.id) as resolvedby_id,
	ISNULL(clo1.id,clo2.id) as closedby_id,
	ISNULL(las1.id,las2.id) as lastmodby_id,

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
	--OWNER
	LEFT JOIN LOOKUP_owner own1 ON (
		SUBSTRING(REPLACE(i.owner,'.',' '), 1, CHARINDEX('@', i.owner)) = own1.owner+'@'
		)

	LEFT JOIN LOOKUP_owner own2 ON (
		ISNULL(REPLACE(i.owner,'.',' '),'') = own2.owner
		)

	--CREATED
	LEFT JOIN LOOKUP_owner cre1 ON (
		SUBSTRING(REPLACE(i.createdby,'.',' '), 1, CHARINDEX('@', i.owner)) = cre1.owner+'@'
		)

	LEFT JOIN LOOKUP_owner cre2 ON (
		ISNULL(REPLACE(i.createdby,'.',' '),'') = cre2.owner
		)

	--RESOLVED
	LEFT JOIN LOOKUP_owner res1 ON (
		SUBSTRING(REPLACE(ISNULL(i.resolvedby,i.closedby),'.',' '), 1, CHARINDEX('@', i.owner)) = res1.owner+'@'
		)

	LEFT JOIN LOOKUP_owner res2 ON (
		ISNULL(REPLACE(ISNULL(i.resolvedby,i.closedby),'.',' '),'') = res2.owner
		)

	--CLOSED
	LEFT JOIN LOOKUP_owner clo1 ON (
		SUBSTRING(REPLACE(i.closedby,'.',' '), 1, CHARINDEX('@', i.owner)) = clo1.owner+'@'
		)

	LEFT JOIN LOOKUP_owner clo2 ON (
		ISNULL(REPLACE(i.closedby,'.',' '),'') = clo2.owner
		)

	--LASTMOD
	LEFT JOIN LOOKUP_owner las1 ON (
		SUBSTRING(REPLACE(i.lastmodby,'.',' '), 1, CHARINDEX('@', i.owner)) = las1.owner+'@'
		)

	LEFT JOIN LOOKUP_owner las2 ON (
		ISNULL(REPLACE(i.lastmodby,'.',' '),'') = las2.owner
		)

	--DATE DIMENSIONS
	LEFT JOIN LOOKUP_dates cre_d ON (cre_d.date = CONVERT(DATE,i.createddatetime))
	LEFT JOIN LOOKUP_dates res_d ON (res_d.date = CONVERT(DATE,ISNULL(resolveddatetime, closeddatetime)))
	LEFT JOIN LOOKUP_dates clo_d ON (clo_d.date = CONVERT(DATE,closeddatetime))
	LEFT JOIN LOOKUP_dates upd_d ON (upd_d.date = CONVERT(DATE,lastmoddatetime))
	LEFT JOIN LOOKUP_dates bre_d ON (bre_d.date = CONVERT(DATE,breachdatetime))
	;