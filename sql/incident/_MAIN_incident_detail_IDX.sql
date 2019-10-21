CREATE INDEX idx_id_DETAIL_incident ON DETAIL_incident 
(	
	recid,
	system_id
);


CREATE INDEX idx_cre_DETAIL_incident ON DETAIL_incident 
(	
	createddate_id
) 
INCLUDE (
recid, number, 
--problemlink, masterincidentlink,
--subject, symptom, resolution, technicalresolution,

--DIMENSION IDS
system_id,
company_id,
businessunit_id, 
typeofincident_id,  
status_id, 
source_id, 
ownerteam_id, 
location_id,
causecode_id,
service_id, 
category_id, 
subcategory_id,

--DIMENSIONS
priority,
isvip,
breachstatus, L1Passed, L2Passed, L3Passed, 
breachpassed, response_breachpassed, 

remoteresolution, 
repeatissue, 
numberofusersaffected, 
reopen_check,

fcr, fcr_scoped, fcr_achieved,

--DATE DIMENSIONS
lastmoddate_id, resolveddate_id, closeddate_id,
--breachdate_id

--FACTS
targetclockduration, totalrunningduration,
response_targetclockduration, response_totalrunningduration, 
reopencount

--owner_id, createdby_id, resolvedby_id, closedby_id, lastmodby_id,	
);

CREATE INDEX idx_res_DETAIL_incident ON DETAIL_incident 
(

	resolveddate_id
) 
INCLUDE (
recid, number, 
--problemlink, masterincidentlink,
--subject, symptom, resolution, technicalresolution,

--DIMENSION IDS
system_id,
company_id,
businessunit_id, 
typeofincident_id,  
status_id, 
source_id, 
ownerteam_id, 
location_id,
causecode_id,
service_id, 
category_id, 
subcategory_id,

--DIMENSIONS
priority,
isvip,
breachstatus, L1Passed, L2Passed, L3Passed, 
breachpassed, response_breachpassed, 

remoteresolution, 
repeatissue, 
numberofusersaffected, 
reopen_check,

fcr, fcr_scoped, fcr_achieved,

--DATE DIMENSIONS
createddate_id, lastmoddate_id, closeddate_id,
--breachdate_id

--FACTS
targetclockduration, totalrunningduration,
response_targetclockduration, response_totalrunningduration, 
reopencount

--owner_id, createdby_id, resolvedby_id, closedby_id, lastmodby_id,	
);
/**/