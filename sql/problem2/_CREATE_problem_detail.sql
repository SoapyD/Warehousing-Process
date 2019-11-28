IF OBJECT_ID(N'DETAIL_problem') IS NOT NULL
    drop table DETAIL_problem


CREATE TABLE [dbo].[DETAIL_problem](
    ID INT IDENTITY(1,1) NOT NULL,-- PRIMARY KEY,
    recid CHAR(32) NULL,
    number NVARCHAR(30) NULL,
    system NVARCHAR(30) NULL,
    company NVARCHAR(100) NULL,
    company_id INT NULL,    
    location NVARCHAR(100) NULL,
    customer NVARCHAR(100) NULL,
    subject NVARCHAR(255) NULL,
    priority INT NULL,
    status NVARCHAR(40) NULL,
    source NVARCHAR(40) NULL,
    category NVARCHAR(60) NULL,
    subcategory NVARCHAR(200) NULL,
    ownerteam NVARCHAR(100) NULL,
    owner_Format NVARCHAR(100) NULL,
    problemsource NVARCHAR(40) NULL,
    createdby_Format NVARCHAR(100) NULL,
    createddatetime DATETIME NULL,
    createddate_Format DATE NOT NULL,
    closedby_Format NVARCHAR(100) NULL,
    closeddatetime DATETIME NULL,
    closeddate_Format DATE NULL,
    lastmodby_Format NVARCHAR(100) NULL,
    lastmoddatetime DATETIME NULL,
    lastmoddate_Format DATE NULL,
    duedate DATE NULL,
    worknotes NVARCHAR(500) NULL,
    businessunit NVARCHAR(100) NULL
) ON [PRIMARY]
;