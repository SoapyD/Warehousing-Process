
--CREATE TABLE [dbo].[DETAIL_orgunit](
DECLARE @Temp_Table TABLE(
    --ID INT IDENTITY(1,1) NOT NULL,-- PRIMARY KEY,
    name NVARCHAR(100) NULL,
    supportingsite NVARCHAR(100) NULL,
    accountmanagername NVARCHAR(100) NULL,
    createddatetime DATETIME NULL,
    lastmoddatetime DATETIME NULL,
    grouping NVARCHAR(100) NULL,
    ddi NVARCHAR(100) NULL,
    ringcentralname NVARCHAR(100) NULL,
    ringcentral_activationdatetime DATETIME NULL,
    telephony_active NVARCHAR(100) NULL,
    telephony_target FLOAT NULL
)
INSERT INTO @Temp_Table
SELECT
	name,
	supportingsite,
	accountmanagername,
	createddatetime,
	lastmoddatetime,
	CASE 
		WHEN d.ddi IS NULL and d.ringcentralname IS NULL THEN 'ALL OTHER CLIENTS'
		ELSE name
	END AS grouping,
	d.ddi,
	d.ringcentralname,
	d.ringcentral_activationdatetime,
	d.active as telephony_active,
	d.target as telephony_target
FROM
	HEATSM_organizationalunit o
	LEFT JOIN DDI_Link d on (d.orgunitname = o.name)

UNION ALL

SELECT 
	ISNULL(d.ddi,d.ringcentralname) AS name,
	NULL,
	NULL,
	NULL,
	NULL,
	NULL AS grouping,
	d.ddi,
	d.ringcentralname,
	d.ringcentral_activationdatetime,
	d.active as telephony_active,
	d.target as telephony_target
FROM 
	DDI_Link d 
WHERE NOT EXISTS 
(
	SELECT 
		name 
	FROM 
		HEATSM_organizationalunit 
	WHERE 
		name = d.orgunitname
)

DECLARE @table_count FLOAT;
SET @table_count = (select COUNT(*) from @Temp_Table)
IF @table_count = 0
BEGIN
	THROW 50000, 'TEMP TABLE EMPTY', 1;
END

IF OBJECT_ID(N'DETAIL_orgunit') IS NULL
BEGIN
	THROW 50001, 'TARGET TABLE DETAIL_orgunit DOES NOT EXIST', 1;
END


MERGE [dbo].[DETAIL_orgunit] target
Using @Temp_Table source
ON (
TARGET.name = SOURCE.name
)
WHEN MATCHED
THEN UPDATE
SET
TARGET.name = SOURCE.name,
TARGET.supportingsite = SOURCE.supportingsite,
TARGET.accountmanagername = SOURCE.accountmanagername,
TARGET.createddatetime = SOURCE.createddatetime,
TARGET.lastmoddatetime = SOURCE.lastmoddatetime,
TARGET.grouping = SOURCE.grouping,
TARGET.ddi = SOURCE.ddi,
TARGET.ringcentralname = SOURCE.ringcentralname,
TARGET.ringcentral_activationdatetime = SOURCE.ringcentral_activationdatetime,
TARGET.telephony_active = SOURCE.telephony_active,
TARGET.telephony_target = SOURCE.telephony_target
WHEN NOT MATCHED BY TARGET
THEN INSERT 
(
name,
supportingsite,
accountmanagername,
createddatetime,
lastmoddatetime,
grouping,
ddi,
ringcentralname,
ringcentral_activationdatetime,
telephony_active,
telephony_target
)
VALUES (
SOURCE.name,
SOURCE.supportingsite,
SOURCE.accountmanagername,
SOURCE.createddatetime,
SOURCE.lastmoddatetime,
SOURCE.grouping,
SOURCE.ddi,
SOURCE.ringcentralname,
SOURCE.ringcentral_activationdatetime,
SOURCE.telephony_active,
SOURCE.telephony_target
);