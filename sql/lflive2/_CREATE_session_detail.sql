IF OBJECT_ID(N'DETAIL_session') IS NOT NULL
    drop table DETAIL_session


CREATE TABLE [dbo].[DETAIL_session](
    ID INT IDENTITY(1,1) NOT NULL

    ,recid NVARCHAR(200) NULL
    ,sessionid BIGINT NULL
    ,databasename TINYINT NULL
    ,subject NVARCHAR(255) NULL
    ,[Whats the Status of Your Problem?] NVARCHAR(50) NULL
    ,[Please Rate Your Remote Support Experience] NVARCHAR(50) NULL
    ,[Q2 score] TINYINT NULL
    ,Comments NVARCHAR(255) NULL
    --DIMENSIONS
    ,status NVARCHAR(50) NULL
    ,techniciangroup NVARCHAR(255) NULL
    ,he_session TINYINT NULL
    ,fsa_session TINYINT NULL
    ,mhclg_session TINYINT NULL
    ,croydon_session TINYINT NULL
    ,enwl_session TINYINT NULL
    --FACTS
    ,connectingtime INT NULL
    ,waitingtime INT NULL
    ,totaltime INT NULL
    ,activetime INT NULL
    ,worktime INT NULL
    ,holdtime INT NULL
    ,transfertime INT NULL
    ,rebootingtime INT NULL
    ,reconnectingtime INT NULL

    ,technicianname_Format NVARCHAR(100) NULL

    --DATE DIMENSIONS
    ,starttime DATETIME NULL
    ,startdate_Format DATE NOT NULL
    ,endtime DATETIME NULL
    ,enddate_Format DATE NULL    
    ,lastactiontime DATETIME NULL
    ,lastactiondate_Format DATE NULL 

    ,system NVARCHAR(30) NULL
    ,session_incidentnumber NVARCHAR(100) NULL
    ,incident_id INT NULL

    ,duplicate_check INT NULL


) ON [PRIMARY]
;