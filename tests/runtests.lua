require('stratum/stratum')



function tableLength(tbl)
	local c = 0
	
	for k, v in pairs(tbl) do
		c = c + 1
	end
	
	return c
end

print('')
print('Running tests...')
require('tests.inheritance')
require('tests.interfaces')
require('tests.traits')

print('')
print('Running performance tests...')
require('tests.performance')
print('')