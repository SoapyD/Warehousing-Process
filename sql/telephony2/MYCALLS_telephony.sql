
INSERT INTO TEMP_telephony_combined
SELECT 
	recid,
	--id,
	ddi,
	ringtime,
	totalduration,
	agentid,
	agentname,
	groupid,
	groupname,
	datetime,
	calltype,
	'mycalls' AS source
FROM 
	dbo.TELEPHONYEXTRACT_call c