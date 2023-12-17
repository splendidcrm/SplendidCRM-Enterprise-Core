

print 'REPORTS Opportunities By Sales Stage';
GO

set nocount on;
GO

-- delete from REPORTS where ID = 'DFA68631-BE21-4647-90E6-A5B754CEC8F6';
exec dbo.spREPORTS_InsertOnly 'DFA68631-BE21-4647-90E6-A5B754CEC8F6', 'Opportunities By Sales Stage', 'Opportunities', 'Freeform', '<?xml version="1.0" encoding="utf-8"?>
<Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns:cl="http://schemas.microsoft.com/sqlserver/reporting/2010/01/componentdefinition" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition">
	<AutoRefresh>0</AutoRefresh>
	<DataSources>
		<DataSource Name="SplendidCRM">
			<ConnectionProperties>
				<DataProvider>SQL</DataProvider>
				<ConnectString>Data Source=sql04;Initial Catalog=SplendidCRM6_Training</ConnectString>
				<IntegratedSecurity>true</IntegratedSecurity>
			</ConnectionProperties>
			<rd:SecurityType>Integrated</rd:SecurityType>
			<rd:DataSourceID>029f686d-1996-4ae6-ac49-ed6cb4d52ded</rd:DataSourceID>
		</DataSource>
	</DataSources>
	<DataSets>
		<DataSet Name="vwOPPORTUNITIES">
			<Query>
				<DataSourceName>SplendidCRM</DataSourceName>
				<QueryParameters>
					<QueryParameter Name="@ASSIGNED_USER_ID">
						<Value>=Parameters!ASSIGNED_USER_ID.Value</Value>
					</QueryParameter>
					<QueryParameter Name="@SALES_STAGE">
						<Value>=Parameters!SALES_STAGE.Value</Value>
					</QueryParameter>
					<QueryParameter Name="@OPPORTUNITY_TYPE">
						<Value>=Parameters!OPPORTUNITY_TYPE.Value</Value>
					</QueryParameter>
				</QueryParameters>
				<CommandText>select cast(ID as char(36)) as ID
     , NAME
     , OPPORTUNITY_TYPE
     , SALES_STAGE
     , DATE_CLOSED
     , AMOUNT_USDOLLAR
     , PROBABILITY
     , ASSIGNED_TO
     , DESCRIPTION
  from vwOPPORTUNITIES
  left outer join vwTEAM_MEMBERSHIPS
               on vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID = TEAM_ID
              and vwTEAM_MEMBERSHIPS.MEMBERSHIP_USER_ID = @ASSIGNED_USER_ID
 where SALES_STAGE in (@SALES_STAGE)
   and OPPORTUNITY_TYPE IN (@OPPORTUNITY_TYPE)
   and (TEAM_ID is null or vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID is not null)
 order by DATE_CLOSED asc</CommandText>
			</Query>
			<Fields>
				<Field Name="ID">
					<DataField>ID</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="NAME">
					<DataField>NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="OPPORTUNITY_TYPE">
					<DataField>OPPORTUNITY_TYPE</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="SALES_STAGE">
					<DataField>SALES_STAGE</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="DATE_CLOSED">
					<DataField>DATE_CLOSED</DataField>
					<rd:TypeName>System.DateTime</rd:TypeName>
				</Field>
				<Field Name="AMOUNT_USDOLLAR">
					<DataField>AMOUNT_USDOLLAR</DataField>
					<rd:TypeName>System.Decimal</rd:TypeName>
				</Field>
				<Field Name="ASSIGNED_TO">
					<DataField>ASSIGNED_TO</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="PROBABILITY">
					<DataField>PROBABILITY</DataField>
					<rd:TypeName>System.Double</rd:TypeName>
				</Field>
				<Field Name="DESCRIPTION">
					<DataField>DESCRIPTION</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
			</Fields>
		</DataSet>
	</DataSets>
	<ReportSections>
		<ReportSection>
			<Body>
				<ReportItems>
					<Tablix Name="table1">
						<TablixBody>
							<TablixColumns>
								<TablixColumn>
									<Width>1.5in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>1in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>1.25in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>1.5in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>1.25in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>1in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>1in</Width>
								</TablixColumn>
							</TablixColumns>
							<TablixRows>
								<TablixRow>
									<Height>0.20833in</Height>
									<TablixCells>
										<TablixCell>
											<CellContents>
												<Textbox Name="SALES_STAGE1">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>="Sales Stage = " + Fields!SALES_STAGE.Value + ", Count = " + Str(Count(Fields!ID.Value)) + ", AVG: Amount = " + FormatCurrency(Avg(Fields!AMOUNT_USDOLLAR.Value), 0) + ", SUM: Amount = " + FormatCurrency(Sum(Fields!AMOUNT_USDOLLAR.Value), 0)</Value>
																	<Style>
																		<FontSize>8pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>SALES_STAGE1</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
														<TopBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</RightBorder>
														<BackgroundColor>LightGrey</BackgroundColor>
														<PaddingLeft>2pt</PaddingLeft>
														<PaddingRight>2pt</PaddingRight>
														<PaddingTop>2pt</PaddingTop>
														<PaddingBottom>2pt</PaddingBottom>
													</Style>
												</Textbox>
												<ColSpan>7</ColSpan>
												<rd:Selected>true</rd:Selected>
											</CellContents>
										</TablixCell>
										<TablixCell />
										<TablixCell />
										<TablixCell />
										<TablixCell />
										<TablixCell />
										<TablixCell />
									</TablixCells>
								</TablixRow>
								<TablixRow>
									<Height>0.20833in</Height>
									<TablixCells>
										<TablixCell>
											<CellContents>
												<Textbox Name="USER_NAME__Header2">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Opportunity Name</Value>
																	<Style>
																		<FontSize>8pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
														<TopBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</RightBorder>
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
												<Textbox Name="Textbox1">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Amount</Value>
																	<Style>
																		<FontSize>8pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Right</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>Textbox1</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
														<TopBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</RightBorder>
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
												<Textbox Name="Textbox6">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Expected Close Date</Value>
																	<Style>
																		<FontSize>8pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Right</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>Textbox5</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
														<TopBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</RightBorder>
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
												<Textbox Name="Textbox35">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Description</Value>
																	<Style>
																		<FontSize>8pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>Textbox35</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
														<TopBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</RightBorder>
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
												<Textbox Name="Textbox37">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Type</Value>
																	<Style>
																		<FontSize>8pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>Textbox37</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
														<TopBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</RightBorder>
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
												<Textbox Name="Textbox2">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Probability (%)</Value>
																	<Style>
																		<FontSize>8pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>Textbox2</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
														<TopBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</RightBorder>
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
												<Textbox Name="Textbox7">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>User Name</Value>
																	<Style>
																		<FontSize>8pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>Textbox1</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
														<TopBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</RightBorder>
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
												<Textbox Name="USER_NAME__Value">
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
													<ActionInfo>
														<Actions>
															<Action>
																<Hyperlink>="~/Opportunities/view.aspx?ID=" + Fields!ID.Value</Hyperlink>
															</Action>
														</Actions>
													</ActionInfo>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
														<TopBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</RightBorder>
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
												<Textbox Name="AMOUNT_USDOLLAR">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!AMOUNT_USDOLLAR.Value</Value>
																	<Style>
																		<Format>c</Format>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Right</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>AMOUNT_USDOLLAR</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
														<TopBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</RightBorder>
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
												<Textbox Name="DATE_CLOSED">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!DATE_CLOSED.Value</Value>
																	<Style>
																		<Format>d</Format>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Right</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>DATE_CLOSED</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
														<TopBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</RightBorder>
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
												<Textbox Name="DESCRIPTION1">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!DESCRIPTION.Value</Value>
																	<Style />
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Left</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>DESCRIPTION1</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
														<TopBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</RightBorder>
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
												<Textbox Name="OPPORTUNITY_TYPE">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!OPPORTUNITY_TYPE.Value</Value>
																	<Style />
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Left</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>OPPORTUNITY_TYPE</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
														<TopBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</RightBorder>
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
												<Textbox Name="PROBABILITY">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!PROBABILITY.Value</Value>
																	<Style />
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Left</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>PROBABILITY</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
														<TopBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</RightBorder>
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
												<Textbox Name="ASSIGNED_TO">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!ASSIGNED_TO.Value</Value>
																	<Style />
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Left</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>ASSIGNED_TO</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
														<TopBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</RightBorder>
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
								<TablixMember />
								<TablixMember />
							</TablixMembers>
						</TablixColumnHierarchy>
						<TablixRowHierarchy>
							<TablixMembers>
								<TablixMember>
									<Group Name="SALES_STAGE">
										<GroupExpressions>
											<GroupExpression>=Fields!SALES_STAGE.Value</GroupExpression>
										</GroupExpressions>
									</Group>
									<SortExpressions>
										<SortExpression>
											<Value>=Fields!SALES_STAGE.Value</Value>
										</SortExpression>
									</SortExpressions>
									<TablixHeader>
										<Size>0.03125in</Size>
										<CellContents>
											<Textbox Name="SALES_STAGE">
												<CanGrow>true</CanGrow>
												<KeepTogether>true</KeepTogether>
												<Paragraphs>
													<Paragraph>
														<TextRuns>
															<TextRun>
																<Value>=Fields!SALES_STAGE.Value</Value>
																<Style />
															</TextRun>
														</TextRuns>
														<Style />
													</Paragraph>
												</Paragraphs>
												<rd:DefaultName>SALES_STAGE</rd:DefaultName>
												<Visibility>
													<Hidden>true</Hidden>
												</Visibility>
												<Style>
													<Border>
														<Style>None</Style>
													</Border>
													<TopBorder>
														<Color>Black</Color>
														<Style>Solid</Style>
														<Width>1pt</Width>
													</TopBorder>
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
									</TablixHeader>
									<TablixMembers>
										<TablixMember>
											<KeepWithGroup>After</KeepWithGroup>
										</TablixMember>
										<TablixMember>
											<KeepWithGroup>After</KeepWithGroup>
										</TablixMember>
										<TablixMember>
											<Group Name="table1_Details_Group">
												<DataElementName>Detail</DataElementName>
											</Group>
											<SortExpressions>
												<SortExpression>
													<Value>=Fields!DATE_CLOSED.Value</Value>
												</SortExpression>
											</SortExpressions>
											<TablixMembers>
												<TablixMember />
											</TablixMembers>
											<DataElementName>Detail_Collection</DataElementName>
											<DataElementOutput>Output</DataElementOutput>
											<KeepTogether>true</KeepTogether>
										</TablixMember>
									</TablixMembers>
								</TablixMember>
							</TablixMembers>
						</TablixRowHierarchy>
						<DataSetName>vwOPPORTUNITIES</DataSetName>
						<Height>0.62666in</Height>
						<Width>8.53125in</Width>
						<Style />
					</Tablix>
				</ReportItems>
				<Height>11in</Height>
				<Style />
			</Body>
			<Width>8.53125in</Width>
			<Page>
				<LeftMargin>0.5in</LeftMargin>
				<RightMargin>0.5in</RightMargin>
				<TopMargin>0.5in</TopMargin>
				<BottomMargin>0.5in</BottomMargin>
				<Style />
			</Page>
		</ReportSection>
	</ReportSections>
	<ReportParameters>
		<ReportParameter Name="SALES_STAGE">
			<DataType>String</DataType>
			<DefaultValue>
				<Values>
					<Value>Prospecting</Value>
					<Value>Qualification</Value>
					<Value>Needs Analysis</Value>
					<Value>Value Proposition</Value>
					<Value>Id. Decision Makers</Value>
					<Value>Perception Analysis</Value>
					<Value>Proposal/Price Quote</Value>
					<Value>Negotiation/Review</Value>
					<Value>Closed Won</Value>
					<Value>Closed Lost</Value>
				</Values>
			</DefaultValue>
			<AllowBlank>true</AllowBlank>
			<Prompt>Sales Stage:</Prompt>
			<MultiValue>true</MultiValue>
		</ReportParameter>
		<ReportParameter Name="ASSIGNED_USER_ID">
			<DataType>String</DataType>
			<Nullable>true</Nullable>
			<Prompt>Assigned To:</Prompt>
		</ReportParameter>
		<ReportParameter Name="OPPORTUNITY_TYPE">
			<DataType>String</DataType>
			<DefaultValue>
				<Values>
					<Value>Existing Business</Value>
					<Value>New Business</Value>
				</Values>
			</DefaultValue>
			<AllowBlank>true</AllowBlank>
			<Prompt>Opportunity Type:</Prompt>
			<MultiValue>true</MultiValue>
		</ReportParameter>
	</ReportParameters>
	<ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
	<rd:ReportUnitType>Inch</rd:ReportUnitType>
	<rd:ReportID>DFA68631-BE21-4647-90E6-A5B754CEC8F6</rd:ReportID>
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

call dbo.spREPORTS_Opportunities_By_Sales_Stage()
/

call dbo.spSqlDropProcedure('spREPORTS_Opportunities_By_Sales_Stage')
/

-- #endif IBM_DB2 */

