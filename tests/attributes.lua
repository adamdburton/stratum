require('stratum/stratum')

class 'User' is {
	
	getFullNameAttribute = function(self)
		return string.format('%s %s', self.firstName, self.lastName)
	end
	
}

local user = new 'User'

user.firstName = 'Michael'
user.lastName = 'De Santa'

assert(user.fullName == string.format('%s %s', user.firstName, user.lastName), 'superAdmin.fullName attribute should return ' .. string.format('%s %s', user.firstName, user.lastName))

print('👍  All attribute tests okay!')