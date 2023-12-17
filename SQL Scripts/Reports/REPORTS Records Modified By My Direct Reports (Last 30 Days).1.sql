

print 'REPORTS Records Modified By My Direct Reports (Last 30 Days)';
GO

set nocount on;
GO

-- delete from REPORTS where ID = 'D50CD870-0C97-4B76-9413-6278A3719412';
exec dbo.spREPORTS_InsertOnly 'D50CD870-0C97-4B76-9413-6278A3719412', 'Records Modified By My Direct Reports (Last 30 Days)', 'Trackers', 'Freeform', '<?xml version="1.0" encoding="utf-8"?>
<Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns:cl="http://schemas.microsoft.com/sqlserver/reporting/2010/01/componentdefinition" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2010/01/reportdefinition">
	<AutoRefresh>0</AutoRefresh>
	<DataSources>
		<DataSource Name="SplendidCRM">
			<DataSourceReference>SplendidCRM</DataSourceReference>
			<rd:DataSourceID>a1c2138e-3286-4613-a3fa-0cde22947bfa</rd:DataSourceID>
		</DataSource>
	</DataSources>
	<DataSets>
		<DataSet Name="vwTRACKER">
			<Query>
				<DataSourceName>SplendidCRM</DataSourceName>
				<QueryParameters>
					<QueryParameter Name="@ASSIGNED_USER_ID">
						<Value>=Parameters!ASSIGNED_USER_ID.Value</Value>
						<rd:UserDefined>true</rd:UserDefined>
					</QueryParameter>
				</QueryParameters>
				<CommandText>select cast(vwTRACKER.ITEM_ID as char(36)) as ITEM_ID
     , vwTRACKER.ITEM_SUMMARY
     , vwTRACKER.MODULE_NAME
     , vwTRACKER.DATE_MODIFIED
     , vwUSERS.USER_NAME
  from      vwTRACKER
 inner join vwUSERS
         on vwUSERS.ID = vwTRACKER.USER_ID
 where vwTRACKER.ACTION        = ''Save''
   and vwTRACKER.DATE_MODIFIED &gt; dbo.fnDateAdd(''day'', -30, getdate())
   and vwUSERS.REPORTS_TO_ID = @ASSIGNED_USER_ID</CommandText>
			</Query>
			<Fields>
				<Field Name="ITEM_ID">
					<DataField>ITEM_ID</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="ITEM_SUMMARY">
					<DataField>ITEM_SUMMARY</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="MODULE_NAME">
					<DataField>MODULE_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="USER_NAME">
					<DataField>USER_NAME</DataField>
					<rd:TypeName>System.String</rd:TypeName>
				</Field>
				<Field Name="DATE_MODIFIED">
					<DataField>DATE_MODIFIED</DataField>
					<rd:TypeName>System.DateTime</rd:TypeName>
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
									<Width>1in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>2in</Width>
								</TablixColumn>
								<TablixColumn>
									<Width>3.5in</Width>
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
										<TablixCell>
											<CellContents>
												<Textbox Name="Textbox8">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Item ID</Value>
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
												<Textbox Name="Textbox5">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Item Summary</Value>
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
												<Textbox Name="Textbox3">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Module Name</Value>
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
												<Textbox Name="Textbox6">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>Last Modified</Value>
																	<Style>
																		<FontSize>8pt</FontSize>
																		<FontWeight>Bold</FontWeight>
																		<Format>d</Format>
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
									</TablixCells>
								</TablixRow>
								<TablixRow>
									<Height>0.21in</Height>
									<TablixCells>
										<TablixCell>
											<CellContents>
												<Textbox Name="USER_NAME">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!USER_NAME.Value</Value>
																	<Style />
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Left</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>USER_NAME</rd:DefaultName>
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
												<Textbox Name="ITEM_ID">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!ITEM_ID.Value</Value>
																	<Style />
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Left</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>ITEM_ID</rd:DefaultName>
													<ActionInfo>
														<Actions>
															<Action>
																<Hyperlink>="~/" + Fields!MODULE_NAME.Value + "/view.aspx?ID=" + Fields!ITEM_ID.Value</Hyperlink>
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
												<Textbox Name="ITEM_SUMMARY">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!ITEM_SUMMARY.Value</Value>
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
													<rd:DefaultName>ITEM_SUMMARY</rd:DefaultName>
													<ActionInfo>
														<Actions>
															<Action>
																<Hyperlink>="~/" + Fields!MODULE_NAME.Value + "/view.aspx?ID=" + Fields!ITEM_ID.Value</Hyperlink>
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
												<Textbox Name="MODULE_NAME">
													<CanGrow>true</CanGrow>
													<KeepTogether>true</KeepTogether>
													<Paragraphs>
														<Paragraph>
															<TextRuns>
																<TextRun>
																	<Value>=Fields!MODULE_NAME.Value</Value>
																	<Style />
																</TextRun>
															</TextRuns>
															<Style>
																<TextAlign>Left</TextAlign>
															</Style>
														</Paragraph>
													</Paragraphs>
													<rd:DefaultName>MODULE_NAME</rd:DefaultName>
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
													<rd:DefaultName>DATE_MODIFIED</rd:DefaultName>
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
						<DataSetName>vwTRACKER</DataSetName>
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
			<Prompt>ASSIGNED_USER_ID</Prompt>
		</ReportParameter>
	</ReportParameters>
	<ConsumeContainerWhitespace>true</ConsumeContainerWhitespace>
	<rd:ReportUnitType>Inch</rd:ReportUnitType>
	<rd:ReportID>D50CD870-0C97-4B76-9413-6278A3719412</rd:ReportID>
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

call dbo.spREPORTS_Records_Modified_Direct_Reports()
/

call dbo.spSqlDropProcedure('spREPORTS_Records_Modified_Direct_Reports')
/

-- #endif IBM_DB2 */

