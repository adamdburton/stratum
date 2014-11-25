class 'User' extends 'ArticulateModel' is {
	
	protected 'getFullNameAttribute' = function()
		return string.format('%s %s', self.firstName, self.lastName)
	end,
	
	public 'isAdministrator' = function()
		return false
	end
	
}

local user = new 'User'

user.firstName = 'Michael'
user.lastName = 'De Santa'

MsgN(user.fullName .. (user:isAdmin() and 'is' or 'is not') .. ' an administrator!')

class 'Administrator' extends 'User' is {
	
	public 'isAdministrator' = function()
		return true
	end
	
}

local admin = new 'Administrator'

user.firstName = 'Trevor'
user.lastName = 'Phillips'

MsgN(user.fullName .. (user:isAdmin() and 'is' or 'is not') .. ' an administrator!')