
INSERT INTO TEMP_telephony_combined
SELECT 
	c.contactid AS recid,
	d.ddi as ddi,
	inqueueseconds AS ringtime,
	totaldurationseconds - prequeueseconds - inqueueseconds AS totalduration,
	c.agentid,
	a.firstname + ' ' + a.lastname AS agentname,
	NULL AS groupid,
	NULL AS groupname,
	c.contactstart AS datetime,
	CASE  
		WHEN c.abandoned = 'True' THEN 'Inc Abd'
		WHEN c.transferindicatorid > 0 THEN 'Inc Tfr'
		ELSE 'Inc'
	END AS calltype,
	'ringcentral' AS source
FROM 
	dbo.RINGCENTRAL_completedcontacts c
	LEFT JOIN RINGCENTRAL_agents a ON (a.agentid = c.agentid)
	LEFT JOIN ddi_link d ON (d.ringcentralname = c.campaignname)

WHERE
	c.isoutbound = 'False'
	AND c.mediatypename = 'Call'
	AND c.totaldurationseconds - prequeueseconds > 0
	--FILTER OUT TESTERS

	AND c.fromaddr NOT IN (
	'+7833252408','+7399572805','+7971501924', --KAREN, DANI, DANI WORK
	'+7715373031','+7538136431','+7894492827', --JAMIE WORK, JAMIE PERSONAL, ALEC WORK
	'+7854086419', '+7973935894' --ALEC PERSONAL, BECKY
	) --TESTING