

print 'REPORTS Generic Payment Voucher';
GO

set nocount on;
GO

-- delete from REPORTS where ID = '7896FAAA-EB8F-4EA4-BB0C-5C6A6139F5BF';
-- 03/06/2009 Paul.  Skip the prompt validation to reduce user confusion. 
-- 03/08/2012 Paul.  The ReportID should match the ID in the table. 
if exists(select * from REPORTS where ID = '7896FAAA-EB8F-4EA4-BB0C-5C6A6139F5BF' and RDL not like '%AllowBlank%' and DELETED = 0) begin -- then
	update REPORTS
	   set RDL = replace(cast(RDL as nvarchar(max)), '<Prompt>Invoice ID</Prompt>', '<AllowBlank>true</AllowBlank>
      <Prompt>Invoice ID</Prompt>')
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where ID = '7896FAAA-EB8F-4EA4-BB0C-5C6A6139F5BF'
	   and RDL not like '%AllowBlank%'
	   and DELETED = 0;
end -- if;
GO

-- delete from REPORTS where ID = '7896FAAA-EB8F-4EA4-BB0C-5C6A6139F5BF';
exec dbo.spREPORTS_InsertOnly '7896FAAA-EB8F-4EA4-BB0C-5C6A6139F5BF', 'Generic Payment Voucher', 'Payments', 'Freeform', '<?xml version="1.0" encoding="utf-8"?>
<Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns:cl="http://schemas.microsoft.com/sqlserver/reporting/2010/01/componentdefinition" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition">
	<Description>Generic Payment Voucher</Description>
	<Author>SplendidCRM</Author>
	<AutoRefresh>0</AutoRefresh>
	<DataSources>
		<DataSource Name="SplendidCRM">
			<ConnectionProperties>
				<DataProvider>SQL</DataProvider>
				<ConnectString>Data Source=sql04;Initial Catalog=SplendidCRM_Ddrops</ConnectString>
				<IntegratedSecurity>true</IntegratedSecurity>
			</ConnectionProperties>
			<rd:SecurityType>Integrated</rd:SecurityType>
			<rd:DataSourceID>a1c2138e-3286-4613-a3fa-0cde22947bfa</rd:DataSourceID>
		</DataSource>
	</DataSources>
	<DataSets>
		<DataSet Name="vwPAYMENTS_INVOICES">
			<Query>
				<DataSourceName>SplendidCRM</DataSourceName>
				<QueryParameters>
					<QueryParameter Name="@PAYMENT_ID">
						<Value>=Parameters!PAYMENT_ID.Value</Value>
					</QueryParameter>
				</QueryParameters>
				<CommandText>select * from vwPAYMENTS_INVOICES where PAYMENT_ID = @PAYMENT_ID</CommandText>
				<rd:UseGenericDesigner>true</rd:UseGenericDesigner>
			</Query>
			<Fields>
				<Field Name="ID">
					<DataField>ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="PAYMENT_ID">
					<DataField>PAYMENT_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="AMOUNT_USDOLLAR">
					<DataField>AMOUNT_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="ALLOCATED">
					<DataField>ALLOCATED</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="AMOUNT">
					<DataField>AMOUNT</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="ALLOCATED_USDOLLAR">
					<DataField>ALLOCATED_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="DATE_MODIFIED_UTC">
					<DataField>DATE_MODIFIED_UTC</DataField>
					<rd:TypeName>System.DateTime</rd:TypeName>
				</Field>
				<Field Name="PAYMENT_NAME">
					<DataField>PAYMENT_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="PAYMENT_TYPE">
					<DataField>PAYMENT_TYPE</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="INVOICE_ID">
					<DataField>INVOICE_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="INVOICE_NAME">
					<DataField>INVOICE_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="INVOICE_NUM">
					<DataField>INVOICE_NUM</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="TOTAL">
					<DataField>TOTAL</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="TOTAL_USDOLLAR">
					<DataField>TOTAL_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="AMOUNT_DUE">
					<DataField>AMOUNT_DUE</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="AMOUNT_DUE_USDOLLAR">
					<DataField>AMOUNT_DUE_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="ASSIGNED_USER_ID">
					<DataField>ASSIGNED_USER_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="DATE_ENTERED">
					<DataField>DATE_ENTERED</DataField>
					<rd:TypeName>System.DateTime</rd:TypeName>
				</Field>
				<Field Name="DATE_MODIFIED">
					<DataField>DATE_MODIFIED</DataField>
					<rd:TypeName>System.DateTime</rd:TypeName>
				</Field>
			</Fields>
		</DataSet>
		<DataSet Name="vwPAYMENTS">
			<Query>
				<DataSourceName>SplendidCRM</DataSourceName>
				<QueryParameters>
					<QueryParameter Name="@PAYMENT_ID">
						<Value>=Parameters!PAYMENT_ID.Value</Value>
					</QueryParameter>
				</QueryParameters>
				<CommandText>select vwPAYMENTS.*
        , vwACCOUNTS.BILLING_ADDRESS_STREET
        , vwACCOUNTS.BILLING_ADDRESS_CITY
        , vwACCOUNTS.BILLING_ADDRESS_STATE
        , vwACCOUNTS.BILLING_ADDRESS_POSTALCODE
        , vwACCOUNTS.BILLING_ADDRESS_COUNTRY
  from vwPAYMENTS
 inner join vwACCOUNTS
              on vwACCOUNTS.ID = vwPAYMENTS.ACCOUNT_ID
 where vwPAYMENTS.ID = @PAYMENT_ID
</CommandText>
				<rd:UseGenericDesigner>true</rd:UseGenericDesigner>
			</Query>
			<Fields>
				<Field Name="ID">
					<DataField>ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="PAYMENT_NUM">
					<DataField>PAYMENT_NUM</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="NAME">
					<DataField>NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="PAYMENT_TYPE">
					<DataField>PAYMENT_TYPE</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="PAYMENT_DATE">
					<DataField>PAYMENT_DATE</DataField>
					<rd:TypeName>System.DateTime</rd:TypeName>
				</Field>
				<Field Name="CUSTOMER_REFERENCE">
					<DataField>CUSTOMER_REFERENCE</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="AMOUNT">
					<DataField>AMOUNT</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="CURRENCY_ID">
					<DataField>CURRENCY_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="AMOUNT_USDOLLAR">
					<DataField>AMOUNT_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="EXCHANGE_RATE">
					<DataField>EXCHANGE_RATE</DataField>
					<rd:TypeName>System.Double</rd:TypeName>
				</Field>
				<Field Name="DATE_MODIFIED_UTC">
					<DataField>DATE_MODIFIED_UTC</DataField>
					<rd:TypeName>System.DateTime</rd:TypeName>
				</Field>
				<Field Name="DESCRIPTION">
					<DataField>DESCRIPTION</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="ACCOUNT_ID">
					<DataField>ACCOUNT_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="ACCOUNT_NAME">
					<DataField>ACCOUNT_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="ACCOUNT_ASSIGNED_USER_ID">
					<DataField>ACCOUNT_ASSIGNED_USER_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="CREDIT_CARD_ID">
					<DataField>CREDIT_CARD_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="CREDIT_CARD_NAME">
					<DataField>CREDIT_CARD_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="CREDIT_CARD_NUMBER">
					<DataField>CREDIT_CARD_NUMBER</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="TOTAL_ALLOCATED_USDOLLAR">
					<DataField>TOTAL_ALLOCATED_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="TEAM_SET_ID">
					<DataField>TEAM_SET_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="TEAM_SET_NAME">
					<DataField>TEAM_SET_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="TEAM_SET_LIST">
					<DataField>TEAM_SET_LIST</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="ASSIGNED_TO_NAME">
					<DataField>ASSIGNED_TO_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="CREATED_BY_NAME">
					<DataField>CREATED_BY_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="MODIFIED_BY_NAME">
					<DataField>MODIFIED_BY_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="BANK_FEE">
					<DataField>BANK_FEE</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="ASSIGNED_USER_ID">
					<DataField>ASSIGNED_USER_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="DATE_ENTERED">
					<DataField>DATE_ENTERED</DataField>
					<rd:TypeName>System.DateTime</rd:TypeName>
				</Field>
				<Field Name="BANK_FEE_USDOLLAR">
					<DataField>BANK_FEE_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="DATE_MODIFIED">
					<DataField>DATE_MODIFIED</DataField>
					<rd:TypeName>System.DateTime</rd:TypeName>
				</Field>
				<Field Name="TEAM_ID">
					<DataField>TEAM_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="TEAM_NAME">
					<DataField>TEAM_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="ASSIGNED_TO">
					<DataField>ASSIGNED_TO</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="CREATED_BY">
					<DataField>CREATED_BY</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="MODIFIED_BY">
					<DataField>MODIFIED_BY</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="CREATED_BY_ID">
					<DataField>CREATED_BY_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="MODIFIED_USER_ID">
					<DataField>MODIFIED_USER_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="ID_C">
					<DataField>ID_C</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="BILLING_ADDRESS_STREET">
					<DataField>BILLING_ADDRESS_STREET</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="BILLING_ADDRESS_CITY">
					<DataField>BILLING_ADDRESS_CITY</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="BILLING_ADDRESS_STATE">
					<DataField>BILLING_ADDRESS_STATE</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="BILLING_ADDRESS_POSTALCODE">
					<DataField>BILLING_ADDRESS_POSTALCODE</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="BILLING_ADDRESS_COUNTRY">
					<DataField>BILLING_ADDRESS_COUNTRY</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
			</Fields>
		</DataSet>
		<DataSet Name="vwCONFIG_Company">
			<Query>
				<DataSourceName>SplendidCRM</DataSourceName>
				<CommandText>select * from vwCONFIG_Company</CommandText>
				<rd:UseGenericDesigner>true</rd:UseGenericDesigner>
			</Query>
			<Fields>
				<Field Name="COMPANY_NAME">
					<DataField>COMPANY_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="COMPANY_ADDRESS">
					<DataField>COMPANY_ADDRESS</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="COMPANY_LOGO">
					<DataField>COMPANY_LOGO</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
			</Fields>
		</DataSet>
	</DataSets>
	<ReportSections>
		<ReportSection>
			<Body>
				<ReportItems>
					<Tablix Name="tblLINE_ITEMS">
						<TablixBody>
							<TablixColumns>
								<TablixColumn>
									<Width>1.5in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>2.625in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>1in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>1in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>1.25in</Width>
								</TablixColumn>
							</TablixColumns>
							<TablixRows>
								<TablixRow>
									<Height>0.21in</Height>
									<TablixCells>
										<TablixCell>
											<CellContents>
												<Textbox Name="lblMFT_PART_NUM">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Invoice Number</Value>
																	<Style>
																		<FontSize>9pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<ZIndex>9</ZIndex>
													<Style>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>2.25pt</Width>
														</BottomBorder>
														<PaddingLeft>2pt</PaddingLeft>
														<PaddingRight>2pt</PaddingRight>
														<PaddingTop>2pt</PaddingTop>
														<PaddingBottom>2pt</PaddingBottom>
													</Style>
												</Textbox>
											</CellContents>
										</TablixCell>
										<TablixCell>
											<CellContents>
												<Textbox Name="lblNAME">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Invoice Name</Value>
																	<Style>
																		<FontSize>9pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<ZIndex>8</ZIndex>
													<Style>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>2.25pt</Width>
														</BottomBorder>
														<PaddingLeft>2pt</PaddingLeft>
														<PaddingRight>2pt</PaddingRight>
														<PaddingTop>2pt</PaddingTop>
														<PaddingBottom>2pt</PaddingBottom>
													</Style>
												</Textbox>
											</CellContents>
										</TablixCell>
										<TablixCell>
											<CellContents>
												<Textbox Name="lblQUANTITY">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Amount</Value>
																	<Style>
																		<FontSize>9pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Right</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<ZIndex>7</ZIndex>
													<Style>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>2.25pt</Width>
														</BottomBorder>
														<PaddingLeft>2pt</PaddingLeft>
														<PaddingRight>2pt</PaddingRight>
														<PaddingTop>2pt</PaddingTop>
														<PaddingBottom>2pt</PaddingBottom>
													</Style>
												</Textbox>
											</CellContents>
										</TablixCell>
										<TablixCell>
											<CellContents>
												<Textbox Name="lblUNIT_PRICE">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Allocated</Value>
																	<Style>
																		<FontSize>9pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Right</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<ZIndex>6</ZIndex>
													<Style>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>2.25pt</Width>
														</BottomBorder>
														<PaddingLeft>2pt</PaddingLeft>
														<PaddingRight>2pt</PaddingRight>
														<PaddingTop>2pt</PaddingTop>
														<PaddingBottom>2pt</PaddingBottom>
													</Style>
												</Textbox>
											</CellContents>
										</TablixCell>
										<TablixCell>
											<CellContents>
												<Textbox Name="lblEXTENDED_PRICE">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Amount Due</Value>
																	<Style>
																		<FontSize>9pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Right</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<ZIndex>5</ZIndex>
													<Style>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>2.25pt</Width>
														</BottomBorder>
														<PaddingLeft>2pt</PaddingLeft>
														<PaddingRight>2pt</PaddingRight>
														<PaddingTop>2pt</PaddingTop>
														<PaddingBottom>2pt</PaddingBottom>
													</Style>
												</Textbox>
											</CellContents>
										</TablixCell>
									</TablixCells>
								</TablixRow>
								<TablixRow>
									<Height>0.21in</Height>
									<TablixCells>
										<TablixCell>
											<CellContents>
												<Textbox Name="INVOICE_NUM1">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!INVOICE_NUM.Value</Value>
																	<Style />
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>INVOICE_NUM1</rd:DefaultName>
													<ZIndex>4</ZIndex>
													<Style>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<PaddingLeft>2pt</PaddingLeft>
														<PaddingRight>2pt</PaddingRight>
														<PaddingTop>2pt</PaddingTop>
														<PaddingBottom>2pt</PaddingBottom>
													</Style>
												</Textbox>
											</CellContents>
										</TablixCell>
										<TablixCell>
											<CellContents>
												<Textbox Name="INVOICE_NAME">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!INVOICE_NAME.Value</Value>
																	<Style />
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>INVOICE_NAME</rd:DefaultName>
													<ZIndex>3</ZIndex>
													<Style>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<PaddingLeft>2pt</PaddingLeft>
														<PaddingRight>2pt</PaddingRight>
														<PaddingTop>2pt</PaddingTop>
														<PaddingBottom>2pt</PaddingBottom>
													</Style>
												</Textbox>
											</CellContents>
										</TablixCell>
										<TablixCell>
											<CellContents>
												<Textbox Name="AMOUNT">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!AMOUNT.Value</Value>
																	<Style>
																		<Format>C</Format>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>AMOUNT</rd:DefaultName>
													<ZIndex>2</ZIndex>
													<Style>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<PaddingLeft>2pt</PaddingLeft>
														<PaddingRight>2pt</PaddingRight>
														<PaddingTop>2pt</PaddingTop>
														<PaddingBottom>2pt</PaddingBottom>
													</Style>
												</Textbox>
												<rd:Selected>true</rd:Selected>
											</CellContents>
										</TablixCell>
										<TablixCell>
											<CellContents>
												<Textbox Name="ALLOCATED">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!ALLOCATED.Value</Value>
																	<Style>
																		<Format>C</Format>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>ALLOCATED</rd:DefaultName>
													<ZIndex>1</ZIndex>
													<Style>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<PaddingLeft>2pt</PaddingLeft>
														<PaddingRight>2pt</PaddingRight>
														<PaddingTop>2pt</PaddingTop>
														<PaddingBottom>2pt</PaddingBottom>
													</Style>
												</Textbox>
											</CellContents>
										</TablixCell>
										<TablixCell>
											<CellContents>
												<Textbox Name="AMOUNT_DUE">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!AMOUNT_DUE.Value</Value>
																	<Style>
																		<Format>C</Format>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>AMOUNT_DUE</rd:DefaultName>
													<Style>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<PaddingLeft>2pt</PaddingLeft>
														<PaddingRight>2pt</PaddingRight>
														<PaddingTop>2pt</PaddingTop>
														<PaddingBottom>2pt</PaddingBottom>
													</Style>
												</Textbox>
											</CellContents>
										</TablixCell>
									</TablixCells>
								</TablixRow>
							</TablixRows>
						</TablixBody>
						<TablixColumnHierarchy>
							<TablixMembers>
								<TablixMember />
								<TablixMember />
								<TablixMember />
								<TablixMember />
								<TablixMember />
							</TablixMembers>
						</TablixColumnHierarchy>
						<TablixRowHierarchy>
							<TablixMembers>
								<TablixMember>
									<KeepWithGroup>After</KeepWithGroup>
									<RepeatOnNewPage>true</RepeatOnNewPage>
									<KeepTogether>true</KeepTogether>
								</TablixMember>
								<TablixMember>
									<Group Name="tblLINE_ITEMS_Details_Group">
										<DataElementName>Detail</DataElementName>
									</Group>
									<TablixMembers>
										<TablixMember />
									</TablixMembers>
									<DataElementName>Detail_Collection</DataElementName>
									<DataElementOutput>Output</DataElementOutput>
									<KeepTogether>true</KeepTogether>
								</TablixMember>
							</TablixMembers>
						</TablixRowHierarchy>
						<DataSetName>vwPAYMENTS_INVOICES</DataSetName>
						<Top>2.625in</Top>
						<Height>0.42in</Height>
						<Width>7.375in</Width>
						<Style />
					</Tablix>
					<Tablix Name="divCOMPANY">
						<TablixBody>
							<TablixColumns>
								<TablixColumn>
									<Width>2.5in</Width>
								</TablixColumn>
							</TablixColumns>
							<TablixRows>
								<TablixRow>
									<Height>1.25in</Height>
									<TablixCells>
										<TablixCell>
											<CellContents>
												<Rectangle Name="divCOMPANY_Contents">
													<ReportItems>
														<Textbox Name="COMPANY_NAME">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!COMPANY_NAME.Value</Value>
																			<Style>
																				<FontSize>12pt</FontSize>
																				<FontWeight>Bold</FontWeight>
																			</Style>
																		</TextRun>
																	</TextRuns>
																	<Style />
																</Paragraph>
															</Paragraphs>
															<Height>0.25in</Height>
															<Width>2.5in</Width>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="COMPANY_ADDRESS">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!COMPANY_ADDRESS.Value</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style />
																</Paragraph>
															</Paragraphs>
															<Top>0.25in</Top>
															<Height>0.875in</Height>
															<Width>2.5in</Width>
															<ZIndex>1</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
													</ReportItems>
													<KeepTogether>true</KeepTogether>
													<Style />
												</Rectangle>
											</CellContents>
										</TablixCell>
									</TablixCells>
								</TablixRow>
							</TablixRows>
						</TablixBody>
						<TablixColumnHierarchy>
							<TablixMembers>
								<TablixMember />
							</TablixMembers>
						</TablixColumnHierarchy>
						<TablixRowHierarchy>
							<TablixMembers>
								<TablixMember>
									<Group Name="divCOMPANY_Details_Group">
										<DataElementName>Item</DataElementName>
									</Group>
									<DataElementName>Item_Collection</DataElementName>
									<DataElementOutput>Output</DataElementOutput>
									<KeepTogether>true</KeepTogether>
								</TablixMember>
							</TablixMembers>
						</TablixRowHierarchy>
						<DataSetName>vwCONFIG_Company</DataSetName>
						<Height>1.25in</Height>
						<Width>2.5in</Width>
						<ZIndex>1</ZIndex>
						<Style />
					</Tablix>
					<Tablix Name="divADDRESS">
						<TablixBody>
							<TablixColumns>
								<TablixColumn>
									<Width>3.25in</Width>
								</TablixColumn>
							</TablixColumns>
							<TablixRows>
								<TablixRow>
									<Height>1.125in</Height>
									<TablixCells>
										<TablixCell>
											<CellContents>
												<Rectangle Name="divADDRESS_Contents">
													<ReportItems>
														<Textbox Name="lblBILL_TO">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>Account:</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style />
																</Paragraph>
															</Paragraphs>
															<Height>0.2in</Height>
															<Width>1in</Width>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="BILLING_ACCOUNT_NAME">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!ACCOUNT_NAME.Value</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style />
																</Paragraph>
															</Paragraphs>
															<Top>0.25in</Top>
															<Left>0.25in</Left>
															<Height>0.2in</Height>
															<Width>3in</Width>
															<ZIndex>1</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="BILLING_ADDRESS_STREET">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!BILLING_ADDRESS_STREET.Value</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style />
																</Paragraph>
															</Paragraphs>
															<Top>0.45in</Top>
															<Left>0.25in</Left>
															<Height>0.2in</Height>
															<Width>3in</Width>
															<ZIndex>2</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="BILLING_ADDRESS_CITY">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!BILLING_ADDRESS_CITY.Value + " " + Fields!BILLING_ADDRESS_STATE.Value + " " + Fields!BILLING_ADDRESS_POSTALCODE.Value</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style />
																</Paragraph>
															</Paragraphs>
															<Top>0.65in</Top>
															<Left>0.25in</Left>
															<Height>0.2in</Height>
															<Width>3in</Width>
															<ZIndex>3</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="BILLING_ADDRESS_COUNTRY">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!BILLING_ADDRESS_COUNTRY.Value</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style />
																</Paragraph>
															</Paragraphs>
															<Top>0.85in</Top>
															<Left>0.25in</Left>
															<Height>0.2in</Height>
															<Width>3in</Width>
															<ZIndex>4</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
													</ReportItems>
													<KeepTogether>true</KeepTogether>
													<Style />
												</Rectangle>
											</CellContents>
										</TablixCell>
									</TablixCells>
								</TablixRow>
							</TablixRows>
						</TablixBody>
						<TablixColumnHierarchy>
							<TablixMembers>
								<TablixMember />
							</TablixMembers>
						</TablixColumnHierarchy>
						<TablixRowHierarchy>
							<TablixMembers>
								<TablixMember>
									<Group Name="divADDRESS_Details_Group">
										<DataElementName>Item</DataElementName>
									</Group>
									<DataElementName>Item_Collection</DataElementName>
									<DataElementOutput>Output</DataElementOutput>
									<KeepTogether>true</KeepTogether>
								</TablixMember>
							</TablixMembers>
						</TablixRowHierarchy>
						<DataSetName>vwPAYMENTS</DataSetName>
						<Top>1.375in</Top>
						<Height>1.125in</Height>
						<Width>3.25in</Width>
						<ZIndex>2</ZIndex>
						<Style />
					</Tablix>
					<Tablix Name="divDETAILS">
						<TablixBody>
							<TablixColumns>
								<TablixColumn>
									<Width>3.01389in</Width>
								</TablixColumn>
							</TablixColumns>
							<TablixRows>
								<TablixRow>
									<Height>1.94375in</Height>
									<TablixCells>
										<TablixCell>
											<CellContents>
												<Rectangle Name="divDETAILS_Contents">
													<ReportItems>
														<Textbox Name="lblTITLE">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>Payment Voucher</Value>
																			<Style>
																				<FontSize>20pt</FontSize>
																				<FontWeight>Bold</FontWeight>
																			</Style>
																		</TextRun>
																	</TextRuns>
																	<Style />
																</Paragraph>
															</Paragraphs>
															<Left>0.01389in</Left>
															<Height>0.375in</Height>
															<Width>3in</Width>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="lblINVOICE_NUM">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>Payment No:</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Right</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>0.375in</Top>
															<Left>0.01389in</Left>
															<Height>0.2in</Height>
															<Width>1.25in</Width>
															<ZIndex>1</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="INVOICE_NUM">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!PAYMENT_NUM.Value</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Left</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>0.375in</Top>
															<Left>1.26389in</Left>
															<Height>0.2in</Height>
															<Width>1.75in</Width>
															<ZIndex>2</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="lblDATE_MODIFIED">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>Date:</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Right</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>0.575in</Top>
															<Left>0.01389in</Left>
															<Height>0.2in</Height>
															<Width>1.25in</Width>
															<ZIndex>3</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="DATE_MODIFIED">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!PAYMENT_DATE.Value</Value>
																			<Style>
																				<Format>d</Format>
																			</Style>
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Left</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>0.575in</Top>
															<Left>1.26389in</Left>
															<Height>0.2in</Height>
															<Width>1.75in</Width>
															<ZIndex>4</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="lblPAYMENT_TERMS">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>Payment Type:</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Right</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>0.775in</Top>
															<Left>0.01389in</Left>
															<Height>0.2in</Height>
															<Width>1.25in</Width>
															<ZIndex>5</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="PAYMENT_TERMS">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!PAYMENT_TYPE.Value</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Left</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>0.775in</Top>
															<Left>1.26389in</Left>
															<Height>0.2in</Height>
															<Width>1.75in</Width>
															<ZIndex>6</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="lblSHIPPER_NAME">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>Customer Ref.:</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Right</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>0.975in</Top>
															<Height>0.2in</Height>
															<Width>1.25in</Width>
															<ZIndex>7</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="SHIPPER_NAME">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!CUSTOMER_REFERENCE.Value</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Left</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>0.975in</Top>
															<Left>1.26389in</Left>
															<Height>0.2in</Height>
															<Width>1.75in</Width>
															<ZIndex>8</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="lblSHIPPER_NAME2">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>Payment Amount:</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Right</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>1.175in</Top>
															<Height>0.2in</Height>
															<Width>1.25in</Width>
															<ZIndex>9</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="SHIPPER_NAME2">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!AMOUNT.Value</Value>
																			<Style>
																				<Format>C</Format>
																			</Style>
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Left</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>1.175in</Top>
															<Left>1.26389in</Left>
															<Height>0.2in</Height>
															<Width>1.75in</Width>
															<ZIndex>10</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
													</ReportItems>
													<KeepTogether>true</KeepTogether>
													<Style />
												</Rectangle>
											</CellContents>
										</TablixCell>
									</TablixCells>
								</TablixRow>
							</TablixRows>
						</TablixBody>
						<TablixColumnHierarchy>
							<TablixMembers>
								<TablixMember />
							</TablixMembers>
						</TablixColumnHierarchy>
						<TablixRowHierarchy>
							<TablixMembers>
								<TablixMember>
									<Group Name="divDETAILS_Details_Group">
										<DataElementName>Item</DataElementName>
									</Group>
									<DataElementName>Item_Collection</DataElementName>
									<DataElementOutput>Output</DataElementOutput>
									<KeepTogether>true</KeepTogether>
								</TablixMember>
							</TablixMembers>
						</TablixRowHierarchy>
						<DataSetName>vwPAYMENTS</DataSetName>
						<Left>4.375in</Left>
						<Height>1.94375in</Height>
						<Width>3.01389in</Width>
						<ZIndex>3</ZIndex>
						<Style />
					</Tablix>
					<Tablix Name="divLOGO">
						<TablixBody>
							<TablixColumns>
								<TablixColumn>
									<Width>1.5in</Width>
								</TablixColumn>
							</TablixColumns>
							<TablixRows>
								<TablixRow>
									<Height>1.375in</Height>
									<TablixCells>
										<TablixCell>
											<CellContents>
												<Rectangle Name="divLOGO_Contents">
													<ReportItems>
														<Image Name="COMPANY_LOGO">
															<Source>External</Source>
															<Value>=Fields!COMPANY_LOGO.Value</Value>
															<Sizing>Fit</Sizing>
															<Left>0.125in</Left>
															<Height>1.25in</Height>
															<Width>1.25in</Width>
															<Visibility>
																<Hidden>=Fields!COMPANY_LOGO.Value = ""</Hidden>
															</Visibility>
															<DataElementOutput>NoOutput</DataElementOutput>
															<Style />
														</Image>
													</ReportItems>
													<KeepTogether>true</KeepTogether>
													<Style />
												</Rectangle>
											</CellContents>
										</TablixCell>
									</TablixCells>
								</TablixRow>
							</TablixRows>
						</TablixBody>
						<TablixColumnHierarchy>
							<TablixMembers>
								<TablixMember />
							</TablixMembers>
						</TablixColumnHierarchy>
						<TablixRowHierarchy>
							<TablixMembers>
								<TablixMember>
									<Group Name="divLOGO_Details_Group">
										<DataElementName>Item</DataElementName>
									</Group>
									<DataElementName>Item_Collection</DataElementName>
									<DataElementOutput>Output</DataElementOutput>
									<KeepTogether>true</KeepTogether>
								</TablixMember>
							</TablixMembers>
						</TablixRowHierarchy>
						<DataSetName>vwCONFIG_Company</DataSetName>
						<Left>2.75in</Left>
						<Height>1.375in</Height>
						<Width>1.5in</Width>
						<ZIndex>4</ZIndex>
						<Style />
					</Tablix>
				</ReportItems>
				<Height>3.925in</Height>
				<Style />
			</Body>
			<Width>7.5in</Width>
			<Page>
				<LeftMargin>0.5in</LeftMargin>
				<RightMargin>0.5in</RightMargin>
				<TopMargin>1in</TopMargin>
				<BottomMargin>1in</BottomMargin>
				<Style />
			</Page>
		</ReportSection>
	</ReportSections>
	<ReportParameters>
		<ReportParameter Name="PAYMENT_ID">
			<DataType>String</DataType>
			<AllowBlank>true</AllowBlank>
			<Prompt>Payment ID</Prompt>
		</ReportParameter>
	</ReportParameters>
	<Language>en-US</Language>
	<ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
	<rd:ReportUnitType>Inch</rd:ReportUnitType>
	<rd:ReportID>7896faaa-eb8f-4ea4-bb0c-5c6a6139f5bf</rd:ReportID>
</Report>', '17BB7135-2B95-42DC-85DE-842CAFF927A0';
GO


set nocount off;
GO

/* -- #if Oracle
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			StoO_selcnt := 0;
		WHEN OTHERS THEN
			RAISE;
	END;
	COMMIT WORK;
END;
/
-- #endif Oracle */

/* -- #if IBM_DB2
	commit;
  end
/

call dbo.spREPORTS_Generic_Payment_Voucher()
/

call dbo.spSqlDropProcedure('spREPORTS_Generic_Payment_Voucher')
/

-- #endif IBM_DB2 */

