INSERT INTO TEMP_incident_combined
SELECT 
    inc.sys_id,
    inc.number as number,
    inc.system,
    inc.company,
    CASE
    WHEN CHARINDEX('english-heritage', users.email) > 0 THEN 'English Heritage'
    WHEN CHARINDEX('historicengland', users.email) > 0 THEN 'Historic England'
    ELSE 'Other'
    END AS businessunit,
    CASE WHEN users.vip = 'False' THEN 0 ELSE 1 END as isvip,
    users.location,
    users.name AS customer,
    inc.subject,
    NULL AS symptom,
    NULL AS priority,
    inc.status,
    inc.source,
    NULL AS service,
    cat.category,
    inc.subcategory,
    NULL AS fcr,
    inc.ownerteam,
    REPLACE(inc.owner,'.',' ') as owner,
    --inc.owneremail,    
    NULL AS causecode,
    inc.createdby,
    inc.createddatetime,
    NULL as resolvingteam,
    NULL AS resolvedby,
    NULL AS resolveddatetime,
    CASE
        WHEN inc.lastmodby = 'system' THEN inc.owner
        ELSE inc.closedby
    END as closedby,
    inc.closeddatetime,
    inc.lastmodby,
    inc.lastmoddatetime,

    CASE
    WHEN ISNULL(tsk.hasbreached,'false') = 'true' THEN 4
    WHEN tsk.businesspercentage >= 90 THEN 3
    WHEN tsk.businesspercentage >= 75 THEN 2
    WHEN tsk.businesspercentage >= 25 THEN 1
    ELSE 0
    END AS breachstatus,
    NULL AS L1DateTime,
    CASE
    WHEN tsk.businesspercentage >= 25 THEN 1 ELSE 0 
    END AS L1Passed,
    NULL AS L2DateTime,
    CASE 
    WHEN tsk.businesspercentage >= 50 THEN 1 ELSE 0 
    END AS L2Passed,
    NULL AS L3DateTime,
    CASE 
    WHEN tsk.businesspercentage >= 90 THEN 1 ELSE 0
    END AS L3Passed,
    NULL AS BreachDateTime,
    CASE 
    WHEN ISNULL(tsk.hasbreached,'false') = 'true' THEN 1 ELSE 0
    END AS BreachPassed,
    NULL AS targetclockduration,
    tsk.businessduration AS totalrunningduration,

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
    dbo.he_sc_req_item inc

    LEFT JOIN dbo.he_sc_request req ON (req.sys_id = inc.requestnumber_id)

    LEFT JOIN dbo.he_sys_user users ON (users.sys_id = req.requestor_id)

    LEFT JOIN dbo.he_sc_cat_item cat ON (cat.sys_id = inc.subcategory_id)

    LEFT JOIN 
    (
        SELECT
            tsk.task_id,
            tsk.businesspercentage,
            tsk.businessduration,
            tsk.hasbreached
        FROM
        (
            SELECT
                tsk.task_id,
                tsk.businesspercentage,
                tsk.businessduration,
                tsk.hasbreached,
                COUNT(*) OVER (PARTITION BY task_id ORDER BY tsk.createddatetime) as row_count
            FROM
                dbo.he_task_sla tsk
            WHERE
                sladefinition LIKE ('HE RItm  - 5 Business Days%')
                AND stage <> 'Cancelled'
        ) tsk

        WHERE
            tsk.row_count = 1

    ) tsk ON (tsk.task_id = inc.sys_id)