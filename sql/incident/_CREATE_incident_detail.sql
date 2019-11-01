CREATE TABLE DETAIL_incident (
    recid CHAR(32),
    number NVARCHAR(30),
    problem_id CHAR(32),
    parentincident_id CHAR(32),

    customer NVARCHAR(100),
    subject NVARCHAR(255),
    symptom NVARCHAR(255),
    resolution NVARCHAR(255),
    technicalresolution NVARCHAR(255),

    system_id INT,
    company_id INT,
    businessunit_id INT,
    typeofincident_id INT,

    status_id INT,
    source_id INT,
    ownerteam_id INT,
    location_id INT, 
    causecode_id INT,

    service_id INT,
    category_id INT,
    subcategory_id INT,

    priority INT,
    isvip INT,
    breachstatus INT,
    l1passed INT,
    l2passed INT,
    l3passed INT,      
    breachpassed INT,
    response_breachpassed INT,
    remoteresolution INT,
    repeatissue INT,

    numberofusersaffected NVARCHAR(20),
    reopen_check INT,
    fcr INT,
    fcr_scoped INT,
    fcr_achieved INT,

    --OWNER DIMENSIONS
    owner_id INT,
    createdby_id INT,
    resolvedby_id INT,
    closedby_id INT,
    lastmodby_id INT,

    --DATE DIMENSIONS   
    createddatetime DATETIME,
    createddate_id INT,
    resolveddatetime DATETIME,
    resolveddate_id INT,
    closeddatetime DATETIME,
    closeddate_id INT,
    lastmoddatetime DATETIME,
    lastmoddate_id INT,
    breachdatetime DATETIME,
    breachdate_id INT,

    --FACTS
    targetclockduration INT,
    totalrunningduration INT,
    response_targetclockduration INT,
    response_totalrunningduration INT,
    reopencount INT

    primary key (recid, system_id)
)