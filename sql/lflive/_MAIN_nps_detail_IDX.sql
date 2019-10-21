CREATE INDEX idx_id_DETAIL_nps ON DETAIL_nps
(	
	recid
);



CREATE INDEX idx_cre_DETAIL_nps ON DETAIL_nps
(	
	submitteddate_id, duplicate_check
) 
INCLUDE (
--recid,
--DIMENSION IDS
system_id,
company_id,
businessunit_id,
ownerteam_id,

--DIMENSIONS
nps,
npstype

--DATE DIMENSIONS

--FACTS

);