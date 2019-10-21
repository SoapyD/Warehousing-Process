UPDATE DETAIL_session
SET
	recid = T2.recid,
	sessionid = T2.sessionid,
	subject = T2.subject,
	technicianid = T2.technicianid,
	technicianname = T2.technicianname,
	technicianemail = T2.technicianemail,
    
	[Whats the Status of Your Problem?] = T2.[Whats the Status of Your Problem?],
	[Please Rate Your Remote Support Experience] = T2.[Please Rate Your Remote Support Experience],
	[Q2 score] = T2.[Q2 score],    
	Comments = T2.Comments,
	duplicate_check = T2.duplicate_check,


	incident_id = T2.incident_id,
	incident_number = T2.incident_number,
	customer = T2.customer,
	isvip = T2.isvip,

	--DIMENSION IDS
	system_id = T2.system_id,
	company_id = T2.company_id,
	businessunit_id = T2.businessunit_id,
	ownerteam_id = T2.ownerteam_id,
	databasename = T2.databasename,

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
    s.recid,
    s.sessionid,
    s.subject,
    s.technicianid,
    s.technicianname,
    s.technicianemail,
    
    s.[Whats the Status of Your Problem?],
    s.[Please Rate Your Remote Support Experience],
    s.[Q2 score],    
    s.comments AS Comments,
    s.duplicate_check,


    ISNULL(i.recid,NULL) AS incident_id,
    ISNULL(i.number,NULL) AS incident_number,
    ISNULL(i.customer,NULL) AS customer,
    ISNULL(i.isvip,NULL) AS isvip,

    --DIMENSION IDS
    ISNULL(sys.id,NULL) as system_id,
    ISNULL(i.company_id,NULL) AS company_id,
    ISNULL(i.businessunit_id,NULL) AS businessunit_id,
    ISNULL(i.ownerteam_id,NULL) AS ownerteam_id,
    s.databasename,

    --s.companyname,
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
    s.reconnectingtime

FROM 
    TEMP_session s   

    --DIMENSION IDS
    LEFT JOIN LOOKUP_system sys ON (sys.system = ISNULL(s.system,''))
    LEFT JOIN DETAIL_incident i ON (sys.id = i.system_id AND i.number = s.incidentnumber)

    --DATE JOINS
    LEFT JOIN LOOKUP_dates start_d ON (start_d.date = CONVERT(DATE,s.starttime))
    LEFT JOIN LOOKUP_dates end_d ON (end_d.date = CONVERT(DATE,s.endtime))
    LEFT JOIN LOOKUP_dates last_d ON (last_d.date = CONVERT(DATE,s.lastactiontime))

    ) T2
    ON (T1.recid = T2.recid)-- AND T1.system_id = T2.system_id)