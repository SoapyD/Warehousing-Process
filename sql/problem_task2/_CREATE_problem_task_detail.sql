IF OBJECT_ID(N'DETAIL_problem_task') IS NOT NULL
    drop table DETAIL_problem_task


CREATE TABLE [dbo].[DETAIL_problem_task](

    ID INT IDENTITY(1,1) NOT NULL,-- PRIMARY KEY,
    recid CHAR(32) NULL,
    number NVARCHAR(30) NULL,
    system NVARCHAR(30) NULL,
    subject NVARCHAR(255) NULL,
    priority INT NULL,
    status NVARCHAR(40) NULL,
    ownerteam NVARCHAR(100) NULL,
    owner_Format NVARCHAR(100) NULL,
    createdby_Format NVARCHAR(100) NULL,
    createddatetime DATETIME NULL,
    createddate_Format DATE NOT NULL,
    resolvedby_Format NVARCHAR(100) NULL,
    resolveddatetime DATETIME NULL,
    resolveddate_Format DATE NULL,
    lastmodby_Format NVARCHAR(100) NULL,
    lastmoddatetime DATETIME NULL,
    lastmoddate_Format DATE NULL,
    [parentproblem_id] [char](32) NULL

) ON [PRIMARY]
;