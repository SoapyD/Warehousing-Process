CREATE INDEX idx_cre_DETAIL_incident ON DETAIL_incident 
(
	
	createddate_id, lastmoddate_id
) 
INCLUDE (
recid, number, 
--subject, symptom, resolution, technicalresolution,
--problemlink, masterincidentlink,

resolveddate_id, closeddate_id,

typeofincident_id, system_id, status_id, source_id,
company_id, businessunit_id, ownerteam_id, 
service_id, category_id, subcategory_id,

--owner_id, createdby_id, resolvedby_id, closedby_id, lastmodby_id,	

fcr, breachstatus, 
L1Passed, L2Passed, L3Passed, 
breachpassed, targetclockduration, totalrunningduration, 
response_breachpassed, response_targetclockduration, response_totalrunningduration, 
reopencount, remoteresolution, numberofusersaffected, repeatissue
);

CREATE INDEX idx_res_DETAIL_incident ON DETAIL_incident 
(

	resolveddate_id, closeddate_id
) 
INCLUDE (
recid, number, 
--subject, symptom, resolution, technicalresolution,
--problemlink, masterincidentlink,

createddate_id, lastmoddate_id,

typeofincident_id, system_id, status_id, source_id,
company_id, businessunit_id, ownerteam_id, 
service_id, category_id, subcategory_id,

--owner_id, createdby_id, resolvedby_id, closedby_id, lastmodby_id,

fcr, breachstatus, 
L1Passed, L2Passed, L3Passed, 
breachpassed, targetclockduration, totalrunningduration, 
response_breachpassed, response_targetclockduration, response_totalrunningduration, 
reopencount, remoteresolution, numberofusersaffected, repeatissue

);
/**/