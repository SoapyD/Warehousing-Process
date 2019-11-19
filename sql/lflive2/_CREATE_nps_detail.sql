IF OBJECT_ID(N'DETAIL_nps') IS NOT NULL
    drop table DETAIL_nps


CREATE TABLE [dbo].[DETAIL_nps](
    ID INT IDENTITY(1,1) NOT NULL
    ,[recid] NVARCHAR(200) NULL
    ,databasename TINYINT NULL
    ,type VARCHAR(8) NULL
    ,surveyid INT NULL 
    ,rescuesessionid BIGINT NULL
    ,comments NVARCHAR(250) NULL
    ,nps TINYINT NULL
    ,npstype VARCHAR(9) NULL
    ,technicianname_Format NVARCHAR(100) NULL
    ,submittedat DATETIME NULL
    ,submittedat_Format DATE NULL
    ,nps_incidentnumber NVARCHAR(30) NULL
    ,incident_id INT NULL
    ,duplicate_check INT NULL
) ON [PRIMARY]
;