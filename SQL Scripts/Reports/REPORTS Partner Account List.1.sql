

print 'REPORTS Partner Account List';
GO

set nocount on;
GO

-- delete from REPORTS where ID = 'A044A12A-B006-4E07-99D6-929316A515EC';
exec dbo.spREPORTS_InsertOnly 'A044A12A-B006-4E07-99D6-929316A515EC', 'Partner Account List', 'Accounts', 'Freeform', '<?xml version="1.0" encoding="utf-8"?>
<Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns:cl="http://schemas.microsoft.com/sqlserver/reporting/2010/01/componentdefinition" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition">
	<AutoRefresh>0</AutoRefresh>
	<DataSources>
		<DataSource Name="SplendidCRM">
			<DataSourceReference>SplendidCRM</DataSourceReference>
			<rd:DataSourceID>a1c2138e-3286-4613-a3fa-0cde22947bfa</rd:DataSourceID>
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
				</QueryParameters>
				<CommandText>select cast(ID as char(36)) as ID
     , NAME
     , PHONE_OFFICE
     , DESCRIPTION
     , ANNUAL_REVENUE
     , ACCOUNT_TYPE
     , ASSIGNED_TO
  from vwACCOUNTS
  left outer join vwTEAM_MEMBERSHIPS
               on vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID = TEAM_ID
              and vwTEAM_MEMBERSHIPS.MEMBERSHIP_USER_ID = @ASSIGNED_USER_ID
 where ACCOUNT_TYPE = ''Partner''
   and (TEAM_ID is null or vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID is not null)
 order by NAME</CommandText>
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
				<Field Name="PHONE_OFFICE">
					<DataField>PHONE_OFFICE</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="ANNUAL_REVENUE">
					<DataField>ANNUAL_REVENUE</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="DESCRIPTION">
					<DataField>DESCRIPTION</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="ACCOUNT_TYPE">
					<DataField>ACCOUNT_TYPE</DataField>
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
									<Width>2in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>1in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>2.5in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>1in</Width>
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
									<Height>0.21in</Height>
									<TablixCells>
										<TablixCell>
											<CellContents>
												<Textbox Name="Textbox8">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Account Name</Value>
																	<Style>
																		<FontSize>8pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>Textbox8</rd:DefaultName>
													<Style>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>2pt</Width>
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
												<Textbox Name="Textbox3">
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
													<rd:DefaultName>Textbox3</rd:DefaultName>
													<Style>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>2pt</Width>
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
												<Textbox Name="Textbox2">
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
													<rd:DefaultName>Textbox2</rd:DefaultName>
													<Style>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>2pt</Width>
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
												<Textbox Name="Textbox4">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Annual Revenue</Value>
																	<Style>
																		<FontSize>8pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>Textbox4</rd:DefaultName>
													<Style>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>2pt</Width>
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
												<Textbox Name="Textbox6">
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
													<rd:DefaultName>Textbox6</rd:DefaultName>
													<Style>
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>2pt</Width>
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
												<Textbox Name="Textbox1">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Assigned To</Value>
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
														<BottomBorder>
															<Color>Black</Color>
															<Style>Solid</Style>
															<Width>2pt</Width>
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
															<Style>
																<TextAlign>Left</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>NAME</rd:DefaultName>
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
												<Textbox Name="DESCRIPTION">
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
													<rd:DefaultName>DESCRIPTION</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
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
												<Textbox Name="ANNUAL_REVENUE">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!ANNUAL_REVENUE.Value</Value>
																	<Style>
																		<Format>c</Format>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Left</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>ANNUAL_REVENUE</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
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
												<Textbox Name="ACCOUNT_TYPE">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!ACCOUNT_TYPE.Value</Value>
																	<Style />
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Left</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>ACCOUNT_TYPE</rd:DefaultName>
													<Style>
														<Border>
															<Style>None</Style>
														</Border>
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
									<Group Name="table1_Details_Group">
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
						<DataSetName>vwACCOUNTS</DataSetName>
						<Height>0.42in</Height>
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
	</ReportParameters>
	<ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
	<rd:ReportUnitType>Inch</rd:ReportUnitType>
	<rd:ReportID>A044A12A-B006-4E07-99D6-929316A515EC</rd:ReportID>
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

call dbo.spREPORTS_Partner_Account_List()
/

call dbo.spSqlDropProcedure('spREPORTS_Partner_Account_List')
/

-- #endif IBM_DB2 */

