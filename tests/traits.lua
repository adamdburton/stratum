require('stratum/stratum')

trait 'SoftDeleting' is {
	
	where = function(self, field, value)
		return self:parent():where('deletedAt', 0):where(field, value) -- Calls the parent where function and returns the parent object
	end,
	
	delete = function(self)
		-- Don't delete from the database, and instead set a property
		self.deletedAt = os.clock()
		
		return 'Delete in trait'
	end,
	
	forceDelete = function(self)
		-- Call the parent function from the class
		self:parent():delete()
	end
	
}

class 'User' has 'SoftDeleting' is {
	
	whereParameters = {},
	
	where = function(field, value)
		table.insert(self.whereParameters, { field, value })
		
		return self
	end,
	
	delete = function(self)
		-- self.database.delete(this.id) -- example that deletes the file from the database
		return 'Delete in model'
	end
	
}

local user = new 'User'

assert(user:delete() == 'Delete in trait', 'user:delete() should call the delete method in the trait')
assert(user:parent():delete() == 'Delete in class', 'user:parent():delete() should call the delete method in the class')

print('👍  All trait tests okay!')