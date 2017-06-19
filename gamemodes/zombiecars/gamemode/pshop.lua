--[[ 
Hey there buddy, it seems you're snooping in my code. Just kidding, it's okay to be here.
So, let me give you some information about this place.
This is the item list. Here you can change the prices, but not what the items actually do. Obviously.
--]]

local items = {"", "+5 Damage"}
local prices = {"1", "80"}
local prices_int = {1, 80}

-- Don't touch this stuff!
-- https://www.youtube.com/watch?v=8iE8W4iq7X8

function addpoint( ply, pts )
	ply:AddFrags(pts)
	return pts
end

function buywp( ply, id )
	local item = items[id]
	local price = prices_int[id]
	local pcs = prices[id]
	local dec
	if (ply:Frags() >= price) then
	dec = true
	ply:SetFrags( ply:Frags() - price)
	ply:ChatPrint( "You bought " .. item .. " for " .. pcs .. "! You now have " .. ply:Frags() .. " dollars!" )
	else dec = false ply:ChatPrint("This item is too expensive!") end
	return dec
end
