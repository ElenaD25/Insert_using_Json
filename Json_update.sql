
create proc [crc].[JsonBIND_Update] @json nvarchar(max), @schema_name varchar(max), @table_name varchar(max),  @condition varchar(max) 
as
	begin
		DECLARE @key VARCHAR(MAX), @val varchar(max), @type int, @isFirstRow int = 1;
		declare @sql NVARCHAR(MAX);

		begin try 
			if (@condition is null or @condition = '')
				throw 50010, 'The where condition hasn''t been provided', 1
			else if(@schema_name is null or @schema_name = '')
				throw 50020, 'The schema name has not been provided', 1
			else if(@table_name is null or @table_name = '')
				throw 50030, 'The table name hasn''t been provided',1
			else
set @sql= 'Update [' + @schema_name + '].[' + @table_name + '] SET'

declare db_cursor cursor local for
	select * from openjson(@json)
		open db_cursor
			fetch next from db_cursor into @key, @val, @type

				while @@fetch_status = 0
					begin
						if @isFirstRow = 0
							set @sql = @sql + ','

							if (@type = 1)
								begin
									set @sql = @sql + ' [' + @key + '] = ''' + @val + ''''
								end

							if(@type =2)
								begin
									set @sql = @sql + ' [' + @key + '] = ' + @val 
								end

							set @isFirstRow = 0

							fetch next from db_cursor into @key, @val, @type
					end

			set @isFirstRow = 1
			close db_cursor
			deallocate db_cursor
			set @sql = @sql + ' where ' + @condition
			exec (@sql)
			--print (@sql)
				end try
			begin catch
				select error_message() as message
			end catch
			
end
 