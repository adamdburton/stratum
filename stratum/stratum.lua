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
	
	stratum.classExtends[lastName] = name
end

-- Makes a class implements an interface

function implements(name)
	if not lastName then error('No classes have been defined') end
	if not lastType == 'classes' then error('Only classes can implement interfaces') end
	if not stratum.classes[name] then error('Cannot implement nonexistent interface ' .. name) end
	
	table.insert(stratum.classImplements[lastName], name)
end

-- Makes a class use a trait

function has(name)
	if not lastName then error('No classes have been defined') end
	if not lastType == 'classes' then error('Only classes can have traits') end
	if not stratum.classes[name] then error('Cannot use nonexistent trait ' .. name) end
	
	table.insert(stratum.classTraits[lastName], name)
end

-- Provides the body of a class

function is(tbl)
	if not lastName then error('No classes have been defined') end
	
	stratum.classes[lastName] = tbl
end

-- Returns a new instance of a class

function new(class, ...)
	
	local baseClass = {
		__className = class,
		
		__construct = function() end,
		__destruct = function() end,
	}
	
	local classMeta = {
		
		__properties = {},
		
		__index = function(self, key)
			-- Check if we're trying to get the parent
			
			if key == 'parent' then
				return function()
					local classTable = stratum.classes[stratum.classExtends[self.__className]]
					local mt = getmetatable(self)
					
					classTable.__className = stratum.classExtends[self.__className] -- Change the className to the parents so the __index lookup for parent doesn't loop
					
					return setmetatable(classTable, mt)
				end
			end
			
			-- Check if the key is in our properties
			
			local t = getmetatable(self)
			
			if t.__properties[key] then
				return t.__properties[key]
			end
			
			-- Check if the method exists in a trait
			
			for k, v in pairs(stratum.classTraits) do
				
			end
			
			-- Or if not, pass it to the parent
			
			if stratum.classExtends[self.__className] then
				return stratum.classes[stratum.classExtends[self.__className]][key]
			end
		end,
		
		__newindex = function(self, key, value)
			-- Add this to our properties in the metatable
			
			local t = getmetatable(self)
			t.__properties[key] = value
			setmetatable(self, t)
		end
	}
	
	-- Loop through the parent classes, building up the layers to reach the desired class
	
	local parentClasses = {}
	local parentClass = class
	
	while stratum.classExtends[parentClass] do
		table.insert(parentClasses, stratum.classExtends[parentClass])
		parentClass = stratum.classExtends[parentClass]
	end
	
	local classTable = {}
	
	for k, v in pairs(baseClass) do
		classTable[k] = v
	end
	
	if #parentClasses then
		-- Extended class, start from the bottom
		
		for _, nextClass in pairs(table.reverse(parentClasses)) do
			for k, v in pairs(stratum.classes[nextClass]) do
				classTable[k] = v
			end
		end
		
		for k, v in pairs(stratum.classes[class]) do
			classTable[k] = v
		end
	else
		-- Base class, the normal table is fine
		
		classTable = stratum.classes[class]
	end
	
	setmetatable(classTable, classMeta)
	
	classTable:__construct(unpack({ ... }))
	
	return classTable
end

-- Exceptions

function throw(exception)
	error()
end

-- Stolen from Garry's Mod

function PrintTable ( t, indent, done )

	done = done or {}
	indent = indent or 0
	local keys = {}

	for key, value in pairs (t) do

		table.insert(keys, key)

	end

	table.sort(keys, function(a, b)
		return tostring(a) < tostring(b)
	end)

	for i = 1, #keys do
		key = keys[i]
		value = t[key]
		print( string.rep ("\t", indent) )

		if  ( type(value) == 'table' and not done[value] ) then

			done[value] = true
			print( tostring(key) .. ":" .. "\n" );
			PrintTable (value, indent + 2, done)

		else

			print( tostring (key) .. "\t=\t" )
			print( tostring(value) .. "\n" )

		end

	end

end

-- https://gist.github.com/balaam/3122129

function table.reverse(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
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


class 'Administrator' extends 'User' implements 'UserInterface' has 'SoftDeletingTrait' is {
	
	
	
}

]]--