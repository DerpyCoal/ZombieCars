AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "pshop.lua" )
include( "shared.lua" )

local nohurt = true
local maps = {"zc_arena", "zc_bricks"}

function GM:InitPostEntity()
timer.Create( "my_timer1", 2, 0, function()
	local loc = Vector(0,40,0)
	local ent = ents.Create("npc_zombie")
        ent:SetPos( loc )
		ent:Spawn()
		ent:SetVelocity( Vector( (VectorRand().x * 100), math.abs(VectorRand().y * 100), (VectorRand().z * 100) ))
end)

timer.Create( "my_timer2", 8, 0, function()
	local loc = Vector(0,40,0)
	local ent = ents.Create("npc_poisonzombie")
        ent:SetPos( loc )
		ent:Spawn()
		ent:SetVelocity( Vector( (VectorRand().x * 100), math.abs(VectorRand().y * 100), (VectorRand().z * 100) ))
end)

timer.Create( "my_timer3", 14, 0, function()
	local loc = Vector(0,40,0)
	local ent = ents.Create("npc_fastzombie")
        ent:SetPos( loc )
		ent:Spawn()
		ent:SetVelocity( Vector( (VectorRand().x * 100), math.abs(VectorRand().y * 100), (VectorRand().z * 100) ))
end)

timer.Create( "my_timer4", 18, 0, function()
	local loc = Vector(0,40,0)
	local ent = ents.Create("npc_headcrab_fast")
        ent:SetPos( loc )
		ent:Spawn()
		ent:SetVelocity( Vector( (VectorRand().x * 100), math.abs(VectorRand().y * 100), (VectorRand().z * 100) ))
end)

timer.Simple( 140, function()
  for _, v in pairs(player.GetAll()) do
	v:ChatPrint("Sudden Death! Players can kill eachother and can be hurt by zombies! \n")
  end
  nohurt = false
timer.Simple( 40, function()
  local moneytable = {}
  for _, v in pairs(player.GetAll()) do
  v:ChatPrint("Game End! Restarting in 15 seconds...")
  local monandperson = (v:GetName() .. " has " .. v:Frags() .. " dollars") 
  table.insert(moneytable, monandperson)
  end
  for _, v in pairs(player.GetAll()) do
  v:ChatPrint(table.concat(moneytable,", ") .. "\n")
  end
  timer.Simple( 15, function()
	RunConsoleCommand("changelevel", table.Random(maps))
  end)
  end)
end)
end

function GM:Think()
for _, v in pairs(player.GetAll()) do
	if nohurt then
    v:SetMaxHealth( 100 )
	v:SetHealth( v:GetMaxHealth() )
	end
end
end

hook.Add( "PlayerSay", "OPS", function( ply, text, team )
	text = string.lower( text )
	if ( text == "!ops" ) then
		ply:ChatPrint("Shop: \n+5 Damage: Buy with !getitem 1")
		return ""
	end
	if ( text == "!getitem 1" ) then
		buywp(ply, 1)
		return ""
	end
end )

function GM:PlayerInitialSpawn(ply)
for _, v in pairs(player.GetAll()) do
	v:ChatPrint( ply:Nick() .. " has joined the game!" )
end
timer.Simple(3, function()
local car = ents.Create("prop_vehicle_jeep_old")
car:SetModel("models/buggy.mdl")
car:SetKeyValue("vehiclescript","scripts/vehicles/jeep_test.txt")
car:SetPos( ply:GetPos() + Vector(0,0,40) + ply:GetForward() * 100  )
car.Owner = ply
car:Spawn()
ply:ChatPrint( "Find your car! Use chat command !OPS to open the point shop!" )
end )
end

function GM:PlayerLoadout(ply)
	ply:StripWeapons()
	return true
end

function GM:PlayerSpawn( ply ) 
	self.BaseClass:PlayerSpawn( ply )
	ply:SetGravity( 1, 900 )
	ply:SetMaxHealth( 75, true )
	ply:SetWalkSpeed( 165 )
	ply:SetRunSpeed( 355 )
	ply:SetModel( "models/skeleton.mdl" ) 
end


hook.Add("PlayerHurt", "IsByPlayer", function(victim, attacker, rem, tak)
  if attacker:GetClass() == "prop_vehicle_jeep" and attacker.Owner and nohurt then
    attacker.Owner:ChatPrint("Hurting players is not allowed until Sudden Death!")
    victim:SetHealth( victim:GetHealth() + tak )
  end
end)

hook.Add("CanPlayerEnterVehicle", "AllowVehicleEntry", function(ply, veh)
	if not IsValid(veh) or not IsValid(ply) then return end
	if not veh.Owner == ply then return false end
	return true
end)

hook.Add("PlayerDeath", "CheckTheKiller", function(victim, inflitor, attacker) 
	if attacker:GetClass() == "prop_vehicle_jeep" then
		if attacker.Owner then
                        killshout( 40, attacker.Owner, victim, true )
			attacker.Owner:AddFrags(40)
		end
	end
end)

hook.Add("OnNPCKilled", "KCheck", function(npc, attacker, inflictor) 
	if attacker:GetClass() == "prop_vehicle_jeep" then
		if attacker.Owner then
                        local ds
                        if npc:GetClass() == "npc_zombie" then ds = 10
                        elseif npc:GetClass() == "npc_poisonzombie" then ds = 20
                        elseif npc:GetClass() == "npc_fastzombie" then ds = 30
                        elseif npc:GetClass() == "npc_headcrab_fast" then ds = 40 
                        else return end
                        killshout( ds, attacker.Owner, npc, false )
			attacker.Owner:AddFrags(ds)
			attacker.Owner:EmitSound("bading.mp3")
		end
	end
end)

hook.Add("EntityTakeDamage", "dmgadder", function(tg, atkinfo)
	local pdmgl = atkinfo:GetAttacker().pdmg
	if pdmgl == nil then return end
	tg:SetHealth( tg:Health() - pdmgl )
end )
 
function killshout( dollars, killer, victim, isplayer )
  for k, v in pairs(player.GetAll()) do
  if isplayer then
   v:ChatPrint( killer:Nick() .. " killed " .. victim:Nick() .. "!" .. "\n")
  else
   v:ChatPrint( killer:Nick() .. " killed a " .. victim:GetClass() .. "!" .. "\n")
  end
  killer:ChatPrint( "+" .. tostring(dollars) .. " Dollars!" .. "\n")
  end
end
