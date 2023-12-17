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
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.Diagnostics;

using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;

namespace SplendidCRM.Pages.Images
{
	[Authorize]
	[SplendidSessionAuthorize]
	public class ImageModel : PageModel
	{
		private SplendidCRM.DbProviderFactories  DbProviderFactories = new SplendidCRM.DbProviderFactories();
		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SplendidError        SplendidError      ;

		public ImageModel(HttpSessionState Session, Security Security, Sql Sql, SplendidError SplendidError)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SplendidError       = SplendidError      ;
		}

		// 02/14/2010 Paul.  Render the error as an image so that the message can appear in an img tag. 
		public static byte[] RenderAsImage(int nWidth, int nHeight, string sText, ImageFormat format)
		{
			byte[] byImage = null;
			using ( MemoryStream ms = new MemoryStream() )
			{
				using ( Bitmap bmp = new Bitmap(nWidth, nHeight) )
				{
					using ( Graphics g = Graphics.FromImage(bmp) )
					{
						using ( Brush brBlack = new SolidBrush(Color.Black) )
						{
							using ( Pen penBlack = new Pen(brBlack) )
							{
								Rectangle rect = new Rectangle(0, 0, nWidth, nHeight);
								g.FillRectangle(Brushes.White, rect);
								//g.DrawRectangle(penBlack, rect);
								using ( Font fntArial = new Font("Arial", 12) )
								{
									//SizeF size = g.MeasureString(sText, fntArial, new SizeF(nWidth, nHeight));
									g.DrawString(sText, fntArial, brBlack, rect);
								}
							}
						}
					}
					bmp.Save(ms, format);
				}
				byImage = ms.GetBuffer();
			}
			return byImage;
		}

		// 10/20/2009 Paul.  Move blob logic to WriteStream. 
		public static void WriteStream(Guid gID, IDbConnection con, BinaryWriter writer)
		{
			// 09/06/2008 Paul.  PostgreSQL does not require that we stream the bytes, so lets explore doing this for all platforms. 
			if ( Sql.StreamBlobs(con) )
			{
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					cmd.CommandText = "spIMAGE_ReadOffset";
					cmd.CommandType = CommandType.StoredProcedure;
					
					const int BUFFER_LENGTH = 4*1024;
					int idx  = 0;
					int size = 0;
					byte[] binData = new byte[BUFFER_LENGTH];  // 10/20/2005 Paul.  This allocation is only used to set the parameter size. 
					IDbDataParameter parID          = Sql.AddParameter(cmd, "@ID"         , gID    );
					IDbDataParameter parFILE_OFFSET = Sql.AddParameter(cmd, "@FILE_OFFSET", idx    );
					// 01/21/2006 Paul.  Field was renamed to READ_SIZE. 
					IDbDataParameter parREAD_SIZE   = Sql.AddParameter(cmd, "@READ_SIZE"  , size   );
					IDbDataParameter parBYTES       = Sql.AddParameter(cmd, "@BYTES"      , binData);
					parBYTES.Direction = ParameterDirection.InputOutput;
					do
					{
						parID         .Value = gID          ;
						parFILE_OFFSET.Value = idx          ;
						parREAD_SIZE  .Value = BUFFER_LENGTH;
						size = 0;
						// 08/14/2005 Paul.  Oracle returns the bytes in a field.
						// SQL Server can only return the bytes in a resultset. 
						// 10/20/2005 Paul.  MySQL works returning bytes in an output parameter. 
						// 02/05/2006 Paul.  DB2 returns bytse in a field. 
						if ( Sql.IsOracle(cmd) || Sql.IsDB2(cmd) ) // || Sql.IsMySQL(cmd) )
						{
							cmd.ExecuteNonQuery();
							binData = Sql.ToByteArray(parBYTES);
							if ( binData != null )
							{
								size = binData.Length;
								writer.Write(binData);
								idx += size;
							}
						}
						else
						{
							using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
							{
								if ( rdr.Read() )
								{
									// 10/20/2005 Paul.  MySQL works returning a record set, but it cannot be cast to a byte array. 
									// binData = (byte[]) rdr[0];
									binData = Sql.ToByteArray((System.Array) rdr[0]);
									if ( binData != null )
									{
										size = binData.Length;
										writer.Write(binData);
										idx += size;
									}
								}
							}
						}
					}
					while ( size == BUFFER_LENGTH );
				}
			}
			else
			{
				using ( IDbCommand cmd = con.CreateCommand() )
				{
					string sSQL;
					sSQL = "select CONTENT         " + ControlChars.CrLf
					     + "  from vwIMAGES_CONTENT" + ControlChars.CrLf
					     + " where ID = @ID        " + ControlChars.CrLf;
					Sql.AddParameter(cmd, "@ID", gID);
					cmd.CommandText = sSQL;
					//object oBlob = cmd.ExecuteScalar();
					//byte[] binData = Sql.ToByteArray(oBlob);
					//writer.Write(binData);
					using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
					{
						if ( rdr.Read() )
						{
							// 10/20/2009 Paul.  Try to be more efficient by using a reader. 
							Sql.WriteStream(rdr, 0, writer);
						}
					}
				}
			}
		}

		public IActionResult OnGetAsync()
		{
			string sMessage = "Image not found.";
			byte[] byImage = null;
			try
			{
				Guid gID = Sql.ToGuid(Request.Query["ID"]);
				//if ( !IsPostBack )
				{
					if ( !Sql.IsEmptyGuid(gID) )
					{
						DbProviderFactory dbf = DbProviderFactories.GetFactory();
						using ( IDbConnection con = dbf.CreateConnection() )
						{
							con.Open();
							string sSQL ;
							sSQL = "select *       " + ControlChars.CrLf
							     + "  from vwIMAGES" + ControlChars.CrLf
							     + " where ID = @ID" + ControlChars.CrLf;
							using ( IDbCommand cmd = con.CreateCommand() )
							{
								cmd.CommandText = sSQL;
								Sql.AddParameter(cmd, "@ID", gID);
								using ( IDataReader rdr = cmd.ExecuteReader(CommandBehavior.SingleRow) )
								{
									if ( rdr.Read() )
									{
										Response.ContentType = Sql.ToString(rdr["FILE_MIME_TYPE"]);
										// 01/27/2011 Paul.  Don't use GetFileName as the name may contain reserved directory characters, but expect them to be removed in Utils.ContentDispositionEncode. 
										string sFileName = Sql.ToString(rdr["FILENAME"]);
										// 08/06/2008 yxy21969.  Make sure to encode all URLs.
										// 12/20/2009 Paul.  Use our own encoding so that a space does not get converted to a +. 
										Response.Headers.Add("Content-Disposition", "attachment;filename=" + Utils.ContentDispositionEncode(sFileName));
									}
									else
									{
										// 04/30/2010 Paul.  Image not found is correct, unless we are an Offline Client. 
										if ( !Sql.IsEmptyString(Sql.ToString(Session["SystemSync.Server"])) )
											sMessage = "Must be online to retrieve image.";
										byImage = ImageModel.RenderAsImage(300, 100, "Error: " + sMessage, ImageFormat.Gif);
										Response.ContentType = "image/gif";
										return File(byImage, Response.ContentType);
									}
								}
							}
							using ( MemoryStream mem = new MemoryStream() )
							{
								using ( BinaryWriter writer = new BinaryWriter(mem) )
								{
									WriteStream(gID, con, writer);
									mem.Position = 0;
									byte[] b = mem.ToArray();
									return File(b, Response.ContentType);
								}
							}
						}
					}
					else
					{
						sMessage = "Error: ID not specified.";
					}
				}
			}
			catch(Exception ex)
			{
				SplendidError.SystemError(new StackTrace(true).GetFrame(0), ex);
				//Response.Write(ex.Message);
				if ( ex.GetType() != Type.GetType("System.Threading.ThreadAbortException") )
				{
					sMessage = ex.Message;
				}
			}
			byImage = ImageModel.RenderAsImage(300, 100, "Error: " + sMessage, ImageFormat.Gif);
			Response.ContentType = "image/gif";
			return File(byImage, Response.ContentType);
		}
	}
}
