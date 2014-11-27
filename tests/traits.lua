require('stratum/stratum')

trait 'SoftDeletingTrait' is {
	
	where = function(self, field, value)
		return self:original():where('deletedAt', 0):where(field, value) -- Calls the original where function and returns the parent object
	end,
	
	delete = function(self)
		-- Don't delete from the database, and instead set a property
		self.deletedAt = os.clock()
		
		return 'Delete in trait'
	end,
	
	forceDelete = function(self)
		-- Call the parent function from the class
		self:original():delete()
	end
	
}

class 'User' has 'SoftDeletingTrait' is {
	
	whereParameters = {},
	
	where = function(self, field, value)
		self.whereParameters[field] = value
		
		return self
	end,
	
	delete = function(self)
		-- self.database.delete(this.id) -- example that deletes the file from the database
		return 'Delete in model'
	end
	
}

local user = new 'User'

assert(user:delete() == 'Delete in trait', 'user:delete() should call the delete method in the SoftDeletingTrait trait')
assert(user:original():delete() == 'Delete in model', 'user:original():delete() should call the delete method in the User class')
assert(tableLength(user:where('abc', 123).whereParameters) == 2, 'user:where(\'abc\', 123) should return a table with 2 indexes')

print('👍  All trait tests okay!')