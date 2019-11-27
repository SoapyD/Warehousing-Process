CREATE TABLE TEMP_telephony_combined (
    recid NVARCHAR(100),
    ddi NVARCHAR(30),
    ringtime INT,
    totalduration INT,
    agentid CHAR(15),
    agentname NVARCHAR(100),
    groupid INT,
    groupname NVARCHAR(300),
    datetime DATETIME,
    calltype NVARCHAR(20),
    source NVARCHAR(30)
)