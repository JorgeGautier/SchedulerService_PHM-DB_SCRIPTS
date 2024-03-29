USE [SCDB]
GO
/****** Object:  StoredProcedure [dbo].[GET_ENCOUNTERS_837_SEND_MANUALLY]    Script Date: 11/21/2023 3:35:07 PM ******/
DROP PROCEDURE IF EXISTS [dbo].[GET_ENCOUNTERS_837_SEND_MANUALLY]
GO
/****** Object:  StoredProcedure [dbo].[GET_ENCOUNTERS_837_SEND_MANUALLY]    Script Date: 11/21/2023 3:35:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		JORGE GAUTIER
-- Create date: 11/16/2023
-- Description:	GET TRANSACTIONS TO CONVERT TO 837 FORMAT 
-- =============================================
CREATE PROCEDURE [dbo].[GET_ENCOUNTERS_837_SEND_MANUALLY] (@INSURANCE VARCHAR(1))
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT TOP 50000 R.*, C.IPA_NAME, C.NPI IPA_NPI, C.PATRONAL_NUM AS IPA_PTA_NUM, C.ADDRESS_1 IPA_ADDRESS1, C.ADDRESS_2 IPA_ADDRESS2, C.[STATE] IPA_STATE, 
			C.CITY IPA_CITY, C.ZIPCODE IPA_ZIPCODE, C.PHONE IPA_PHONE, P.LINE1 REF_ADDR1, ISNULL(P.LINE2,'') REF_ADDR2, 
			P.CITY REF_CITY, P.[STATE] REF_STATE, P.ZIPCODE REF_ZIP, P.PHONE1 REF_PHONE, PM.LINE1 MEM_ADDR1, PM.LINE2 MEM_ADDR2, 
			PM.CITY MEM_CITY, PM.[STATE] MEM_STATE, PM.ZIPCODE MEM_ZIP, PM.PHONE1 MEM_PHONE, 
			(SELECT TOP 1 BIRTHDATE FROM NAME_MEM_MASTER WHERE MEM_NUM = R.MEM_NUM AND BIRTHDATE IS NOT NULL) AS MEM_BIRTHDATE, 
			(SELECT TOP 1 GENDER FROM NAME_MEM_MASTER WHERE MEM_NUM = R.MEM_NUM AND GENDER IS NOT NULL) AS MEM_GENDER,
			M.PCP_NAME REF_REAL_NAME, M.PCP_LAST_NAME REF_LAST_NAME, 
			(SELECT TOP 1 MEM_NAME FROM NAME_MEM_MASTER WHERE MEM_NUM = R.MEM_NUM AND MEM_NAME IS NOT NULL) AS MEM_NAME, 
			(SELECT TOP 1 MEM_LAST_NAME FROM NAME_MEM_MASTER WHERE MEM_NUM = R.MEM_NUM AND BIRTHDATE IS NOT NULL) AS MEM_LAST_NAME,
			S.TAXONOMY_CODE REF_TAXONOMY_CODE,
			S.SPEC_ID
	FROM REF_HISTORY_MASTER R
			LEFT OUTER JOIN COMPANY_MASTER C ON R.IPA_NUM = C.IPA_NUM --AND R.INSURANCE = C.INSURANCE_ID 
			LEFT OUTER JOIN ADDRESSES P ON R.REND_NUM = P.REF_NUM AND P.[TYPE] = 'PCP'
			LEFT OUTER JOIN ADDRESSES PM ON R.MEM_NUM = PM.REF_NUM AND PM.[TYPE] = 'MEM'
			--LEFT OUTER JOIN NAME_MEM_MASTER N ON R.MEM_NUM = N.MEM_NUM --AND R.IPA_NUM = N.IPA_NUM R.INSURANCE = N.INSURANCE AND 
			LEFT OUTER JOIN NAME_PROV_MASTER M ON R.REND_NUM = M.NPI --AND R.IPA_NUM = M.IPA_NUM AND R.INSURANCE = M.INSURANCE
			LEFT OUTER JOIN SPEC_MASTER S ON M.SPEC_ID = S.SPEC_ID 
			--LEFT OUTER JOIN ENCOUNTERS_PATRONAL_NUM PN ON PN.INSURANCE_ID = R.INSURANCE
	WHERE R.INSURANCE NOT IN (12) AND --R.IPA_NUM = @IPA_NUM AND FROM_DATE BETWEEN '11/01/2020' AND @TO_DATE AND 
			IS_ENCOUNTER = 1 AND
			[STATUS] IN (-4) --AND  DIAG_CODE <> '' AND DIAG_CODE <> 'A20219A'
	ORDER BY FROM_DATE DESC

	-- FM
	SELECT TOP 50000 R.*, C.IPA_NAME, C.NPI IPA_NPI, C.PATRONAL_NUM AS IPA_PTA_NUM, C.ADDRESS_1 IPA_ADDRESS1, C.ADDRESS_2 IPA_ADDRESS2, C.[STATE] IPA_STATE, 
			C.CITY IPA_CITY, C.ZIPCODE IPA_ZIPCODE, C.PHONE IPA_PHONE, P.LINE1 REF_ADDR1, ISNULL(P.LINE2,'') REF_ADDR2, 
			P.CITY REF_CITY, P.[STATE] REF_STATE, P.ZIPCODE REF_ZIP, P.PHONE1 REF_PHONE, PM.LINE1 MEM_ADDR1, PM.LINE2 MEM_ADDR2, 
			PM.CITY MEM_CITY, PM.[STATE] MEM_STATE, PM.ZIPCODE MEM_ZIP, PM.PHONE1 MEM_PHONE, 
			(SELECT TOP 1 BIRTHDATE FROM NAME_MEM_MASTER WHERE MEM_NUM = R.MEM_NUM AND BIRTHDATE IS NOT NULL AND BIRTHDATE <> '1900-01-01') AS MEM_BIRTHDATE, 
			(SELECT TOP 1 GENDER FROM NAME_MEM_MASTER WHERE MEM_NUM = R.MEM_NUM AND GENDER IS NOT NULL) AS MEM_GENDER,
			M.PCP_NAME REF_REAL_NAME, M.PCP_LAST_NAME REF_LAST_NAME, 
			(SELECT TOP 1 MEM_NAME FROM NAME_MEM_MASTER WHERE MEM_NUM = R.MEM_NUM AND MEM_NAME IS NOT NULL) AS MEM_NAME, 
			(SELECT TOP 1 MEM_LAST_NAME FROM NAME_MEM_MASTER WHERE MEM_NUM = R.MEM_NUM AND BIRTHDATE IS NOT NULL) AS MEM_LAST_NAME,
			S.TAXONOMY_CODE REF_TAXONOMY_CODE,
			S.SPEC_ID
	FROM REF_HISTORY_MASTER R
			LEFT OUTER JOIN COMPANY_MASTER C ON R.IPA_NUM = C.IPA_NUM --AND R.INSURANCE = C.INSURANCE_ID 
			LEFT OUTER JOIN ADDRESSES P ON R.REND_NUM = P.REF_NUM AND P.[TYPE] = 'PCP'
			LEFT OUTER JOIN ADDRESSES PM ON R.MEM_NUM = PM.REF_NUM AND PM.[TYPE] = 'MEM'
			--LEFT OUTER JOIN NAME_MEM_MASTER N ON R.MEM_NUM = N.MEM_NUM AND R.IPA_NUM = N.IPA_NUM AND R.INSURANCE = N.INSURANCE  
			LEFT OUTER JOIN NAME_PROV_MASTER M ON R.REND_NUM = M.NPI --AND R.IPA_NUM = M.IPA_NUM AND R.INSURANCE = M.INSURANCE
			LEFT OUTER JOIN SPEC_MASTER S ON M.SPEC_ID = S.SPEC_ID 
			--LEFT OUTER JOIN ENCOUNTERS_PATRONAL_NUM PN ON PN.INSURANCE_ID = R.INSURANCE
	WHERE R.INSURANCE = 12 AND --R.IPA_NUM = @IPA_NUM AND FROM_DATE BETWEEN '11/01/2020' AND @TO_DATE AND 
			IS_ENCOUNTER = 1 AND
			[STATUS] IN (-4) --AND  DIAG_CODE <> '' AND DIAG_CODE <> 'A20219A'  
	ORDER BY FROM_DATE DESC

	-------------------------------------------------------------------------------------------------------------------------------------------------------------

	---- INSURANCE / IPA VALIDATION
	----UPDATE R SET INSURANCE = ISNULL((SELECT TOP 1 INSURANCE
	----		FROM CAP_MASTER 
	----		WHERE MEM_NUM = R.MEM_NUM AND MONTH(FILE_DATE) = MONTH(FROM_DATE) AND YEAR(FILE_DATE) = YEAR(R.FROM_DATE) ORDER BY FILE_DATE DESC),R.INSURANCE),
	----	IPA_NUM = ISNULL((SELECT TOP 1 IPA_NUM 
	----		FROM CAP_MASTER 
	----		WHERE MEM_NUM = R.MEM_NUM AND MONTH(FILE_DATE) = MONTH(FROM_DATE) AND YEAR(FILE_DATE) = YEAR(R.FROM_DATE) ORDER BY FILE_DATE DESC),R.IPA_NUM)
	----FROM REF_HISTORY_MASTER R
	----WHERE FROM_DATE BETWEEN @FROM_DATE AND @TO_DATE AND [STATUS] IN (1,2,-2) AND IS_ENCOUNTER = 1 AND ID IN (
	----	SELECT ID FROM (
	----		SELECT 
	----			ISNULL((SELECT TOP 1 IPA_NUM 
	----			FROM CAP_MASTER 
	----			WHERE MEM_NUM = R.MEM_NUM AND MONTH(FILE_DATE) = MONTH(FROM_DATE) AND YEAR(FILE_DATE) = YEAR(FILE_DATE) ORDER BY FILE_DATE DESC),R.IPA_NUM) AS IPA_FIX,
	----			ISNULL((SELECT TOP 1 INSURANCE
	----			FROM CAP_MASTER 
	----			WHERE MEM_NUM = R.MEM_NUM AND MONTH(FILE_DATE) = MONTH(FROM_DATE) AND YEAR(FILE_DATE) = YEAR(FILE_DATE) ORDER BY FILE_DATE DESC),R.INSURANCE) AS INSURANCE_FIX, 
	----			INSURANCE, IPA_NUM, ID
	----		FROM REF_HISTORY_MASTER R
	----		WHERE IS_ENCOUNTER = 1 AND MONTH(FROM_DATE)=MONTH(GETDATE()) AND YEAR(FROM_DATE)=YEAR(GETDATE())) T
	----	WHERE INSURANCE_FIX <> INSURANCE OR IPA_FIX <> IPA_NUM)
	
	----CHANGE ENCOUNTERS TO BE SEND TO STATUS 2
	--UPDATE REF_HISTORY_MASTER SET [STATUS] = 2, AUDIT_DATE = GETDATE(), AUDIT_USER = 'scuser'
	--WHERE IS_ENCOUNTER = 1 AND [STATUS] = 1 AND INSURANCE = @INSURANCE AND IPA_NUM = @IPA_NUM

 --   -- SENT FOR THE FIRST TIME
 --   IF @ISRESEND = 0
 --   BEGIN
	--	SELECT TOP 4500 R.*, C.IPA_NAME, C.NPI IPA_NPI, C.PATRONAL_NUM AS IPA_PTA_NUM, C.ADDRESS_1 IPA_ADDRESS1, C.ADDRESS_2 IPA_ADDRESS2, C.[STATE] IPA_STATE, 
	--		   C.CITY IPA_CITY, C.ZIPCODE IPA_ZIPCODE, C.PHONE IPA_PHONE, P.LINE1 REF_ADDR1, ISNULL(P.LINE2,'') REF_ADDR2, 
	--		   P.CITY REF_CITY, P.[STATE] REF_STATE, P.ZIPCODE REF_ZIP, P.PHONE1 REF_PHONE, PM.LINE1 AS MEM_ADDR1, PM.LINE2 AS MEM_ADDR2, 
	--		   PM.CITY MEM_CITY, PM.[STATE] MEM_STATE, PM.ZIPCODE MEM_ZIP, PM.PHONE1 MEM_PHONE, 
	--		   (SELECT TOP 1 BIRTHDATE FROM NAME_MEM_MASTER WHERE MEM_NUM = R.MEM_NUM AND BIRTHDATE IS NOT NULL) AS MEM_BIRTHDATE, N.GENDER MEM_GENDER,
	--		   M.PCP_NAME REF_REAL_NAME, M.PCP_LAST_NAME REF_LAST_NAME, N.MEM_NAME, N.MEM_LAST_NAME, S.TAXONOMY_CODE REF_TAXONOMY_CODE,
	--		   S.SPEC_ID
	--	FROM REF_HISTORY_MASTER R
	--			LEFT OUTER JOIN COMPANY_MASTER C ON R.IPA_NUM = C.IPA_NUM --AND R.INSURANCE = C.INSURANCE_ID 
	--			LEFT OUTER JOIN ADDRESSES P ON R.REND_NUM = P.REF_NUM AND P.[TYPE] = 'PCP'
	--			LEFT OUTER JOIN ADDRESSES PM ON R.MEM_NUM = PM.REF_NUM AND PM.[TYPE] = 'MEM'
	--			LEFT OUTER JOIN NAME_MEM_MASTER N ON R.MEM_NUM = N.MEM_NUM --AND R.INSURANCE = N.INSURANCE AND R.IPA_NUM = N.IPA_NUM 
	--			LEFT OUTER JOIN NAME_PROV_MASTER M ON R.REND_NUM = M.NPI --AND R.IPA_NUM = M.IPA_NUM AND R.INSURANCE = M.INSURANCE 
	--			LEFT OUTER JOIN SPEC_MASTER S ON M.SPEC_ID = S.SPEC_ID
	--			LEFT OUTER JOIN ENCOUNTERS_PATRONAL_NUM PN ON PN.INSURANCE_ID = R.INSURANCE
	--	WHERE R.INSURANCE = @INSURANCE AND R.IPA_NUM = @IPA_NUM AND FROM_DATE BETWEEN '11/01/2020' AND @TO_DATE AND IS_ENCOUNTER = 1 AND
	--		  [STATUS] = 2 AND  DIAG_CODE <> '' AND DIAG_CODE <> 'A20219A'
	--	ORDER BY FROM_DATE DESC
	--END
	--ELSE IF @ISRESEND = 1
	--BEGIN
	--	IF @INSURANCE = 13 -- BATCH FROM 01/01/2017 TO 12/31/2017 + CURRENT DAY (03/27/2018)
	--	BEGIN
	--		IF @IPA_NUM <> 'E55MH'
	--		BEGIN
	--			SELECT TOP 4500 R.*, C.IPA_NAME, C.NPI IPA_NPI, C.PATRONAL_NUM AS IPA_PTA_NUM, C.ADDRESS_1 IPA_ADDRESS1, C.ADDRESS_2 IPA_ADDRESS2, C.[STATE] IPA_STATE, 
	--				   C.CITY IPA_CITY, C.ZIPCODE IPA_ZIPCODE, C.PHONE IPA_PHONE, P.LINE1 REF_ADDR1, ISNULL(P.LINE2,'') REF_ADDR2, 
	--				   P.CITY REF_CITY, P.[STATE] REF_STATE, P.ZIPCODE REF_ZIP, P.PHONE1 REF_PHONE, PM.LINE1 MEM_ADDR1, PM.LINE2 MEM_ADDR2, 
	--				   PM.CITY MEM_CITY, PM.[STATE] MEM_STATE, PM.ZIPCODE MEM_ZIP, PM.PHONE1 MEM_PHONE, 
	--				   (SELECT TOP 1 BIRTHDATE FROM NAME_MEM_MASTER WHERE MEM_NUM = R.MEM_NUM AND BIRTHDATE IS NOT NULL) AS MEM_BIRTHDATE, N.GENDER MEM_GENDER,
	--				   M.PCP_NAME REF_REAL_NAME, M.PCP_LAST_NAME REF_LAST_NAME, N.MEM_NAME, N.MEM_LAST_NAME, S.TAXONOMY_CODE REF_TAXONOMY_CODE,
	--				   S.SPEC_ID
	--			FROM REF_HISTORY_MASTER R
	--					LEFT OUTER JOIN COMPANY_MASTER C ON R.IPA_NUM = C.IPA_NUM --AND R.INSURANCE = C.INSURANCE_ID 
	--					LEFT OUTER JOIN ADDRESSES P ON R.REND_NUM = P.REF_NUM AND P.[TYPE] = 'PCP'
	--					LEFT OUTER JOIN ADDRESSES PM ON R.MEM_NUM = PM.REF_NUM AND PM.[TYPE] = 'MEM'
	--					LEFT OUTER JOIN NAME_MEM_MASTER N ON R.MEM_NUM = N.MEM_NUM --AND R.IPA_NUM = N.IPA_NUM R.INSURANCE = N.INSURANCE AND 
	--					LEFT OUTER JOIN NAME_PROV_MASTER M ON R.REND_NUM = M.NPI --AND R.IPA_NUM = M.IPA_NUM AND R.INSURANCE = M.INSURANCE
	--					LEFT OUTER JOIN SPEC_MASTER S ON M.SPEC_ID = S.SPEC_ID 
	--					--LEFT OUTER JOIN ENCOUNTERS_PATRONAL_NUM PN ON PN.INSURANCE_ID = R.INSURANCE
	--			WHERE R.INSURANCE = @INSURANCE AND R.IPA_NUM = @IPA_NUM AND FROM_DATE BETWEEN '11/01/2020' AND @TO_DATE AND IS_ENCOUNTER = 1 AND
	--				  [STATUS] IN (2, -2) AND  DIAG_CODE <> '' AND DIAG_CODE <> 'A20219A'
	--			ORDER BY FROM_DATE DESC
	--		END
	--		ELSE
	--		BEGIN
	--			SELECT TOP 4500 R.*, C.IPA_NAME, C.NPI IPA_NPI, '660867882' AS IPA_PTA_NUM, C.ADDRESS_1 IPA_ADDRESS1, C.ADDRESS_2 IPA_ADDRESS2, C.[STATE] IPA_STATE, 
	--					C.CITY IPA_CITY, C.ZIPCODE IPA_ZIPCODE, C.PHONE IPA_PHONE,		 
	--					'1551 Calle Alda Suite 201' AS REF_ADDR1, 'Urb. Caribe' AS REF_ADDR2, 'SAN JUAN' AS REF_CITY, 'PR' AS REF_STATE, '00926-2709' AS REF_ZIP, '787-625-2500' AS REF_PHONE,
	--					PM.LINE1 MEM_ADDR1, PM.LINE2 MEM_ADDR2, 
	--					PM.CITY MEM_CITY, PM.[STATE] MEM_STATE, PM.ZIPCODE MEM_ZIP, PM.PHONE1 MEM_PHONE, 
	--					(SELECT TOP 1 BIRTHDATE FROM NAME_MEM_MASTER WHERE MEM_NUM = R.MEM_NUM AND BIRTHDATE IS NOT NULL) AS MEM_BIRTHDATE, N.GENDER MEM_GENDER,
	--					M.PCP_NAME REF_REAL_NAME, M.PCP_LAST_NAME REF_LAST_NAME, N.MEM_NAME, N.MEM_LAST_NAME, S.TAXONOMY_CODE REF_TAXONOMY_CODE,
	--					S.SPEC_ID
	--			FROM REF_HISTORY_MASTER R
	--					LEFT OUTER JOIN COMPANY_MASTER C ON R.IPA_NUM = C.IPA_NUM AND R.INSURANCE = C.INSURANCE_ID 
	--					LEFT OUTER JOIN ADDRESSES P ON R.REND_NUM = P.REF_NUM AND P.[TYPE] = 'PCP'
	--					LEFT OUTER JOIN ADDRESSES PM ON R.MEM_NUM = PM.REF_NUM AND PM.[TYPE] = 'MEM'
	--					LEFT OUTER JOIN NAME_MEM_MASTER N ON R.MEM_NUM = N.MEM_NUM --AND R.IPA_NUM = N.IPA_NUM  R.INSURANCE = N.INSURANCE AND 
	--					LEFT OUTER JOIN NAME_PROV_MASTER M ON R.REND_NUM = M.NPI --AND R.IPA_NUM = M.IPA_NUM AND R.INSURANCE = M.INSURANCE
	--					LEFT OUTER JOIN SPEC_MASTER S ON M.SPEC_ID = S.SPEC_ID 
	--			WHERE R.INSURANCE = @INSURANCE AND R.IPA_NUM = @IPA_NUM AND FROM_DATE BETWEEN '11/01/2020' AND @TO_DATE AND IS_ENCOUNTER = 1 AND
	--					[STATUS] IN (2, -2) AND  DIAG_CODE <> '' AND DIAG_CODE <> 'A20219A'
	--		END
	--	END

	--	--ELSE 
	--	ELSE IF @INSURANCE = 5 
	--	BEGIN
	--		SELECT TOP 4500 R.*, C.IPA_NAME, C.NPI IPA_NPI, C.PATRONAL_NUM AS IPA_PTA_NUM, C.ADDRESS_1 IPA_ADDRESS1, C.ADDRESS_2 IPA_ADDRESS2, C.[STATE] IPA_STATE, 
	--			   C.CITY IPA_CITY, C.ZIPCODE IPA_ZIPCODE, C.PHONE IPA_PHONE, P.LINE1 REF_ADDR1, ISNULL(P.LINE2,'') REF_ADDR2, 
	--			   P.CITY REF_CITY, P.[STATE] REF_STATE, P.ZIPCODE REF_ZIP, P.PHONE1 REF_PHONE, PM.LINE1 MEM_ADDR1, PM.LINE2 MEM_ADDR2, 
	--			   PM.CITY MEM_CITY, PM.[STATE] MEM_STATE, PM.ZIPCODE MEM_ZIP, PM.PHONE1 MEM_PHONE, 
	--			   (SELECT TOP 1 BIRTHDATE FROM NAME_MEM_MASTER WHERE MEM_NUM = R.MEM_NUM AND BIRTHDATE IS NOT NULL) AS MEM_BIRTHDATE, N.GENDER MEM_GENDER,
	--			   M.PCP_NAME REF_REAL_NAME, M.PCP_LAST_NAME REF_LAST_NAME, N.MEM_NAME, N.MEM_LAST_NAME, S.TAXONOMY_CODE REF_TAXONOMY_CODE,
	--			   S.SPEC_ID
	--		FROM REF_HISTORY_MASTER R
	--				LEFT OUTER JOIN COMPANY_MASTER C ON R.IPA_NUM = C.IPA_NUM --AND R.INSURANCE = C.INSURANCE_ID 
	--				LEFT OUTER JOIN ADDRESSES P ON R.REND_NUM = P.REF_NUM AND P.[TYPE] = 'PCP'
	--				LEFT OUTER JOIN ADDRESSES PM ON R.MEM_NUM = PM.REF_NUM AND PM.[TYPE] = 'MEM'
	--				LEFT OUTER JOIN NAME_MEM_MASTER N ON R.MEM_NUM = N.MEM_NUM --AND R.IPA_NUM = N.IPA_NUM R.INSURANCE = N.INSURANCE AND 
	--				LEFT OUTER JOIN NAME_PROV_MASTER M ON R.REND_NUM = M.NPI --AND R.IPA_NUM = M.IPA_NUM AND R.INSURANCE = M.INSURANCE
	--				LEFT OUTER JOIN SPEC_MASTER S ON M.SPEC_ID = S.SPEC_ID 
	--				--LEFT OUTER JOIN ENCOUNTERS_PATRONAL_NUM PN ON PN.INSURANCE_ID = R.INSURANCE
	--		WHERE R.INSURANCE = @INSURANCE AND R.IPA_NUM = @IPA_NUM AND FROM_DATE BETWEEN '11/01/2020' AND @TO_DATE AND IS_ENCOUNTER = 1 AND
	--			  [STATUS] IN (2, -2) AND  DIAG_CODE <> '' AND DIAG_CODE <> 'A20219A'
	--		--UNION ALL  -- BATCH FROM 01/01/2017 TO 12/31/2017 + CURRENT DAY (03/27/2018)
	--		--SELECT TOP 4500 R.*, C.IPA_NAME, C.NPI IPA_NPI, C.PATRONAL_NUM IPA_PTA_NUM, C.ADDRESS_1 IPA_ADDRESS1, C.ADDRESS_2 IPA_ADDRESS2, C.[STATE] IPA_STATE, 
	--		--		C.CITY IPA_CITY, C.ZIPCODE IPA_ZIPCODE, C.PHONE IPA_PHONE, P.LINE1 REF_ADDR1, ISNULL(P.LINE2,'') REF_ADDR2, 
	--		--		P.CITY REF_CITY, P.[STATE] REF_STATE, P.ZIPCODE REF_ZIP, P.PHONE1 REF_PHONE, PM.LINE1 MEM_ADDR1, PM.LINE2 MEM_ADDR2, 
	--		--		PM.CITY MEM_CITY, PM.[STATE] MEM_STATE, PM.ZIPCODE MEM_ZIP, PM.PHONE1 MEM_PHONE, N.BIRTHDATE MEM_BIRTHDATE, N.GENDER MEM_GENDER,
	--		--		M.PCP_NAME REF_REAL_NAME, M.PCP_LAST_NAME REF_LAST_NAME, N.MEM_NAME, N.MEM_LAST_NAME, S.TAXONOMY_CODE REF_TAXONOMY_CODE,
	--		--		S.SPEC_ID
	--		--FROM REF_HISTORY_MASTER R
	--		--		LEFT OUTER JOIN COMPANY_MASTER C ON R.IPA_NUM = C.IPA_NUM --AND R.INSURANCE = C.INSURANCE_ID 
	--		--		LEFT OUTER JOIN ADDRESSES P ON R.REND_NUM = P.REF_NUM AND P.[TYPE] = 'PCP'
	--		--		LEFT OUTER JOIN ADDRESSES PM ON R.MEM_NUM = PM.REF_NUM AND PM.[TYPE] = 'MEM'
	--		--		LEFT OUTER JOIN NAME_MEM_MASTER N ON R.MEM_NUM = N.MEM_NUM AND R.IPA_NUM = N.IPA_NUM --R.INSURANCE = N.INSURANCE AND 
	--		--		LEFT OUTER JOIN NAME_PROV_MASTER M ON R.REND_NUM = M.NPI --AND R.IPA_NUM = M.IPA_NUM AND R.INSURANCE = M.INSURANCE
	--		--		LEFT OUTER JOIN SPEC_MASTER S ON M.SPEC_ID = S.SPEC_ID 
	--		--WHERE R.INSURANCE = @INSURANCE AND R.IPA_NUM = @IPA_NUM AND IS_ENCOUNTER = 1 AND ID IN (SELECT ID 
	--		--	FROM REF_HISTORY_MASTER 
	--		--	WHERE IS_ENCOUNTER=1 AND FROM_DATE BETWEEN '01/01/2017' AND '1/31/2018' AND INSURANCE = 5 AND STATUS IN (2,-2))
	--		ORDER BY FROM_DATE DESC
	--	END

	--	ELSE IF @INSURANCE = 12     
	--	BEGIN
	--		SELECT TOP 4500 R.*, C.IPA_NAME, C.NPI IPA_NPI, C.PATRONAL_NUM AS IPA_PTA_NUM, C.ADDRESS_1 IPA_ADDRESS1, C.ADDRESS_2 IPA_ADDRESS2, C.[STATE] IPA_STATE, 
	--			   C.CITY IPA_CITY, C.ZIPCODE IPA_ZIPCODE, C.PHONE IPA_PHONE, P.LINE1 REF_ADDR1, ISNULL(P.LINE2,'') REF_ADDR2, 
	--			   P.CITY REF_CITY, P.[STATE] REF_STATE, P.ZIPCODE REF_ZIP, P.PHONE1 REF_PHONE, PM.LINE1 MEM_ADDR1, PM.LINE2 MEM_ADDR2, 
	--			   PM.CITY MEM_CITY, PM.[STATE] MEM_STATE, PM.ZIPCODE MEM_ZIP, PM.PHONE1 MEM_PHONE, 
	--			   (SELECT TOP 1 BIRTHDATE FROM NAME_MEM_MASTER WHERE MEM_NUM = R.MEM_NUM AND BIRTHDATE IS NOT NULL AND BIRTHDATE <> '1900-01-01') AS MEM_BIRTHDATE, N.GENDER MEM_GENDER,
	--			   M.PCP_NAME REF_REAL_NAME, M.PCP_LAST_NAME REF_LAST_NAME, N.MEM_NAME, N.MEM_LAST_NAME, S.TAXONOMY_CODE REF_TAXONOMY_CODE,
	--			   S.SPEC_ID
	--		FROM REF_HISTORY_MASTER R
	--				LEFT OUTER JOIN COMPANY_MASTER C ON R.IPA_NUM = C.IPA_NUM --AND R.INSURANCE = C.INSURANCE_ID 
	--				LEFT OUTER JOIN ADDRESSES P ON R.REND_NUM = P.REF_NUM AND P.[TYPE] = 'PCP'
	--				LEFT OUTER JOIN ADDRESSES PM ON R.MEM_NUM = PM.REF_NUM AND PM.[TYPE] = 'MEM'
	--				LEFT OUTER JOIN NAME_MEM_MASTER N ON R.MEM_NUM = N.MEM_NUM AND R.IPA_NUM = N.IPA_NUM AND R.INSURANCE = N.INSURANCE  
	--				LEFT OUTER JOIN NAME_PROV_MASTER M ON R.REND_NUM = M.NPI --AND R.IPA_NUM = M.IPA_NUM AND R.INSURANCE = M.INSURANCE
	--				LEFT OUTER JOIN SPEC_MASTER S ON M.SPEC_ID = S.SPEC_ID 
	--				--LEFT OUTER JOIN ENCOUNTERS_PATRONAL_NUM PN ON PN.INSURANCE_ID = R.INSURANCE
	--		WHERE R.INSURANCE = @INSURANCE AND R.IPA_NUM = @IPA_NUM AND FROM_DATE BETWEEN '11/01/2020' AND @TO_DATE AND IS_ENCOUNTER = 1 AND
	--			  STATUS IN (2, -2) AND  DIAG_CODE <> '' AND DIAG_CODE <> 'A20219A'		  
	--		ORDER BY FROM_DATE DESC

	--		--WHERE R.INSURANCE = 99 -- ** DISABLED **

	--		--UNION ALL  -- BATCH FROM 9/01/2017 TO 12/31/2017 + CURRENT DAY (4/17/2018) EXCLUDING 2 PROVIDERS
	--		--SELECT TOP 4500 R.*, C.IPA_NAME, C.NPI IPA_NPI, C.PATRONAL_NUM IPA_PTA_NUM, C.ADDRESS_1 IPA_ADDRESS1, C.ADDRESS_2 IPA_ADDRESS2, C.[STATE] IPA_STATE, 
	--		--		C.CITY IPA_CITY, C.ZIPCODE IPA_ZIPCODE, C.PHONE IPA_PHONE, P.LINE1 REF_ADDR1, ISNULL(P.LINE2,'') REF_ADDR2, 
	--		--		P.CITY REF_CITY, P.[STATE] REF_STATE, P.ZIPCODE REF_ZIP, P.PHONE1 REF_PHONE, PM.LINE1 MEM_ADDR1, PM.LINE2 MEM_ADDR2, 
	--		--		PM.CITY MEM_CITY, PM.[STATE] MEM_STATE, PM.ZIPCODE MEM_ZIP, PM.PHONE1 MEM_PHONE, N.BIRTHDATE MEM_BIRTHDATE, N.GENDER MEM_GENDER,
	--		--		M.PCP_NAME REF_REAL_NAME, M.PCP_LAST_NAME REF_LAST_NAME, N.MEM_NAME, N.MEM_LAST_NAME, S.TAXONOMY_CODE REF_TAXONOMY_CODE,
	--		--		S.SPEC_ID
	--		--FROM REF_HISTORY_MASTER R
	--		--		LEFT OUTER JOIN COMPANY_MASTER C ON R.IPA_NUM = C.IPA_NUM --AND R.INSURANCE = C.INSURANCE_ID 
	--		--		LEFT OUTER JOIN ADDRESSES P ON R.REND_NUM = P.REF_NUM AND P.[TYPE] = 'PCP'
	--		--		LEFT OUTER JOIN ADDRESSES PM ON R.MEM_NUM = PM.REF_NUM AND PM.[TYPE] = 'MEM'
	--		--		LEFT OUTER JOIN NAME_MEM_MASTER N ON R.MEM_NUM = N.MEM_NUM AND R.IPA_NUM = N.IPA_NUM  --R.INSURANCE = N.INSURANCE AND 
	--		--		LEFT OUTER JOIN NAME_PROV_MASTER M ON R.REND_NUM = M.NPI --AND R.IPA_NUM = M.IPA_NUM AND R.INSURANCE = M.INSURANCE
	--		--		LEFT OUTER JOIN SPEC_MASTER S ON M.SPEC_ID = S.SPEC_ID 
	--		--WHERE R.INSURANCE = @INSURANCE AND R.IPA_NUM = @IPA_NUM AND IS_ENCOUNTER = 1 AND ID IN (SELECT ID 
	--		--	FROM REF_HISTORY_MASTER 
	--		--	WHERE IS_ENCOUNTER=1 AND FROM_DATE BETWEEN '9/01/2017' AND '12/31/2017' AND INSURANCE = 12 AND STATUS IN (2,-2) AND 
	--		--		REND_NUM NOT IN ('1306908215','1932219896'))
			
	--	END

	--	ELSE IF @INSURANCE = 16 
	--	BEGIN
	--		SELECT TOP 4500 R.*, C.IPA_NAME, C.NPI IPA_NPI, C.PATRONAL_NUM AS IPA_PTA_NUM, C.ADDRESS_1 IPA_ADDRESS1, C.ADDRESS_2 IPA_ADDRESS2, C.[STATE] IPA_STATE, 
	--			   C.CITY IPA_CITY, C.ZIPCODE IPA_ZIPCODE, C.PHONE IPA_PHONE, P.LINE1 REF_ADDR1, ISNULL(P.LINE2,'') REF_ADDR2, 
	--			   P.CITY REF_CITY, P.[STATE] REF_STATE, P.ZIPCODE REF_ZIP, P.PHONE1 REF_PHONE, PM.LINE1 MEM_ADDR1, PM.LINE2 MEM_ADDR2, 
	--			   PM.CITY MEM_CITY, PM.[STATE] MEM_STATE, PM.ZIPCODE MEM_ZIP, PM.PHONE1 MEM_PHONE, 
	--			   (SELECT TOP 1 BIRTHDATE FROM NAME_MEM_MASTER WHERE MEM_NUM = R.MEM_NUM AND BIRTHDATE IS NOT NULL) AS MEM_BIRTHDATE, N.GENDER MEM_GENDER,
	--			   M.PCP_NAME REF_REAL_NAME, M.PCP_LAST_NAME REF_LAST_NAME, N.MEM_NAME, N.MEM_LAST_NAME, S.TAXONOMY_CODE REF_TAXONOMY_CODE,
	--			   S.SPEC_ID
	--		FROM REF_HISTORY_MASTER R
	--				LEFT OUTER JOIN COMPANY_MASTER C ON R.IPA_NUM = C.IPA_NUM --AND R.INSURANCE = C.INSURANCE_ID 
	--				LEFT OUTER JOIN ADDRESSES P ON R.REND_NUM = P.REF_NUM AND P.[TYPE] = 'PCP'
	--				LEFT OUTER JOIN ADDRESSES PM ON R.MEM_NUM = PM.REF_NUM AND PM.[TYPE] = 'MEM'
	--				LEFT OUTER JOIN NAME_MEM_MASTER N ON R.MEM_NUM = N.MEM_NUM --AND R.IPA_NUM = N.IPA_NUM R.INSURANCE = N.INSURANCE AND 
	--				LEFT OUTER JOIN NAME_PROV_MASTER M ON R.REND_NUM = M.NPI --AND R.IPA_NUM = M.IPA_NUM AND R.INSURANCE = M.INSURANCE
	--				LEFT OUTER JOIN SPEC_MASTER S ON M.SPEC_ID = S.SPEC_ID 
	--				--LEFT OUTER JOIN ENCOUNTERS_PATRONAL_NUM PN ON PN.INSURANCE_ID = R.INSURANCE
	--		WHERE R.INSURANCE = @INSURANCE AND R.IPA_NUM = @IPA_NUM AND FROM_DATE BETWEEN '11/01/2020' AND @TO_DATE AND IS_ENCOUNTER = 1 AND
	--			  [STATUS] IN (2, -2) AND  DIAG_CODE <> '' AND DIAG_CODE <> 'A20219A'
	--		--WHERE R.INSURANCE = 99 -- ** DISABLED **
	--	END

	--	ELSE
	--	BEGIN
	--		SELECT TOP 4500 R.*, C.IPA_NAME, C.NPI IPA_NPI, C.PATRONAL_NUM AS IPA_PTA_NUM, C.ADDRESS_1 IPA_ADDRESS1, C.ADDRESS_2 IPA_ADDRESS2, C.[STATE] IPA_STATE, 
	--			   C.CITY IPA_CITY, C.ZIPCODE IPA_ZIPCODE, C.PHONE IPA_PHONE, P.LINE1 REF_ADDR1, ISNULL(P.LINE2,'') REF_ADDR2, 
	--			   P.CITY REF_CITY, P.[STATE] REF_STATE, P.ZIPCODE REF_ZIP, P.PHONE1 REF_PHONE, PM.LINE1 MEM_ADDR1, PM.LINE2 MEM_ADDR2, 
	--			   PM.CITY MEM_CITY, PM.[STATE] MEM_STATE, PM.ZIPCODE MEM_ZIP, PM.PHONE1 MEM_PHONE, 
	--			   (SELECT TOP 1 BIRTHDATE FROM NAME_MEM_MASTER WHERE MEM_NUM = R.MEM_NUM AND BIRTHDATE IS NOT NULL) AS MEM_BIRTHDATE, N.GENDER MEM_GENDER,
	--			   M.PCP_NAME REF_REAL_NAME, M.PCP_LAST_NAME REF_LAST_NAME, N.MEM_NAME, N.MEM_LAST_NAME, S.TAXONOMY_CODE REF_TAXONOMY_CODE,
	--			   S.SPEC_ID
	--		FROM REF_HISTORY_MASTER R
	--				LEFT OUTER JOIN COMPANY_MASTER C ON R.IPA_NUM = C.IPA_NUM --AND R.INSURANCE = C.INSURANCE_ID 
	--				LEFT OUTER JOIN ADDRESSES P ON R.REND_NUM = P.REF_NUM AND P.[TYPE] = 'PCP'
	--				LEFT OUTER JOIN ADDRESSES PM ON R.MEM_NUM = PM.REF_NUM AND PM.[TYPE] = 'MEM'
	--				LEFT OUTER JOIN NAME_MEM_MASTER N ON R.MEM_NUM = N.MEM_NUM --AND R.IPA_NUM = N.IPA_NUM R.INSURANCE = N.INSURANCE AND 
	--				LEFT OUTER JOIN NAME_PROV_MASTER M ON R.REND_NUM = M.NPI --AND R.IPA_NUM = M.IPA_NUM AND R.INSURANCE = M.INSURANCE
	--				LEFT OUTER JOIN SPEC_MASTER S ON M.SPEC_ID = S.SPEC_ID 
	--				--LEFT OUTER JOIN ENCOUNTERS_PATRONAL_NUM PN ON PN.INSURANCE_ID = R.INSURANCE
	--		WHERE R.INSURANCE = @INSURANCE AND R.IPA_NUM = @IPA_NUM AND FROM_DATE BETWEEN @FROM_DATE AND @TO_DATE AND IS_ENCOUNTER = 1 AND
	--			  [STATUS] IN (2, -2) AND  DIAG_CODE <> '' AND DIAG_CODE <> 'A20219A'
	--		ORDER BY FROM_DATE DESC
	--	END
	--END
END



GO
