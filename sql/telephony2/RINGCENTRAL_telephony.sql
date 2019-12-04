
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
    --AND c.totaldurationseconds - prequeueseconds > 0
    --FILTER OUT TESTERS
    
    AND c.fromaddr NOT IN (
    '+447833252408', '+7833252408',--KAREN,
    '+447399572805', '+7399572805',--DANI,
    '+447971501924', '+7971501924',--DANI WORK 
    '+447715373031', '+7715373031', --JAMIE WORK, 
    '+447538136431', '+7538136431', --JAMIE PERSONAL,
    '+447894492827','+7894492827', --ALEC WORK
    '+447854086419', '+7854086419', --ALEC PERSONAL, 
    '+447973935894', '+7973935894',--BECKY
    '+447970973665', '+7970973665', --JAMIE
    '+447833252408', '+7833252408' --KAREN
    ) --TESTING 

    AND d.ringcentral_activationdatetime IS NOT NULL
    AND d.ringcentral_activationdatetime < contactstart