require('stratum/stratum')

class 'SomeException' extends 'Exception' is { }
class 'AnotherException' extends 'Exception' is { }
class 'SomeOtherException' extends 'Exception' is { }

try(function()
	throw ('SomeException', 'This is a message')
end)
local caught1 = catch({
	['SomeException'] = function(exception)
		return('Caught SomeException: ' .. exception.message)
	end
})

try(function()
	throw ('AnotherException', 'This is another message')
end)
local caught2 = catch('AnotherException', function(exception)
	return('Caught AnotherException: ' .. exception.message)
end)

try(function()
	return something[nothing]
end)
local caught3 = catch('ErrorException', function(exception)
	return('Caught ErrorException: ' .. exception.message)
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

assert(caught1 == 'Caught SomeException: This is a message', 'SomeException should be caught')
assert(caught2 == 'Caught AnotherException: This is another message', 'AnotherException should be caught')
assert(caught3:find('Caught ErrorException', 1, true), 'ErrorException should be caught')
assert(uncaught:find('Uncaught SomeOtherException', 1, true), 'SomeOtherException should not be caught')

print('👍  All try/catch tests okay!')