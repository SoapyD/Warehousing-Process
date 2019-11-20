UPDATE DETAIL_session
SET
	recid = T2.recid,
	sessionid = T2.sessionid,
	databasename = T2.databasename,

	subject = T2.subject,
	[Whats the Status of Your Problem?] = T2.[Whats the Status of Your Problem?],
	[Please Rate Your Remote Support Experience] = T2.[Please Rate Your Remote Support Experience],
	[Q2 score] = T2.[Q2 score],    
	Comments = T2.Comments,

    --DIMENSIONS
	status = T2.status,
	techniciangroup = T2.techniciangroup,
	he_session = T2.he_session,
	fsa_session = T2.fsa_session,
	mhclg_session = T2.mhclg_session,
	croydon_session = T2.croydon_session,
	enwl_session = T2.enwl_session,

    --FACTS
    connectingtime = T2.connectingtime,
    waitingtime = T2.waitingtime,
    totaltime = T2.totaltime,
    activetime = T2.activetime,
    worktime = T2.worktime,
    holdtime = T2.holdtime,
    transfertime = T2.transfertime,
    rebootingtime = T2.rebootingtime,

    technicianname_Format = T2.technicianname_Format,

	--DATE DIMENSIONS
	starttime = T2.starttime,
	startdate_Format = T2.startdate_Format,
	endtime = T2.endtime,
	enddate_Format = T2.enddate_Format,    
	lastactiontime = T2.lastactiontime,
	lastactiondate_Format = T2.lastactiondate_Format,


    system = T2.system,
    session_incidentnumber = T2.session_incidentnumber,
    incident_id = T2.incident_id,

	duplicate_check = T2.duplicate_check

FROM   
	DETAIL_session T1
    JOIN 
    (


SELECT
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

    ) T2
    ON (T1.recid = T2.recid)-- AND T1.system_id = T2.system_id)