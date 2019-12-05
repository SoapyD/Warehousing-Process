INSERT INTO TEMP_incident_combined
SELECT 
    inc.recid,
    inc.number,
    inc.system,
    inc.company,
    e.businessunit AS businessunit,
    CASE WHEN inc.isvip = 'False' THEN 0 ELSE 1 END as isvip,
    e.location,
    e.name AS customer,
    inc.subject,
    NULL AS symptom,
    inc.priority,
    inc.status,
    inc.source,
    inc.service,
    inc.category,
    inc.subcategory,
    inc.fcr,
    CASE WHEN inc.ownerteam = 'Service Desk' THEN 'ENWL Service Desk' ELSE inc.ownerteam END as ownerteam,
    REPLACE(inc.owner,'.',' ') as owner,
    --owneremail,    
    inc.causecode,
    inc.createdby,
    inc.createddatetime,
    NULL as resolvingteam,
    inc.resolvedby,
    inc.resolveddatetime,
    inc.closedby,
    inc.closeddatetime,
    inc.lastmodby,
    inc.lastmoddatetime,
    CASE
        WHEN ISNULL(res.breachpassed,0) = 1 THEN 4
        WHEN ISNULL(res.l3passed,0) = 1 THEN 3
        WHEN ISNULL(res.l2passed,0) = 1 THEN 2
        WHEN ISNULL(res.l1passed,0) = 1 THEN 1
        ELSE 0 
    END AS breachstatus,
    res.L1DateTime,
    CONVERT(INT,res.L1Passed) AS l1passed,
    res.L2DateTime,
    CONVERT(INT,res.L2Passed) AS l2passed,
    res.L3DateTime,
    CONVERT(INT,res.L3Passed) AS l3passed,
    res.BreachDateTime,
    CASE WHEN res.BreachPassed = 0 THEN 0 ELSE 1 END as breachpassed,
    res.targetclockduration,
    res.totalrunningduration,

    CASE WHEN resp.breachpassed = 0 THEN 0 ELSE 1 END AS response_breachpassed,
    resp.targetclockduration AS response_targetclockduration,
    resp.totalrunningduration AS response_totalrunningduration,

    inc.typeofincident,
    
    NULL AS reopencount,
    NULL AS remoteresolution,
    inc.resolution,
    NULL AS technicalresolution,
    NULL AS numberofusersaffected,
    NULL AS repeatissue,
    NULL AS problem_id,
    inc.masterincidentlink as parentincident_id

FROM
    dbo.enwl_incident inc
    LEFT JOIN dbo.enwl_employee e ON (e.recid = inc.profilelink)
    LEFT JOIN dbo.enwl_frs_data_escalation_watch res ON (res.recid = inc.resolutionesclink)
    LEFT JOIN dbo.enwl_frs_data_escalation_watch resp ON (resp.recid = inc.responseesclink)
