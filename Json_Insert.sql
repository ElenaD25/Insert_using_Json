CREATE proc [crc].[Insert_with_Json] 
@json nvarchar(max), @schema varchar(max), @table varchar(max)
as 
	begin
		declare @key varchar(max), @val varchar(max), @type int,
		@sql nvarchar(max),
		@values_to_insert varchar(max),
		@isFirstCol int = 1,
		@isFirstVal int = 1,
		@ErrorMessage nvarchar(4000),@ErrorSeverity int,@ErrorState int;

	begin try 
		set @sql = 'insert into ' + quotename(trim(@schema)) + '.' + quotename(trim(@table)) +' ('
		set @values_to_insert = 'values('

	declare db_cursor cursor local for
		select * from openjson(@json)
			open db_cursor
				fetch next from db_cursor into @key, @val,@type

					while @@FETCH_STATUS = 0 
						begin
							if @isFirstCol = 0
								set @sql = @sql + ','
								
								set @sql = @sql + ' [' + @key + ']'

							set @isFirstCol = 0

								if @isFirstVal = 0
									set @values_to_insert = @values_to_insert + ','
									if (@type = 1)
										begin
											set @values_to_insert = @values_to_insert + ' ''' + trim(@val) + ''''
										end

									if(@type =2)
										begin
											set @values_to_insert = @values_to_insert +  trim(@val) 
										end
							set @isFirstVal = 0
			fetch next from db_cursor into @key, @val, @type
	end
	
	set @isFirstCol = 1
	set @isFirstVal = 1

	close db_cursor
	deallocate db_cursor
	set @sql = @sql + ' )' + @values_to_insert + ');'
	
	exec sp_executesql @sql
	end try
		begin catch
			  SELECT 
					@ErrorMessage = ERROR_MESSAGE(), 
					@ErrorSeverity = ERROR_SEVERITY(), 
					@ErrorState = ERROR_STATE();

		   RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState)

		end catch

end
