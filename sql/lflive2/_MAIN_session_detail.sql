
INSERT INTO DETAIL_session
SELECT 
    NULLIF(s.recid+'_i_'+ISNULL(s.incidentnumber,'zz'),'') as recid
    ,NULLIF(s.sessionid,'') AS sessionid
    ,s.databasename AS databasename
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
    ,s.connectingtime AS connectingtime
    ,s.waitingtime AS waitingtime
    ,s.totaltime AS totaltime
    ,s.activetime AS activetime
    ,s.worktime AS worktime
    ,s.holdtime AS holdtime
    ,s.transfertime AS transfertime
    ,s.rebootingtime AS rebootingtime
    ,s.reconnectingtime AS reconnectingtime

    ,replace(LEFT(s.technicianname,len(s.technicianname)-charindex('@',reverse(s.technicianname))),'.',' ') AS [technicianname_Format]

    --DATE DIMENSIONS
    ,NULLIF(s.starttime,'') AS starttime
    ,NULLIF(CONVERT(DATE,s.starttime),'') AS startdate_Format
    ,NULLIF(s.endtime,'') AS endtime
    ,NULLIF(CONVERT(DATE,s.endtime),'') AS enddate_Format    
    ,NULLIF(s.lastactiontime,'') AS lastactiontime
    ,NULLIF(CONVERT(DATE,s.lastactiontime),'') AS lastactiondate_Format 

    ,NULLIF(s.system,'') AS system
    ,NULLIF(s.incidentnumber,'') AS session_incidentnumber
    ,ISNULL(i.id,NULL) AS incident_id

    ,ROW_NUMBER() OVER (PARTITION BY s.[sessionid], s.databasename
        ORDER BY s.starttime DESC, s.recid DESC --RECID
        ) AS duplicate_check

    --WILL PROBABLY NEED TO INC ID ADDED BACK INTO THE ROW NUMBER CHECKER? MAYBE

FROM 
    TEMP_session s   

    LEFT JOIN DETAIL_incident i ON (i.system = s.system AND i.number = s.incidentnumber)

ORDER BY
    s.starttime



ALTER TABLE [dbo].[DETAIL_session] ADD CONSTRAINT PK_session_ID PRIMARY KEY (ID);

CREATE NONCLUSTERED INDEX IDX_check_session ON [dbo].[DETAIL_session] ([recid]) 
INCLUDE ([sessionid],[databasename],[technicianname_Format],[startdate_Format],[incident_id],[duplicate_check]); --CHECKED WHEN UPDATING RECORDS


CREATE NONCLUSTERED INDEX IDX_created_session
ON [dbo].[DETAIL_session] ([duplicate_check],[startdate_Format])
INCLUDE ([technicianname_Format])

CREATE NONCLUSTERED INDEX IDX_org_session
ON [dbo].[DETAIL_session] (incident_id, duplicate_check)
INCLUDE (technicianname_Format, startdate_Format)


/*
CREATE NONCLUSTERED INDEX IDX_detail_session
ON [dbo].[DETAIL_session] (id)
INCLUDE (
    recid
    ,sessionid
    ,databasename
    ,subject
    ,[Whats the Status of Your Problem?]
    ,[Please Rate Your Remote Support Experience]
    ,[Q2 score]
    ,Comments
    --DIMENSIONS
    ,status
    ,techniciangroup
    ,he_session
    ,fsa_session
    ,mhclg_session
    ,croydon_session
    ,enwl_session

    --FACTS
    ,connectingtime
    ,waitingtime
    ,totaltime
    ,activetime
    ,worktime
    ,holdtime
    ,transfertime
    ,rebootingtime
    ,reconnectingtime

    --DATE DIMENSIONS
    ,starttime
    ,startdate_Format
    ,endtime
    ,enddate_Format    
    ,lastactiontime
    ,lastactiondate_Format 

    ,system
    ,session_incidentnumber
)

*/




