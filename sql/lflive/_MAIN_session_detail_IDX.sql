CREATE INDEX idx_id_DETAIL_session ON DETAIL_session
(	
	recid
);


CREATE INDEX idx_cre_DETAIL_session ON DETAIL_session
(	
	startdate_id, duplicate_check
) 
INCLUDE (
--recid,
--DIMENSION IDS
system_id,
company_id,
businessunit_id,
ownerteam_id,
technician_id,

--DIMENSIONS
[Whats the Status of Your Problem?],
[Please Rate Your Remote Support Experience],
[Q2 score],

--DATE DIMENSIONS
enddate_id,
lastactiondate_id,

--FACTS
connectingtime,
waitingtime,
totaltime,
activetime,
worktime,
holdtime,
transfertime,
rebootingtime,
reconnectingtime

);