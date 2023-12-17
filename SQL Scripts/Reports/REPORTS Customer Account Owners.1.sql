

print 'REPORTS Customer Account Owners';
GO

set nocount on;
GO

-- delete from REPORTS where ID = '1930474B-866B-4443-92FC-9C2BC7A31041';
exec dbo.spREPORTS_InsertOnly '1930474B-866B-4443-92FC-9C2BC7A31041', 'Customer Account Owners', 'Accounts', 'Freeform', '<?xml version="1.0" encoding="utf-8"?>
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
		<DataSet Name="vwACCOUNTS">
			<Query>
				<DataSourceName>SplendidCRM</DataSourceName>
				<QueryParameters>
					<QueryParameter Name="@ASSIGNED_USER_ID">
						<Value>=Parameters!ASSIGNED_USER_ID.Value</Value>
					</QueryParameter>
					<QueryParameter Name="@ASSIGNED_TO">
						<Value>=Parameters!ASSIGNED_TO.Value</Value>
					</QueryParameter>
				</QueryParameters>
				<CommandText>select cast(ID as char(36)) as ID
     , NAME
     , WEBSITE
     , PHONE_OFFICE
     , BILLING_ADDRESS_CITY
     , BILLING_ADDRESS_COUNTRY
     , ASSIGNED_TO
  from vwACCOUNTS
  left outer join vwTEAM_MEMBERSHIPS
               on vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID = TEAM_ID
              and vwTEAM_MEMBERSHIPS.MEMBERSHIP_USER_ID = @ASSIGNED_USER_ID
 where ASSIGNED_TO in (@ASSIGNED_TO)
   and (TEAM_ID is null or vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID is not null)
 order by NAME asc</CommandText>
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
				<Field Name="WEBSITE">
					<DataField>WEBSITE</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="PHONE_OFFICE">
					<DataField>PHONE_OFFICE</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="BILLING_ADDRESS_CITY">
					<DataField>BILLING_ADDRESS_CITY</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="BILLING_ADDRESS_COUNTRY">
					<DataField>BILLING_ADDRESS_COUNTRY</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="ASSIGNED_TO">
					<DataField>ASSIGNED_TO</DataField>
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
									<Width>2.5in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>1.71875in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>1.25in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>1.5in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>1.5in</Width>
								</TablixColumn>
							</TablixColumns>
							<TablixRows>
								<TablixRow>
									<Height>0.20833in</Height>
									<TablixCells>
										<TablixCell>
											<CellContents>
												<Textbox Name="ASSIGNED_TO1">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>="User Name = " + Fields!ASSIGNED_TO.Value + ", Count = " + Str(Count(Fields!ID.Value))</Value>
																	<Style>
																		<FontSize>8pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>ASSIGNED_TO1</rd:DefaultName>
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
												<ColSpan>5</ColSpan>
												<rd:Selected>true</rd:Selected>
											</CellContents>
										</TablixCell>
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
																	<Value>Name</Value>
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
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
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
																	<Value>Website</Value>
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
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
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
												<Textbox Name="Textbox47">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Phone Office</Value>
																	<Style>
																		<FontSize>8pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>Textbox47</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
														<TopBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
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
																	<Value>Billing City</Value>
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
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
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
																	<Value>Billing Country</Value>
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
														</TopBorder>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>1pt</Width>
														</BottomBorder>
														<LeftBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
														</LeftBorder>
														<RightBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
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
																<Hyperlink>="~/Accounts/view.aspx?ID=" + Fields!ID.Value</Hyperlink>
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
												<Textbox Name="WEBSITE">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!WEBSITE.Value</Value>
																	<Style />
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Left</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>WEBSITE</rd:DefaultName>
													<ActionInfo>
														<Actions>
															<Action>
																<Hyperlink>=Fields!WEBSITE.Value</Hyperlink>
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
												<Textbox Name="PHONE_OFFICE">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!PHONE_OFFICE.Value</Value>
																	<Style />
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Left</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>PHONE_OFFICE</rd:DefaultName>
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
												<Textbox Name="BILLING_ADDRESS_CITY">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!BILLING_ADDRESS_CITY.Value</Value>
																	<Style />
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Left</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>BILLING_ADDRESS_CITY</rd:DefaultName>
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
															<Style>
																<TextAlign>Left</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>BILLING_ADDRESS_COUNTRY</rd:DefaultName>
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
							</TablixMembers>
						</TablixColumnHierarchy>
						<TablixRowHierarchy>
							<TablixMembers>
								<TablixMember>
									<Group Name="ASSIGNED_TO">
										<GroupExpressions>
											<GroupExpression>=Fields!ASSIGNED_TO.Value</GroupExpression>
										</GroupExpressions>
									</Group>
									<SortExpressions>
										<SortExpression>
											<Value>=Fields!ASSIGNED_TO.Value</Value>
										</SortExpression>
									</SortExpressions>
									<TablixHeader>
										<Size>0.03125in</Size>
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
														<Style />
													</Paragraph>
												</Paragraphs>
												<rd:DefaultName>ASSIGNED_TO</rd:DefaultName>
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
													<Value>=Fields!NAME.Value</Value>
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
						<DataSetName>vwACCOUNTS</DataSetName>
						<Height>0.62666in</Height>
						<Width>8.5in</Width>
						<Style />
					</Tablix>
				</ReportItems>
				<Height>11in</Height>
				<Style />
			</Body>
			<Width>8.5in</Width>
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
		<ReportParameter Name="ASSIGNED_USER_ID">
			<DataType>String</DataType>
			<Nullable>true</Nullable>
			<Prompt>Assigned To:</Prompt>
		</ReportParameter>
		<ReportParameter Name="ASSIGNED_TO">
			<DataType>String</DataType>
			<AllowBlank>true</AllowBlank>
			<Prompt>Assigned To:</Prompt>
			<MultiValue>true</MultiValue>
		</ReportParameter>
	</ReportParameters>
	<ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
	<rd:ReportUnitType>Inch</rd:ReportUnitType>
	<rd:ReportID>1930474B-866B-4443-92FC-9C2BC7A31041</rd:ReportID>
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

call dbo.spREPORTS_Customer_Account_Owners()
/

call dbo.spSqlDropProcedure('spREPORTS_Customer_Account_Owners')
/

-- #endif IBM_DB2 */

