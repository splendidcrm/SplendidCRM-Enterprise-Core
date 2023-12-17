/**********************************************************************************************************************
 * SplendidCRM is a Customer Relationship Management program created by SplendidCRM Software, Inc. 
 * Copyright (C) 2005-2023 SplendidCRM Software, Inc. All rights reserved.
 *
 * Any use of the contents of this file are subject to the SplendidCRM Enterprise Source Code License 
 * Agreement, or other written agreement between you and SplendidCRM ("License"). By installing or 
 * using this file, you have unconditionally agreed to the terms and conditions of the License, 
 * including but not limited to restrictions on the number of users therein, and you may not use this 
 * file except in compliance with the License. 
 * 
 * SplendidCRM owns all proprietary rights, including all copyrights, patents, trade secrets, and 
 * trademarks, in and to the contents of this file.  You will not link to or in any way combine the 
 * contents of this file or any derivatives with any Open Source Code in any manner that would require 
 * the contents of this file to be made available to any third party. 
 * 
 * IN NO EVENT SHALL SPLENDIDCRM BE RESPONSIBLE FOR ANY DAMAGES OF ANY KIND, INCLUDING ANY DIRECT, 
 * SPECIAL, PUNITIVE, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES.  Other limitations of liability 
 * and disclaimers set forth in the License. 
 * 
 *********************************************************************************************************************/
using System;
using System.IO;
using System.Text.Json;
using System.Data;
using System.Data.Common;
using System.Threading;
using System.Threading.Tasks;
using System.Diagnostics;

namespace SplendidCRM.MachineLearning
{
	public class MachineLearningUtils
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpApplicationState Application        = new HttpApplicationState();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;
		private Crm.Modules          Modules            ;

		public static bool m_bBusyTraining = false;
		public static bool m_bInsidePredicting = false;

		public MachineLearningUtils(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, SplendidCRM.Crm.Modules Modules)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
			this.Modules             = Modules            ;
		}

		public class MachineLearningThread
		{
			private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
			private HttpApplicationState Application        = new HttpApplicationState();
			private HttpSessionState     Session            ;
			private Security             Security           ;
			private Sql                  Sql                ;
			private SqlProcs             SqlProcs           ;
			private SplendidError        SplendidError      ;

			protected Guid        gID                  ;
			protected string      sNAME                ;
			protected string      sSTATUS              ;
			protected string      sSCENARIO            ;
			protected string      sTRAIN_SQL_VIEW      ;
			protected string      sEVALUATE_SQL_VIEW   ;
			protected string      sGOOD_FIELD_NAME     ;
			protected bool        bUSE_CROSS_VALIDATION;
			protected byte[]      byCONTENT            ;
			
			public MachineLearningThread(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError, Guid gID)
			{
				this.Session             = Session            ;
				this.Security            = Security           ;
				this.Sql                 = Sql                ;
				this.SqlProcs            = SqlProcs           ;
				this.SplendidError       = SplendidError      ;

				this.gID       = gID    ;
				this.byCONTENT = null   ;
			}
			
#pragma warning disable CS1998
			public async ValueTask Train(CancellationToken token)
			{
				Train();
			}
#pragma warning restore CS1998

			public void Train()
			{
				if ( m_bBusyTraining )
					return;
				try
				{
					m_bBusyTraining = true;
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						string sSQL ;
						sSQL = "select *                             " + ControlChars.CrLf
						     + "  from vwMACHINE_LEARNING_MODELS_Edit" + ControlChars.CrLf
						     + " where ID = @ID                      " + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@ID", gID);
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dtCurrent = new DataTable() )
								{
									da.Fill(dtCurrent);
									if ( dtCurrent.Rows.Count > 0 )
									{
										DataRow rdr = dtCurrent.Rows[0];
										sNAME                 = Sql.ToString (rdr["NAME"                ]);
										sSTATUS               = Sql.ToString (rdr["STATUS"              ]);
										sSCENARIO             = Sql.ToString (rdr["SCENARIO"            ]);
										sTRAIN_SQL_VIEW       = Sql.ToString (rdr["TRAIN_SQL_VIEW"      ]);
										sGOOD_FIELD_NAME      = Sql.ToString (rdr["GOOD_FIELD_NAME"     ]);
										bUSE_CROSS_VALIDATION = Sql.ToBoolean(rdr["USE_CROSS_VALIDATION"]);
									}
								}
							}
						}
						DateTime dtStart = DateTime.Now;
						bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.MachineLearning.VerboseStatus"]);
						// 07/27/2023 Paul.  This is not a Sync error. 
						if ( bVERBOSE_STATUS )
							SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "MachineLearning.Train:  Begin " + sNAME + " [" + gID.ToString() + "] at " + dtStart.ToString());
						
						using ( DataTable dtTrainingData = new DataTable() )
						{
							sSQL = "select *" + ControlChars.CrLf
							     + "  from " + sTRAIN_SQL_VIEW + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									da.Fill(dtTrainingData);
								}
							}
							try
							{
								BinaryClassificationModel model = new BinaryClassificationModel(dtTrainingData, sGOOD_FIELD_NAME);
								model.LoadData();
								model.Train(bUSE_CROSS_VALIDATION);
								using ( MemoryStream stm = new MemoryStream() )
								{
									model.Save(stm);
									stm.Seek(0, SeekOrigin.Begin);
									byte[] byContent = stm.ToArray();
									SqlProcs.spMACHINE_LEARNING_MODELS_Content(gID, dtTrainingData.Rows.Count, "Success", byContent);
								}
							}
							catch(Exception ex)
							{
								SqlProcs.spMACHINE_LEARNING_MODELS_Content(gID, dtTrainingData.Rows.Count, ex.Message, null);
							}
						}
						
						DateTime dtEnd = DateTime.Now;
						TimeSpan ts = dtEnd - dtStart;
						// 07/27/2023 Paul.  This is not a Sync error. 
						if ( bVERBOSE_STATUS )
							SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "MachineLearning.Train:  End "   + sNAME + " [" + gID.ToString() + "] at " + dtEnd.ToString() + ". Elapse time " + ts.Minutes.ToString() + " minutes " + ts.Seconds.ToString() + " seconds.");
					}
				}
				catch(Exception ex)
				{
					SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				}
				finally
				{
					m_bBusyTraining = false;
				}
			}
			
#pragma warning disable CS1998
			public async ValueTask Evaluate(CancellationToken token)
			{
				Evaluate();
			}
#pragma warning restore CS1998

			public void Evaluate()
			{
				if ( m_bBusyTraining )
					return;
				try
				{
					m_bBusyTraining = true;
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						string sSQL ;
						sSQL = "select *                             " + ControlChars.CrLf
						     + "  from vwMACHINE_LEARNING_MODELS_Edit" + ControlChars.CrLf
						     + " where ID = @ID                      " + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@ID", gID);
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								using ( DataTable dtCurrent = new DataTable() )
								{
									da.Fill(dtCurrent);
									if ( dtCurrent.Rows.Count > 0 )
									{
										DataRow rdr = dtCurrent.Rows[0];
										sNAME                 = Sql.ToString (rdr["NAME"                ]);
										sSTATUS               = Sql.ToString (rdr["STATUS"              ]);
										sSCENARIO             = Sql.ToString (rdr["SCENARIO"            ]);
										sEVALUATE_SQL_VIEW    = Sql.ToString (rdr["EVALUATE_SQL_VIEW"   ]);
										sGOOD_FIELD_NAME      = Sql.ToString (rdr["GOOD_FIELD_NAME"     ]);
										bUSE_CROSS_VALIDATION = Sql.ToBoolean(rdr["USE_CROSS_VALIDATION"]);
									}
								}
							}
						}
						sSQL = "select CONTENT                          " + ControlChars.CrLf
						     + "  from vwMACHINE_LEARNING_MODELS_Content" + ControlChars.CrLf
						     + " where ID = @ID                         " + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AddParameter(cmd, "@ID", gID);
							byCONTENT = Sql.ToByteArray(cmd.ExecuteScalar());
						}
						DateTime dtStart = DateTime.Now;
						bool bVERBOSE_STATUS = Sql.ToBoolean(Application["CONFIG.MachineLearning.VerboseStatus"]);
						// 07/27/2023 Paul.  This is not a Sync error. 
						if ( bVERBOSE_STATUS )
							SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "MachineLearning.Evaluate:  Begin " + sNAME + " [" + gID.ToString() + "] at " + dtStart.ToString());
						
						using ( DataTable dtEvaluationData = new DataTable() )
						{
							sSQL = "select *" + ControlChars.CrLf
							     + "  from " + sEVALUATE_SQL_VIEW + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									da.Fill(dtEvaluationData);
								}
							}
							try
							{
								BinaryClassificationModel model = new BinaryClassificationModel(dtEvaluationData, sGOOD_FIELD_NAME);
								using ( MemoryStream stm = new MemoryStream(byCONTENT) )
								{
									model.Load(stm);
									Microsoft.ML.Data.CalibratedBinaryClassificationMetrics metrics = model.Evaluate(dtEvaluationData);
									string sEVALUATION_DATA = JsonSerializer.Serialize(metrics);
									SqlProcs.spMACHINE_LEARNING_MODELS_Evaluation(gID, sEVALUATION_DATA, "Success");
								}
							}
							catch(Exception ex)
							{
								SqlProcs.spMACHINE_LEARNING_MODELS_Evaluation(gID, null, ex.Message);
							}
						}
						
						DateTime dtEnd = DateTime.Now;
						TimeSpan ts = dtEnd - dtStart;
						// 07/27/2023 Paul.  This is not a Sync error. 
						if ( bVERBOSE_STATUS )
							SplendidError.SystemMessage("Warning", new StackTrace(true).GetFrame(0), "MachineLearning.Evaluate:  End "   + sNAME + " [" + gID.ToString() + "] at " + dtEnd.ToString() + ". Elapse time " + ts.Minutes.ToString() + " minutes " + ts.Seconds.ToString() + " seconds.");
					}
				}
				catch(Exception ex)
				{
					SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				}
				finally
				{
					m_bBusyTraining = false;
				}
			}
		}

#pragma warning disable CS1998
		public async ValueTask RunAllModels(CancellationToken token)
		{
			RunAllModels();
		}
#pragma warning restore CS1998

		public void RunAllModels()
		{
			if ( !m_bInsidePredicting )
			{
				m_bInsidePredicting = true;
				try
				{
					SplendidError.SystemMessage("Information", new StackTrace(true).GetFrame(0), "MachineLearningUtils.RunAllModels Begin");
					DbProviderFactory dbf = DbProviderFactories.GetFactory();
					using ( IDbConnection con = dbf.CreateConnection() )
					{
						con.Open();
						string sSQL ;
						using ( DataTable dtModels = new DataTable() )
						{
							sSQL = "select *                                " + ControlChars.CrLf
							     + "  from vwMACHINE_LEARNING_MODELS_Content" + ControlChars.CrLf
							     + " where STATUS = N'Active'               " + ControlChars.CrLf
							     + "   and CONTENT is not null              " + ControlChars.CrLf
							     + " order by NAME                          " + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								using ( DbDataAdapter da = dbf.CreateDataAdapter() )
								{
									((IDbDataAdapter)da).SelectCommand = cmd;
									da.Fill(dtModels);
								}
							}
							foreach ( DataRow rowModel in dtModels.Rows )
							{
								int    nUpdatedRecords = 0;
								Guid   gMACHINE_LEARNING_MODEL_ID = Sql.ToGuid     (rowModel["ID"             ]);
								string sMODEL_NAME                = Sql.ToString   (rowModel["NAME"           ]);
								byte[] byCONTENT                  = Sql.ToByteArray(rowModel["CONTENT"        ]);
								string sBASE_MODULE               = Sql.ToString   (rowModel["BASE_MODULE"    ]);
								string sGOOD_FIELD_NAME           = Sql.ToString   (rowModel["GOOD_FIELD_NAME"]);
								string sBASE_TABLE                = Modules.TableName(sBASE_MODULE);
								string sBASE_VIEW                 = "vw" + sBASE_TABLE;
								string sPREDICTIONS_TABLE         = sBASE_TABLE + "_PREDICTIONS";
								string sMODULE_FIELD_NAME         = Crm.Modules.SingularTableName(sBASE_TABLE) + "_ID";
								IDbCommand cmdPREDICTIONS_Update = SqlProcs.Factory(con, "sp" + sBASE_TABLE + "_PREDICTIONS_Update");
								// 08/13/2021 Paul.  We could wrap all updates in a transaction, but the machine learning prediction may be slow, so we don't want to lock the table. 
								Sql.SetParameter(cmdPREDICTIONS_Update, "@MODIFIED_USER_ID", Security.USER_ID);
								using ( DataTable dtCurrent = new DataTable() )
								{
									sSQL = "select " + sBASE_VIEW + ".*" + ControlChars.CrLf
									     + "  from " + sBASE_VIEW        + ControlChars.CrLf
									     + "  left outer join " + sPREDICTIONS_TABLE + ControlChars.CrLf
									     + "               on " + sPREDICTIONS_TABLE + "." + sMODULE_FIELD_NAME + " = " + sBASE_VIEW + ".ID    " + ControlChars.CrLf
									     + "              and " + sPREDICTIONS_TABLE + ".DELETED        = 0                        " + ControlChars.CrLf
									     + " where " + sPREDICTIONS_TABLE + ".ID is null                                           " + ControlChars.CrLf
									     + "    or " + sPREDICTIONS_TABLE + ".DATE_MODIFIED < " + sBASE_VIEW + ".DATE_MODIFIED     " + ControlChars.CrLf
									     + "    or " + sPREDICTIONS_TABLE + ".DATE_MODIFIED < " + sBASE_VIEW + ".LAST_ACTIVITY_DATE" + ControlChars.CrLf;
									using ( IDbCommand cmd = con.CreateCommand() )
									{
										cmd.CommandText = sSQL;
										using ( DbDataAdapter da = dbf.CreateDataAdapter() )
										{
											((IDbDataAdapter)da).SelectCommand = cmd;
											da.Fill(dtCurrent);
										}
									}
									try
									{
										MachineLearning.BinaryClassificationModel model = new MachineLearning.BinaryClassificationModel(dtCurrent, sGOOD_FIELD_NAME);
										using ( MemoryStream stm = new MemoryStream(byCONTENT) )
										{
											model.Load(stm);
											foreach ( DataRow row in dtCurrent.Rows )
											{
												Guid gRECORD_ID = Sql.ToGuid(row["ID"]);
												MachineLearning.OutputModel results = model.Predict(row);
												//Debug.WriteLine(gRECORD_ID.ToString() + " Score: " + results.Score.ToString() + " Probability " + results.Probability.ToString() );
												Sql.SetParameter(cmdPREDICTIONS_Update, "@" + sMODULE_FIELD_NAME    , gRECORD_ID                );
												Sql.SetParameter(cmdPREDICTIONS_Update, "@MACHINE_LEARNING_MODEL_ID", gMACHINE_LEARNING_MODEL_ID);
												Sql.SetParameter(cmdPREDICTIONS_Update, "@PROBABILITY"              , results.Probability       );
												Sql.SetParameter(cmdPREDICTIONS_Update, "@SCORE"                    , results.Score             );
												Sql.SetParameter(cmdPREDICTIONS_Update, "@PREDICTED_LABEL"          , results.PredictedLabel    );
												cmdPREDICTIONS_Update.ExecuteNonQuery();
												nUpdatedRecords++;
											}
										}
									}
									catch(Exception ex)
									{
										SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
									}
								}
								SplendidError.SystemMessage("Information", new StackTrace(true).GetFrame(0), "MachineLearningUtils.RunAllModels: Updated " + nUpdatedRecords.ToString() + " in model " + sMODEL_NAME);
							}
						}
					}
				}
				catch(Exception ex)
				{
					SplendidError.SystemMessage("Error", new StackTrace(true).GetFrame(0), Utils.ExpandException(ex));
				}
				finally
				{
					SplendidError.SystemMessage("Information", new StackTrace(true).GetFrame(0), "MachineLearningUtils.RunAllModels End");
					m_bInsidePredicting = false;
				}
			}
		}

		public void Predict(Guid gID, string[] arrID)
		{
			if ( arrID != null && arrID.Length > 0 )
			{
				byte[] byCONTENT        = null;
				string sBASE_MODULE     = String.Empty;
				string sGOOD_FIELD_NAME = String.Empty;
				DbProviderFactory dbf = DbProviderFactories.GetFactory();
				using ( IDbConnection con = dbf.CreateConnection() )
				{
					con.Open();
					string sSQL ;
					sSQL = "select *                                " + ControlChars.CrLf
					     + "  from vwMACHINE_LEARNING_MODELS_Content" + ControlChars.CrLf
					     + " where ID = @ID                         " + ControlChars.CrLf;
					using ( IDbCommand cmd = con.CreateCommand() )
					{
						cmd.CommandText = sSQL;
						Sql.AddParameter(cmd, "@ID", gID);
						using ( DbDataAdapter da = dbf.CreateDataAdapter() )
						{
							((IDbDataAdapter)da).SelectCommand = cmd;
							using ( DataTable dtCurrent = new DataTable() )
							{
								da.Fill(dtCurrent);
								if ( dtCurrent.Rows.Count > 0 )
								{
									DataRow rdr = dtCurrent.Rows[0];
									byCONTENT        = Sql.ToByteArray(rdr["CONTENT"        ]);
									sBASE_MODULE     = Sql.ToString   (rdr["BASE_MODULE"    ]);
									sGOOD_FIELD_NAME = Sql.ToString   (rdr["GOOD_FIELD_NAME"]);
								}
							}
						}
					}
					
					string sBASE_TABLE = Modules.TableName(sBASE_MODULE);
					using ( DataTable dtCurrent = new DataTable() )
					{
						sSQL = "select *"                + ControlChars.CrLf
						     + "  from vw" + sBASE_TABLE + ControlChars.CrLf
						     + " where 1 = 1"            + ControlChars.CrLf;
						using ( IDbCommand cmd = con.CreateCommand() )
						{
							cmd.CommandText = sSQL;
							Sql.AppendParameter(cmd, arrID, "ID");
							using ( DbDataAdapter da = dbf.CreateDataAdapter() )
							{
								((IDbDataAdapter)da).SelectCommand = cmd;
								da.Fill(dtCurrent);
							}
						}
						string sMODULE_FIELD_NAME = Crm.Modules.SingularTableName(sBASE_TABLE) + "_ID";
						IDbCommand cmdPREDICTIONS_Update = SqlProcs.Factory(con, "sp" + sBASE_TABLE + "_PREDICTIONS_Update");
						// 08/12/2021 Paul.  We could wrap all updates in a transaction, but the machine learning prediction may be slow, so we don't want to lock the table. 
						Sql.SetParameter(cmdPREDICTIONS_Update, "@MODIFIED_USER_ID", Security.USER_ID);
						MachineLearning.BinaryClassificationModel model = new MachineLearning.BinaryClassificationModel(dtCurrent, sGOOD_FIELD_NAME);
						using ( MemoryStream stm = new MemoryStream(byCONTENT) )
						{
							model.Load(stm);
							foreach ( DataRow row in dtCurrent.Rows )
							{
								Guid gRECORD_ID = Sql.ToGuid(row["ID"]);
								MachineLearning.OutputModel results = model.Predict(row);
								//Debug.WriteLine(gRECORD_ID.ToString() + " Score: " + results.Score.ToString() + " Probability " + results.Probability.ToString() );
								Sql.SetParameter(cmdPREDICTIONS_Update, "@" + sMODULE_FIELD_NAME    , gRECORD_ID            );
								Sql.SetParameter(cmdPREDICTIONS_Update, "@MACHINE_LEARNING_MODEL_ID", gID                   );
								Sql.SetParameter(cmdPREDICTIONS_Update, "@PROBABILITY"              , results.Probability   );
								Sql.SetParameter(cmdPREDICTIONS_Update, "@SCORE"                    , results.Score         );
								Sql.SetParameter(cmdPREDICTIONS_Update, "@PREDICTED_LABEL"          , results.PredictedLabel);
								cmdPREDICTIONS_Update.ExecuteNonQuery();
							}
						}
					}
				}
			}
		}
	}

}

