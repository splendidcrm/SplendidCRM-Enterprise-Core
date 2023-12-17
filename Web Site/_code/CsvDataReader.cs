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
using System.Data.Common;
using System.Text;
//using MySql.Data.MySqlClient;

namespace SplendidCRM
{
	/// <summary>
	/// Summary description for CsvDataReader.
	/// </summary>
	public class CsvDataReader
	{
		private DataTable m_tbl;

		public DataTable Table
		{
			get { return m_tbl; }
		}

		public CsvDataReader(Stream stm) : this(stm, ',')
		{
		}

		public CsvDataReader(Stream stm, char chFieldSeparator)
		{
			m_tbl = new DataTable();
			using ( TextReader reader = new StreamReader(stm) )
			{
				m_tbl.Columns.Add("Column001");

				string sLine = null;
				while ( (sLine = reader.ReadLine()) != null )
				{
					if ( sLine.Length == 0 )
						continue;

					DataRow row = m_tbl.NewRow();
					m_tbl.Rows.Add(row);
					
					int i = 0;
					int nMode = 0;
					int nField = 0;
					bool bContinueParsing = true;
					while ( bContinueParsing )
					{
						switch ( nMode )
						{
							case 0:  // Search for next entry. 
							{
								if ( chFieldSeparator == ControlChars.Tab )
								{
									// Don't skip the tab when it is used as a separator. 
									// 01/28/2009 Paul.  Make sure not to read past the end of the line. 
									while ( i < sLine.Length && Char.IsWhiteSpace(sLine[i]) && sLine[i] != ControlChars.Tab )
										i++;
								}
								else
								{
									// 01/28/2009 Paul.  Make sure not to read past the end of the line. 
									while ( i < sLine.Length && Char.IsWhiteSpace(sLine[i]) )
										i++;
								}
								nMode = 1;
								break;
							}
							case 1:  // Determine if field is quoted or unquoted. 
							{
								// first check if field is empty. 
								char chPunctuation = sLine[i];
								if ( chPunctuation == chFieldSeparator )
								{
									i++;
									nField++;
									if ( nField >= m_tbl.Columns.Count )
										m_tbl.Columns.Add("Column" + nField.ToString("000"));
									nMode = 0;
								}
								// 07/21/2010 Paul.  Bug fix, this should be an else-if so that a bunch of empty fields don't confuse the parser. 
								else if ( chPunctuation == '\"' )
								{
									i++;
									// Field is quoted, so start reading until next quote. 
									nMode = 3;
								}
								else
								{
									// Field is unquoted, so start reading until next separator or end-of-line.
									nMode = 2;
								}
								break;
							}
							case 2:  // Extract unquoted field. 
							{
								nField++;
								if ( nField > m_tbl.Columns.Count )
									m_tbl.Columns.Add("Column" + nField.ToString("000"));
								
								int nFieldStart = i;
								// Field is unquoted, so start reading until next separator or end-of-line.
								while ( i < sLine.Length && sLine[i] != chFieldSeparator )
									i++;
								int nFieldEnd = i;
								
								string sField = sLine.Substring(nFieldStart, nFieldEnd-nFieldStart);
								row[nField-1] = sField;
								nMode = 0;
								i++;
								break;
							}
							case 3:  // Extract quoted field. 
							{
								nField++;
								if ( nField > m_tbl.Columns.Count )
									m_tbl.Columns.Add("Column" + nField.ToString("000"));
								
								bool bMultiline = false;
								StringBuilder sbField = new StringBuilder();
								do
								{
									int nFieldStart = i;
									// Field is quoted, so start reading until next quote.  Watch out for an escaped quote (two double quotes). 
									while ( ( i < sLine.Length && sLine[i] != '\"' ) || ( i + 1 < sLine.Length && sLine[i] == '\"' && sLine[i + 1] == '\"' ) )
									{
										if ( i + 1 < sLine.Length && sLine[i] == '\"' && sLine[i + 1] == '\"' )
											i++;
										i++;
									}
									int nFieldEnd = i;
									if ( sbField.Length > 0 )
										sbField.AppendLine();
									sbField.Append(sLine.Substring(nFieldStart, nFieldEnd - nFieldStart));
									
									// 08/23/2006 Paul.  If we are at the end of the line, then it must be a multi-line string. 
									bMultiline = (i == sLine.Length);
									if ( bMultiline )
									{
										sLine = reader.ReadLine();
										i = 0;
										if ( sLine == null )
											break;
									}
								}
								while ( bMultiline );

								if ( sLine != null )
								{
									// Skip all characters until we reach the separator or end-of-line. 
									while ( i < sLine.Length && sLine[i] != chFieldSeparator )
										i++;
								}
								
								string sField = sbField.ToString();
								sField = sField.Replace("\"\"", "\"");
								row[nField-1] = sField;
								nMode = 0;
								i++;
								break;
							}
							default:
								bContinueParsing = false;
								break;
						}
						if ( i >= sLine.Length )
							break;
					}
				}
			}
		}
	}
}

