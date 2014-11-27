require('stratum/stratum')

class 'Test' is {
	
	one = 0,
	two = 0,
	three = 0,
	
	__construct = function(self, one, two, three)
		self.one = one
		self.two = two
		self.three = three
	end
	
}

class 'Test2' is {
	
	params = {},
	
	__construct = function(self, ...)
		self.params = { ... }
	end
	
}


local test = new ('Test', 1, 2, 3)
local test2 = new ('Test2', 'a', 'b', 'c')

assert(test.one == 1 and test.two == 2 and test.three == 3, 'user.one, user.two, user.three should be 1 2 and 3 respectively')
assert(tableLength(test2.params) == 3, 'tableLength(test2.params should be 3')

print('👍  All constructor tests okay!')