CREATE TABLE table_india 
  ( 
     customer_name       VARCHAR(255), 
     customer_id         VARCHAR(18), 
     open_date           DATE, 
     last_consulted_date DATE, 
     vaccination_id      VARCHAR(100), 
     dr_name             VARCHAR(255), 
     state               VARCHAR(255), 
     dob                 DATE, 
     is_active           CHAR(10) 
  ) 

CREATE TABLE cntrytbl 
  ( 
     id      INT IDENTITY, 
     country VARCHAR(100) 
  ) 

INSERT INTO cntrytbl 
SELECT DISTINCT country FROM staging_tbl 

SET ANSI_NULLS ON 

GO 

SET QUOTED_IDENTIFIER ON 

GO 

/****** 
Author: -----------
Date written: ------------
Purpose: ---------------
Version: --------------

 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[Hospitalproc] 
AS 
-- EXEC [dbo].[Hospitalproc] 
  BEGIN 
      DECLARE @i       INT=1, 
              @ttlrw   INT, 
              @Country VARCHAR(100), 
              @var     VARCHAR(max) 
	
	-- Get total number of rows
      SELECT @ttlrw = Count(country) FROM   cntrytbl 
	
	-- start the data insertion
      WHILE( @i <= @ttlrw ) 
        BEGIN 
            SELECT @Country = country FROM   cntrytbl WHERE  id = @i 

            SET @var= 'if not exists(select * from sys.tables where name=''table_' + @Country + ''')    
						 select * into table_' + @Country+ ' from table_India  where 1 = 2  

					  Insert into table_'+ @Country 
						  + ' select Customer_Name,Customer_Id,Open_Date,Last_Consulted_Date,Vaccination_Id,Dr_Name,State,  
							DOB,Is_Active from Staging_Tbl WHERE Country='''
						  + @Country + ''' ' 
			SET @i=@i + 1 

			PRINT @i 

			PRINT @var 

			EXEC (@var) 
		END 
END 
