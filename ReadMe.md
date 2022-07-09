## Insert a new record in a table using Json
This stored procedure helps to insert new records a table (with each execution of it) without specifing all table columns where we want to make the insert of the record.
The names of the columns are taken dinamically based on the name of the table specified as a parameter of the stored procedure
The insert statement is made up dynamically by using dynamic SQL.

## How it was made
- first i started to create the stored procedure by giving it a name and declaring the params
- i declared the variables that will be used in the cursor and also the variable that will contain the final statement
- i started composing the cursor that goes through the json and, step by step, i added to the @sql variable the columns and the values needed for insert
- i closed and deallocated the cursor and i added the condition to the @sql variable
- i executed the @sql variable which contained the insert statement

## Execution syntax
exec SP_Create_New @schema = 'your schema name (in my case 'crc')', @table='your table name',
@json =  @json = '{"table_column_name":"value","table_column_name":"value", "table_column_name":"value"}'

!!Do not forget that the Json must contains the names of the columns in the table!!
