
--THIS SCRIPT IS THE ONLY WAY CURRENTLY OF UPDATING DUPLICATE RECORD NUMBERS IN THE NPS DETAILS TABLE
--IT NEEDS TO ACCOUNT FOR RECORDS CREATED AFTER THE NPS RECORD, WHICH CAN IN THEORY BE ANY TIME AFTER THE SESSION IS CLOSED

UPDATE DETAIL_session
SET
    duplicate_check = T2.duplicate_check

FROM  
    DETAIL_nps T1
    JOIN 
    (

    SELECT
        recid,
    	s.sessionid,
        ROW_NUMBER() OVER (
            PARTITION BY sessionid, databasename 
            ORDER BY starttime DESC, recid) AS duplicate_check

    FROM
    	DETAIL_session s

    --RETURN ALL DETAIL_NPS RECORDS WHERE THE SESSIONID OR INCIDENT NUMBER APPEAR IN THE TEMP UPDATE
    WHERE EXISTS
        (
            SELECT 
                sessionid
            FROM 
                TEMP_session d 
            WHERE 
                s.sessionid = d.sessionid
                AND s.databasename = d.databasename
        )
    ) T2

    --THEN UPDATE THE DUPLICATE COLUMN WITH THE UPDATED DUPLICATE NUMBER
    ON (T1.recid = T2.recid)