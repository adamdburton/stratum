-- Utils

local function reverseTable(tbl)
    local reversed = {}
    local i = #tbl + 1
		
    for k, v in ipairs(tbl) do
        reversed[i - k] = v
    end
		
    return reversed
end

-- Let's get started

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

local lastType = nil
local lastName = nil

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
	stratum.interfaces[name] = {}
	
	lastType = 'interfaces'
	lastName = name
end

-- Creates a new trait

function trait(name)
	stratum.traits[name] = {}
	
	lastType = 'traits'
	lastName = name
end

-- Extends a class from another, for example `class 'Administrator' extends 'User'` would extend the the Administator class from the User class

function extends(name)
	assert(lastName, 'No classes have been defined')
	assert(lastType == 'classes', 'Only classes can extend other classes')
	assert(stratum.classes[name], 'Cannot extend ' .. lastName .. ' with nonexistent class ' .. name)
	
	stratum.classExtends[lastName] = name
end

-- Makes a class implements an interface

function implements(name)
	assert(lastName, 'No classes have been defined')
	assert(lastType == 'classes', 'Only classes can implement interfaces')
	assert(stratum.classes[name], 'Cannot implement nonexistent interface ' .. name)
	
	stratum.classImplements[lastName] = stratum.classImplements[lastName] or {}
	
	table.insert(stratum.classImplements[lastName], name)
end

-- Makes a class use a trait

function has(name)
	assert(lastName, 'No classes have been defined')
	assert(lastType == 'classes', 'Only classes can have traits')
	assert(stratum.traits[name], 'Cannot use nonexistent trait ' .. name)
	
	stratum.classTraits[lastName] = stratum.classTraits[lastName] or {}
	
	table.insert(stratum.classTraits[lastName], name)
end

-- Provides the body of a class

function is(tbl)
	assert(lastName, 'No classes, interfaces or traits have been defined')
	
	-- Check that this class implements all functions defined in it's interfaces if it's a class
	
	if lastType == 'classes' and stratum.classImplements[lastName] then
		for _, interface in pairs(stratum.classImplements[lastName]) do
			for method, _ in pairs(interface) do
				assert(tbl[method], 'Class' .. lastName .. ' must implement method ' .. method .. '')
			end
		end
	end
	
	stratum[lastType][lastName] = tbl
end

-- Returns a new instance of a class

function new(class, ...)
	assert(stratum.classes[class], 'Cannot instantiate nonexistent class ' .. class)
	
	local baseClass = {
		__className = class,
		__properties = {},
		
		__construct = function() end,
		__destruct = function() end,
	}
	
	local classMeta = {
		
		__attributes = {},
		__traitOverrides = {},
		
		__index = function(self, key)
			
			-- Store the metatable here
			
			local mt = getmetatable(self)
			
			-- Check if we're trying to get the parent
			
			if key == 'parent' then
				
				--PrintTable(debug.getinfo(2))
				
				if stratum.classExtends[self.__className] then
					return function()
						local classTable = stratum.classes[stratum.classExtends[self.__className]]
					
						classTable.__className = stratum.classExtends[self.__className] -- Change the className to the parents so the __index lookup for parent doesn't loop
					
						return setmetatable(classTable, mt)
					end
				end
			end
			
			-- Check if the key is a property
			
			if self.__properties[key] then
				return t.__properties[key]
			end
			
			-- Check if the key is an attribute
			
			if mt.__attributes[key] then
				return mt.__attributes[key](self)
			end
			
			-- Try pass it to the parent
			
			if stratum.classExtends[self.__className] then
				-- Pass the function from the parent, it gets called in the context of this class, and even if the method doesn't exist, the __index method passes it up again
				return stratum.classes[stratum.classExtends[self.__className]][key]
			end
			
			-- Or nothing!
		end,
		
		__newindex = function(self, key, value)
			-- Add this to the properties in the metatable
			
			self.__properties[key] = value
		end
	}
	
	-- Loop through the parent classes, building up the layers to reach the desired class
	
	local parentClasses = {}
	local parentClass = class
	
	while stratum.classExtends[parentClass] do
		table.insert(parentClasses, stratum.classExtends[parentClass])
		parentClass = stratum.classExtends[parentClass]
	end
	
	table.insert(parentClasses, class)
	
	local classTable = {}
	
	for k, v in pairs(baseClass) do
		classTable[k] = v
	end
	
	for _, nextClass in pairs(reverseTable(parentClasses)) do
		for k, v in pairs(stratum.classes[nextClass]) do
			classTable[k] = v
		end
	end
	
	-- Override any trait methods
	
	if stratum.classTraits[class] then
		for _, trait in pairs(stratum.classTraits[class]) do
			for k, v in pairs(stratum.traits[trait]) do
				classTable[k] = v
			end
		end
	end
	
	setmetatable(classTable, classMeta)
	
	classTable:__construct(unpack({ ... }))
	
	return classTable
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