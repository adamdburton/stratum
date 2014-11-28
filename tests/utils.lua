-- From Garry's Mod

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

-- #table doesn't work

function tableLength(tbl)
	local c = 0
	
	for k, v in pairs(tbl) do
		c = c + 1
	end
	
	return c
end
