require('stratum/stratum')

-- https://github.com/kikito/middleclass/blob/master/performance/time.lua

function time(title, f, times)
  collectgarbage()
  
  local times = times or 10000
  local startTime = os.clock()
  for i=0,times do f() end
  local endTime = os.clock()
  print( '👍  ' .. title .. ' x ' .. times .. ' took ' .. (endTime - startTime) .. ' seconds' )
end

time('class creation', function()
	class 'A'
end)

class 'A'

time('instance creation', function()
	local a = new 'A'
end)

class 'A' is {
	
	foo = function()
		return 1
	end
}

local a = new 'A'

time('instance method invocation', function()
	a:foo()
end)

class 'B' extends 'A'

local b = new 'B'

time('inherited method invocation', function()
  b:foo()
end)

class 'C' extends 'B'

local c = new 'C'

time('inherited x2 method invocation', function()
  c:foo()
end)