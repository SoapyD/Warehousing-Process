CREATE TABLE TEMP_problem_combined (
    recid CHAR(32),
    number NVARCHAR(30),
    system NVARCHAR(30),
    company NVARCHAR(100),
    location NVARCHAR(100),
    customer NVARCHAR(100),
    subject NVARCHAR(255),
    priority INT,
    status NVARCHAR(40),
    source NVARCHAR(40),
    category NVARCHAR(60),
    subcategory NVARCHAR(200),
    ownerteam NVARCHAR(100),
    owner NVARCHAR(100),
    problemsource NVARCHAR(40),
    createdby NVARCHAR(100),
    createddatetime DATETIME,
    closedby NVARCHAR(100),
    closeddatetime DATETIME,
    lastmodby NVARCHAR(100),
    lastmoddatetime DATETIME,
    duedate DATE,
    worknotes NVARCHAR(500),
    businessunit NVARCHAR(100)
)