

SELECT 
    --s.recid,
    --NULLIF(s.recid,'') AS recid
    NULLIF(s.recid+'_i_'+ISNULL(s.incidentnumber,'zz'),'') as recid
    ,NULLIF(s.sessionid,'') AS sessionid
    ,NULLIF(s.databasename,'') AS databasename
    ,NULLIF(s.subject,'') AS subject
    ,NULLIF(s.[Whats the Status of Your Problem?],'') AS [Whats the Status of Your Problem?]
    ,NULLIF(s.[Please Rate Your Remote Support Experience],'') AS [Please Rate Your Remote Support Experience]
    ,NULLIF(s.[Q2 score],'') AS [Q2 score]
    ,NULLIF(s.comments,'') AS Comments
    --DIMENSIONS
    ,NULLIF(s.status,'') AS status
    ,NULLIF(s.techniciangroup,'') AS techniciangroup
    ,NULLIF(he_session,'') AS he_session
    ,NULLIF(fsa_session,'') AS fsa_session
    ,NULLIF(mhclg_session,'') AS mhclg_session
    ,NULLIF(croydon_session,'') AS croydon_session
    ,NULLIF(enwl_session,'') AS enwl_session

    --FACTS
    ,NULLIF(s.connectingtime,'') AS connectingtime
    ,NULLIF(s.waitingtime,'') AS waitingtime
    ,NULLIF(s.totaltime,'') AS totaltime
    ,NULLIF(s.activetime,'') AS activetime
    ,NULLIF(s.worktime,'') AS worktime
    ,NULLIF(s.holdtime,'') AS holdtime
    ,NULLIF(s.transfertime,'') AS transfertime
    ,NULLIF(s.rebootingtime,'') AS rebootingtime
    ,NULLIF(s.reconnectingtime,'') AS reconnectingtime

    ,replace(LEFT(s.technicianname,len(s.technicianname)-charindex('@',reverse(s.technicianname))),'.',' ') AS [technicianname_Format]

    --DATE DIMENSIONS
    ,NULLIF(s.starttime,'') AS starttime
    ,NULLIF(CONVERT(DATE,s.starttime),'') AS startdate_Format
    ,NULLIF(s.endtime,'') AS endtime
    ,NULLIF(CONVERT(DATE,s.endtime),'') AS enddate_Format    
    ,NULLIF(s.lastactiontime,'') AS lastactiontime
    ,NULLIF(CONVERT(DATE,s.lastactiontime),'') AS lastactiondate_Format 

    ,NULLIF(s.incidentnumber,'') AS session_incidentnumber
    ,ISNULL(i.id,NULL) AS incident_id

    ,ROW_NUMBER() OVER (PARTITION BY s.[sessionid], s.databasename
        ORDER BY s.starttime DESC, s.recid DESC --RECID
        ) AS duplicate_check

    --WILL PROBABLY NEED TO INC ID ADDED BACK INTO THE ROW NUMBER CHECKER? MAYBE

INTO
    DETAIL_session
FROM 
    TEMP_session s   

    --DIMENSION IDS
    --LEFT JOIN LOOKUP_system sys ON (sys.system = ISNULL(s.system,''))
    LEFT JOIN DETAIL_incident i ON (sys.id = i.system_id AND i.number = s.incidentnumber)

ORDER BY
    s.starttime



ALTER TABLE [dbo].[DETAIL_session] ADD CONSTRAINT PK_session_ID PRIMARY KEY ([startdate_Format],ID);