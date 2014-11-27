require('stratum/stratum')

class 'User' is {
	
	test = 123,
	
	fullName = function(self)
		return string.format('%s %s', self.firstName, self.lastName)
	end,
	
	isAdministrator = function(self)
		return false
	end,
		
	isSuperAdministrator = function(self)
		return false
	end,
		
	existsInUserButNotAdministratorOrSuperAdministrator = function(self)
		return self:fullName()
	end
	
}

class 'Administrator' extends 'User' is {
	
	test = 456,
	
	isAdministrator = function(self)
		return true
	end,
	
	existsInAdministratorButNotSuperAdministrator = function(self)
		return self.lastName
	end
}

local admin = new 'Administrator'

class 'SuperAdministrator' extends 'Administrator' is {
	
	test = 789,
	
	isAdministrator = function(self)
		return self:parent():isAdministrator()
	end,
	
	isSuperAdministrator = function(self)
		return true
	end
	
}

local superAdmin = new 'SuperAdministrator'

superAdmin.firstName = 'Trevor'
superAdmin.lastName = 'Phillips'

assert(admin.test == 456, 'admin.test property should be 456')
assert(superAdmin.test == 789, 'superAdmin.test property should be 789')
assert(superAdmin:isSuperAdministrator() == true, 'superAdmin:isSuperAdministrator() method should return true')
assert(superAdmin:existsInUserButNotAdministratorOrSuperAdministrator() == string.format('%s %s', superAdmin.firstName, superAdmin.lastName), 'superAdmin:existsInUserButNotAdministratorOrSuperAdministrator() should return ' .. superAdmin.firstName)
assert(superAdmin:existsInAdministratorButNotSuperAdministrator() == superAdmin.lastName, 'superAdmin:existsInAdministratorButNotSuperAdministrator() should return ' .. superAdmin.lastName)
assert(superAdmin:parent():isSuperAdministrator() == false, 'superAdmin:parent():isSuperAdministrator() method should return false from User:isSuperAdministrator()')
assert(superAdmin:parent():parent():isSuperAdministrator() == false, 'superAdmin:parent():isSuperAdministrator() method should return false from User:isSuperAdministrator()')

print('👍  All inheritance tests okay!')