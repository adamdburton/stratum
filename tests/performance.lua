require('stratum/stratum')

-- https://github.com/kikito/middleclass/blob/master/performance/time.lua

function time(title, f)

	collectgarbage()

	local startTime = os.clock()

	for i=0,10000 do f() end

	local endTime = os.clock()

	print( title, endTime - startTime )

end

-- Class creation

time('Class creation', function()
	class 'A' is { }
end)

-- Instance creation

class 'A'

time('Instance creation', function()
	local a = new 'A'
end)

-- Instance method invocation

class 'A' is {
	
	foo = function()
		return 1
	end
}

local a = new 'A'

time('Instance method invocation', function()
	a:foo()
end)

-- Inherited method invocation

class 'B' extends 'A' is  { }

local b = new 'B'

time('Inherited method invocation', function()
	b:foo()
end)

-- Static calls

local A = class 'A' is {

	bar = function()
		return 2
	end
	
}

time('class method invocation', function()
	A.bar()
end)

local B = class 'B' extends 'A' is { }

time('inherited class method invocation', function()
	B.bar()
end)
