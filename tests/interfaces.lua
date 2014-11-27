require('stratum/stratum')

interface 'DataInterface' is {
	
	getData = function() error('Method is being called') end,
	setData = function() error('Method is being called') end

}

class 'TableDataInterface' implements 'DataInterface' is {
	
	data = {},
	
	getData = function(self, table)
		return self.data[table] or {}
	end,
	
	setData = function(self, table, data)
		self.data[table] = data
		
		return true
	end

}

local dataInterface = new 'TableDataInterface'

assert(tableLength(dataInterface:getData('sometable')) == 0, 'dataInterface:getData() should return an empty table')
assert(dataInterface:setData('sometable', 12345), 'dataInterface:setData(\'sometable\', 12345) should set some data without error')
assert(dataInterface:getData('sometable') == 12345, 'dataInterface:getData(\'sometable\') should return 12345')

print('👍  All interface tests okay!')