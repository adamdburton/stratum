local stratum = {}

-- Store classes, interfaces, traits

stratum.classes = {}
stratum.interfaces = {}
stratum.traits = {}

-- Store per class extensions, implementations, traits and statics

stratum.classExtends = {}
stratum.classImplements = {}
stratum.classTraits = {}
stratum.classStatics = {}

-- Internal reference to the name of the latest defined class, use for applying extensions, implementations, traits, privates, publics, protecteds and statics

local lastType = ''
local lastName = ''

--[[
	Class creation functions
]]

-- Creates a new class

function class(name)
	stratum.classes[name] = {}
	
	lastType = 'classes'
	lastName = name
end

-- Creates a new interface

function interface(name)
	if not lastName then error('No classes have been defined') end
	
	stratum.interfaces[name] = {}
	
	lastType = 'interfaces'
	lastName = name
end

-- Creates a new trait

function trait(name)
	if not lastName then error('No classes have been defined') end
	
	stratum.traits[name] = {}
	
	lastType = 'traits'
	lastName = name
end

-- Extends a class from another, for example `class 'Administrator' extends 'User'` would extend the the Administator class from the User class

function extends(name)
	if not lastName then error('No classes have been defined') end
	if not lastType == 'classes' then error('Only classes can extend other classes') end
	if not stratum.classes[name] then error('Cannot extend with nonexistent class ' .. name) end
	
	table.push(stratum.classExtends[lastName], name)
end

-- Makes a class implements an interface

function implements(name)
	if not lastName then error('No classes have been defined') end
	if not lastType == 'classes' then error('Only classes can implement interfaces') end
	if not stratum.classes[name] then error('Cannot implement nonexistent interface ' .. name) end
	
	table.push(stratum.classImplements[lastName], name)
end

-- Makes a class use a trait

function has(name)
	if not lastName then error('No classes have been defined') end
	if not lastType == 'classes' then error('Only classes can have traits') end
	if not stratum.classes[name] then error('Cannot use nonexistent trait ' .. name) end
	
	table.push(stratum.classTraits[lastName], name)
end

-- Provides the body of a class

function is(tbl)
	if not lastName then error('No classes have been defined') end
	
	stratum[lastType][lastName] = tbl
end

--[[
	Internal class functions for keeping track of publics, privates, protecteds and statics
]]

function private(name)
	if not lastName then error('No classes have been defined') end
	
	stratum[lastType][lastName].__private[name] = nil
	
	return '__private' .. name
end

function public(name)
	if not lastName then error('No classes have been defined') end
	
	stratum[lastType][lastName].__public[name] = nil
	
	return name
end

function protected(name)
	if not lastName then error('No classes have been defined') end
	
	stratum[lastType][lastName].__protected[name] = nil
	
	return '__protected' .. name
end

function static(name)
	if not lastName then error('No classes have been defined') end
	if not lastType == 'classes' then error('Only classes can have statics') end
	
	classStatics[lastName][name] = nil
end

-- Returns a new instance of a class

function new(class, ...)
	local t = {
		__className = class,
		__private = {},
		__protected = {},
		__publicStatic = {},
		__privateStatic = {},
		__protectedStatic = {},
		
		__index = function(self, key)
			-- Check if we're calling from inside the class or outside, or from a extended class, or from a trait
		end
	}
	
	setmetatable(t, classes[class])
	
	t::__construct(unpack(...))
	
	return t
end

-- Exceptions

function throw(exception)
	error()
end

--[[
 
interface 'UserInterface' is {
	
	SetName = function(name) end -- Any function content is ignored
	
}

trait 'SoftDeletingTrait' is {
	
	delete = function(self)
		self.attributes['deleted_at'] = os.time()
	end,

	forceDelete = function(self)
		self.query.delete()
	end
	
}


class 'Administrator' extends 'User' implements 'UserInterface' has 'SoftDeletingTrait' with {
	
	
	
}

]]--