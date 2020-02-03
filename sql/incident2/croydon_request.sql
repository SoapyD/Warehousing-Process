INSERT INTO TEMP_incident_combined
SELECT 
    inc.sys_id,
    inc.number as number,
    inc.system,
    inc.company,
    NULL AS businessunit,
    CASE WHEN users.vip = 'False' THEN 0 ELSE 1 END as isvip,
    users.location,
    users.name AS customer,
    inc.subject,
    NULL AS symptom,
    inc.priority,
    inc.status,
    inc.source,
    NULL AS service,
    cat.category,
    inc.subcategory,
    NULL AS fcr,
    inc.ownerteam,
    REPLACE(inc.owner,'.',' ') as owner,
    --ISNULL(tsk.owneremail,NULL) AS owneremail, 
    NULL AS causecode,
    inc.createdby,
    inc.createddatetime,
    NULL as resolvingteam,
    NULL AS resolvedby,
    NULL AS resolveddatetime,
    inc.closedby,
    inc.closeddatetime,
    inc.lastmodby,
    inc.lastmoddatetime,
    NULL AS breachstatus,
    NULL AS L1DateTime,
    NULL AS L1Passed,
    NULL AS L2DateTime,
    NULL AS L2Passed,
    NULL AS L3DateTime,
    NULL AS L3Passed,
    NULL AS BreachDateTime,
    NULL AS BreachPassed,
    NULL AS targetclockduration,
    NULL AS totalrunningduration,

    NULL AS response_breached,
    NULL AS response_targetclockduration,
    NULL AS response_totalrunningduration,

    inc.typeofincident,
    NULL AS reopencount,
    NULL AS remoteresolution,
    NULL AS resolution,
    NULL AS technicalresolution,
    NULL AS numberofusersaffected,
    NULL AS repeatissue,            
    NULL AS breachreason,
    NULL AS cancellationreason,  
    NULL AS prioritychangecount,          
    NULL AS problem_id,
    NULL AS parentincident_id
FROM
    dbo.croydon_sc_req_item inc

    LEFT JOIN dbo.croydon_sc_request req ON (req.sys_id = inc.requestnumber_id)

    LEFT JOIN dbo.croydon_sys_user users ON (users.sys_id = req.requestor_id)

    LEFT JOIN dbo.croydon_sc_cat_item cat ON (cat.sys_id = inc.subcategory_id)