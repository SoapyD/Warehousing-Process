INSERT INTO TEMP_incident_combined
SELECT 
    inc.sys_id AS recid,
    inc.number,
    inc.system,
    inc.company,
    NULL AS businessunit, --MODDED
    CASE WHEN users.vip = 'False' THEN 0 ELSE 1 END as isvip,
    inc.location,
    users.name AS customer,
    inc.subject,
    NULL AS symptom,
    inc.priority,
    inc.status,
    inc.source,
    NULL AS service,
    inc.category,
    inc.subcategory,
    inc.fcr,  
    inc.ownerteam,
    REPLACE(inc.owner,'.',' ') as owner,
    --owneremail,    
    NULL AS causecode,
    inc.createdby,
    inc.createddatetime,
    NULL as resolvingteam,
    inc.resolvedby,
    inc.resolveddatetime,
    inc.closedby,
    inc.closeddatetime,
    inc.lastmodby,
    inc.lastmoddatetime,
    NULL AS breachstatus, --MODDED
    NULL AS L1DateTime,
    NULL AS L1Passed, --MODDED
    NULL AS L2DateTime,
    NULL AS L2Passed, --MODDED
    NULL AS L3DateTime,
    NULL AS L3Passed, --MODDED
    NULL AS BreachDateTime,
    NULL AS BreachPassed, --MODDED
    NULL AS targetclockduration,
    NULL AS totalrunningduration,

    NULL AS response_breached,
    NULL AS response_targetclockduration,
    NULL AS response_totalrunningduration,

    inc.typeofincident,
    reopencount,
    NULL AS remoteresolution,
    NULL AS resolution,
    NULL AS technicalresolution,
    NULL AS numberofusersaffected,
    NULL AS repeatissue,           
    problem_id,
    parentincident_id
FROM
    dbo.FSA_incident inc

    LEFT JOIN dbo.FSA_sys_user users ON (users.sys_id = inc.customer_id)

