CREATE TABLE TEMP_problem_task_combined (
    recid CHAR(32),
    number NVARCHAR(30),
    system NVARCHAR(30),
    subject NVARCHAR(255),
    priority INT,
    status NVARCHAR(40),
    ownerteam NVARCHAR(100),
    owner NVARCHAR(100),
    createdby NVARCHAR(100),
    createddatetime DATETIME,
    resolvedby NVARCHAR(100),
    resolveddatetime DATETIME,
    lastmodby NVARCHAR(100),
    lastmoddatetime DATETIME,
    [parentproblem_id] [char](32)
)