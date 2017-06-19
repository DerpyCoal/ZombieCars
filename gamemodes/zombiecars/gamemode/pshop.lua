include("pshop_items.lua")

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