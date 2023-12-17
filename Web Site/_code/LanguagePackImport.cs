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
using System.Text;
using System.Diagnostics;
using ICSharpCode.SharpZipLib.Zip;

namespace SplendidCRM
{
	/// <summary>
	/// Summary description for LanguagePackImport.
	/// </summary>
	public class LanguagePackImport
	{
		/*
		$mod_strings = array (
		//DON'T CONVERT THESE THEY ARE MAPPINGS
		  array (
		 ),

		);

		$mod_list_strings = Array(
		);

		$app_list_strings = array (
		$app_strings = array (
		*/

		private HttpSessionState     Session            ;
		private Security             Security           ;
		private Sql                  Sql                ;
		private SqlProcs             SqlProcs           ;
		private SplendidError        SplendidError      ;

		public LanguagePackImport(HttpSessionState Session, Security Security, Sql Sql, SqlProcs SqlProcs, SplendidError SplendidError)
		{
			this.Session             = Session            ;
			this.Security            = Security           ;
			this.Sql                 = Sql                ;
			this.SqlProcs            = SqlProcs           ;
			this.SplendidError       = SplendidError      ;
		}

		public string GetModuleName(string sPathName)
		{
			string[] arrFolders = Path.GetDirectoryName(sPathName).Split('\\');
			string strModuleName = String.Empty;
			if ( arrFolders.Length >= 2 )
			{
				if ( String.Compare(arrFolders[arrFolders.Length-1], "language", true) == 0 )
				{
					strModuleName = arrFolders[arrFolders.Length-2];
					if ( String.Compare(strModuleName, "include", true) == 0 )
						strModuleName = null;
				}
			}
			return strModuleName;
		}

		public string GetLanguage(string sPathName)
		{
			// 11/13/2006 Paul.  There is a file the the SugarCRM German language pack that has 4 parts.  
			string[] arrParts = Path.GetFileName(sPathName).Split('.');
			string sLang = arrParts[arrParts.Length-3];
			sLang = sLang.Replace("_", "-");
			if ( sLang.IndexOf("-") >= 0 )
			{
				string[] arrLang = sLang.Split('-');
				sLang = arrLang[0] + '-' + arrLang[1].ToUpper();
			}
			return sLang;
		}

		public Encoding GetEncoding(string sLang)
		{
			// 10/09/2005 Paul.  I expected UTF-8 to always work, but it does not.  Only use UTF-8 for known languages. 
			// 04/30/2023 Paul.  UTF7 is obsolete, so says microsoft. 
			System.Text.Encoding enc = Encoding.UTF8;
			return enc;
		}

		public void InsertTerms(string sPathName, bool bForceUTF8)
		{
			string sModuleName = GetModuleName(sPathName);
			string sLang       = GetLanguage  (sPathName);
			System.Text.Encoding enc = GetEncoding(sLang);
			if ( bForceUTF8 )
				enc = Encoding.UTF8;
			using ( StreamReader sr = new StreamReader(sPathName, enc, true) )
			{
				string sData = sr.ReadToEnd();
				int nListStart = sData.IndexOf("$app_strings");
				if ( nListStart >= 0 )
					ParseList(sModuleName, sLang, "$app_strings", sData, nListStart);
				nListStart = sData.IndexOf("$app_list_strings");
				if ( nListStart >= 0 )
					ParseList(sModuleName, sLang, "$app_list_strings", sData, nListStart);
				nListStart = sData.IndexOf("$mod_strings");
				if ( nListStart >= 0 )
					ParseList(sModuleName, sLang, "$mod_strings", sData, nListStart);
				nListStart = sData.IndexOf("$mod_list_strings");
				if ( nListStart >= 0 )
					ParseList(sModuleName, sLang, "$mod_list_strings", sData, nListStart);
			}
		}

		public void InsertHelp(string sPathName, bool bForceUTF8)
		{
			try
			{
				const string sDocType = "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">";
				string sModuleName  = GetModuleName(sPathName);
				string sLang        = GetLanguage  (sPathName);
				string strEntryName = Path.GetFileName(sPathName).Split('.')[2];
				System.Text.Encoding enc = GetEncoding(sLang);
				if ( bForceUTF8 )
					enc = Encoding.UTF8;
				using ( StreamReader sr = new StreamReader(sPathName, enc, true) )
				{
					string sData = sr.ReadToEnd();
					int nDocType = sData.IndexOf(sDocType);
					if ( nDocType >= 0 )
					{
						nDocType += sDocType.Length;
					}
					else
					{
						nDocType = sData.IndexOf("-->");
						if ( nDocType >= 0 )
							nDocType += 3;
					}
					while ( sData[nDocType] == ControlChars.Cr || sData[nDocType] == ControlChars.Lf )
						nDocType++;
					sData = sData.Substring(nDocType);
					Guid gID = Guid.Empty;
					SqlProcs.spTERMINOLOGY_HELP_Update(ref gID, strEntryName, sLang, sModuleName, sData);
				}
			}
			catch
			{
			}
		}

		public void InsertTerms(string sPathName, ZipInputStream stmZip, bool bForceUTF8)
		{
			string sModuleName = GetModuleName(sPathName);
			string sLang       = GetLanguage  (sPathName);
			System.Text.Encoding enc = GetEncoding(sLang);
			if ( bForceUTF8 )
				enc = Encoding.UTF8;
			// 01/12/2006 Paul.  Don't use using as it is clsing the zip stream. 
			StreamReader sr = new StreamReader(stmZip, enc, true);
			{
				string sData = String.Empty;
				try
				{
					// 01/12/2006 Paul.  Problem importing it_it_3.5.1.langpack.zip, modules/OptimisticLock/language/it_it.lang.php
					// Specified argument was out of the range of valid values. Parameter name: length 
					// Catch the error and allow processing of the rest of the files. 
					sData = sr.ReadToEnd();
				}
				catch(Exception ex)
				{
					SplendidError.SystemError(new StackTrace(true).GetFrame(0), sPathName + "; " + ex.Message);
					return;
				}
				int nListStart = sData.IndexOf("$app_strings");
				if ( nListStart >= 0 )
					ParseList(sModuleName, sLang, "$app_strings", sData, nListStart);
				nListStart = sData.IndexOf("$app_list_strings");
				if ( nListStart >= 0 )
					ParseList(sModuleName, sLang, "$app_list_strings", sData, nListStart);
				nListStart = sData.IndexOf("$mod_strings");
				if ( nListStart >= 0 )
					ParseList(sModuleName, sLang, "$mod_strings", sData, nListStart);
				nListStart = sData.IndexOf("$mod_list_strings");
				if ( nListStart >= 0 )
					ParseList(sModuleName, sLang, "$mod_list_strings", sData, nListStart);
			}
		}

		public void ParseList(string sModuleName, string sLang, string strListGroup, string sData, int nListStart)
		{
			nListStart = sData.IndexOf("(", nListStart);
			if ( nListStart >= 0 )
			{
				nListStart++;
				int nMode = 0;  // 
				int nListOrder = 0 ;
				string strTemp = String.Empty;
				string strListName    = String.Empty;
				string strEntryName   = String.Empty;
				string strDisplayName = String.Empty;
				bool bInsideArray = false;
				bool bContinueParsing = true;
				while ( bContinueParsing )
				{
					switch ( nMode )
					{
						case 0:  // Search for next entry. 
							while ( Char.IsWhiteSpace(sData, nListStart) || sData[nListStart] == ',' )
							{
								nListStart++;
								if ( nListStart >= sData.Length )
								{
									bContinueParsing = false;
									break;
								}
							}
							if ( bInsideArray && sData[nListStart] == ')' )
							{
								nListStart++;
								bInsideArray = false;  // turn off array processing. 
								strListName = String.Empty;
								nListOrder = 0;
								nMode = 0;
							}
							else
							{
								nMode = 1;
							}
							break;
						case 1:  // Extract entry name. 
						{
							if ( nListStart >= sData.Length || (sData[nListStart] == ')' && sData[nListStart+1] == ';') )
							{
								bContinueParsing = false;
								break;
							}
							char chPunctuation = sData[nListStart];
							if ( chPunctuation != '\'' && chPunctuation != '\"' )
							{
								strTemp = sData.Substring(nListStart, Math.Min(100, sData.Length-nListStart));
								if ( sData[nListStart] == '/' && sData[nListStart+1] == '/' )
								{
									// Ignore comment. 
									// 05/19/2006 Paul.  lang-pt_br12-351b.zip ends the line with '\n'
									while ( nListStart < sData.Length && sData[nListStart] != '\r' && sData[nListStart] != '\n' )
										nListStart++;
								}
								// If character is not expected, then exit. 
								nListStart++;
								nMode = 0;
								break;
							}
							nListStart++;
							int nValueStart = nListStart;
							while ( chPunctuation != sData[nListStart] && nListStart < sData.Length )
								nListStart++;
							int nValueEnd = nListStart;
							nListStart++;
							if ( nValueEnd - nValueStart == 0 )
								nMode = 0 ;
							else
							{
								strEntryName = sData.Substring(nValueStart, nValueEnd - nValueStart);
								nMode = 2;
							}
							break;
						}
						case 2: // Search for display name or inner list
						{
							while ( Char.IsWhiteSpace(sData, nListStart) )
							{
								nListStart++;
								// 10/09/2005 Paul.  Just in case the file has been truncated, 
								// exit if there are not enough characters for a fully formed display name.
								if ( nListStart+4 >= sData.Length )
								{
									bContinueParsing = false;
									break;
								}
							}
							if ( sData[nListStart] == '=' && sData[nListStart+1] == '>' )
							{
								nListStart++;
								nListStart++;
								while ( Char.IsWhiteSpace(sData, nListStart) )
									nListStart++;
								char chPunctuation = sData[nListStart];
								if ( chPunctuation != '\'' && chPunctuation != '\"' )
								{
									string strArray = sData.Substring(nListStart, Math.Min(5, sData.Length-nListStart));
									if ( strArray == "array" )
									{
										nListStart += 5;
										while ( Char.IsWhiteSpace(sData, nListStart) || sData[nListStart] == '(' )
											nListStart++;
										bInsideArray = true;
										strListName = strEntryName;
										nListOrder = 0 ;
										nMode = 0;
										break;
									}
									else
									{
										strTemp = sData.Substring(nListStart, Math.Min(100, sData.Length-nListStart));
										// If character is not expected, then exit. 
										nListStart++;
										nMode = 0;
									}
									break;
								}
								nListStart++;
								int nValueStart = nListStart;
								// 10/09/2005 Paul.  Watch out for 'LBL_CURRENCY_SYMBOL' => '\\', where the punctuation end has a slash before it. 
								//  'NTC_LOGIN_MESSAGE' => 'Prego fai login all\\\'applicazione.',
								// 10/09/2005 Paul.  Use the bLastCharExcaped flag as a simple way to keep track of escaped characters 
								// to prevent early termination or allow proper termination of the string. 
								bool bLastCharExcaped = false;
								while ( nListStart < sData.Length && (chPunctuation != sData[nListStart] || (chPunctuation == sData[nListStart] && sData[nListStart-1] == '\\' && !bLastCharExcaped)) )
								{
									// If last character was escaped, then don't escape this one. 
									if ( !bLastCharExcaped && sData[nListStart-1] == '\\' )
										bLastCharExcaped = true;
									else
										bLastCharExcaped = false;
									nListStart++;
								}
								int nValueEnd = nListStart;
								nListStart++;
								if ( nValueEnd - nValueStart == 0 )
									nMode = 0 ;
								else
								{
									strDisplayName = sData.Substring(nValueStart, nValueEnd - nValueStart);
									// 10/09/2005 Paul.  Need to remove escape characters. 
									if ( strDisplayName.IndexOf('\\', 0) >= 0 )
									{
										// 10/09/2005 Paul. We must escape twice because we have escapes within escapes. \\\' should become '.  
										// First, escape the punctuation delimiter. 
										strDisplayName = strDisplayName.Replace("\\" + chPunctuation.ToString(), chPunctuation.ToString());
										// Second, escape the escape character. 
										strDisplayName = strDisplayName.Replace("\\\\", "\\");
										// Now escape all other known escape values. 
										strDisplayName = strDisplayName.Replace("\\\'", "'");
										strDisplayName = strDisplayName.Replace("\\\"", "\"");
										strDisplayName = strDisplayName.Replace("\\n", ControlChars.CrLf);
									}
									if ( strListName.Length > 0 )
									{
										nListOrder++;
									}
									SqlProcs.spTERMINOLOGY_Update(strEntryName, sLang, sModuleName, strListName, nListOrder, strDisplayName);
									nMode = 0;
								}
							}
							else
							{
								strTemp = sData.Substring(nListStart, Math.Min(100, sData.Length-nListStart));
								// If character is not expected, then exit. 
								nListStart++;
								nMode = 0;
								break;
							}
							break;
						}
						default:
							bContinueParsing = false;
							break;
					}
					if ( nListStart >= sData.Length )
						break;
				}
			}
		}

	}
}

