-- Let's get started

local stratum = {}

-- Store classes, interfaces, traits

stratum.classes = {}
stratum.interfaces = {}
stratum.traits = {}

-- Store per class meta, extensions, implementations, traits

stratum.classMetas = {}
stratum.classExtends = {}
stratum.classImplements = {}
stratum.classTraits = {}

-- Internal reference to the name of the latest defined class, use for applying extensions, implementations, traits, privates, publics, protecteds and statics

local lastType = nil
local lastName = nil

--[[
	Class creation functions
]]

local function _staticClass(name)
	-- Build a table up for returning the static object
	
	return setmetatable({ __className = name, new = function(...) return new (self.__className, unpack({ ... })) end }, {
		
		__index = function(s, k)
			if stratum.classMetas[s.__className].__methods[k] then
				return stratum.classMetas[s.__className].__methods[k]
			end
			
			if stratum.classMetas[s.__className].__properties[k] then
				return stratum.classMetas[s.__className].__staticProperties[k]
			end
		end,
		
		__newindex = function(s, k, v)
			if type(v) == 'function' then
				stratum.classMetas[s.__className].__methods[k] = v
			else
				stratum.classMetas[s.__className].__staticProperties[k] = v
			end
		end
		
	})
end

-- Creates a new class

function class(name)
	local classTable = {
		__className = name,
		
		__properties = {},
		
		parent = function(self)
			if stratum.classExtends[self.__className] then
				return setmetatable(self, stratum.classMetas[stratum.classExtends[self.__className]])
			end
		end,
		
		original = function(self)
			if stratum.classTraits[self.__className] then
				return setmetatable({}, {
					__index = function(s, k)
						if self.__properties[k] then
							return self.__properties[k]
						end
						
						local mt = getmetatable(self)
					
						if mt.__methods[k] then
							return mt.__methods[k]
						end
					end
				})
			end
		end,
		
		static = function(self)
			return _staticClass(self.__className)
		end,
		
		__construct = function() end,
		__destruct = function() end,
	}
	
	local classMeta = {
		
		__methods = {},
		__traitMethods = {},
		
		__properties = {},
		__staticProperties = {},
		
		__index = function(self, key)
			
			-- Check if the key is a property
			
			if self.__properties[key] ~= nil then
				return self.__properties[key]
			end
			
			-- Store the metatable here
			
			local mt = getmetatable(self)
			
			-- Check if the key is a trait method
			
			if mt.__traitMethods[key] then
				return mt.__traitMethods[key]
			end
			
			-- Check if the key is a method
			
			if mt.__methods[key] then
				return mt.__methods[key]
			end
			
			-- Or nothing!
		end,
		
		__newindex = function(self, key, value)
			local mt = getmetatable(self)
			
			if type(value) == 'function' then
				mt.__methods[key] = value -- Shares the method umong all instances
			else
				self.__properties[key] = value
			end
		end
	}
	
	stratum.classes[name] = classTable
	stratum.classMetas[name] = classMeta
	
	lastType = 'classes'
	lastName = name
	
	-- Return the table
	
	return _staticClass(name)
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

-- Extends a class from another

function extends(name) -- user
	assert(lastName, 'No classes have been defined')
	assert(lastType == 'classes', 'Only classes can extend other classes')
	assert(stratum.classes[name], 'Cannot extend ' .. lastName .. ' with nonexistent class ' .. name)
	
	-- Copy the meta table from the base class to the class being defined now
	
	for k, v in pairs(stratum.classMetas[name].__methods) do
		stratum.classMetas[lastName].__methods[k] = v
	end
	
	for k, v in pairs(stratum.classMetas[name].__traitMethods) do
		stratum.classMetas[lastName].__traitMethods[k] = v
	end
	
	for k, v in pairs(stratum.classMetas[name].__properties) do
		stratum.classMetas[lastName].__properties[k] = v
	end
	
	stratum.classExtends[lastName] = name
end

-- Makes a class implement an interface

function implements(name)
	assert(lastName, 'No classes have been defined')
	assert(lastType == 'classes', 'Only classes can implement interfaces')
	assert(stratum.interfaces[name], 'Cannot implement nonexistent interface ' .. name)
	
	stratum.classImplements[lastName] = stratum.classImplements[lastName] or {}
	
	table.insert(stratum.classImplements[lastName], name)
end

-- Makes a class use a trait

function has(name)
	assert(lastName, 'No classes have been defined')
	assert(lastType == 'classes', 'Only classes can have traits')
	assert(stratum.traits[name], 'Cannot use nonexistent trait ' .. name)
	
	-- Override any trait methods in lastName with trait name
	
	for k, v in pairs(stratum.traits[name]) do
		stratum.classMetas[lastName].__traitMethods[k] = v
	end
	
	stratum.classTraits[lastName] = stratum.classTraits[lastName] or {}
	
	table.insert(stratum.classTraits[lastName], name)
end

-- Provides the body of a class

function is(tbl)
	assert(lastName, 'No classes, interfaces or traits have been defined')
	
	if lastType == 'classes' then
		
		-- Check that this class implements all functions defined in it's interfaces
		
		if stratum.classImplements[lastName] then
			for _, interface in pairs(stratum.classImplements[lastName]) do
				for method, _ in pairs(stratum.interfaces[interface]) do
					assert(tbl[method], 'Class ' .. lastName .. ' must implement method ' .. method .. '')
				end
			end
		end
		
		-- Loop the table
		
		for k, v in pairs(tbl) do
			if type(v) == 'function' then
				-- Add any methods to the __methods meta table
				
				stratum.classMetas[lastName].__methods[k] = v
			else
				-- Add any non-methods to the __properties meta table
				
				stratum.classMetas[lastName].__properties[k] = v
				stratum.classMetas[lastName].__staticProperties[k] = v
			end
		end
		
	else
		stratum[lastType][lastName] = tbl
	end
	
	-- Reset
	
	lastType = nil
	lastName = nil
end

-- Returns a new instance of a class

function new(class, ...)
	assert(stratum.classes[class], 'Cannot instantiate nonexistent class ' .. class)
	
	-- Copy the class table
	
	local classTable = {}
	
	for k, v in pairs(stratum.classes[class]) do
		classTable[k] = v
	end
	
	-- Set the meta
	
	setmetatable(classTable, stratum.classMetas[class])
	
	-- Add any default properties in
	
	for k, v in pairs(stratum.classMetas[class].__properties) do
		classTable[k] = v
	end
	
	-- Call the constructor
	
	classTable:__construct(unpack({ ... }))
	
	-- Done!
	
	return classTable
end