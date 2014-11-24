local classes = {}

-- Creates a new ckass

function class(name)
	table.insert(classes, name)
	print(#classes)
end

-- Creates a new interface

function interface(name)
	
end

-- Creates a new trait

function trait(name)
	
end

-- Extends a class from another, for example `class 'Administrator' extends 'User'` would extend the the Administator class from the User class

function extends(name)
	
end

-- Makes a class impliment an interface

function impliments(name)
	
end

-- Makes a class use a trait

function uses(name)
	
end

-- Provides the body of a class

function with(tbl)
	print(#tbl)
end

is = with

-- Returns a new instance of a class

function new(class)
	
end

--[[
 
interface 'UserInterface' is {
	
	SetName = function(name) end -- Any function content is ignored
	
}

trait 'SoftDeletableTrait' is {
	
	delete = function()
		self.attributes['deleted_at'] = os.time()
	end,

	forceDelete = function()
		self.
	end
	
}


class 'Administrator' extends 'User' Impliments 'UserInterface' uses 'SoftDeletableTrait' with {
	
	
	
}

]]--