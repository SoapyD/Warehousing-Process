
/*
IF OBJECT_ID(N'DETAIL_orgunit') IS NOT NULL
    drop table DETAIL_orgunit
*/

IF OBJECT_ID(N'DETAIL_orgunit') IS NULL
CREATE TABLE [dbo].[DETAIL_orgunit](

    ID INT IDENTITY(1,1) NOT NULL,-- PRIMARY KEY,
    name NVARCHAR(100) NULL,
    supportingsite NVARCHAR(100) NULL,
    accountmanagername NVARCHAR(100) NULL,
    createddatetime DATETIME NULL,
    lastmoddatetime DATETIME NULL,
    grouping NVARCHAR(100) NULL,
    ddi NVARCHAR(100) NULL,
    ringcentralname NVARCHAR(100) NULL,
    ringcentral_activationdatetime DATETIME NULL,
    telephony_active NVARCHAR(100) NULL,
    telephony_target FLOAT NULL

) ON [PRIMARY]
;