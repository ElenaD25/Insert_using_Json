# Update a table using Json

I faced a challenge while developing an app with 2 other colleagues. We had to update a table, but we didn't know exactly which fields the user will update. After a short discussion we concluded that is better to send a Json to the database and make the update based on the fields provided inside it. 

Because we had a few tables that required this operation, i thought about doing a dynamic stored procedure (i used dynamic sql) where we can provide the following info: 
    - schema name
    - table name
    - condition (to avoid disaster :) )
    - json  
 
## How it was made

- first i started to create the stored procedure by giving it a name and declaring the params
- i declared the variables that will be used in the cursor and also the variable that will contain the final statement
- i did some checks on schema name, table name and condition
- i started composing the cursor that goes through the json and, step by step, i added to the @sql variable the columns and the values needed for the update
- i closed and deallocated the cursor and i added the condition to the @sql variable
- i executed the @sql variable which contained the update statement

## Execution syntax

exec crc.Update_using_Json @schema_name = 'your schema name (in my case 'crc'), @table_name = 'your table name', @condition = 'your condition (for example: 'id = 2')', @json = '{"table_column_name":"value","table_column_name":"value", "table_column_name":"value"}' 


!!Do not forget that the Json must contain the names of the columns in the table!!

