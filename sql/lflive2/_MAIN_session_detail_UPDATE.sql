UPDATE DETAIL_session
SET
	recid = T2.recid,
	sessionid = T2.sessionid,
	subject = T2.subject,
    /*
	technicianid = T2.technicianid,
	technicianname = T2.technicianname,
	technicianemail = T2.technicianemail,
    */
	[Whats the Status of Your Problem?] = T2.[Whats the Status of Your Problem?],
	[Please Rate Your Remote Support Experience] = T2.[Please Rate Your Remote Support Experience],
	[Q2 score] = T2.[Q2 score],    
	Comments = T2.Comments,
	duplicate_check = T2.duplicate_check,


	incident_id = T2.incident_id,
	--incident_number = T2.incident_number,

	--DIMENSION IDS
	system_id = T2.system_id,
    technician_id = T2.technician_id,
	databasename = T2.databasename,

    --DIMENSIONS
	status = T2.status,
	techniciangroup = T2.techniciangroup,
	he_session = T2.he_session,
	fsa_session = T2.fsa_session,
	mhclg_session = T2.mhclg_session,
	croydon_session = T2.croydon_session,
	enwl_session = T2.enwl_session,

	--DATE DIMENSIONS
	starttime = T2.starttime,
	startdate_id = T2.startdate_id,
	endtime = T2.endtime,
	enddate_id = T2.enddate_id,    
	lastactiontime = T2.lastactiontime,
	lastactiondate_id = T2.lastactiondate_id,

	--FACTS
	connectingtime = T2.connectingtime,
	waitingtime = T2.waitingtime,
	totaltime = T2.totaltime,
	activetime = T2.activetime,
	worktime = T2.worktime,
	holdtime = T2.holdtime,
	transfertime = T2.transfertime,
	rebootingtime = T2.rebootingtime

FROM   
	DETAIL_session T1
    JOIN 
    (


SELECT
    --s.recid,
    s.recid as recid,
    s.sessionid,
    s.subject,
    /*
    s.technicianid,
    s.technicianname,
    s.technicianemail,
    */
    
    s.[Whats the Status of Your Problem?],
    s.[Please Rate Your Remote Support Experience],
    s.[Q2 score],    
    s.comments AS Comments,


    ISNULL(i.recid,NULL) AS incident_id,
    --ISNULL(i.number,NULL) AS incident_number,

    --DIMENSION IDS
    ISNULL(sys.id,NULL) as system_id,
    ISNULL(rdb.id,NULL) as technician_id,      
    s.databasename,

    --DIMENSIONS
    s.status,
    s.techniciangroup,
    he_session,
    fsa_session,
    mhclg_session,
    croydon_session,
    enwl_session,

    --DATE DIMENSIONS
    s.starttime,
    start_d.id AS startdate_id,
    s.endtime,
    end_d.id AS enddate_id,    
    s.lastactiontime,
    last_d.id AS lastactiondate_id,

    --FACTS
    s.connectingtime,
    s.waitingtime,
    s.totaltime,
    s.activetime,
    s.worktime,
    s.holdtime,
    s.transfertime,
    s.rebootingtime,
    s.reconnectingtime,

    --s.duplicate_check,
    ROW_NUMBER() OVER (PARTITION BY s.[sessionid], s.databasename
        ORDER BY s.starttime DESC, s.recid DESC --RECID
        ) AS duplicate_check

FROM 
    TEMP_session s   

    --DIMENSION IDS
    LEFT JOIN LOOKUP_system sys ON (sys.system = ISNULL(s.system,''))
    LEFT JOIN DETAIL_incident i ON (sys.id = i.system_id AND i.number = s.incidentnumber)

    --DATE JOINS
    LEFT JOIN LOOKUP_dates start_d ON (start_d.date = CONVERT(DATE,s.starttime))
    LEFT JOIN LOOKUP_dates end_d ON (end_d.date = CONVERT(DATE,s.endtime))
    LEFT JOIN LOOKUP_dates last_d ON (last_d.date = CONVERT(DATE,s.lastactiontime))

    --OWNER JOINS 
    LEFT JOIN LOOKUP_owner rdb ON (rdb.owner = ISNULL(s.technicianname,'')) 

    ) T2
    ON (T1.recid = T2.recid)-- AND T1.system_id = T2.system_id)