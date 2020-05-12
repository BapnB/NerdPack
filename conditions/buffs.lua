local _, NeP = ...
local _G = _G

local function UnitBuffL(target, spell, own)
  for i=1,40 do
    local name, _, count, type, duration, expiration, caster, isStealable,
    _,spellId,_, isBoss = _G.UnitBuff(target, i, own)
    if name == spell or tonumber(spell) == tonumber(spellId) then
      return name, count, expiration, caster, type, isStealable, isBoss
    end
  end
end

local function UnitDebuffL(target, spell, own)
  for i=1,40 do
    local name, _, count, type, duration, expiration, caster, isStealable,
    _,spellId,_, isBoss = _G.UnitDebuff(target, i, own)
    if name == spell or tonumber(spell) == tonumber(spellId) then
      return name, count, expiration, caster, type, isStealable, isBoss
    end
  end
end

local heroismBuffs = { 32182, 90355, 80353, 2825, 146555 }
NeP.DSL:Register("hashero", function()
  for i = 1, #heroismBuffs do
    local SpellName = NeP.Core:GetSpellName(heroismBuffs[i])
    if UnitBuffL('player', SpellName) then return true end
  end
end)

-- List of slows from players
local slows = { 

   45524,   -- Chains of Ice                  	   -- Death Knight
   228645,  -- Heart Strike                  	   -- Death Knight
   196770,  -- Remorseless Winter                  -- Death Knight
   
   203556,	-- Master of the Glaive				   -- Demon Hunter

   339,  	-- Entangling Roots                    -- Druid   
   48484,  	-- Infected Wounds                     -- Druid

   5116,   	-- Concussive Shot                     -- Hunter
   109248,  -- Binding Shot                        -- Hunter   
   186387,  -- Bursting Shot                       -- Hunter
   187698,  -- Tar Trap                     	   -- Hunter
   195645,  -- Wing Clip                     	   -- Hunter

   190356,  -- Blizzard                     	   -- Mage
   205708,  -- Chilled                     		   -- Mage
   235711,  -- Chrono Shift                        -- Mage
   162120,  -- Cone of Cold                        -- Mage
   2120,  	-- Flamestrike                         -- Mage
   33395,  	-- Freeze                          	   -- Mage
   122,  	-- Frost Nova                          -- Mage
   84714,  	-- Frozen Orb                          -- Mage
   205021,  -- Ray of Frost                        -- Mage
   31589,  	-- Slow                     		   -- Mage
   
   116095,  -- Disable                  		   -- Monk
   101545,  -- Flying Serpent Kick                 -- Monk
   
   204054,  -- Consecrated Ground                  -- Paladin
   183218,  -- Hand of Hindrance                   -- Paladin
   
   15407,  	-- Mind Flay						   -- Priest
   204263,  -- Shining Force					   -- Priest
   
   3408,  	-- Crippling Poison					   -- Rogue
   277953,  -- Night Terrors					   -- Rogue
   185763,  -- Pistol Shot					   	   -- Rogue
   277950,  -- Shadow's Grasp					   -- Rogue
   
   2484,  	-- Earthbind Totem      			   -- Shaman
   51485,   -- Earthgrab Totem       			   -- Shaman
   196840,  -- Frost Shock       				   -- Shaman
   196834,  -- Frostbrand       				   -- Shaman
   197211,  -- Fury of Air       				   -- Shaman
   
   118000,  -- Dragon Roar                         -- Warrior
   1715,   	-- Hamstring                           -- Warrior
   12323,   -- Piercing Howl                       -- Warrior
   
}

NeP.DSL:Register("hasslowp", function()
  for i = 1, #slows do
    local SpellName = NeP.Core:GetSpellName(slows[i])
    if UnitDebuffL("player", SpellName) then return true 
	end
  end
end)

NeP.DSL:Register("hasslowf", function()
  for i = 1, #slows do
    local SpellName = NeP.Core:GetSpellName(slows[i])
    if UnitDebuffL("friend", SpellName) then return true 
	end
  end
end)

-- Curse/Poison Debuffs list for ferals
local curselist = {

	-- Atal'Dazar
  --252781,	-- Unstable Hex (curse) //need advanced unlocker
	250096,	-- Wracking Pain (curse)
	252687,	-- Venomfang Strike (poison on tank)
	
	-- Freehold
  --257436, -- Poisoning Strike (poison) //"debuff(Poisoning Strike).count >= 2"

	-- King's Rest
	276031,	-- Pit of Despair (curse)
	270492, -- Hex (curse)
	270865, -- Hidden Blade (poison)
	271563,	-- Embalming Fluid (poison)
	270507,	-- Poison Barrage (poison)
	
	-- Siege of Boralus
	257168,	-- Cursed Slash (curse)
  --275835, -- Stinging Venom Coating (poison) //"debuff(Stinging Venom Coating).count >= 5"
	
	-- Temple of Sethraliss
	273563, -- Neurotoxin (poison) //"debuff(Neurotoxin) & ismoving || ..."
	267027, -- Cytotoxin (poison) //"debuff(Cytotoxin).count >= x"
	272699, -- Venomous Spit (poison)
	
	-- The MOTHERLODE!!
	269298, -- Widowmaker Toxin (poison)
	
	-- The Underrot
	265468,	-- Withering Curse (curse)
	
	-- Tol Dagor
	257777, -- Crippling Shiv (poison)
	
--[[-- Waycrest Manor //not worth atm
	
	260703,	-- Unstable Runic Mark (curse)
	263905, -- Marking Cleave (curse)
	265880, -- Dread Mark (curse)
	265882, -- Lingering Dread (curse)
	264105, -- Runic Mark (curse)
]]--	
}

NeP.DSL:Register("tocurse", function()
  for i = 1, #curselist do
    local SpellName = NeP.Core:GetSpellName(curselist[i])
    if UnitDebuffL("player", SpellName) or UnitDebuffL("friend", SpellName) then return true 
	end
  end
end)

------------------------------------------ BUFFS -----------------------------------------
------------------------------------------------------------------------------------------
NeP.DSL:Register("buff", function(target, spell)
  return UnitBuffL(target, spell, 'PLAYER') ~= nil
end)

NeP.DSL:Register("buff.any", function(target, spell)
  return UnitBuffL(target, spell) ~= nil
end)

NeP.DSL:Register("buff.count", function(target, spell)
  local _, count = UnitBuffL(target, spell, 'PLAYER')
  return count or 0
end)

NeP.DSL:Register("buff.count.any", function(target, spell)
  local _, count = UnitBuffL(target, spell)
  return count or 0
end)

NeP.DSL:Register("buff.duration", function(target, spell)
  local buff,_,expires = UnitBuffL(target, spell, 'PLAYER')
  return buff and (expires - _G.GetTime()) or 0
end)

NeP.DSL:Register("buff.duration.any", function(target, spell)
  local buff,_,expires = UnitBuffL(target, spell)
  return buff and (expires - _G.GetTime()) or 0
end)

NeP.DSL:Register("buff.many", function(target, spell)
  local count = 0
  for i=1,40 do
    if UnitBuffL(target, i, 'PLAYER') == spell then count = count + 1 end
  end
  return count
end)

NeP.DSL:Register("buff.many.any", function(target, spell)
  local count = 0
  for i=1,40 do
    if UnitBuffL(target, i) == spell then count = count + 1 end
  end
  return count
end)

------------------------------------------ DEBUFFS ---------------------------------------
------------------------------------------------------------------------------------------

NeP.DSL:Register("debuff", function(target, spell)
  return  UnitDebuffL(target, spell, 'PLAYER') ~= nil
end)

NeP.DSL:Register("debuff.any", function(target, spell)
  return UnitDebuffL(target, spell) ~= nil
end)

NeP.DSL:Register("debuff.count", function(target, spell)
  local _,count = UnitDebuffL(target, spell, 'PLAYER')
  return count or 0
end)

NeP.DSL:Register("debuff.count.any", function(target, spell)
  local _,count = UnitDebuffL(target, spell)
  return count or 0
end)

NeP.DSL:Register("debuff.duration", function(target, spell)
  local debuff,_,expires = UnitDebuffL(target, spell, 'PLAYER')
  return debuff and (expires - _G.GetTime()) or 0
end)

NeP.DSL:Register("debuff.duration.any", function(target, spell)
  local debuff,_,expires = UnitDebuffL(target, spell)
  return debuff and (expires - _G.GetTime()) or 0
end)

NeP.DSL:Register("debuff.many", function(target, spell)
  local count = 0
  for i=1,40 do
    if UnitDebuffL(target, i, 'PLAYER') == spell then count = count + 1 end
  end
  return count
end)

NeP.DSL:Register("debuff.many.any", function(target, spell)
  local count = 0
  for i=1,40 do
    if UnitDebuffL(target, i) == spell then count = count + 1 end
  end
  return count
end)

----------------------------------------------------------------------------------------------

-- Counts how many units have the buff
-- USAGE: count.enemies(BUFF).buffs > = #
NeP.DSL:Register("count.enemies.buffs", function(_,buff)
  local n1 = 0
  for _, Obj in pairs(NeP.OM:Get('Enemy')) do
      if NeP.DSL:Get('buff.any')(Obj.key, buff) then
          n1 = n1 + 1
      end
  end
  return n1
end)

-- Counts how many units have the buff
-- USAGE: count(BUFF).buffs > = #
NeP.DSL:Register("count.friendly.buffs", function(_,buff)
  local n1 = 0
  for _, Obj in pairs(NeP.OM:Get('Roster')) do
      if NeP.DSL:Get('buff')(Obj.key, buff) then
          n1 = n1 + 1
      end
  end
  return n1
end)

-- Counts how many units have the debuff
-- USAGE: count.enemies(DEBUFF).debuffs > = #
NeP.DSL:Register("count.enemies.debuffs", function(_,debuff)
  local n1 = 0
  for _, Obj in pairs(NeP.OM:Get('Enemy', true)) do
      if NeP.DSL:Get('debuff')(Obj.key, debuff) then
          n1 = n1 + 1
      end
  end
  return n1
end)

-- Counts how many units have the debuff
-- USAGE: count.friendly(DEBUFF).debuffs > = #
NeP.DSL:Register("count.friendly.debuffs", function(_,debuff)
  local n1 = 0
  for _, Obj in pairs(NeP.OM:Get('Roster')) do
      if NeP.DSL:Get('debuff.any')(Obj.key, debuff) then
          n1 = n1 + 1
      end
  end
  return n1
end)
