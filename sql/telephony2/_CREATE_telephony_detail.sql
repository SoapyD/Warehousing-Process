IF OBJECT_ID(N'DETAIL_telephony') IS NOT NULL
    drop table DETAIL_telephony


CREATE TABLE [dbo].[DETAIL_telephony](
    --[ID] int not NULL,
    ID INT IDENTITY(1,1) NOT NULL,-- PRIMARY KEY,
    recid NVARCHAR(100) NULL,
    ddi NVARCHAR(30) NULL,
    ddi_id INT NULL,
    ringtime INT,
    totalduration INT,
    agentid CHAR(15) NULL,
    agentname NVARCHAR(100) NULL,
    groupid INT NULL,
    groupname NVARCHAR(300) NULL,
    datetime DATETIME NULL,
    date_Format DATE NOT NULL,
    calltype NVARCHAR(20) NULL,
    source NVARCHAR(30) NULL
) ON [PRIMARY]
;