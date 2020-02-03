INSERT INTO TEMP_incident_combined
SELECT 
    inc.sys_id AS recid,
    inc.number,
    inc.system,
    inc.company,
    CASE
    WHEN CHARINDEX('english-heritage', users.email) > 0 THEN 'English Heritage'
    WHEN CHARINDEX('historicengland', users.email) > 0 THEN 'Historic England'
    ELSE 'Other'
    END AS businessunit,
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
    ISNULL(lst_inc_tsk.ownerteam,inc.ownerteam) AS "ownerteam",
    ISNULL(lst_inc_tsk.owner,inc.owner) AS "owner", 
    NULL AS causecode,
    inc.createdby,
    inc.createddatetime,
    inc.resolvingteam,
    inc.resolvedby,
    inc.resolveddatetime,
    inc.closedby,
    inc.closeddatetime,
    inc.lastmodby,
    inc.lastmoddatetime,
    
    CASE
    WHEN ISNULL(exceptionagreed,NULL) = 'yes' THEN 0
    WHEN ISNULL(tsk.hasbreached,'false') = 'true' THEN 4
    WHEN tsk.businesspercentage >= 90 THEN 3
    WHEN tsk.businesspercentage >= 75 THEN 2
    WHEN tsk.businesspercentage >= 25 THEN 1
    ELSE 0
    END AS breachstatus,
    NULL AS L1DateTime,
    CASE
    WHEN ISNULL(exceptionagreed,NULL) = 'yes' THEN 0 
    WHEN tsk.businesspercentage >= 25 THEN 1 ELSE 0 
    END AS L1Passed,
    NULL AS L2DateTime,
    CASE 
    WHEN ISNULL(exceptionagreed,NULL) = 'yes' THEN 0
    WHEN tsk.businesspercentage >= 50 THEN 1 ELSE 0
    END AS L2Passed,
    NULL AS L3DateTime,
    CASE 
    WHEN ISNULL(exceptionagreed,NULL) = 'yes' THEN 0
    WHEN tsk.businesspercentage >= 90 THEN 1 ELSE 0 
    END AS L3Passed,
    NULL AS BreachDateTime,
    CASE 
    WHEN ISNULL(exceptionagreed,NULL) = 'yes' THEN 0
    WHEN ISNULL(tsk.hasbreached,'false') = 'true' THEN 1 ELSE 0
    END AS BreachPassed,
    NULL AS targetclockduration,
    tsk.businessduration AS totalrunningduration,

    NULL AS response_breached,
    NULL AS response_targetclockduration,
    NULL AS response_totalrunningduration,

    typeofincident,
    reopencount,
    NULL AS remoteresolution,
    NULL AS resolution,
    NULL AS technicalresolution,
    NULL AS numberofusersaffected,
    NULL AS repeatissue,      
    NULL AS breachreason,
    NULL AS cancellationreason,      
    NULL AS prioritychangecount,        
    problem_id,
    parentincident_id

FROM
    dbo.he_incident inc

    LEFT JOIN dbo.he_sys_user users ON (users.sys_id = inc.customer_id)

    LEFT JOIN
    (
        SELECT
            sys_id,
            incident_id,
            ownerteam,
            owner
        FROM
        (
            SELECT 
                sys_id,
                incident_id,
                ownerteam,
                owner,
                ROW_NUMBER() OVER (PARTITION BY tsk.incident_id ORDER BY ISNULL(tsk.closeddatetime,GETDATE()) DESC, createddatetime desc) as dup_check
            FROM
                dbo.he_incident_task tsk
            --WHERE
            --    status <> 'Completed'
            --WILL HAVE TO TURN THIS BACK ON WHEN I'VE HAD A CHAT WITH MARK ABOUT IT
        ) lst_inc_tsk
        WHERE
            lst_inc_tsk.dup_check = 1
    ) lst_inc_tsk ON (lst_inc_tsk.incident_id = inc.sys_id)


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
                (
                    sladefinition LIKE ('HE Priority 1 Resolution%')
                    OR
                    sladefinition LIKE ('HE Priority 2 Resolution%')
                    OR
                    sladefinition LIKE ('HE Priority 3 Resolution%')
                    OR
                    sladefinition LIKE ('HE Priority 4 Resolution%')
                )
                AND stage <> 'Cancelled'
        ) tsk

        WHERE
            tsk.row_count = 1

    ) tsk ON (tsk.task_id = inc.sys_id)