

IF OBJECT_ID(N'DETAIL_session') IS NOT NULL
    drop table DETAIL_session

SELECT 
    --s.recid,
    s.recid+'_i_'+ISNULL(i.number,'zz') as recid,
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
    ISNULL(i.number,NULL) AS incident_number,
    ISNULL(i.customer,NULL) AS customer,
    ISNULL(i.isvip,NULL) AS isvip,

    --DIMENSION IDS
    ISNULL(sys.id,NULL) as system_id,
    ISNULL(i.company_id,NULL) AS company_id,
    ISNULL(i.businessunit_id,NULL) AS businessunit_id,
    ISNULL(i.ownerteam_id,NULL) AS ownerteam_id,
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
    --IF NO INCIDENT NUMBER APPEARS, MARK IT AS ZZ SO IT'LL APPEAR AT THE BOTTOM OF ANY DUPLICATE CORRECTIONS
    ROW_NUMBER() OVER (PARTITION BY s.[sessionid], s.databasename
        ORDER BY s.starttime DESC, s.recid+'_i_'+ISNULL(i.number,'zz') --RECID
        ) AS duplicate_check

INTO
    DETAIL_session
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
