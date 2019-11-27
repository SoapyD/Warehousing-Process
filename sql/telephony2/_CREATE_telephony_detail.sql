IF OBJECT_ID(N'DETAIL_telephony') IS NOT NULL
    drop table DETAIL_telephony


CREATE TABLE [dbo].[DETAIL_telephony](
    --[ID] int not NULL,
    ID INT IDENTITY(1,1) NOT NULL,-- PRIMARY KEY,
    recid NVARCHAR(100),
    ddi NVARCHAR(30),
    ddi_id INT,
    ringtime INT,
    totalduration INT,
    agentid CHAR(15),
    agentname NVARCHAR(100),
    groupid INT,
    groupname NVARCHAR(300),
    datetime DATETIME,
    date_Format DATE NOT NULL,
    calltype NVARCHAR(20),
    source NVARCHAR(30)
) ON [PRIMARY]
;