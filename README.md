stratum
=======

Stratum is a php-like class system for lua with inheritance, interfaces, traits and statics, exceptions and try/catch functions.

##Features

* Class inheritance, interfaces and traits.
* Exceptions and try/catch functions.
* PHP-style definitions using syntactic sugar.
* No dependencies.

##Future Development

* Private/public/protected properties/methods.

##Installation

```lua
require('stratum/stratum')
```

##Examples

Below are a few examples on how to use stratum.

####Class Definition

```lua
class 'User' is {

  __construct = function(self, name)
    self.name = name
  end,
  
  sayHello = function(self)
    return string.format('Hi %s!', self.name)
  end
  
}
```

####Class Instantiation

```lua
local user = new 'User' -- Without parameters

local user2 = new ('User', 'Adam') -- With parameters
```

####Extending Classes

```lua
class 'Administrator' extends 'User' is {
  
  sayHello = function(self)
    return string.format('Hi %s, you\'re an administrator!', self.name)
  end
  
}

local admin = new ('Administrator', 'Jim')

print(user:sayHello()) -- Hi Adam!
print(admin:sayHello()) -- Hi Jim, you're an administrator!
```

####Interfaces

```lua
interface 'DataInterface' is {
  
  getData = function() end,
  setData = function() end
  
}

class 'TableDataInterface' implements 'DataInterface' is {

  data = {},
  
  getData = function(self, table)
    return self.data[table] or {}
  end,
  
  setData = function(self, table, data)
    self.data[table] = data
  end
  
}
```

####Traits

```lua
trait 'Shareable' is {
  
  share = function(self, text)
    self:original():share('Trait! ' .. text)	
  end
  
}

class 'Post' has 'Shareable' -- The `is {}` declaration is missing here because there is no class body

class 'Comment' has 'Shareable' is {
	
	share = function(self, text)
		print('Sharing ' .. self.__className .. ': ' .. text)
	end
	
}

local post = new 'Post'
post:share('I just shared a post with stratum!') -- Errors, there is no share method in the Post class
 
local comment = new 'Comment';
comment:share('I just shared a comment with stratum') -- The trait calls the share method with some text prepended
```

####Static Methods and Properties

```lua
local User = class 'User' is {
	
	exists = false,
	lastID = 1,
	
	create = function(name, email, password) -- static method, no self argument
		local user = new 'User'
		
		user.name = name
		
		user:save()
		
		return user
	end,
	
	save = function(self)
		-- Save to the database?
		self.exists = true -- instance property
		
		self:static().lastID = self:static().lastID + 1 -- static property
		
		return true
	end
	
}

local user = User.create('Test Name') -- User instance

print(User.lastID) -- Static property

```

####Chaining

```lua
class 'SomeClass' extends 'AnotherClass' implements 'SomeInterface' implements 'AnotherInterface' has 'SomeTrait' has 'AnotherTrait' is { }
```

####Try/Catch

```lua
class 'SomeException' extends 'Exception' is { }
class 'SomeOtherException' extends 'Exception' is { }

try(function()
	throw ('SomeException', 'This is a message')
	--echo something[thatDoesNotExist]
end)
catch({
	['SomeException'] = function(exception)
		return('Caught SomeException: ' .. exception.message) -- This will be called
	end,
	['SomeOtherException'] = function(exception)
		return('Caught SomeOtherException: ' .. exception.message) -- This won't be called
	end,
	['ErrorException'] = function(exception)
		print('There was an error!' .. exception.message)
	end
})
```

##Performance

There are a few performance and test files included in the ```tests``` directory. These tests also contain working examples of each feature of Stratum.

##No Sugar Please

If you prefer your lua a little less sweet, you can also use standard syntax.

```lua
class('User')
extends('SomeClass')
impliments('SomeInterface')
has('SomeTrait')
is({ someProperty = 'hello', someMethod = function(self) return self.someProperty end })

new('User')

throw('Exception')
try(function() end)
catch('Exception', function() end)
```

##Globals

Stratum defines the below 8 global methods.

```lua
class(name)
interface(name)
trait(name)
extends(name)
implements(name)
has(name)
is(tbl)
new(class, ...)
throw(class, ...)
try(function)
catch(exception, function) or catch(table)
```