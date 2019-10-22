

IF OBJECT_ID(N'TEMP_session') IS NOT NULL
    drop table TEMP_session

SELECT 
    --s.recid+'_s_'+ISNULL(CONVERT(NVARCHAR,cs.id),'') AS recid,
    CASE 
        WHEN he_ci.sessionid IS NOT NULL OR ISNULL(SPB.he_session,0) = 1 THEN s.recid+'_i_'+ISNULL(he_ci.incidentnumber,LEFT(s.existingticketno,20))+'_s_'+ISNULL(CONVERT(NVARCHAR,cs.id),'')
        WHEN fsa_ci.sessionid IS NOT NULL OR ISNULL(SPB.fsa_session,0) = 1  THEN s.recid+'_i_'+ISNULL(fsa_ci.incidentnumber,LEFT(s.existingticketno,20))+'_s_'+ISNULL(CONVERT(NVARCHAR,cs.id),'')
        WHEN mhclg_ci.sessionid IS NOT NULL OR ISNULL(SPB.mhclg_session,0) = 1  THEN s.recid+'_i_'+ISNULL(mhclg_ci.incidentnumber,LEFT(s.existingticketno,20))+'_s_'+ISNULL(CONVERT(NVARCHAR,cs.id),'')
        WHEN croy_ci.sessionid IS NOT NULL OR ISNULL(SPB.croydon_session,0) = 1  THEN s.recid+'_i_'+ISNULL(croy_ci.incidentnumber,LEFT(s.existingticketno,20))+'_s_'+ISNULL(CONVERT(NVARCHAR,cs.id),'')
        WHEN enwl_ci.sessionid IS NOT NULL OR ISNULL(SPB.enwl_session,0) = 1  THEN s.recid+'_i_'+ISNULL(enwl_ci.incidentnumber,LEFT(s.existingticketno,20))+'_s_'+ISNULL(CONVERT(NVARCHAR,cs.id),'')     
        ELSE s.recid+'_i_'+ISNULL(ci.incidentnumber,ISNULL(LEFT(s.existingticketno,20),''))+'_s_'+ISNULL(CONVERT(NVARCHAR,cs.id),'')
    end as recid,
    s.sessionid,
    --s.sessiontype,
    s.status,
    --s.contactname,
    s.email,
    s.subject,
    s.techniciangroup,
    s.technicianid,
    s.technicianname,
    s.technicianemail,
    ISNULL(spb.he_session,0) AS he_session,
    ISNULL(spb.fsa_session,0) AS fsa_session,
    ISNULL(spb.mhclg_session,0) AS mhclg_session,
    ISNULL(spb.croydon_session,0) AS croydon_session,
    ISNULL(spb.enwl_session,0) AS enwl_session,
    LEFT(s.existingticketno,20) AS existingticketno,

    t1.answertext AS "Whats the Status of Your Problem?",
    t2.answertext AS "Please Rate Your Remote Support Experience",
    t2.score AS [Q2 score],
    cs.comments,

    NULL AS incident_id,
    CASE 
        WHEN he_ci.sessionid IS NOT NULL OR ISNULL(SPB.he_session,0) = 1 THEN ISNULL(he_ci.incidentnumber,LEFT(s.existingticketno,20))
        WHEN fsa_ci.sessionid IS NOT NULL OR ISNULL(SPB.fsa_session,0) = 1  THEN ISNULL(fsa_ci.incidentnumber,LEFT(s.existingticketno,20))
        WHEN mhclg_ci.sessionid IS NOT NULL OR ISNULL(SPB.mhclg_session,0) = 1  THEN ISNULL(mhclg_ci.incidentnumber,LEFT(s.existingticketno,20))
        WHEN croy_ci.sessionid IS NOT NULL OR ISNULL(SPB.croydon_session,0) = 1  THEN ISNULL(croy_ci.incidentnumber,LEFT(s.existingticketno,20))
        WHEN enwl_ci.sessionid IS NOT NULL OR ISNULL(SPB.enwl_session,0) = 1  THEN ISNULL(enwl_ci.incidentnumber,LEFT(s.existingticketno,20))        
        ELSE ISNULL(ci.incidentnumber,LEFT(s.existingticketno,20))
    end as incidentnumber,
    CASE 
        WHEN he_ci.sessionid IS NOT NULL OR ISNULL(SPB.he_session,0) = 1 THEN 'he'
        WHEN fsa_ci.sessionid IS NOT NULL OR ISNULL(SPB.fsa_session,0) = 1  THEN 'fsa'
        WHEN mhclg_ci.sessionid IS NOT NULL OR ISNULL(SPB.mhclg_session,0) = 1  THEN 'mhclg'
        WHEN croy_ci.sessionid IS NOT NULL OR ISNULL(SPB.croydon_session,0) = 1  THEN 'croydon'
        WHEN enwl_ci.sessionid IS NOT NULL OR ISNULL(SPB.enwl_session,0) = 1  THEN 'enwl'
        ELSE 'heat'
    end as [system],
    s.companyname,
    CONVERT(NVARCHAR(100),'') AS sourced_companyname,
    s.databasename,
    ROW_NUMBER() OVER (PARTITION BY s.[sessionid], s.databasename ORDER BY s.starttime DESC) AS duplicate_check,

    --DATE DIMENSIONS
    s.starttime,
    s.endtime,
    s.lastactiontime,

    --FACTS
    s.connectingtime,
    s.waitingtime,
    s.totaltime,
    s.activetime,
    s.worktime,
    s.holdtime,
    s.transfertime,
    s.rebootingtime,
    s.reconnectingtime

INTO
    TEMP_session
FROM 
    LFLIVEEXTRACT_session s

    LEFT JOIN [LFLIVEEXTRACT_sessionpostback] spb ON (spb.sessionid = s.sessionid AND spb.databasename = s.databasename)
    
    LEFT JOIN [LFLIVEEXTRACT_sessionincident] ci ON (ci.sessionid = s.sessionid AND ci.databasename = s.databasename)
    
    LEFT JOIN [LFLIVEEXTRACT_he_sessionincident] he_ci ON (he_ci.sessionid = s.sessionid AND he_ci.databasename = s.databasename)
    
    LEFT JOIN [LFLIVEEXTRACT_fsa_sessionincident] fsa_ci ON (fsa_ci.sessionid = s.sessionid AND fsa_ci.databasename = s.databasename)
    
    LEFT JOIN [LFLIVEEXTRACT_mhclg_sessionincident] mhclg_ci ON (mhclg_ci.sessionid = s.sessionid AND mhclg_ci.databasename = s.databasename)

    LEFT JOIN [LFLIVEEXTRACT_croydon_sessionincident] croy_ci ON (croy_ci.sessionid = s.sessionid AND croy_ci.databasename = s.databasename)
    
    LEFT JOIN [LFLIVEEXTRACT_enwl_sessionincident] enwl_ci ON (enwl_ci.sessionid = s.sessionid AND enwl_ci.databasename = s.databasename)        


    /**/
    LEFT JOIN (
        SELECT
            *
        FROM
        (
            SELECT
                id,
                rescuesessionid,
                comments,
                nps,
                --submittedat,
                --ROW_NUMBER() OVER (PARTITION BY rescuesessionid, databasename order by submittedat DESC) as pos_count,
                databasename                
            FROM 
                [LFLIVEEXTRACT_completedsurvey] c
        ) cs 
        --WHERE
        --    ISNULL(cs.pos_count,-1) IN (1,-1)
    ) cs ON (s.sessionid = cs.rescuesessionid AND s.databasename = cs.databasename)
    

    LEFT JOIN (
        SELECT a.answertext, completedsurveyid, databasename
        FROM [LFLIVEEXTRACT_completedsurveyresponse] r 
        JOIN [dbo].[LFLIVEEXTRACT_answers] a ON a.id=r.answerid 
        WHERE
        r.questionid=1
    ) t1 ON (
    t1.completedsurveyid=cs.id AND 
    t1.databasename=cs.databasename)

    LEFT JOIN (
        SELECT a.answertext, completedsurveyid, databasename,
        CASE WHEN a.answertext = 'Excellent' Then 4 
        WHEN a.answertext = 'Good' Then 3 
        WHEN a.answertext = 'Mediocre' Then 2 
        WHEN a.answertext = 'Poor' Then 1
        END as score        
        FROM [LFLIVEEXTRACT_completedsurveyresponse] r 
        JOIN [dbo].[LFLIVEEXTRACT_answers] a ON a.id=r.answerid 
        WHERE
        r.questionid=2
    ) t2 ON (
    t2.completedsurveyid=cs.id AND 
    t2.databasename=cs.databasename)
