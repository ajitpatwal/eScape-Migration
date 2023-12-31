/****** Object:  Trigger [EFORMS_OWN].[ARTWORK_GMM_PRODUCT_DETAILS_TRG]    Script Date: 8/13/2023 8:32:24 AM ******/
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



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [EFORMS_OWN].[ARTWORK_GMM_PRODUCT_DETAILS_TRG]
	ON [EFORMS_OWN].[ARTWORK_GMM_PRODUCT_DETAILS]
	AFTER INSERT,UPDATE,DELETE
	AS
		BEGIN
		
			SET  NOCOUNT  ON

			DECLARE
				@triggerType char(1);

			SELECT @triggerType = 'I'

			DECLARE
				@NEW_row uniqueidentifier, 

				--@TTAUDIT_SKIP char(1), 
				@NEW_ROW_ID float, 
				@NEW_GMM_CODE nvarchar(500), 
				@NEW_PRODUCT_DESCRIPTION nvarchar(500), 
				@NEW_IS_ACTIVE char(1), 
				@NEW_LOCAL_SKU_CODE varchar(20), 

				@OLD_ROW_ID float, 
				@OLD_GMM_CODE nvarchar(500), 
				@OLD_PRODUCT_DESCRIPTION nvarchar(500), 
				@OLD_IS_ACTIVE char(1), 
				@OLD_LOCAL_SKU_CODE varchar(20)

			DECLARE
				 ForEachInsertedRowTriggerCursor CURSOR LOCAL FORWARD_ONLY READ_ONLY FOR 
					SELECT 
						--NEW_row, 
						ROW_ID, 
						GMM_CODE, 
						PRODUCT_DESCRIPTION, 
						IS_ACTIVE, 
						LOCAL_SKU_CODE
					FROM inserted
			--@New_row = new
			OPEN ForEachInsertedRowTriggerCursor

			FETCH ForEachInsertedRowTriggerCursor
				 INTO 
					--@NEW_row, 
					@NEW_ROW_ID, 
					@NEW_GMM_CODE, 
					@NEW_PRODUCT_DESCRIPTION, 
					@NEW_IS_ACTIVE, 
					@NEW_LOCAL_SKU_CODE

			WHILE @@fetch_status = 0

			BEGIN

				DECLARE
					@TTAUDIT_SKIP char(1), 
					@TTAUDIT_ROW_ID float, 
					@TTAUDIT_DATE datetime2(6), 
					@TTAUDIT_REASON varchar(6), 
					@TTAUDIT_APP_USER_ID varchar(10), 
					@TTAUDIT_DB_USER_ID varchar(64), 
					@TTAUDIT_IP_ADDR varchar(39), 
					@TTAUDIT_CLIENTID Nvarchar(4000), 
					@TTAUDIT_TEMP Nvarchar(4000);

			/* By default, don't skip the auditing.*/
				SET @TTAUDIT_SKIP = 'N'

				--IF @TTAUDIT_SKIP = 'N'
				--	BEGIN
						
						/*
						*    Check the old row versus the new row, column-by-column.
						*    If all values are identical, then skip the auditing.
						*/
						IF 
							(@OLD_ROW_ID = @NEW_ROW_ID) AND 
							(@OLD_GMM_CODE = @NEW_GMM_CODE) AND 
							(@OLD_PRODUCT_DESCRIPTION = @NEW_PRODUCT_DESCRIPTION) AND 
							(@OLD_IS_ACTIVE = @NEW_IS_ACTIVE) AND 
							(@OLD_LOCAL_SKU_CODE = @NEW_LOCAL_SKU_CODE)
							SET @TTAUDIT_SKIP = 'Y'
						END

						IF (@ttaudit_skip = 'N') 
						BEGIN

					/* Determine the values of the 'audit_insert%' and 'audit_delete%' columns*/
						SET @TTAUDIT_DATE = getutcdate()
						SET @ttaudit_app_user_id = ''
						SET @ttaudit_db_user_id = ORIGINAL_LOGIN()
						SET @ttaudit_ip_addr = CAST(CONNECTIONPROPERTY('client_net_address') as varchar(200))
						SET @ttaudit_clientid = HOST_NAME()
--SELECT				
						END
--           ORIGINAL_DB_NAME(), 
--           ORIGINAL_LOGIN(),
--           @@SPID,GETDATE(),
--           HOST_NAME(),
--           APP_NAME()

--declare  @IP_Address nvarchar(200)
--SELECT @IP_Address = CAST(CONNECTIONPROPERTY('client_net_address') as varchar(200))
--print(@IP_Address)

---instr provides the index of a char or sting in the string
						IF (@TTAUDIT_CLIENTID LIKE '%ttaudit_user_id=%')
						BEGIN
							SET @TTAUDIT_TEMP = substring(@TTAUDIT_CLIENTID, CHARINDEX(@TTAUDIT_CLIENTID, 'ttaudit_user_id=') 
													+ LEN('ttaudit_user_id='), 999)

						IF (@TTAUDIT_TEMP LIKE '%&%')
											/*
											*   SSMA warning messages:
											*   O2SS0273: Oracle SUBSTR function and SQL Server SUBSTRING function may give different results.
											*/

							SET @TTAUDIT_TEMP = substring(@TTAUDIT_TEMP, 1, CHARINDEX(@TTAUDIT_TEMP, '&') - 1)

							SET @TTAUDIT_APP_USER_ID = @TTAUDIT_TEMP

						END

		/* Retrieve the ttaudit_ip_addr from ASP.NET (if available)*/
						IF (@TTAUDIT_CLIENTID LIKE '%ttaudit_ip_addr=%')
							BEGIN

										/*
										*   SSMA warning messages:
										*   O2SS0273: Oracle SUBSTR function and SQL Server SUBSTRING function may give different results.
										*/

								SET @TTAUDIT_TEMP = substring(@TTAUDIT_CLIENTID, CHARINDEX(@TTAUDIT_CLIENTID, 'ttaudit_ip_addr=') + LEN('ttaudit_ip_addr='), 999)

								IF (@TTAUDIT_TEMP LIKE '%&%')
											/*
											*   SSMA warning messages:
											*   O2SS0273: Oracle SUBSTR function and SQL Server SUBSTRING function may give different results.
											*/

								SET @TTAUDIT_TEMP = substring(@TTAUDIT_TEMP, 1, CHARINDEX(@TTAUDIT_TEMP, '&') - 1)

								SET @TTAUDIT_IP_ADDR = @TTAUDIT_TEMP



							END	

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
									   	@NEW_ROW_ID, 
									   	@NEW_GMM_CODE, 
									   	@NEW_PRODUCT_DESCRIPTION, 
									   	@NEW_IS_ACTIVE, 
									   	@NEW_LOCAL_SKU_CODE, 
									   	@TTAUDIT_DATE,					/*audit_insert_date*/
									   	@TTAUDIT_REASON,				/*audit_insert_reason*/ 
									   	@TTAUDIT_APP_USER_ID,			/*audit_insert_app_user_id*/
									   	@TTAUDIT_DB_USER_ID,			/*audit_insert_db_user_id*/
									   	@TTAUDIT_IP_ADDR,			/*audit_insert_ip_addr*/
									   	CAST('2999-12-31 23:59:59.999999' as datetime),   /*audit_delete_date is "end of time".*/ 
									   	NULL,/*audit_delete_reason      is blank; row has not been deleted.*/
									   	NULL,/*audit_delete_app_user_id is blank; row has not been deleted.*/
									   	NULL,/*audit_delete_db_user_id  is blank; row has not been deleted.*/
									   	NULL)/*audit_delete_ip_addr     is blank; row has not been deleted.*/
								
															
							CLOSE ForEachInsertedRowTriggerCursor

							DEALLOCATE ForEachInsertedRowTriggerCursor
							END