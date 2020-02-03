CREATE TABLE TEMP_incident_combined (
    recid CHAR(32),
    number NVARCHAR(30),
    system NVARCHAR(30),
    company NVARCHAR(100),
    businessunit NVARCHAR(100),
    isvip INT,
    location NVARCHAR(100),
    customer NVARCHAR(100),
    subject NVARCHAR(255),
    symptom NVARCHAR(255),
    priority INT,
    status NVARCHAR(40),
    source NVARCHAR(40),
    service NVARCHAR(60),
    category NVARCHAR(60),
    subcategory NVARCHAR(200),
    fcr INT,
    ownerteam NVARCHAR(100),
    owner NVARCHAR(100),  
    causecode NVARCHAR(150),
    createdby NVARCHAR(100),
    createddatetime DATETIME,
    resolvingteam NVARCHAR(100),
    resolvedby NVARCHAR(100),
    resolveddatetime DATETIME,
    closedby NVARCHAR(100),
    closeddatetime DATETIME,
    lastmodby NVARCHAR(100),
    lastmoddatetime DATETIME,
    breachstatus INT,
    l1dateTime DATETIME,
    l1passed INT,
    L2dateTime DATETIME,
    l2passed INT,
    l3dateTime DATETIME,
    l3passed INT,
    breachdatetime DATETIME,
    breachpassed INT,
    targetclockduration FLOAT,
    totalrunningduration FLOAT,
    response_breachpassed INT,
    response_targetclockduration FLOAT,
    response_totalrunningduration FLOAT,

    typeofincident NVARCHAR(20),
    reopencount INT,
    remoteresolution INT,
    resolution NVARCHAR(255),
    technicalresolution NVARCHAR(255),
    numberofusersaffected NVARCHAR(20),
    repeatissue INT,
    breachreason NVARCHAR(255),        
    cancellationreason NVARCHAR(255),
    prioritychangecount INT,
    problem_id CHAR(32),
    parentincident_id CHAR(32)
)