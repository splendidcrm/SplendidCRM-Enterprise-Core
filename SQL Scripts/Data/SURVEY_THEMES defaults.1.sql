

print 'SURVEY_THEMES defaults';
GO

set nocount on;
GO

-- delete from SURVEY_THEMES;
exec dbo.spSURVEY_THEMES_InsertOnly '795E60EE-CF84-4CD2-926B-E26D22D6C9DB'
	, N'Blue'
	, N'Arial, Helvetica, sans-serif'  -- SURVEY_FONT_FAMILY            
	, N'#FFD14E'                       -- LOGO_BACKGROUND               
	, N'#ffffff'                       -- SURVEY_BACKGROUND             
	, N'#ffffff'                       -- SURVEY_TITLE_TEXT_COLOR       
	, N'20px'                          -- SURVEY_TITLE_FONT_SIZE        
	, N'normal'                        -- SURVEY_TITLE_FONT_STYLE       
	, N'bold'                          -- SURVEY_TITLE_FONT_WEIGHT      
	, N'none'                          -- SURVEY_TITLE_DECORATION       
	, N'#1f4570'                       -- SURVEY_TITLE_BACKGROUND       
	, N'#000000'                       -- PAGE_TITLE_TEXT_COLOR         
	, N'20px'                          -- PAGE_TITLE_FONT_SIZE          
	, N'normal'                        -- PAGE_TITLE_FONT_STYLE         
	, N'normal'                        -- PAGE_TITLE_FONT_WEIGHT        
	, N'none'                          -- PAGE_TITLE_DECORATION         
	, N'#b9ceed'                       -- PAGE_TITLE_BACKGROUND         
	, N'#000000'                       -- PAGE_DESCRIPTION_TEXT_COLOR  
	, N'16px'                          -- PAGE_DESCRIPTION_FONT_SIZE   
	, N'normal'                        -- PAGE_DESCRIPTION_FONT_STYLE  
	, N'normal'                        -- PAGE_DESCRIPTION_FONT_WEIGHT 
	, N'#b9ceed'                       -- PAGE_DESCRIPTION_DECORATION  
	, N'#ffffff'                       -- PAGE_DESCRIPTION_BACKGROUND
	, N'#000000'                       -- QUESTION_HEADING_TEXT_COLOR   
	, N'16px'                          -- QUESTION_HEADING_FONT_SIZE    
	, N'normal'                        -- QUESTION_HEADING_FONT_STYLE   
	, N'bold'                          -- QUESTION_HEADING_FONT_WEIGHT  
	, N'none'                          -- QUESTION_HEADING_DECORATION   
	, N'#ffffff'                       -- QUESTION_HEADING_BACKGROUND   
	, N'#000000'                       -- QUESTION_CHOICE_TEXT_COLOR    
	, N'12px'                          -- QUESTION_CHOICE_FONT_SIZE     
	, N'normal'                        -- QUESTION_CHOICE_FONT_STYLE    
	, N'normal'                        -- QUESTION_CHOICE_FONT_WEIGHT   
	, N'none'                          -- QUESTION_CHOICE_DECORATION    
	, N'#ffffff'                       -- QUESTION_CHOICE_BACKGROUND    
	, N'60%'                           -- PROGRESS_BAR_PAGE_WIDTH       
	, N'#000000'                       -- PROGRESS_BAR_COLOR            
	, N'#cccccc'                       -- PROGRESS_BAR_BORDER_COLOR     
	, N'1px'                           -- PROGRESS_BAR_BORDER_WIDTH     
	, N'#ffffff'                       -- PROGRESS_BAR_TEXT_COLOR       
	, N'12px'                          -- PROGRESS_BAR_FONT_SIZE        
	, N'normal'                        -- PROGRESS_BAR_FONT_STYLE       
	, N'normal'                        -- PROGRESS_BAR_FONT_WEIGHT      
	, N'none'                          -- PROGRESS_BAR_DECORATION       
	, N'#ffffff'                       -- PROGRESS_BAR_BACKGROUND       
	, N'#e00000'                       -- ERROR_TEXT_COLOR              
	, N'11px'                          -- ERROR_FONT_SIZE               
	, N'normal'                        -- ERROR_FONT_STYLE              
	, N'bold'                          -- ERROR_FONT_WEIGHT             
	, N'none'                          -- ERROR_DECORATION              
	, N'inherit'                       -- ERROR_BACKGROUND              
	, N'#000000'                       -- EXIT_LINK_TEXT_COLOR          
	, N'11px'                          -- EXIT_LINK_FONT_SIZE           
	, N'normal'                        -- EXIT_LINK_FONT_STYLE          
	, N'normal'                        -- EXIT_LINK_FONT_WEIGHT         
	, N'none'                          -- EXIT_LINK_DECORATION          
	, N'#dddddd'                       -- EXIT_LINK_BACKGROUND          
	, N'#000000'                       -- REQUIRED_TEXT_COLOR           
	, null                             -- DESCRIPTION                   
	;

exec dbo.spSURVEY_THEMES_InsertOnly 'C10F3FFA-73E4-4B75-9AB1-C00F157A1C43'
	, N'Black'
	, N'Arial, Helvetica, sans-serif'  -- SURVEY_FONT_FAMILY            
	, N'#FFD14E'                       -- LOGO_BACKGROUND               
	, N'#ffffff'                       -- SURVEY_BACKGROUND             
	, N'#ffffff'                       -- SURVEY_TITLE_TEXT_COLOR       
	, N'20px'                          -- SURVEY_TITLE_FONT_SIZE        
	, N'normal'                        -- SURVEY_TITLE_FONT_STYLE       
	, N'bold'                          -- SURVEY_TITLE_FONT_WEIGHT      
	, N'none'                          -- SURVEY_TITLE_DECORATION       
	, N'#000000'                       -- SURVEY_TITLE_BACKGROUND       
	, N'#000000'                       -- PAGE_TITLE_TEXT_COLOR         
	, N'20px'                          -- PAGE_TITLE_FONT_SIZE          
	, N'normal'                        -- PAGE_TITLE_FONT_STYLE         
	, N'normal'                        -- PAGE_TITLE_FONT_WEIGHT        
	, N'none'                          -- PAGE_TITLE_DECORATION         
	, N'#dddddd'                       -- PAGE_TITLE_BACKGROUND         
	, N'#000000'                       -- PAGE_DESCRIPTION_TEXT_COLOR  
	, N'16px'                          -- PAGE_DESCRIPTION_FONT_SIZE   
	, N'normal'                        -- PAGE_DESCRIPTION_FONT_STYLE  
	, N'normal'                        -- PAGE_DESCRIPTION_FONT_WEIGHT 
	, N'#b9ceed'                       -- PAGE_DESCRIPTION_DECORATION  
	, N'#ffffff'                       -- PAGE_DESCRIPTION_BACKGROUND
	, N'#000000'                       -- QUESTION_HEADING_TEXT_COLOR   
	, N'16px'                          -- QUESTION_HEADING_FONT_SIZE    
	, N'normal'                        -- QUESTION_HEADING_FONT_STYLE   
	, N'bold'                          -- QUESTION_HEADING_FONT_WEIGHT  
	, N'none'                          -- QUESTION_HEADING_DECORATION   
	, N'#ffffff'                       -- QUESTION_HEADING_BACKGROUND   
	, N'#000000'                       -- QUESTION_CHOICE_TEXT_COLOR    
	, N'12px'                          -- QUESTION_CHOICE_FONT_SIZE     
	, N'normal'                        -- QUESTION_CHOICE_FONT_STYLE    
	, N'normal'                        -- QUESTION_CHOICE_FONT_WEIGHT   
	, N'none'                          -- QUESTION_CHOICE_DECORATION    
	, N'#ffffff'                       -- QUESTION_CHOICE_BACKGROUND    
	, N'60%'                           -- PROGRESS_BAR_PAGE_WIDTH       
	, N'#000000'                       -- PROGRESS_BAR_COLOR            
	, N'#cccccc'                       -- PROGRESS_BAR_BORDER_COLOR     
	, N'1px'                           -- PROGRESS_BAR_BORDER_WIDTH     
	, N'#ffffff'                       -- PROGRESS_BAR_TEXT_COLOR       
	, N'12px'                          -- PROGRESS_BAR_FONT_SIZE        
	, N'normal'                        -- PROGRESS_BAR_FONT_STYLE       
	, N'normal'                        -- PROGRESS_BAR_FONT_WEIGHT      
	, N'none'                          -- PROGRESS_BAR_DECORATION       
	, N'#ffffff'                       -- PROGRESS_BAR_BACKGROUND       
	, N'#e00000'                       -- ERROR_TEXT_COLOR              
	, N'11px'                          -- ERROR_FONT_SIZE               
	, N'normal'                        -- ERROR_FONT_STYLE              
	, N'bold'                          -- ERROR_FONT_WEIGHT             
	, N'none'                          -- ERROR_DECORATION              
	, N'inherit'                       -- ERROR_BACKGROUND              
	, N'#000000'                       -- EXIT_LINK_TEXT_COLOR          
	, N'11px'                          -- EXIT_LINK_FONT_SIZE           
	, N'normal'                        -- EXIT_LINK_FONT_STYLE          
	, N'normal'                        -- EXIT_LINK_FONT_WEIGHT         
	, N'none'                          -- EXIT_LINK_DECORATION          
	, N'#dddddd'                       -- EXIT_LINK_BACKGROUND          
	, N'#000000'                       -- REQUIRED_TEXT_COLOR           
	, null                             -- DESCRIPTION                   
	;
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

call dbo.spSURVEY_THEMES_Defaults()
/

call dbo.spSqlDropProcedure('spSURVEY_THEMES_Defaults')
/

-- #endif IBM_DB2 */

