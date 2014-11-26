stratum
=======

Stratum is a class system for lua with inheritance, interfaces and traits. Definitions have a php-like style using some syntactic sugar.

##Features

* Class inheritance, interfaces and traits.
* PHP-style definitions using syntactic sugar.
* No dependencies.

##Future Development

* Static properties/methods.
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
    print('Sharing ' .. self.__className .. ': ' .. text)
  end
  
}

class 'Post' has 'Shareable' -- The `is {}` declaration is missing here because there is no class body
class 'Comment' has 'Shareable' -- Same again

local post = new 'Post'
post:share('I just shared a post with stratum!')
 
local comment = new 'Comment';
comment:share('I just shared a comment with stratum')
```

####Class Attributes

```lua
class 'User' is {
  
  getFullNameAttribute = function(self)
    return string.format('%s %s', self.firstName, self.lastName)
  end
  
}

local user = new 'User'

user.firstName = 'Michael'
user.lastName = 'De Santa'

print(user.fullName) -- Michael De Santa
```

####Chaining

```lua
class 'SomeClass' extends 'AnotherCLass' implements 'SomeInterface' implements 'AnotherInterface' has 'SomeTrait' has 'AnotherTrait' is {

}
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
```