local _, NeP = ...
local _G = _G

NeP.DSL:Register('ingroup', function(target)
  return _G.UnitInParty(target) or _G.UnitInRaid(target)
end)

NeP.DSL:Register('group.members', function()
  return (_G.GetNumGroupMembers() or 0)
end)

-- USAGE: group.type==#
-- * 3 = RAID
-- * 2 = Party
-- * 1 = SOLO
NeP.DSL:Register('group.type', function()
  return _G.IsInRaid() and 3 or _G.IsInGroup() and 2 or 1
end)

local UnitClsf = {
  ['elite'] = 2,
  ['rareelite'] = 3,
  ['rare'] = 4,
  ['worldboss'] = 5
}

NeP.DSL:Register("boss", function (target)
  if NeP.DSL:Get("isdummy")(target) then return end
  local classification = UnitClassification(target)
  if UnitClsf[classification] then
    return UnitClsf[classification] >= 3 or NeP.BossID:Eval(target)
  end
end)

NeP.DSL:Register('elite', function (target)
  local classification = _G.UnitClassification(target)
  if UnitClsf[classification] then
    return UnitClsf[classification] >= 2
  end
  return NeP.BossID:Eval(target)
end)

NeP.DSL:Register('id', function(target, id)
  local expectedID = tonumber(id)
  return expectedID and NeP.Core:UnitID(target) == expectedID
end)

NeP.DSL:Register('threat', function(target)
  if _G.UnitThreatSituation('player', target) then
    return select(3, _G.UnitDetailedThreatSituation('player', target))
  end
  return 0
end)

NeP.DSL:Register('aggro', function(target)
  return (_G.UnitThreatSituation(target) and _G.UnitThreatSituation(target) >= 2)
end)

NeP.DSL:Register('moving', function(target)
  local speed, _ = _G.GetUnitSpeed(target)
  return speed ~= 0
end)

NeP.DSL:Register('classification', function (target, spell)
  if not spell then return false end
  local classification = _G.UnitClassification(target)
  if string.find(spell, '[%s,]+') then
    for classificationExpected in string.gmatch(spell, '%a+') do
      if classification == string.lower(classificationExpected) then
        return true
      end
    end
    return false
  else
    return _G.UnitClassification(target) == string.lower(spell)
  end
end)

NeP.DSL:Register('target', function(target, spell)
  return ( _G.UnitGUID(target .. 'target') == _G.UnitGUID(spell) )
end)

NeP.DSL:Register('player', function(target)
  return _G.UnitIsPlayer(target)
end)

NeP.DSL:Register('exists', function(target)
  return _G.UnitExists(target)
end)

NeP.DSL:Register('dead', function (target)
  return _G.UnitIsDeadOrGhost(target)
end)

NeP.DSL:Register('alive', function(target)
  return not _G.UnitIsDeadOrGhost(target)
end)

NeP.DSL:Register('behind', function(target)
  return not NeP.Protected.Infront('player', target)
end)

NeP.DSL:Register('infront', function(target)
  return NeP.Protected.Infront('player', target)
end)

local time_stanting = 0;
local last_moved = 0;
function buildStandingTime()
    -- if we´re not falling then reset the counter and return 0
  if (_G.GetUnitSpeed("player") > 0) then
    time_stanting = 0
        last_moved = 0
        return;
  end
  -- if we have a time set then return the difference
  local time = _G.GetTime()
  if time_stanting > 0 then
    last_moved = time - time_stanting
        return;
  end
  -- otherwise set time and return 0
  time_stanting = time
    last_moved = 0
end
_G.C_Timer.NewTicker(0.1, buildStandingTime)

NeP.DSL:Register('lastmoved', function(target)
  return last_moved
end)

local movingCache = {}

NeP.DSL:Register('movingfor', function(target)
  if _G.UnitExists(target) then
    local guid = _G.UnitGUID(target)
    if movingCache[guid] then
      local moving = (_G.GetUnitSpeed(target) > 0)
      if not movingCache[guid].moving then
        movingCache[guid].last = _G.GetTime()
        movingCache[guid].moving = (_G.GetUnitSpeed(target) > 0)
        return 0
      elseif moving then
        return _G.GetTime() - movingCache[guid].last
      elseif not moving then
        movingCache[guid].moving = false
        return 0
      end
    else
      movingCache[guid] = { }
      movingCache[guid].last = _G.GetTime()
      movingCache[guid].moving = (_G.GetUnitSpeed(target) > 0)
      return 0
    end
  end
  return 0
end)

NeP.DSL:Register('friend', function(target)
  return _G.UnitIsFriend('player', target)
end)

NeP.DSL:Register('enemy', function(target)
  return _G.UnitCanAttack('player', target)
end)

NeP.DSL:Register('range', function(unit)
  return NeP.Protected.UnitCombatRange('player', unit)
end)

NeP.DSL:Register('distance', function(unit)
  return NeP.Protected.Distance('player', unit)
end)

NeP.DSL:Register('rangefrom', function(unit, unit2)
  return NeP.Protected.UnitCombatRange(unit, unit2)
end)

NeP.DSL:Register('distancefrom', function(unit, unit2)
  return NeP.Protected.Distance(unit, unit2)
end)

NeP.DSL:Register('level', function(target)
  return _G.UnitLevel(target)
end)

NeP.DSL:Register('combat', function(target)
  return _G.UnitAffectingCombat(target)
end)

-- Checks if the player has autoattack toggled currently
-- Use {'/startattack', '!isattacking'}, at the top of a CR to force autoattacks
NeP.DSL:Register('isattacking', function()
  return _G.IsCurrentSpell(6603)
end)

NeP.DSL:Register('role', function(target, role)
  return role:upper() == _G.UnitGroupRolesAssigned(target)
end)

NeP.DSL:Register('name', function (target, expectedName)
  return _G.UnitName(target):lower():find(expectedName:lower()) ~= nil
end)

NeP.DSL:Register('creatureType', function (target, expectedType)
  return _G.UnitCreatureType(target) == expectedType
end)

NeP.DSL:Register('class', function (target, expectedClass)
  local class, _, classID = _G.UnitClass(target)
  if tonumber(expectedClass) then
    return tonumber(expectedClass) == classID
  else
    return expectedClass == class
  end
end)

NeP.DSL:Register('melee', function()
  return 4.5
end)

NeP.DSL:Register('inmelee', function(target)
  local range = NeP.Protected.UnitCombatRange('player', target)
  return range <= NeP.DSL:Get('melee')(), range
end)

NeP.DSL:Register('inranged', function(target)
  local range = NeP.Protected.UnitCombatRange('player', target)
  return range <= 40, range
end)

NeP.DSL:Register('incdmg', function(target, args)
  if args and _G.UnitExists(target) then
    local pDMG = NeP.CombatTracker:getDMG(target)
    return pDMG * tonumber(args)
  end
  return 0
end)

NeP.DSL:Register('incdmg.phys', function(target, args)
  if args and _G.UnitExists(target) then
    local pDMG = select(3, NeP.CombatTracker:getDMG(target))
    return pDMG * tonumber(args)
  end
  return 0
end)

NeP.DSL:Register('incdmg.magic', function(target, args)
  if args and _G.UnitExists(target) then
    local mDMG = select(4, NeP.CombatTracker:getDMG(target))
    return mDMG * tonumber(args)
  end
  return 0
end)

NeP.DSL:Register('swimming', function ()
  return _G.IsSwimming()
end)

--return if a unit is a unit
NeP.DSL:Register('is', function(a,b)
  return _G.UnitIsUnit(a,b)
end)

NeP.DSL:Register("falling", function()
  return _G.IsFalling()
end)

local last_fall = 0;
local falling_for = 0;
function buildFallTime()
	-- if we´re not falling then reset the counter and return 0
  if not _G.IsFalling() then
    last_fall = 0
		falling_for = 0
		return;
  end
  -- if we have a time set then return the difference
  local time = _G.GetTime()
  if last_fall > 0 then
    falling_for = time - last_fall
		return;
  end
  -- otherwise set time and return 0
  last_fall = time
	falling_for = 0
end
_G.C_Timer.NewTicker(0.1, buildFallTime)

NeP.DSL:Register({"falling.duration", "fall.duration"}, function()
  return falling_for
end)

NeP.DSL:Register({"deathin", "ttd", "timetodie"}, function(target)
  return NeP.CombatTracker:TimeToDie(target)
end)

NeP.DSL:Register("charmed", function(target)
  return _G.UnitIsCharmed(target)
end)

local communName = NeP.Locale:TA('Dummies', 'Name')
local matchs = NeP.Locale:TA('Dummies', 'Pattern')

NeP.DSL:Register('isdummy', function(unit)
  if not _G.UnitExists(unit) then return end
  if _G.UnitName(unit):lower():find(communName) then return true end
  return NeP.Tooltip:Unit(unit, matchs)
end)

NeP.DSL:Register('indoors', function()
    return _G.IsIndoors()
end)

NeP.DSL:Register('haste', function(unit)
  return _G.UnitSpellHaste(unit)
end)

NeP.DSL:Register("mounted", function()
  return _G.IsMounted()
end)

NeP.DSL:Register('combat.time', function(target)
  return NeP.CombatTracker:CombatTime(target)
end)

NeP.DSL:Register('los', function(a, b)
  return NeP.Protected.LineOfSight(a, b)
end)
