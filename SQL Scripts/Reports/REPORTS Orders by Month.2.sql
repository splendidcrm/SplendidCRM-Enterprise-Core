

print 'REPORTS Orders by Month';
GO

set nocount on;
GO

-- 03/08/2012 Paul.  The ReportID should match the ID in the table. 
-- delete from REPORTS where ID = '6C32AF69-7FE6-41F8-8D32-3782AE78F8E3';
exec dbo.spREPORTS_InsertOnly '6C32AF69-7FE6-41F8-8D32-3782AE78F8E3', 'Orders by Month', 'Orders', 'Freeform', '<?xml version="1.0" encoding="utf-8"?>
<Report xmlns:rd="http://schemas.microsoft.com/SQLServer/reporting/reportdesigner" xmlns="http://schemas.microsoft.com/sqlserver/reporting/2008/01/reportdefinition">
	<DataSources>
		<DataSource Name="SplendidCRM">
			<DataSourceReference>SplendidCRM</DataSourceReference>
			<rd:DataSourceID>a1c2138e-3286-4613-a3fa-0cde22947bfa</rd:DataSourceID>
		</DataSource>
	</DataSources>
	<DataSets>
		<DataSet Name="vwORDERS_LINE_ITEMS">
			<Fields>
				<Field Name="DATE_ORDER_DUE">
					<DataField>DATE_ORDER_DUE</DataField>
					<rd:TypeName>System.DateTime</rd:TypeName>
				</Field>
				<Field Name="QUANTITY">
					<DataField>QUANTITY</DataField>
					<rd:TypeName>System.Int32</rd:TypeName>
				</Field>
			</Fields>
			<Query>
				<DataSourceName>SplendidCRM</DataSourceName>
				<QueryParameters>
					<QueryParameter Name="@ASSIGNED_USER_ID">
						<Value>=Parameters!ASSIGNED_USER_ID.Value</Value>
					</QueryParameter>
				</QueryParameters>
				<CommandText>
select dbo.fnMonthOnly(vwORDERS.DATE_ORDER_DUE) as DATE_ORDER_DUE
--     , vwORDERS_LINE_ITEMS.NAME
--     , vwORDERS_LINE_ITEMS.MFT_PART_NUM
     , sum(vwORDERS_LINE_ITEMS.QUANTITY) as QUANTITY
--     , vwORDERS_LINE_ITEMS.UNIT_PRICE
--     , vwORDERS_LINE_ITEMS.EXTENDED_PRICE
  from            vwORDERS
       inner join vwORDERS_LINE_ITEMS
               on vwORDERS_LINE_ITEMS.ORDER_ID = vwORDERS.ID
  left outer join vwTEAM_MEMBERSHIPS
               on vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID = TEAM_ID
              and vwTEAM_MEMBERSHIPS.MEMBERSHIP_USER_ID = @ASSIGNED_USER_ID
 where vwORDERS.ORDER_STAGE = ''Ordered''
   and vwORDERS_LINE_ITEMS.NAME is not null
   and (TEAM_ID is null or vwTEAM_MEMBERSHIPS.MEMBERSHIP_TEAM_ID is not null)
 group by dbo.fnMonthOnly(vwORDERS.DATE_ORDER_DUE)  --,  vwORDERS_LINE_ITEMS.NAME, vwORDERS_LINE_ITEMS.MFT_PART_NUM
 order by dbo.fnMonthOnly(vwORDERS.DATE_ORDER_DUE) desc  --, vwORDERS_LINE_ITEMS.NAME
				</CommandText>
				<rd:UseGenericDesigner>true</rd:UseGenericDesigner>
			</Query>
		</DataSet>
	</DataSets>
	<Body>
		<ReportItems>
			<Textbox Name="ReportTitle">
				<CanGrow>true</CanGrow>
				<KeepTogether>true</KeepTogether>
				<Paragraphs>
					<Paragraph>
						<TextRuns>
							<TextRun>
								<Value>Orders by Month</Value>
								<Style>
									<FontFamily>Verdana</FontFamily>
									<FontSize>14pt</FontSize>
									<FontWeight>Normal</FontWeight>
								</Style>
							</TextRun>
						</TextRuns>
						<Style />
					</Paragraph>
				</Paragraphs>
				<rd:WatermarkTextbox>Title</rd:WatermarkTextbox>
				<rd:DefaultName>ReportTitle</rd:DefaultName>
				<Height>0.25417in</Height>
				<Width>4.36458in</Width>
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
			<Tablix Name="Tablix1">
				<TablixBody>
					<TablixColumns>
						<TablixColumn>
							<Width>1.38542in</Width>
						</TablixColumn>
						<TablixColumn>
							<Width>0.97917in</Width>
						</TablixColumn>
					</TablixColumns>
					<TablixRows>
						<TablixRow>
							<Height>0.21285in</Height>
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
															<Value>Order Date</Value>
															<Style />
														</TextRun>
													</TextRuns>
													<Style />
												</Paragraph>
											</Paragraphs>
											<rd:DefaultName>Textbox1</rd:DefaultName>
											<Style>
												<Border>
													<Color>LightGrey</Color>
													<Style>Solid</Style>
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
										<Textbox Name="Textbox5">
											<CanGrow>true</CanGrow>
											<KeepTogether>true</KeepTogether>
											<Paragraphs>
												<Paragraph>
													<TextRuns>
														<TextRun>
															<Value>Quantity</Value>
															<Style />
														</TextRun>
													</TextRuns>
													<Style />
												</Paragraph>
											</Paragraphs>
											<rd:DefaultName>Textbox5</rd:DefaultName>
											<Style>
												<Border>
													<Color>LightGrey</Color>
													<Style>Solid</Style>
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
						<TablixRow>
							<Height>0.17813in</Height>
							<TablixCells>
								<TablixCell>
									<CellContents>
										<Textbox Name="DATE_ORDER_DUE">
											<CanGrow>true</CanGrow>
											<KeepTogether>true</KeepTogether>
											<Paragraphs>
												<Paragraph>
													<TextRuns>
														<TextRun>
															<Value>=Fields!DATE_ORDER_DUE.Value</Value>
															<Style>
																<Format>MMM yyyy</Format>
															</Style>
														</TextRun>
													</TextRuns>
													<Style />
												</Paragraph>
											</Paragraphs>
											<rd:DefaultName>DATE_ORDER_DUE</rd:DefaultName>
											<Style>
												<Border>
													<Color>LightGrey</Color>
													<Style>Solid</Style>
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
											<Style>
												<Border>
													<Color>LightGrey</Color>
													<Style>Solid</Style>
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
					</TablixMembers>
				</TablixColumnHierarchy>
				<TablixRowHierarchy>
					<TablixMembers>
						<TablixMember>
							<KeepWithGroup>After</KeepWithGroup>
						</TablixMember>
						<TablixMember>
							<Group Name="Details" />
						</TablixMember>
					</TablixMembers>
				</TablixRowHierarchy>
				<DataSetName>vwORDERS_LINE_ITEMS</DataSetName>
				<Top>0.26806in</Top>
				<Height>0.39098in</Height>
				<Width>2.36459in</Width>
				<ZIndex>1</ZIndex>
				<Style>
					<Border>
						<Style>None</Style>
					</Border>
				</Style>
			</Tablix>
		</ReportItems>
		<Height>0.65904in</Height>
		<Style>
			<Border>
				<Style>None</Style>
			</Border>
		</Style>
	</Body>
	<Width>4.36459in</Width>
	<Page>
		<PageFooter>
			<Height>0.22083in</Height>
			<PrintOnFirstPage>true</PrintOnFirstPage>
			<PrintOnLastPage>true</PrintOnLastPage>
			<Style>
				<Border>
					<Style>None</Style>
				</Border>
			</Style>
		</PageFooter>
		<PageHeight>4in</PageHeight>
		<PageWidth>4in</PageWidth>
		<LeftMargin>0.5in</LeftMargin>
		<RightMargin>0.5in</RightMargin>
		<TopMargin>0.5in</TopMargin>
		<BottomMargin>0.5in</BottomMargin>
		<Style />
	</Page>
	<ReportParameters>
		<ReportParameter Name="ASSIGNED_USER_ID">
			<DataType>String</DataType>
			<Nullable>true</Nullable>
			<Prompt>Assigned To:</Prompt>
		</ReportParameter>
	</ReportParameters>
	<rd:ReportID>6C32AF69-7FE6-41F8-8D32-3782AE78F8E3</rd:ReportID>
	<rd:ReportUnitType>Inch</rd:ReportUnitType>
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

call dbo.spREPORTS_Orders_by_Month()
/

call dbo.spSqlDropProcedure('spREPORTS_Orders_by_Month')
/

-- #endif IBM_DB2 */

