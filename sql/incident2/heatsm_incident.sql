INSERT INTO TEMP_incident_combined
SELECT 
    inc.recid,
    inc.number,
    inc.system,
    inc.company,
    inc.businessunit,
    CASE WHEN inc.isvip = 'False' THEN 0 ELSE 1 END as isvip,
    e.location,
    e.name AS customer,
    inc.subject,
    inc.symptom,
    inc.priority,
    inc.status,
    inc.source,
    inc.service,
    inc.category,
    inc.subcategory,
    inc.fcr,
    inc.ownerteam,
    REPLACE(inc.owner,'.',' ') as owner,
    --owneremail,    
    inc.causecode,
    inc.createdby,
    inc.createddatetime,
    '                     ' as resolvingteam,
    inc.resolvedby,
    inc.resolveddatetime,
    inc.closedby,
    inc.closeddatetime,
    inc.lastmodby,
    inc.lastmoddatetime,
    CASE
        WHEN ISNULL(inc.breachpassed,0) = 1 THEN 4
        WHEN ISNULL(inc.l3passed,0) = 1 THEN 3
        WHEN ISNULL(inc.l2passed,0) = 1 THEN 2
        WHEN ISNULL(inc.l1passed,0) = 1 THEN 1
        ELSE 0 
    END AS breachstatus,
    inc.L1DateTime,
    CONVERT(INT,inc.L1Passed) AS l1passed,
    inc.L2DateTime,
    CONVERT(INT,inc.L2Passed) AS l2passed,
    inc.L3DateTime,
    CONVERT(INT,inc.L3Passed) AS l3passed,
    inc.BreachDateTime,
    CASE WHEN inc.BreachPassed = 0 THEN 0 ELSE 1 END as breachpassed,
    inc.targetclockduration,
    inc.totalrunningduration,

    CASE WHEN inc.response_breached = 0 THEN 0 ELSE 1 END  AS response_breachpassed,
    inc.response_targetclockduration,
    inc.response_totalrunningduration,

    inc.typeofincident,
    inc.reopencount,
    CASE WHEN inc.remoteresolution = 'Yes' THEN 1 ELSE 0 END as remoteresolution,
    inc.resolution,
    inc.technicalresolution,
    inc.numberofusersaffected,
    CASE WHEN inc.repeatissue = 'Yes' THEN 1 ELSE 0 END as repeatissue,
    inc.problemlink AS problem_id,
    inc.masterincidentlink as parentincident_id
FROM
    dbo.heatsm_incident inc
    LEFT JOIN dbo.heatsm_employee e ON (e.recid = inc.profilelink)