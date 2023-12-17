

print 'REPORTS Generic Order';
GO

set nocount on;
GO

-- delete from REPORTS where ID = 'F40989FE-24F5-4352-BB32-A23713EA6EC8';
-- 03/06/2009 Paul.  Skip the prompt validation to reduce user confusion. 
-- 03/08/2012 Paul.  The ReportID should match the ID in the table. 
if exists(select * from REPORTS where ID = 'F40989FE-24F5-4352-BB32-A23713EA6EC8' and RDL not like '%AllowBlank%' and DELETED = 0) begin -- then
	update REPORTS
	   set RDL = replace(cast(RDL as nvarchar(max)), '<Prompt>Order ID</Prompt>', '<AllowBlank>true</AllowBlank>
			<Prompt>Order ID</Prompt>')
	     , DATE_MODIFIED    = getdate()
	     , MODIFIED_USER_ID = null
	 where ID = 'F40989FE-24F5-4352-BB32-A23713EA6EC8'
	   and RDL not like '%AllowBlank%'
	   and DELETED = 0;
end -- if;
GO

-- 03/27/2016 Paul.  Add support for Signature, but not to existing report. 
-- delete from REPORTS where ID = 'F40989FE-24F5-4352-BB32-A23713EA6EC8';
exec dbo.spREPORTS_InsertOnly 'F40989FE-24F5-4352-BB32-A23713EA6EC8', 'Generic Order', 'Orders', 'Freeform', '<?xml version="1.0" encoding="utf-8"?>
<Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns:cl="http://schemas.microsoft.com/sqlserver/reporting/2010/01/componentdefinition" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition">
	<Description>Generic Invoice</Description>
	<Author>SplendidCRM</Author>
	<AutoRefresh>0</AutoRefresh>
	<DataSources>
		<DataSource Name="SplendidCRM">
			<DataSourceReference>SplendidCRM</DataSourceReference>
			<rd:SecurityType>None</rd:SecurityType>
			<rd:DataSourceID>a1c2138e-3286-4613-a3fa-0cde22947bfa</rd:DataSourceID>
		</DataSource>
	</DataSources>
	<DataSets>
		<DataSet Name="vwORDERS_LINE_ITEMS">
			<Query>
				<DataSourceName>SplendidCRM</DataSourceName>
				<QueryParameters>
					<QueryParameter Name="@ORDER_ID">
						<Value>=Parameters!ORDER_ID.Value</Value>
					</QueryParameter>
				</QueryParameters>
				<CommandText>select * from vwORDERS_LINE_ITEMS where ORDER_ID = @ORDER_ID order by POSITION</CommandText>
				<rd:UseGenericDesigner>true</rd:UseGenericDesigner>
			</Query>
			<Fields>
				<Field Name="ID">
					<DataField>ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="ORDER_ID">
					<DataField>ORDER_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="LINE_GROUP_ID">
					<DataField>LINE_GROUP_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="LINE_ITEM_TYPE">
					<DataField>LINE_ITEM_TYPE</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="POSITION">
					<DataField>POSITION</DataField>
					<rd:TypeName>System.Int32</rd:TypeName>
				</Field>
				<Field Name="NAME">
					<DataField>NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="MFT_PART_NUM">
					<DataField>MFT_PART_NUM</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="VENDOR_PART_NUM">
					<DataField>VENDOR_PART_NUM</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="PRODUCT_TEMPLATE_ID">
					<DataField>PRODUCT_TEMPLATE_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="TAX_CLASS">
					<DataField>TAX_CLASS</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="QUANTITY">
					<DataField>QUANTITY</DataField>
					<rd:TypeName>System.Int32</rd:TypeName>
				</Field>
				<Field Name="COST_PRICE">
					<DataField>COST_PRICE</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="COST_USDOLLAR">
					<DataField>COST_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="LIST_PRICE">
					<DataField>LIST_PRICE</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="LIST_USDOLLAR">
					<DataField>LIST_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="UNIT_PRICE">
					<DataField>UNIT_PRICE</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="UNIT_USDOLLAR">
					<DataField>UNIT_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="EXTENDED_PRICE">
					<DataField>EXTENDED_PRICE</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="EXTENDED_USDOLLAR">
					<DataField>EXTENDED_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="DESCRIPTION">
					<DataField>DESCRIPTION</DataField>
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
			</Fields>
		</DataSet>
		<DataSet Name="vwORDERS">
			<Query>
				<DataSourceName>SplendidCRM</DataSourceName>
				<QueryParameters>
					<QueryParameter Name="@ORDER_ID">
						<Value>=Parameters!ORDER_ID.Value</Value>
					</QueryParameter>
				</QueryParameters>
				<CommandText>select * from vwORDERS where ID = @ORDER_ID</CommandText>
				<rd:UseGenericDesigner>true</rd:UseGenericDesigner>
			</Query>
			<Fields>
				<Field Name="ID">
					<DataField>ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="ORDER_NUM">
					<DataField>ORDER_NUM</DataField>
					<rd:TypeName>System.Int32</rd:TypeName>
				</Field>
				<Field Name="NAME">
					<DataField>NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="PAYMENT_TERMS">
					<DataField>PAYMENT_TERMS</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="ORDER_STAGE">
					<DataField>ORDER_STAGE</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="PURCHASE_ORDER_NUM">
					<DataField>PURCHASE_ORDER_NUM</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="ORIGINAL_PO_DATE">
					<DataField>ORIGINAL_PO_DATE</DataField>
					<rd:TypeName>System.DateTime</rd:TypeName>
				</Field>
				<Field Name="DATE_ORDER_DUE">
					<DataField>DATE_ORDER_DUE</DataField>
					<rd:TypeName>System.DateTime</rd:TypeName>
				</Field>
				<Field Name="DATE_ORDER_SHIPPED">
					<DataField>DATE_ORDER_SHIPPED</DataField>
					<rd:TypeName>System.DateTime</rd:TypeName>
				</Field>
				<Field Name="SHOW_LINE_NUMS">
					<DataField>SHOW_LINE_NUMS</DataField>
					<rd:TypeName>System.Boolean</rd:TypeName>
				</Field>
				<Field Name="CALC_GRAND_TOTAL">
					<DataField>CALC_GRAND_TOTAL</DataField>
					<rd:TypeName>System.Boolean</rd:TypeName>
				</Field>
				<Field Name="CURRENCY_ID">
					<DataField>CURRENCY_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="EXCHANGE_RATE">
					<DataField>EXCHANGE_RATE</DataField>
					<rd:TypeName>System.Double</rd:TypeName>
				</Field>
				<Field Name="SUBTOTAL">
					<DataField>SUBTOTAL</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="SUBTOTAL_USDOLLAR">
					<DataField>SUBTOTAL_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="DISCOUNT">
					<DataField>DISCOUNT</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="DISCOUNT_USDOLLAR">
					<DataField>DISCOUNT_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="SHIPPING">
					<DataField>SHIPPING</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="SHIPPING_USDOLLAR">
					<DataField>SHIPPING_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="TAX">
					<DataField>TAX</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="TAX_USDOLLAR">
					<DataField>TAX_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="TOTAL">
					<DataField>TOTAL</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="TOTAL_USDOLLAR">
					<DataField>TOTAL_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
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
				<Field Name="SHIPPING_ADDRESS_STREET">
					<DataField>SHIPPING_ADDRESS_STREET</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="SHIPPING_ADDRESS_CITY">
					<DataField>SHIPPING_ADDRESS_CITY</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="SHIPPING_ADDRESS_STATE">
					<DataField>SHIPPING_ADDRESS_STATE</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="SHIPPING_ADDRESS_POSTALCODE">
					<DataField>SHIPPING_ADDRESS_POSTALCODE</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="SHIPPING_ADDRESS_COUNTRY">
					<DataField>SHIPPING_ADDRESS_COUNTRY</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="TAXRATE_ID">
					<DataField>TAXRATE_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="SHIPPER_ID">
					<DataField>SHIPPER_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
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
				<Field Name="BILLING_ACCOUNT_ID">
					<DataField>BILLING_ACCOUNT_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="BILLING_ACCOUNT_NAME">
					<DataField>BILLING_ACCOUNT_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="BILLING_ACCOUNT_ASSIGNED_ID">
					<DataField>BILLING_ACCOUNT_ASSIGNED_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="SHIPPING_ACCOUNT_ID">
					<DataField>SHIPPING_ACCOUNT_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="SHIPPING_ACCOUNT_NAME">
					<DataField>SHIPPING_ACCOUNT_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="SHIPPING_ACCOUNT_ASSIGNED_ID">
					<DataField>SHIPPING_ACCOUNT_ASSIGNED_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="BILLING_CONTACT_ID">
					<DataField>BILLING_CONTACT_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="BILLING_CONTACT_NAME">
					<DataField>BILLING_CONTACT_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="BILLING_CONTACT_ASSIGNED_ID">
					<DataField>BILLING_CONTACT_ASSIGNED_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="SHIPPING_CONTACT_ID">
					<DataField>SHIPPING_CONTACT_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="SHIPPING_CONTACT_NAME">
					<DataField>SHIPPING_CONTACT_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="SHIPPING_CONTACT_ASSIGNED_ID">
					<DataField>SHIPPING_CONTACT_ASSIGNED_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="OPPORTUNITY_ID">
					<DataField>OPPORTUNITY_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="OPPORTUNITY_NAME">
					<DataField>OPPORTUNITY_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="LEAD_SOURCE">
					<DataField>LEAD_SOURCE</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="NEXT_STEP">
					<DataField>NEXT_STEP</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="QUOTE_ID">
					<DataField>QUOTE_ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="QUOTE_NAME">
					<DataField>QUOTE_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="TAXRATE_NAME">
					<DataField>TAXRATE_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="TAXRATE_VALUE">
					<DataField>TAXRATE_VALUE</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="SHIPPER_NAME">
					<DataField>SHIPPER_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
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
		<DataSet Name="vwIMAGES">
			<Query>
				<DataSourceName>SplendidCRM</DataSourceName>
				<QueryParameters>
					<QueryParameter Name="@ID">
						<Value>=Parameters!SIGNATURE_ID.Value</Value>
					</QueryParameter>
				</QueryParameters>
				<CommandText>select * from vwIMAGES_Content where ID = @ID</CommandText>
				<rd:UseGenericDesigner>true</rd:UseGenericDesigner>
			</Query>
			<Fields>
				<Field Name="ID">
					<DataField>ID</DataField>
					<rd:TypeName>System.Guid</rd:TypeName>
				</Field>
				<Field Name="CONTENT">
					<DataField>CONTENT</DataField>
					<rd:TypeName>System.Binary</rd:TypeName>
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
																	<Value>Part Number</Value>
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
																	<Value>Product Name</Value>
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
																	<Value>Quantity</Value>
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
																	<Value>Unit Price</Value>
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
																	<Value>Ext. Price</Value>
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
												<Textbox Name="MFT_PART_NUM">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!MFT_PART_NUM.Value</Value>
																	<Style />
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>MFT_PART_NUM</rd:DefaultName>
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
												<Textbox Name="NAME">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!NAME.Value</Value>
																	<Style />
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>NAME</rd:DefaultName>
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
												<Textbox Name="QUANTITY">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!QUANTITY.Value</Value>
																	<Style />
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>QUANTITY</rd:DefaultName>
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
											</CellContents>
										</TablixCell>
										<TablixCell>
											<CellContents>
												<Textbox Name="UNIT_PRICE">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!UNIT_PRICE.Value</Value>
																	<Style>
																		<Format>C</Format>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>UNIT_PRICE</rd:DefaultName>
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
												<Textbox Name="EXTENDED_PRICE">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!EXTENDED_PRICE.Value</Value>
																	<Style>
																		<Format>C</Format>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>EXTENDED_PRICE</rd:DefaultName>
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
						<DataSetName>vwORDERS_LINE_ITEMS</DataSetName>
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
																			<Value>Bill To:</Value>
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
																			<Value>=Fields!BILLING_ACCOUNT_NAME.Value</Value>
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
						<DataSetName>vwORDERS</DataSetName>
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
									<Width>3in</Width>
								</TablixColumn>
							</TablixColumns>
							<TablixRows>
								<TablixRow>
									<Height>1.25in</Height>
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
																			<Value>Order</Value>
																			<Style>
																				<FontSize>20pt</FontSize>
																				<FontWeight>Bold</FontWeight>
																			</Style>
																		</TextRun>
																	</TextRuns>
																	<Style />
																</Paragraph>
															</Paragraphs>
															<Height>0.375in</Height>
															<Width>3in</Width>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="lblORDER_NUM">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>Order No:</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Right</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>0.375in</Top>
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
														<Textbox Name="ORDER_NUM">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!ORDER_NUM.Value</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Left</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>0.375in</Top>
															<Left>1.25in</Left>
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
																			<Value>=Fields!DATE_MODIFIED.Value</Value>
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
															<Left>1.25in</Left>
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
																			<Value>Terms:</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Right</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>0.775in</Top>
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
																			<Value>=Fields!PAYMENT_TERMS.Value</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Left</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>0.775in</Top>
															<Left>1.25in</Left>
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
																			<Value>Shipping Method:</Value>
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
																			<Value>=Fields!SHIPPER_NAME.Value</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Left</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>0.975in</Top>
															<Left>1.25in</Left>
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
						<DataSetName>vwORDERS</DataSetName>
						<Left>4.375in</Left>
						<Height>1.25in</Height>
						<Width>3in</Width>
						<ZIndex>3</ZIndex>
						<Style />
					</Tablix>
					<Tablix Name="divTOTAL">
						<TablixBody>
							<TablixColumns>
								<TablixColumn>
									<Width>3.25in</Width>
								</TablixColumn>
							</TablixColumns>
							<TablixRows>
								<TablixRow>
									<Height>0.8in</Height>
									<TablixCells>
										<TablixCell>
											<CellContents>
												<Rectangle Name="divTOTAL_Contents">
													<ReportItems>
														<Textbox Name="SUBTOTAL">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!SUBTOTAL.Value</Value>
																			<Style>
																				<Format>C</Format>
																			</Style>
																		</TextRun>
																	</TextRuns>
																	<Style />
																</Paragraph>
															</Paragraphs>
															<Left>2in</Left>
															<Height>0.2in</Height>
															<Width>1.25in</Width>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="SHIPPING">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!SHIPPING.Value</Value>
																			<Style>
																				<Format>C</Format>
																			</Style>
																		</TextRun>
																	</TextRuns>
																	<Style />
																</Paragraph>
															</Paragraphs>
															<Top>0.2in</Top>
															<Left>2in</Left>
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
														<Textbox Name="TAX">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!TAX.Value</Value>
																			<Style>
																				<Format>C</Format>
																			</Style>
																		</TextRun>
																	</TextRuns>
																	<Style />
																</Paragraph>
															</Paragraphs>
															<Top>0.4in</Top>
															<Left>2in</Left>
															<Height>0.2in</Height>
															<Width>1.25in</Width>
															<ZIndex>2</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="TOTAL">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!TOTAL.Value</Value>
																			<Style>
																				<Format>C</Format>
																			</Style>
																		</TextRun>
																	</TextRuns>
																	<Style />
																</Paragraph>
															</Paragraphs>
															<Top>0.6in</Top>
															<Left>2in</Left>
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
														<Textbox Name="lblSUBTOTAL">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>Subtotal:</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Right</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Left>1in</Left>
															<Height>0.2in</Height>
															<Width>1in</Width>
															<ZIndex>4</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="lblSHIPPING">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>Shipping:</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Right</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>0.2in</Top>
															<Left>1in</Left>
															<Height>0.2in</Height>
															<Width>1in</Width>
															<ZIndex>5</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="lblTAX">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>Tax:</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Right</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>0.4in</Top>
															<Left>1in</Left>
															<Height>0.2in</Height>
															<Width>1in</Width>
															<ZIndex>6</ZIndex>
															<Style>
																<PaddingLeft>2pt</PaddingLeft>
																<PaddingRight>2pt</PaddingRight>
																<PaddingTop>2pt</PaddingTop>
																<PaddingBottom>2pt</PaddingBottom>
															</Style>
														</Textbox>
														<Textbox Name="lblTOTAL">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>Total:</Value>
																			<Style />
																		</TextRun>
																	</TextRuns>
																	<Style>
																		<TextAlign>Right</TextAlign>
																	</Style>
																</Paragraph>
															</Paragraphs>
															<Top>0.6in</Top>
															<Left>1in</Left>
															<Height>0.2in</Height>
															<Width>1in</Width>
															<ZIndex>7</ZIndex>
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
									<Group Name="divTOTAL_Details_Group">
										<DataElementName>Item</DataElementName>
									</Group>
									<DataElementName>Item_Collection</DataElementName>
									<DataElementOutput>Output</DataElementOutput>
									<KeepTogether>true</KeepTogether>
								</TablixMember>
							</TablixMembers>
						</TablixRowHierarchy>
						<DataSetName>vwORDERS</DataSetName>
						<Top>3.125in</Top>
						<Left>4.125in</Left>
						<Height>0.8in</Height>
						<Width>3.25in</Width>
						<ZIndex>4</ZIndex>
						<Style />
					</Tablix>
					<Tablix Name="divSHIPPING_ADDRESS">
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
												<Rectangle Name="divSHIPPING_ADDRESS_Contents">
													<ReportItems>
														<Textbox Name="lblSHIP_TO">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>Ship To:</Value>
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
														<Textbox Name="SHIPPING_ACCOUNT_NAME">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!SHIPPING_ACCOUNT_NAME.Value</Value>
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
														<Textbox Name="SHIPPING_ADDRESS_STREET">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!SHIPPING_ADDRESS_STREET.Value</Value>
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
														<Textbox Name="SHIPPING_ADDRESS_CITY">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!SHIPPING_ADDRESS_CITY.Value + " " + Fields!SHIPPING_ADDRESS_STATE.Value + " " + Fields!SHIPPING_ADDRESS_POSTALCODE.Value</Value>
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
														<Textbox Name="SHIPPING_ADDRESS_COUNTRY">
															<CanGrow>true</CanGrow>
															<KeepTogether>true</KeepTogether>
															<Paragraphs>
																<Paragraph>
																	<TextRuns>
																		<TextRun>
																			<Value>=Fields!SHIPPING_ADDRESS_COUNTRY.Value</Value>
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
									<Group Name="divSHIPPING_ADDRESS_Details_Group">
										<DataElementName>Item</DataElementName>
									</Group>
									<DataElementName>Item_Collection</DataElementName>
									<DataElementOutput>Output</DataElementOutput>
									<KeepTogether>true</KeepTogether>
								</TablixMember>
							</TablixMembers>
						</TablixRowHierarchy>
						<DataSetName>vwORDERS</DataSetName>
						<Top>1.375in</Top>
						<Left>4.125in</Left>
						<Height>1.125in</Height>
						<Width>3.25in</Width>
						<ZIndex>5</ZIndex>
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
						<ZIndex>6</ZIndex>
						<Style />
					</Tablix>
					<Tablix Name="Tablix1">
						<TablixBody>
							<TablixColumns>
								<TablixColumn>
									<Width>3.20834in</Width>
								</TablixColumn>
							</TablixColumns>
							<TablixRows>
								<TablixRow>
									<Height>0.8in</Height>
									<TablixCells>
										<TablixCell>
											<CellContents>
												<Rectangle Name="Rectangle2">
													<ReportItems>
														<Image Name="Image2">
															<Source>Database</Source>
															<Value>=Fields!CONTENT.Value</Value>
															<MIMEType>image/png</MIMEType>
															<Sizing>FitProportional</Sizing>
															<Height>0.8in</Height>
															<Width>3.19792in</Width>
															<Style>
																<Border>
																	<Style>None</Style>
																</Border>
															</Style>
														</Image>
													</ReportItems>
													<KeepTogether>true</KeepTogether>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
													</Style>
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
									<Group Name="Details" />
								</TablixMember>
							</TablixMembers>
						</TablixRowHierarchy>
						<DataSetName>vwIMAGES</DataSetName>
						<Top>3.125in</Top>
						<Left>0.25in</Left>
						<Height>0.8in</Height>
						<Width>3.20834in</Width>
						<ZIndex>7</ZIndex>
						<Style>
							<Border>
								<Style>None</Style>
							</Border>
						</Style>
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
		<ReportParameter Name="ORDER_ID">
			<DataType>String</DataType>
			<AllowBlank>true</AllowBlank>
			<Prompt>Order ID</Prompt>
		</ReportParameter>
		<ReportParameter Name="SIGNATURE_ID">
			<DataType>String</DataType>
			<Nullable>true</Nullable>
			<DefaultValue>
				<Values>
					<Value>00000000-0000-0000-0000-000000000000</Value>
				</Values>
			</DefaultValue>
			<AllowBlank>true</AllowBlank>
			<Prompt>Signature ID</Prompt>
			<Hidden>true</Hidden>
		</ReportParameter>
	</ReportParameters>
	<Language>en-US</Language>
	<ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
	<rd:ReportUnitType>Inch</rd:ReportUnitType>
	<rd:ReportID>f40989fe-24f5-4352-bb32-a23713ea6ec8</rd:ReportID>
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

call dbo.spREPORTS_Generic_Order()
/

call dbo.spSqlDropProcedure('spREPORTS_Generic_Order')
/

-- #endif IBM_DB2 */

