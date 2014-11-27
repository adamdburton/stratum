require('stratum/stratum')

class 'User' is {
	
	getFullNameAttribute = function(self)
		return string.format('%s %s', self.firstName, self.lastName)
	end
	
}

class 'Administrator' extends 'User' is {
	
	-- Empty
	
}

local user = new 'User'

user.firstName = 'Michael'
user.lastName = 'De Santa'

local admin = new 'Administrator'

admin.firstName = 'Franklin'
admin.lastName = 'Clinton'

assert(user.fullName == string.format('%s %s', user.firstName, user.lastName), 'superAdmin.fullName attribute should return ' .. string.format('%s %s', user.firstName, user.lastName))
assert(admin.fullName == string.format('%s %s', admin.firstName, admin.lastName), 'superAdmin.fullName attribute should return ' .. string.format('%s %s', admin.firstName, admin.lastName) .. ' from base User class')

print('👍  All attribute tests okay!')