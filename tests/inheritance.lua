require('stratum/stratum')

class 'User' is {
	
	getFullNameAttribute = function()
		return string.format('%s %s', self.firstName, self.lastName)
	end,
	
	isAdministrator = function()
		return false
	end,
		
	isSuperAdministrator = function()
		return false
	end,
		
	existsInUserButNotAdministratorOrSuperAdministrator = function(self)
		return self.firstName
	end
	
}

--local user = new 'User'

--PrintTable(user)

--user.firstName = 'Michael'
--user.lastName = 'De Santa'

--print(user.fullName .. (user:isAdministrator() and 'is' or 'is not') .. ' an administrator!')

class 'Administrator' extends 'User' is {
	
	isAdministrator = function()
		return true
	end,
	
	existsInAdministratorButNotSuperAdministrator = function(self)
		return self.lastName
	end
}

--local admin = new 'Administrator'

class 'SuperAdministrator' extends 'Administrator' is {
	
	isAdministrator = function(self)
		return self:parent():isAdministrator()
	end,
	
	isSuperAdministrator = function()
		return true
	end
	
}

local superAdmin = new 'SuperAdministrator'

superAdmin.firstName = 'Trevor'
superAdmin.lastName = 'Phillips'

assert(superAdmin:isSuperAdministrator() == true, 'superAdmin:isSuperAdministrator() method should return true')
assert(superAdmin:existsInUserButNotAdministratorOrSuperAdministrator() == superAdmin.firstName, 'superAdmin:existsInUserButNotAdministratorOrSuperAdministrator() should return ' .. superAdmin.firstName)
assert(superAdmin:existsInAdministratorButNotSuperAdministrator() == superAdmin.lastName, 'superAdmin:existsInAdministratorButNotSuperAdministrator() should return ' .. superAdmin.lastName)
assert(superAdmin:parent():isSuperAdministrator() == false, 'superAdmin:parent():isSuperAdministrator() method should return false from User:isSuperAdministrator()')
assert(superAdmin:parent():parent():isSuperAdministrator() == false, 'superAdmin:parent():isSuperAdministrator() method should return false from User:isSuperAdministrator()')

print('👍  All inheritance tests okay!')