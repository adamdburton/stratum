require('stratum/stratum')

trait 'ShareableTrait' is {
	
	share = function(self, text)
		return 'Trait! ' .. text
	end
	
}

interface 'ShareableInterface' is {
	
	share = function() end
	
}

-- Post class has no body, but the ShareableTrait provides the share function required in the ShareableInterface
-- The trait must be added before implementing the interface, otherwise the function won't exist in the metatable

class 'Post' has 'ShareableTrait' implements 'ShareableInterface' 
	
local post = new 'Post'

assert(post:share('test') == 'Trait! test', 'post:share(\'test\') should be Trait! test')

print('👍  All interface/trait tests okay!')