/****** Object:  Table [EFORMS_OWN].[ARTWORK_GMM_PRODUCT_DETAILS]    Script Date: 8/13/2023 9:28:56 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [EFORMS_OWN].[ARTWORK_GMM_PRODUCT_DETAILS](
	[ROW_ID] [int] NOT NULL,
	[GMM_CODE] [nvarchar](500) NULL,
	[PRODUCT_DESCRIPTION] [nvarchar](500) NULL,
	[IS_ACTIVE] [char](1) NOT NULL,
	[LOCAL_SKU_CODE] [varchar](20) NULL,
 CONSTRAINT [PK_ARTWORK_GMM_PRODUCT_DETAILS] PRIMARY KEY CLUSTERED 
(
	[ROW_ID] ASC
)WITH (STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [EFORMS_OWN].[ARTWORK_GMM_PRODUCT_DETAILS] ADD  DEFAULT ('Y') FOR [IS_ACTIVE]
GO





CREATE TRIGGER EFORMS_OWN.ARTWORK_GMM_PRODUCT_DETAILS_TRG$AfterInsert
	ON EFORMS_OWN.ARTWORK_GMM_PRODUCT_DETAILS
	 AFTER INSERT
	AS 
		BEGIN

			SET  NOCOUNT  ON

			DECLARE
				@triggerType char(1)

			SELECT @triggerType = 'I'

			/* column variables declaration*/
			DECLARE
				@NEW$0 uniqueidentifier, 
				/*
				*   SSMA warning messages:
				*   O2SS0356: Conversion from NUMBER datatype can cause data loss.
				*/

				@NEW$ROW_ID float(53), 
				/*
				*   SSMA warning messages:
				*   O2SS0356: Conversion from NUMBER datatype can cause data loss.
				*/

				@OLD$ROW_ID float(53), 
				@NEW$GMM_CODE varchar(500), 
				@OLD$GMM_CODE varchar(500), 
				@NEW$PRODUCT_DESCRIPTION varchar(500), 
				@OLD$PRODUCT_DESCRIPTION varchar(500), 
				@NEW$IS_ACTIVE char(1), 
				@OLD$IS_ACTIVE char(1), 
				@NEW$LOCAL_SKU_CODE varchar(20), 
				@OLD$LOCAL_SKU_CODE varchar(20)

			DECLARE
				 ForEachInsertedRowTriggerCursor CURSOR LOCAL FORWARD_ONLY READ_ONLY FOR 
					SELECT 
						ROWID, 
						ROW_ID, 
						GMM_CODE, 
						PRODUCT_DESCRIPTION, 
						IS_ACTIVE, 
						LOCAL_SKU_CODE
					FROM inserted

			OPEN ForEachInsertedRowTriggerCursor

			FETCH ForEachInsertedRowTriggerCursor
				 INTO 
					@NEW$0, 
					@NEW$ROW_ID, 
					@NEW$GMM_CODE, 
					@NEW$PRODUCT_DESCRIPTION, 
					@NEW$IS_ACTIVE, 
					@NEW$LOCAL_SKU_CODE

			WHILE @@fetch_status = 0
			
				BEGIN

					/* trigger implementation: begin*/
					BEGIN

						DECLARE
							@TTAUDIT_SKIP char(1), 
							/*
							*   SSMA warning messages:
							*   O2SS0356: Conversion from NUMBER datatype can cause data loss.
							*/

							/* The 'audit_insert_%' and 'audit_dalete_%' columns have identical structure.*/
							@TTAUDIT_ROW_ID float(53), 
							@TTAUDIT_DATE datetime2(6), 
							@TTAUDIT_REASON varchar(6), 
							@TTAUDIT_APP_USER_ID varchar(10), 
							@TTAUDIT_DB_USER_ID varchar(64), 
							@TTAUDIT_IP_ADDR varchar(39), 
							@TTAUDIT_CLIENTID varchar(4000), 
							@TTAUDIT_TEMP varchar(4000)

						/* By default, don't skip the auditing.*/
						SET @TTAUDIT_SKIP = 'N'

						IF @triggerType = 'U'
							BEGIN
								
								/*
								*    Check the old row versus the new row, column-by-column.
								*    If all values are identical, then skip the auditing.
								*/
								IF 
									(@OLD$ROW_ID = @NEW$ROW_ID) AND 
									(@OLD$GMM_CODE = @NEW$GMM_CODE) AND 
									(@OLD$PRODUCT_DESCRIPTION = @NEW$PRODUCT_DESCRIPTION) AND 
									(@OLD$IS_ACTIVE = @NEW$IS_ACTIVE) AND 
									(@OLD$LOCAL_SKU_CODE = @NEW$LOCAL_SKU_CODE)
									SET @TTAUDIT_SKIP = 'Y'
							END

						IF (@TTAUDIT_SKIP = 'N')
							BEGIN

								/* Determine the values of the 'audit_insert%' and 'audit_delete%' columns*/
								SELECT @TTAUDIT_DATE = switchoffset(sysdatetimeoffset(), 0)

								SELECT @TTAUDIT_APP_USER_ID = NULL

								/* 
								*   SSMA error messages:
								*   O2SS0050: Conversion of identifier 'SYS_CONTEXT(CHAR, CHAR)' is not supported.

								SELECT @TTAUDIT_DB_USER_ID = lower(SYS_CONTEXT('USERENV', 'OS_USER'))
								*/



								/* 
								*   SSMA error messages:
								*   O2SS0050: Conversion of identifier 'SYS_CONTEXT(CHAR, CHAR)' is not supported.

								SELECT @TTAUDIT_IP_ADDR = lower(SYS_CONTEXT('USERENV', 'IP_ADDRESS'))
								*/



								/* 
								*   SSMA error messages:
								*   O2SS0050: Conversion of identifier 'SYS_CONTEXT(CHAR, CHAR)' is not supported.

								SELECT @TTAUDIT_CLIENTID = lower(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'))
								*/



								
								/*
								*    ASP.NET will set the CLIENT_IDENTIFIER with an encoded string
								*    in the format < ttaudit_user_id={0}&ttaudit_ip_addr={1} >
								*    Retrieve the ttaudit_app_user_id from ASP.NET (if available)
								*/
								IF (@TTAUDIT_CLIENTID LIKE '%ttaudit_user_id=%')
									BEGIN

										/*
										*   SSMA warning messages:
										*   O2SS0273: Oracle SUBSTR function and SQL Server SUBSTRING function may give different results.
										*/

										SET @TTAUDIT_TEMP = substring(@TTAUDIT_CLIENTID, ssma_oracle.instr2_varchar(@TTAUDIT_CLIENTID, 'ttaudit_user_id=') + ssma_oracle.length_char('ttaudit_user_id='), 999)

										IF (@TTAUDIT_TEMP LIKE '%&%')
											/*
											*   SSMA warning messages:
											*   O2SS0273: Oracle SUBSTR function and SQL Server SUBSTRING function may give different results.
											*/

											SET @TTAUDIT_TEMP = substring(@TTAUDIT_TEMP, 1, ssma_oracle.instr2_varchar(@TTAUDIT_TEMP, '&') - 1)

										SET @TTAUDIT_APP_USER_ID = @TTAUDIT_TEMP

									END

								/* Retrieve the ttaudit_ip_addr from ASP.NET (if available)*/
								IF (@TTAUDIT_CLIENTID LIKE '%ttaudit_ip_addr=%')
									BEGIN

										/*
										*   SSMA warning messages:
										*   O2SS0273: Oracle SUBSTR function and SQL Server SUBSTRING function may give different results.
										*/

										SET @TTAUDIT_TEMP = substring(@TTAUDIT_CLIENTID, ssma_oracle.instr2_varchar(@TTAUDIT_CLIENTID, 'ttaudit_ip_addr=') + ssma_oracle.length_char('ttaudit_ip_addr='), 999)

										IF (@TTAUDIT_TEMP LIKE '%&%')
											/*
											*   SSMA warning messages:
											*   O2SS0273: Oracle SUBSTR function and SQL Server SUBSTRING function may give different results.
											*/

											SET @TTAUDIT_TEMP = substring(@TTAUDIT_TEMP, 1, ssma_oracle.instr2_varchar(@TTAUDIT_TEMP, '&') - 1)

										SET @TTAUDIT_IP_ADDR = @TTAUDIT_TEMP

									END

								/* Determine the reason for auditing.*/
								IF @triggerType = 'I'
									SET @TTAUDIT_REASON = 'INSERT'
								ELSE 
									IF @triggerType = 'U'
										SET @TTAUDIT_REASON = 'UPDATE'
									ELSE 
										BEGIN
											IF @triggerType = 'D'
												SET @TTAUDIT_REASON = 'DELETE'
										END

								/* Determine what row_id we are auditing.*/
								IF @triggerType = 'I'
									SET @TTAUDIT_ROW_ID = @NEW$ROW_ID
								ELSE 
									IF @triggerType = 'U'
										SET @TTAUDIT_ROW_ID = @OLD$ROW_ID
									ELSE 
										BEGIN
											IF @triggerType = 'D'
												SET @TTAUDIT_ROW_ID = @OLD$ROW_ID
										END

								IF @triggerType = 'U' OR @triggerType = 'D'
									/* Update any existing _TTAUDIT rows, closing off the 'audit_delete_date'*/
									UPDATE EFORMS_OWN.ARTWORK_GMM_PRODUCT_DETAILS_TTAUDIT
									   SET 
									   	AUDIT_DELETE_DATE = @TTAUDIT_DATE, 
									   	AUDIT_DELETE_REASON = @TTAUDIT_REASON, 
									   	AUDIT_DELETE_APP_USER_ID = @TTAUDIT_APP_USER_ID, 
									   	AUDIT_DELETE_DB_USER_ID = @TTAUDIT_DB_USER_ID, 
									   	AUDIT_DELETE_IP_ADDR = @TTAUDIT_IP_ADDR
									  WHERE ARTWORK_GMM_PRODUCT_DETAILS_TTAUDIT.ROW_ID = @TTAUDIT_ROW_ID AND ARTWORK_GMM_PRODUCT_DETAILS_TTAUDIT.AUDIT_DELETE_DATE > @TTAUDIT_DATE

								IF @triggerType = 'U' OR @triggerType = 'I'
									/* 
									*   SSMA error messages:
									*   O2SS0050: Conversion of identifier 'TO_TIMESTAMP(CHAR, CHAR)' is not supported.

									/* Insert a new _TTAUDIT row with an open-ended 'audit_delete_date'*/
									INSERT EFORMS_OWN.ARTWORK_GMM_PRODUCT_DETAILS_TTAUDIT(
									   ROW_ID, 
									   GMM_CODE, 
									   PRODUCT_DESCRIPTION, 
									   IS_ACTIVE, 
									   LOCAL_SKU_CODE, 
									   AUDIT_INSERT_DATE, 
									   AUDIT_INSERT_REASON, 
									   AUDIT_INSERT_APP_USER_ID, 
									   AUDIT_INSERT_DB_USER_ID, 
									   AUDIT_INSERT_IP_ADDR, 
									   AUDIT_DELETE_DATE, 
									   AUDIT_DELETE_REASON, 
									   AUDIT_DELETE_APP_USER_ID, 
									   AUDIT_DELETE_DB_USER_ID, 
									   AUDIT_DELETE_IP_ADDR)
									   VALUES (
									   	@NEW$ROW_ID, 
									   	@NEW$GMM_CODE, 
									   	@NEW$PRODUCT_DESCRIPTION, 
									   	@NEW$IS_ACTIVE, 
									   	@NEW$LOCAL_SKU_CODE, 
									   	@TTAUDIT_DATE/*audit_insert_date*/, 
									   	@TTAUDIT_REASON/*audit_insert_reason*/, 
									   	@TTAUDIT_APP_USER_ID/*audit_insert_app_user_id*/, 
									   	@TTAUDIT_DB_USER_ID/*audit_insert_db_user_id*/, 
									   	@TTAUDIT_IP_ADDR/*audit_insert_ip_addr*/, 
									   	TO_TIMESTAMP('2999-12-31 23:59:59.999999', 'YYYY-MM-DD HH24:MI:SS.FF')/*audit_delete_date is "end of time".*/, 
									   	NULL/*audit_delete_reason      is blank; row has not been deleted.*/, 
									   	NULL/*audit_delete_app_user_id is blank; row has not been deleted.*/, 
									   	NULL/*audit_delete_db_user_id  is blank; row has not been deleted.*/, 
									   	NULL/*audit_delete_ip_addr     is blank; row has not been deleted.*/)
									*/


									DECLARE
										@db_null_statement int

								IF @triggerType = 'U'
									BEGIN

										IF (ssma_oracle.trim2_varchar(3, @OLD$PRODUCT_DESCRIPTION) IS NULL OR ssma_oracle.trim2_varchar(3, @OLD$LOCAL_SKU_CODE) IS NULL) AND (ssma_oracle.trim2_varchar(3, @NEW$PRODUCT_DESCRIPTION) IS NOT NULL OR ssma_oracle.trim2_varchar(3, @NEW$LOCAL_SKU_CODE) IS NOT NULL)
											BEGIN

												UPDATE EFORMS_OWN.REQUEST_DETAIL
												   SET 
												   	FIELD_VALUE = @NEW$LOCAL_SKU_CODE
												  WHERE 
												  	REQUEST_DETAIL.FIELD_ID = 461000302 AND 
												  	ssma_oracle.trim2_varchar(3, REQUEST_DETAIL.FIELD_VALUE) IS NULL AND 
												  	REQUEST_DETAIL.REQUEST_ID IN 
												  	(
												  		SELECT REQUEST_DETAIL$2.REQUEST_ID
												  		FROM EFORMS_OWN.REQUEST_DETAIL  AS REQUEST_DETAIL$2
												  		WHERE REQUEST_DETAIL$2.FIELD_ID = 461000301 AND REQUEST_DETAIL$2.FIELD_VALUE = @NEW$GMM_CODE
												  	)

												UPDATE EFORMS_OWN.REQUEST_DETAIL
												   SET 
												   	FIELD_VALUE = @NEW$PRODUCT_DESCRIPTION
												  WHERE 
												  	REQUEST_DETAIL.FIELD_ID = 461000303 AND 
												  	ssma_oracle.trim2_varchar(3, REQUEST_DETAIL.FIELD_VALUE) IS NULL AND 
												  	REQUEST_DETAIL.REQUEST_ID IN 
												  	(
												  		SELECT REQUEST_DETAIL$2.REQUEST_ID
												  		FROM EFORMS_OWN.REQUEST_DETAIL  AS REQUEST_DETAIL$2
												  		WHERE REQUEST_DETAIL$2.FIELD_ID = 461000301 AND REQUEST_DETAIL$2.FIELD_VALUE = @NEW$GMM_CODE
												  	)

											END

										PRINT 'Trigger update - ending.'

									END

							END

					END
					/* trigger implementation: end*/

					FETCH ForEachInsertedRowTriggerCursor
						 INTO 
							@NEW$0, 
							@NEW$ROW_ID, 
							@NEW$GMM_CODE, 
							@NEW$PRODUCT_DESCRIPTION, 
							@NEW$IS_ACTIVE, 
							@NEW$LOCAL_SKU_CODE

				END

			CLOSE ForEachInsertedRowTriggerCursor

			DEALLOCATE ForEachInsertedRowTriggerCursor

		END
GO
CREATE TRIGGER EFORMS_OWN.ARTWORK_GMM_PRODUCT_DETAILS_TRG$AfterDelete
	ON EFORMS_OWN.ARTWORK_GMM_PRODUCT_DETAILS
	 AFTER DELETE
	AS 
		BEGIN

			SET  NOCOUNT  ON

			DECLARE
				@triggerType char(1)

			SELECT @triggerType = 'D'

			/* column variables declaration*/
			DECLARE
				@OLD$0 uniqueidentifier, 
				/*
				*   SSMA warning messages:
				*   O2SS0356: Conversion from NUMBER datatype can cause data loss.
				*/

				@NEW$ROW_ID float(53), 
				/*
				*   SSMA warning messages:
				*   O2SS0356: Conversion from NUMBER datatype can cause data loss.
				*/

				@OLD$ROW_ID float(53), 
				@NEW$GMM_CODE varchar(500), 
				@OLD$GMM_CODE varchar(500), 
				@NEW$PRODUCT_DESCRIPTION varchar(500), 
				@OLD$PRODUCT_DESCRIPTION varchar(500), 
				@NEW$IS_ACTIVE char(1), 
				@OLD$IS_ACTIVE char(1), 
				@NEW$LOCAL_SKU_CODE varchar(20), 
				@OLD$LOCAL_SKU_CODE varchar(20)

			DECLARE
				 ForEachDeletedRowTriggerCursor CURSOR LOCAL FORWARD_ONLY READ_ONLY FOR 
					SELECT 
						ROWID, 
						ROW_ID, 
						GMM_CODE, 
						PRODUCT_DESCRIPTION, 
						IS_ACTIVE, 
						LOCAL_SKU_CODE
					FROM deleted

			OPEN ForEachDeletedRowTriggerCursor

			FETCH ForEachDeletedRowTriggerCursor
				 INTO 
					@OLD$0, 
					@OLD$ROW_ID, 
					@OLD$GMM_CODE, 
					@OLD$PRODUCT_DESCRIPTION, 
					@OLD$IS_ACTIVE, 
					@OLD$LOCAL_SKU_CODE

			WHILE @@fetch_status = 0
			
				BEGIN

					/* trigger implementation: begin*/
					BEGIN

						DECLARE
							@TTAUDIT_SKIP char(1), 
							/*
							*   SSMA warning messages:
							*   O2SS0356: Conversion from NUMBER datatype can cause data loss.
							*/

							@TTAUDIT_ROW_ID float(53), 
							@TTAUDIT_DATE datetime2(6), 
							@TTAUDIT_REASON varchar(6), 
							@TTAUDIT_APP_USER_ID varchar(10), 
							@TTAUDIT_DB_USER_ID varchar(64), 
							@TTAUDIT_IP_ADDR varchar(39), 
							@TTAUDIT_CLIENTID varchar(4000), 
							@TTAUDIT_TEMP varchar(4000)

						SET @TTAUDIT_SKIP = 'N'

						IF @triggerType = 'U'
							BEGIN
								IF 
									(@OLD$ROW_ID = @NEW$ROW_ID) AND 
									(@OLD$GMM_CODE = @NEW$GMM_CODE) AND 
									(@OLD$PRODUCT_DESCRIPTION = @NEW$PRODUCT_DESCRIPTION) AND 
									(@OLD$IS_ACTIVE = @NEW$IS_ACTIVE) AND 
									(@OLD$LOCAL_SKU_CODE = @NEW$LOCAL_SKU_CODE)
									SET @TTAUDIT_SKIP = 'Y'
							END

						IF (@TTAUDIT_SKIP = 'N')
							BEGIN

								SELECT @TTAUDIT_DATE = switchoffset(sysdatetimeoffset(), 0)

								SELECT @TTAUDIT_APP_USER_ID = NULL

								/* 
								*   SSMA error messages:
								*   O2SS0050: Conversion of identifier 'SYS_CONTEXT(CHAR, CHAR)' is not supported.

								SELECT @TTAUDIT_DB_USER_ID = lower(SYS_CONTEXT('USERENV', 'OS_USER'))
								*/



								/* 
								*   SSMA error messages:
								*   O2SS0050: Conversion of identifier 'SYS_CONTEXT(CHAR, CHAR)' is not supported.

								SELECT @TTAUDIT_IP_ADDR = lower(SYS_CONTEXT('USERENV', 'IP_ADDRESS'))
								*/



								/* 
								*   SSMA error messages:
								*   O2SS0050: Conversion of identifier 'SYS_CONTEXT(CHAR, CHAR)' is not supported.

								SELECT @TTAUDIT_CLIENTID = lower(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'))
								*/



								IF (@TTAUDIT_CLIENTID LIKE '%ttaudit_user_id=%')
									BEGIN

										/*
										*   SSMA warning messages:
										*   O2SS0273: Oracle SUBSTR function and SQL Server SUBSTRING function may give different results.
										*/

										SET @TTAUDIT_TEMP = substring(@TTAUDIT_CLIENTID, ssma_oracle.instr2_varchar(@TTAUDIT_CLIENTID, 'ttaudit_user_id=') + ssma_oracle.length_char('ttaudit_user_id='), 999)

										IF (@TTAUDIT_TEMP LIKE '%&%')
											/*
											*   SSMA warning messages:
											*   O2SS0273: Oracle SUBSTR function and SQL Server SUBSTRING function may give different results.
											*/

											SET @TTAUDIT_TEMP = substring(@TTAUDIT_TEMP, 1, ssma_oracle.instr2_varchar(@TTAUDIT_TEMP, '&') - 1)

										SET @TTAUDIT_APP_USER_ID = @TTAUDIT_TEMP

									END

								IF (@TTAUDIT_CLIENTID LIKE '%ttaudit_ip_addr=%')
									BEGIN

										/*
										*   SSMA warning messages:
										*   O2SS0273: Oracle SUBSTR function and SQL Server SUBSTRING function may give different results.
										*/

										SET @TTAUDIT_TEMP = substring(@TTAUDIT_CLIENTID, ssma_oracle.instr2_varchar(@TTAUDIT_CLIENTID, 'ttaudit_ip_addr=') + ssma_oracle.length_char('ttaudit_ip_addr='), 999)

										IF (@TTAUDIT_TEMP LIKE '%&%')
											/*
											*   SSMA warning messages:
											*   O2SS0273: Oracle SUBSTR function and SQL Server SUBSTRING function may give different results.
											*/

											SET @TTAUDIT_TEMP = substring(@TTAUDIT_TEMP, 1, ssma_oracle.instr2_varchar(@TTAUDIT_TEMP, '&') - 1)

										SET @TTAUDIT_IP_ADDR = @TTAUDIT_TEMP

									END

								IF @triggerType = 'I'
									SET @TTAUDIT_REASON = 'INSERT'
								ELSE 
									IF @triggerType = 'U'
										SET @TTAUDIT_REASON = 'UPDATE'
									ELSE 
										BEGIN
											IF @triggerType = 'D'
												SET @TTAUDIT_REASON = 'DELETE'
										END

								IF @triggerType = 'I'
									SET @TTAUDIT_ROW_ID = @NEW$ROW_ID
								ELSE 
									IF @triggerType = 'U'
										SET @TTAUDIT_ROW_ID = @OLD$ROW_ID
									ELSE 
										BEGIN
											IF @triggerType = 'D'
												SET @TTAUDIT_ROW_ID = @OLD$ROW_ID
										END

								IF @triggerType = 'U' OR @triggerType = 'D'
									UPDATE EFORMS_OWN.ARTWORK_GMM_PRODUCT_DETAILS_TTAUDIT
									   SET 
									   	AUDIT_DELETE_DATE = @TTAUDIT_DATE, 
									   	AUDIT_DELETE_REASON = @TTAUDIT_REASON, 
									   	AUDIT_DELETE_APP_USER_ID = @TTAUDIT_APP_USER_ID, 
									   	AUDIT_DELETE_DB_USER_ID = @TTAUDIT_DB_USER_ID, 
									   	AUDIT_DELETE_IP_ADDR = @TTAUDIT_IP_ADDR
									  WHERE ARTWORK_GMM_PRODUCT_DETAILS_TTAUDIT.ROW_ID = @TTAUDIT_ROW_ID AND ARTWORK_GMM_PRODUCT_DETAILS_TTAUDIT.AUDIT_DELETE_DATE > @TTAUDIT_DATE

								IF @triggerType = 'U' OR @triggerType = 'I'
									/* 
									*   SSMA error messages:
									*   O2SS0050: Conversion of identifier 'TO_TIMESTAMP(CHAR, CHAR)' is not supported.

									INSERT EFORMS_OWN.ARTWORK_GMM_PRODUCT_DETAILS_TTAUDIT(
									   ROW_ID, 
									   GMM_CODE, 
									   PRODUCT_DESCRIPTION, 
									   IS_ACTIVE, 
									   LOCAL_SKU_CODE, 
									   AUDIT_INSERT_DATE, 
									   AUDIT_INSERT_REASON, 
									   AUDIT_INSERT_APP_USER_ID, 
									   AUDIT_INSERT_DB_USER_ID, 
									   AUDIT_INSERT_IP_ADDR, 
									   AUDIT_DELETE_DATE, 
									   AUDIT_DELETE_REASON, 
									   AUDIT_DELETE_APP_USER_ID, 
									   AUDIT_DELETE_DB_USER_ID, 
									   AUDIT_DELETE_IP_ADDR)
									   VALUES (
									   	@NEW$ROW_ID, 
									   	@NEW$GMM_CODE, 
									   	@NEW$PRODUCT_DESCRIPTION, 
									   	@NEW$IS_ACTIVE, 
									   	@NEW$LOCAL_SKU_CODE, 
									   	@TTAUDIT_DATE, 
									   	@TTAUDIT_REASON, 
									   	@TTAUDIT_APP_USER_ID, 
									   	@TTAUDIT_DB_USER_ID, 
									   	@TTAUDIT_IP_ADDR, 
									   	TO_TIMESTAMP('2999-12-31 23:59:59.999999', 'YYYY-MM-DD HH24:MI:SS.FF'), 
									   	NULL, 
									   	NULL, 
									   	NULL, 
									   	NULL)
									*/


									DECLARE
										@db_null_statement int

								IF @triggerType = 'U'
									BEGIN

										IF (ssma_oracle.trim2_varchar(3, @OLD$PRODUCT_DESCRIPTION) IS NULL OR ssma_oracle.trim2_varchar(3, @OLD$LOCAL_SKU_CODE) IS NULL) AND (ssma_oracle.trim2_varchar(3, @NEW$PRODUCT_DESCRIPTION) IS NOT NULL OR ssma_oracle.trim2_varchar(3, @NEW$LOCAL_SKU_CODE) IS NOT NULL)
											BEGIN

												UPDATE EFORMS_OWN.REQUEST_DETAIL
												   SET 
												   	FIELD_VALUE = @NEW$LOCAL_SKU_CODE
												  WHERE 
												  	REQUEST_DETAIL.FIELD_ID = 461000302 AND 
												  	ssma_oracle.trim2_varchar(3, REQUEST_DETAIL.FIELD_VALUE) IS NULL AND 
												  	REQUEST_DETAIL.REQUEST_ID IN 
												  	(
												  		SELECT REQUEST_DETAIL$2.REQUEST_ID
												  		FROM EFORMS_OWN.REQUEST_DETAIL  AS REQUEST_DETAIL$2
												  		WHERE REQUEST_DETAIL$2.FIELD_ID = 461000301 AND REQUEST_DETAIL$2.FIELD_VALUE = @NEW$GMM_CODE
												  	)

												UPDATE EFORMS_OWN.REQUEST_DETAIL
												   SET 
												   	FIELD_VALUE = @NEW$PRODUCT_DESCRIPTION
												  WHERE 
												  	REQUEST_DETAIL.FIELD_ID = 461000303 AND 
												  	ssma_oracle.trim2_varchar(3, REQUEST_DETAIL.FIELD_VALUE) IS NULL AND 
												  	REQUEST_DETAIL.REQUEST_ID IN 
												  	(
												  		SELECT REQUEST_DETAIL$2.REQUEST_ID
												  		FROM EFORMS_OWN.REQUEST_DETAIL  AS REQUEST_DETAIL$2
												  		WHERE REQUEST_DETAIL$2.FIELD_ID = 461000301 AND REQUEST_DETAIL$2.FIELD_VALUE = @NEW$GMM_CODE
												  	)

											END

										PRINT 'Trigger update - ending.'

									END

							END

					END
					/* trigger implementation: end*/

					FETCH ForEachDeletedRowTriggerCursor
						 INTO 
							@OLD$0, 
							@OLD$ROW_ID, 
							@OLD$GMM_CODE, 
							@OLD$PRODUCT_DESCRIPTION, 
							@OLD$IS_ACTIVE, 
							@OLD$LOCAL_SKU_CODE

				END

			CLOSE ForEachDeletedRowTriggerCursor

			DEALLOCATE ForEachDeletedRowTriggerCursor

		END
GO
CREATE TRIGGER EFORMS_OWN.ARTWORK_GMM_PRODUCT_DETAILS_TRG$AfterUpdate
	ON EFORMS_OWN.ARTWORK_GMM_PRODUCT_DETAILS
	 AFTER UPDATE
	AS 
		BEGIN

			SET  NOCOUNT  ON

			DECLARE
				@triggerType char(1)

			SELECT @triggerType = 'U'

			/* column variables declaration*/
			DECLARE
				@NEW$0 uniqueidentifier, 
				@OLD$0 uniqueidentifier, 
				/*
				*   SSMA warning messages:
				*   O2SS0356: Conversion from NUMBER datatype can cause data loss.
				*/

				@NEW$ROW_ID float(53), 
				/*
				*   SSMA warning messages:
				*   O2SS0356: Conversion from NUMBER datatype can cause data loss.
				*/

				@OLD$ROW_ID float(53), 
				@NEW$GMM_CODE varchar(500), 
				@OLD$GMM_CODE varchar(500), 
				@NEW$PRODUCT_DESCRIPTION varchar(500), 
				@OLD$PRODUCT_DESCRIPTION varchar(500), 
				@NEW$IS_ACTIVE char(1), 
				@OLD$IS_ACTIVE char(1), 
				@NEW$LOCAL_SKU_CODE varchar(20), 
				@OLD$LOCAL_SKU_CODE varchar(20)

			DECLARE
				 ForEachInsertedRowTriggerCursor CURSOR LOCAL FORWARD_ONLY READ_ONLY FOR 
					SELECT 
						ROWID, 
						ROW_ID, 
						GMM_CODE, 
						PRODUCT_DESCRIPTION, 
						IS_ACTIVE, 
						LOCAL_SKU_CODE
					FROM inserted

			OPEN ForEachInsertedRowTriggerCursor

			FETCH ForEachInsertedRowTriggerCursor
				 INTO 
					@NEW$0, 
					@NEW$ROW_ID, 
					@NEW$GMM_CODE, 
					@NEW$PRODUCT_DESCRIPTION, 
					@NEW$IS_ACTIVE, 
					@NEW$LOCAL_SKU_CODE

			WHILE @@fetch_status = 0
			
				BEGIN

					SELECT 
						@OLD$0 = ROWID, 
						@OLD$ROW_ID = ROW_ID, 
						@OLD$GMM_CODE = GMM_CODE, 
						@OLD$PRODUCT_DESCRIPTION = PRODUCT_DESCRIPTION, 
						@OLD$IS_ACTIVE = IS_ACTIVE, 
						@OLD$LOCAL_SKU_CODE = LOCAL_SKU_CODE
					FROM deleted
					WHERE ROWID = @NEW$0

					/* trigger implementation: begin*/
					BEGIN

						DECLARE
							@TTAUDIT_SKIP char(1), 
							/*
							*   SSMA warning messages:
							*   O2SS0356: Conversion from NUMBER datatype can cause data loss.
							*/

							@TTAUDIT_ROW_ID float(53), 
							@TTAUDIT_DATE datetime2(6), 
							@TTAUDIT_REASON varchar(6), 
							@TTAUDIT_APP_USER_ID varchar(10), 
							@TTAUDIT_DB_USER_ID varchar(64), 
							@TTAUDIT_IP_ADDR varchar(39), 
							@TTAUDIT_CLIENTID varchar(4000), 
							@TTAUDIT_TEMP varchar(4000)

						SET @TTAUDIT_SKIP = 'N'

						IF @triggerType = 'U'
							BEGIN
								IF 
									(@OLD$ROW_ID = @NEW$ROW_ID) AND 
									(@OLD$GMM_CODE = @NEW$GMM_CODE) AND 
									(@OLD$PRODUCT_DESCRIPTION = @NEW$PRODUCT_DESCRIPTION) AND 
									(@OLD$IS_ACTIVE = @NEW$IS_ACTIVE) AND 
									(@OLD$LOCAL_SKU_CODE = @NEW$LOCAL_SKU_CODE)
									SET @TTAUDIT_SKIP = 'Y'
							END

						IF (@TTAUDIT_SKIP = 'N')
							BEGIN

								SELECT @TTAUDIT_DATE = switchoffset(sysdatetimeoffset(), 0)

								SELECT @TTAUDIT_APP_USER_ID = NULL

								/* 
								*   SSMA error messages:
								*   O2SS0050: Conversion of identifier 'SYS_CONTEXT(CHAR, CHAR)' is not supported.

								SELECT @TTAUDIT_DB_USER_ID = lower(SYS_CONTEXT('USERENV', 'OS_USER'))
								*/



								/* 
								*   SSMA error messages:
								*   O2SS0050: Conversion of identifier 'SYS_CONTEXT(CHAR, CHAR)' is not supported.

								SELECT @TTAUDIT_IP_ADDR = lower(SYS_CONTEXT('USERENV', 'IP_ADDRESS'))
								*/



								/* 
								*   SSMA error messages:
								*   O2SS0050: Conversion of identifier 'SYS_CONTEXT(CHAR, CHAR)' is not supported.

								SELECT @TTAUDIT_CLIENTID = lower(SYS_CONTEXT('USERENV', 'CLIENT_IDENTIFIER'))
								*/



								IF (@TTAUDIT_CLIENTID LIKE '%ttaudit_user_id=%')
									BEGIN

										/*
										*   SSMA warning messages:
										*   O2SS0273: Oracle SUBSTR function and SQL Server SUBSTRING function may give different results.
										*/

										SET @TTAUDIT_TEMP = substring(@TTAUDIT_CLIENTID, ssma_oracle.instr2_varchar(@TTAUDIT_CLIENTID, 'ttaudit_user_id=') + ssma_oracle.length_char('ttaudit_user_id='), 999)

										IF (@TTAUDIT_TEMP LIKE '%&%')
											/*
											*   SSMA warning messages:
											*   O2SS0273: Oracle SUBSTR function and SQL Server SUBSTRING function may give different results.
											*/

											SET @TTAUDIT_TEMP = substring(@TTAUDIT_TEMP, 1, ssma_oracle.instr2_varchar(@TTAUDIT_TEMP, '&') - 1)

										SET @TTAUDIT_APP_USER_ID = @TTAUDIT_TEMP

									END

								IF (@TTAUDIT_CLIENTID LIKE '%ttaudit_ip_addr=%')
									BEGIN

										/*
										*   SSMA warning messages:
										*   O2SS0273: Oracle SUBSTR function and SQL Server SUBSTRING function may give different results.
										*/

										SET @TTAUDIT_TEMP = substring(@TTAUDIT_CLIENTID, ssma_oracle.instr2_varchar(@TTAUDIT_CLIENTID, 'ttaudit_ip_addr=') + ssma_oracle.length_char('ttaudit_ip_addr='), 999)

										IF (@TTAUDIT_TEMP LIKE '%&%')
											/*
											*   SSMA warning messages:
											*   O2SS0273: Oracle SUBSTR function and SQL Server SUBSTRING function may give different results.
											*/

											SET @TTAUDIT_TEMP = substring(@TTAUDIT_TEMP, 1, ssma_oracle.instr2_varchar(@TTAUDIT_TEMP, '&') - 1)

										SET @TTAUDIT_IP_ADDR = @TTAUDIT_TEMP

									END

								IF @triggerType = 'I'
									SET @TTAUDIT_REASON = 'INSERT'
								ELSE 
									IF @triggerType = 'U'
										SET @TTAUDIT_REASON = 'UPDATE'
									ELSE 
										BEGIN
											IF @triggerType = 'D'
												SET @TTAUDIT_REASON = 'DELETE'
										END

								IF @triggerType = 'I'
									SET @TTAUDIT_ROW_ID = @NEW$ROW_ID
								ELSE 
									IF @triggerType = 'U'
										SET @TTAUDIT_ROW_ID = @OLD$ROW_ID
									ELSE 
										BEGIN
											IF @triggerType = 'D'
												SET @TTAUDIT_ROW_ID = @OLD$ROW_ID
										END

								IF @triggerType = 'U' OR @triggerType = 'D'
									UPDATE EFORMS_OWN.ARTWORK_GMM_PRODUCT_DETAILS_TTAUDIT
									   SET 
									   	AUDIT_DELETE_DATE = @TTAUDIT_DATE, 
									   	AUDIT_DELETE_REASON = @TTAUDIT_REASON, 
									   	AUDIT_DELETE_APP_USER_ID = @TTAUDIT_APP_USER_ID, 
									   	AUDIT_DELETE_DB_USER_ID = @TTAUDIT_DB_USER_ID, 
									   	AUDIT_DELETE_IP_ADDR = @TTAUDIT_IP_ADDR
									  WHERE ARTWORK_GMM_PRODUCT_DETAILS_TTAUDIT.ROW_ID = @TTAUDIT_ROW_ID AND ARTWORK_GMM_PRODUCT_DETAILS_TTAUDIT.AUDIT_DELETE_DATE > @TTAUDIT_DATE

								IF @triggerType = 'U' OR @triggerType = 'I'
									/* 
									*   SSMA error messages:
									*   O2SS0050: Conversion of identifier 'TO_TIMESTAMP(CHAR, CHAR)' is not supported.

									INSERT EFORMS_OWN.ARTWORK_GMM_PRODUCT_DETAILS_TTAUDIT(
									   ROW_ID, 
									   GMM_CODE, 
									   PRODUCT_DESCRIPTION, 
									   IS_ACTIVE, 
									   LOCAL_SKU_CODE, 
									   AUDIT_INSERT_DATE, 
									   AUDIT_INSERT_REASON, 
									   AUDIT_INSERT_APP_USER_ID, 
									   AUDIT_INSERT_DB_USER_ID, 
									   AUDIT_INSERT_IP_ADDR, 
									   AUDIT_DELETE_DATE, 
									   AUDIT_DELETE_REASON, 
									   AUDIT_DELETE_APP_USER_ID, 
									   AUDIT_DELETE_DB_USER_ID, 
									   AUDIT_DELETE_IP_ADDR)
									   VALUES (
									   	@NEW$ROW_ID, 
									   	@NEW$GMM_CODE, 
									   	@NEW$PRODUCT_DESCRIPTION, 
									   	@NEW$IS_ACTIVE, 
									   	@NEW$LOCAL_SKU_CODE, 
									   	@TTAUDIT_DATE, 
									   	@TTAUDIT_REASON, 
									   	@TTAUDIT_APP_USER_ID, 
									   	@TTAUDIT_DB_USER_ID, 
									   	@TTAUDIT_IP_ADDR, 
									   	TO_TIMESTAMP('2999-12-31 23:59:59.999999', 'YYYY-MM-DD HH24:MI:SS.FF'), 
									   	NULL, 
									   	NULL, 
									   	NULL, 
									   	NULL)
									*/


									DECLARE
										@db_null_statement int

								IF @triggerType = 'U'
									BEGIN

										IF (ssma_oracle.trim2_varchar(3, @OLD$PRODUCT_DESCRIPTION) IS NULL OR ssma_oracle.trim2_varchar(3, @OLD$LOCAL_SKU_CODE) IS NULL) AND (ssma_oracle.trim2_varchar(3, @NEW$PRODUCT_DESCRIPTION) IS NOT NULL OR ssma_oracle.trim2_varchar(3, @NEW$LOCAL_SKU_CODE) IS NOT NULL)
											BEGIN

												UPDATE EFORMS_OWN.REQUEST_DETAIL
												   SET 
												   	FIELD_VALUE = @NEW$LOCAL_SKU_CODE
												  WHERE 
												  	REQUEST_DETAIL.FIELD_ID = 461000302 AND 
												  	ssma_oracle.trim2_varchar(3, REQUEST_DETAIL.FIELD_VALUE) IS NULL AND 
												  	REQUEST_DETAIL.REQUEST_ID IN 
												  	(
												  		SELECT REQUEST_DETAIL$2.REQUEST_ID
												  		FROM EFORMS_OWN.REQUEST_DETAIL  AS REQUEST_DETAIL$2
												  		WHERE REQUEST_DETAIL$2.FIELD_ID = 461000301 AND REQUEST_DETAIL$2.FIELD_VALUE = @NEW$GMM_CODE
												  	)

												UPDATE EFORMS_OWN.REQUEST_DETAIL
												   SET 
												   	FIELD_VALUE = @NEW$PRODUCT_DESCRIPTION
												  WHERE 
												  	REQUEST_DETAIL.FIELD_ID = 461000303 AND 
												  	ssma_oracle.trim2_varchar(3, REQUEST_DETAIL.FIELD_VALUE) IS NULL AND 
												  	REQUEST_DETAIL.REQUEST_ID IN 
												  	(
												  		SELECT REQUEST_DETAIL$2.REQUEST_ID
												  		FROM EFORMS_OWN.REQUEST_DETAIL  AS REQUEST_DETAIL$2
												  		WHERE REQUEST_DETAIL$2.FIELD_ID = 461000301 AND REQUEST_DETAIL$2.FIELD_VALUE = @NEW$GMM_CODE
												  	)

											END

										PRINT 'Trigger update - ending.'

									END

							END

					END
					/* trigger implementation: end*/

					FETCH ForEachInsertedRowTriggerCursor
						 INTO 
							@NEW$0, 
							@NEW$ROW_ID, 
							@NEW$GMM_CODE, 
							@NEW$PRODUCT_DESCRIPTION, 
							@NEW$IS_ACTIVE, 
							@NEW$LOCAL_SKU_CODE

				END

			CLOSE ForEachInsertedRowTriggerCursor

			DEALLOCATE ForEachInsertedRowTriggerCursor

		END
GO