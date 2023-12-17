

print 'REPORTS Open Meetings';
GO

set nocount on;
GO

-- delete from REPORTS where ID = 'D6B1A1A1-EAD1-4950-AE50-B4C3085E719D';
exec dbo.spREPORTS_InsertOnly 'D6B1A1A1-EAD1-4950-AE50-B4C3085E719D', 'Open Meetings', 'Meetings', 'Freeform', '<?xml version="1.0" encoding="utf-8"?>
<Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns:cl="http://schemas.microsoft.com/sqlserver/reporting/2010/01/componentdefinition" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition">
	<AutoRefresh>0</AutoRefresh>
	<DataSources>
		<DataSource Name="SplendidCRM">
			<DataSourceReference>SplendidCRM</DataSourceReference>
			<rd:DataSourceID>a1c2138e-3286-4613-a3fa-0cde22947bfa</rd:DataSourceID>
		</DataSource>
	</DataSources>
	<DataSets>
		<DataSet Name="vwMEETINGS">
			<Query>
				<DataSourceName>SplendidCRM</DataSourceName>
				<QueryParameters>
					<QueryParameter Name="@ASSIGNED_USER_ID">
						<Value>=Parameters!ASSIGNED_USER_ID.Value</Value>
					</QueryParameter>
					<QueryParameter Name="@STATUS">
						<Value>=Parameters!STATUS.Value</Value>
					</QueryParameter>
					<QueryParameter Name="@ASSIGNED_TO">
						<Value>=Parameters!ASSIGNED_TO.Value</Value>
					</QueryParameter>
					<QueryParameter Name="@DATE_RULE">
						<Value>=Parameters!DATE_RULE.Value</Value>
					</QueryParameter>
				</QueryParameters>
				<CommandText>select cast(ID as char(36)) as ID
     , NAME
     , DESCRIPTION
     , DATE_ENTERED
     , ASSIGNED_TO
  from vwMEETINGS
  left outer join vwTEAM_MEMBERSHIPS
               on vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID = TEAM_ID
              and vwTEAM_MEMBERSHIPS.MEMBERSHIP_USER_ID = @ASSIGNED_USER_ID
 where STATUS in (@STATUS)
   and DATE_START &gt; @DATE_RULE
   and ASSIGNED_TO in (@ASSIGNED_TO)
   and (TEAM_ID is null or vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID is not null)
 order by DATE_ENTERED asc</CommandText>
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
				<Field Name="DESCRIPTION">
					<DataField>DESCRIPTION</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="DATE_ENTERED">
					<DataField>DATE_ENTERED</DataField>
					<rd:TypeName>System.DateTime</rd:TypeName>
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
									<Width>3in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>3in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>1.25in</Width>
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
												<Textbox Name="USER_NAME__Header">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Subject</Value>
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
												<Textbox Name="FULL__NAME__Header">
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
												<Textbox Name="Textbox5">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Date Created</Value>
																	<Style>
																		<FontSize>8pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																	</Style>
																</TextRun>
															</TextRuns>
															<Style />
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>Textbox5</rd:DefaultName>
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
																<Hyperlink>="~/Calls/view.aspx?ID=" + Fields!ID.Value</Hyperlink>
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
												<Textbox Name="FULL_NAME__Value">
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
															<Style />
														</Paragraph>
													</Paragraphs>
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
												<Textbox Name="DATE_ENTERED">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!DATE_ENTERED.Value</Value>
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
													<rd:DefaultName>DATE_ENTERED</rd:DefaultName>
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
						<DataSetName>vwMEETINGS</DataSetName>
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
		<ReportParameter Name="STATUS">
			<DataType>String</DataType>
			<DefaultValue>
				<Values>
					<Value>Planned</Value>
					<Value>Not Held</Value>
				</Values>
			</DefaultValue>
			<AllowBlank>true</AllowBlank>
			<Prompt>Status:</Prompt>
			<MultiValue>true</MultiValue>
		</ReportParameter>
		<ReportParameter Name="ASSIGNED_TO">
			<DataType>String</DataType>
			<AllowBlank>true</AllowBlank>
			<Prompt>Assigned To:</Prompt>
			<MultiValue>true</MultiValue>
		</ReportParameter>
		<ReportParameter Name="DATE_RULE">
			<DataType>String</DataType>
			<DefaultValue>
				<Values>
					<Value>=DateTime.Today.AddDays(-7)</Value>
				</Values>
			</DefaultValue>
			<AllowBlank>true</AllowBlank>
			<Prompt>Date Rule:</Prompt>
		</ReportParameter>
		<ReportParameter Name="ASSIGNED_USER_ID">
			<DataType>String</DataType>
			<Nullable>true</Nullable>
			<Prompt>Assigned To:</Prompt>
		</ReportParameter>
	</ReportParameters>
	<ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
	<rd:ReportUnitType>Inch</rd:ReportUnitType>
	<rd:ReportID>D6B1A1A1-EAD1-4950-AE50-B4C3085E719D</rd:ReportID>
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

call dbo.spREPORTS_Open_Meetings()
/

call dbo.spSqlDropProcedure('spREPORTS_Open_Meetings')
/

-- #endif IBM_DB2 */

