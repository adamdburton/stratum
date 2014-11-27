require('stratum/stratum')

local User = class 'User' is {
	
	exists = false,
	lastID = 1,
	
	create = function(name, email, password) -- static function, no self argument
		local user = new 'User'
		
		user.name = name
		user.email = email
		user.password = password
		
		user:save()
		
		return user
	end,
	
	save = function(self)
		-- Save to the database?
		self.exists = true -- instance variable
		
		self:static().lastID = self:static().lastID + 1
		
		return true
	end
	
}

local user = User.create('Test Name', 'test@test.com', 'password123')

assert(user.name == 'Test Name', 'user.name property should be Test Name')
assert(user.exists == true, 'user.exists should be set to true')
assert(User.lastID == 2, 'User.lastID should be 2')

local user = new 'User'

assert(user.exists == false, 'user.exists should be set to false')

print('👍  All static tests okay!')