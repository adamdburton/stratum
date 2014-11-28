require('stratum/stratum')

class 'SomeException' extends 'Exception' is { }
class 'AnotherException' extends 'Exception' is { }
class 'SomeOtherException' extends 'Exception' is { }

try(function()
	throw ('SomeException', 'This is a message')
end)
local caught = catch({
	['SomeException'] = function(exception)
		return('Caught SomeException: ' .. exception.message)
	end
})

try(function()
	throw ('AnotherException', 'This is a another message')
end)
local caught2 = catch('AnotherException', function(exception)
	return('Caught AnotherException: ' .. exception.message)
end)

try(function()
	throw ('SomeOtherException', 'This is some other message')
end)
local ret, uncaught = pcall(function()
	catch({
		['SomeException'] = function(exception)
			return('Caught SomeException: ' .. exception.message)
		end
	})
end)

assert(caught == 'Caught SomeException: This is a message', 'SomeException should be caught')
assert(caught2 == 'Caught AnotherException: This is a message', 'SomeException should be caught')
assert(uncaught:find('Uncaught exception: SomeOtherException', 1, true), 'SomeOtherException should not be caught')

print('👍  All try/catch tests okay!')