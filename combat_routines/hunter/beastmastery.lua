-- OPTIONAL!
-- List of all elements can be found at:
-- https://github.com/MrTheSoulz/NerdPack/wiki/Class-Interface
local GUI = {
     {type = 'text', text = 'nothing here yet...'},
}

-- OPTIONAL!
local GUI_ST = {
    title='[NeP] Humter - Beast Mastery',
    --width='256',
    --height='300',
    --color='A330C9'
}

-- This is executed on load
-- OPTIONAL!
local ExeOnLoad = function()
     -- This will print a message everytime the user selects your CR.
     NeP.Core:Print('Hello User!\nThanks for using [NeP] Humter - Beast Mastery\nRemember this is just a basic routine.')
end

-- this is executed on unload
-- OPTIONAL!
local ExeOnUnload = function()
     -- This will print a message everytime the user selects your CR.
     NeP.Core:Print('Goodbye :(')
end

--CR for in-combat
--[[

]]
local InCombat = {
    {"Mend Pet", "!pet.buff & pet.health <= 65 & pet.range <= 45", "player"},
    {"/startattack", "inRange(Cobra Shot).spell & infront & canAttack & targettimeout(autoattack, 1.5)", "target"},
	{"Kill Command", "inRange(Cobra Shot).spell & infront & canAttack & targettimeout(kill, 0.5)", "target"},
	{"Barbed Shot", "inRange.spell & !player.buff(246152) & infront & canAttack", "target"},
    {"Cobra Shot", "inRange.spell & infront & canAttack", "target"},
}

--CR for out of combat
-- OPTIONAL!
local OutCombat = {
    {"Mend Pet", "!pet.buff & pet.health <= 65 & pet.range <= 45", "player"},
	{"Kill Command", "inRange(Cobra Shot).spell & infront & canAttack & targettimeout(kill, 0.5)", "target"},
	{"Barbed Shot", "inRange.spell & !player.buff(246152) & infront & canAttack", "target"},
    {"Cobra Shot", "inRange.spell & infront & canAttack", "target"},
    {"/startattack", "inRange(Cobra Shot).spell & infront & canAttack & targettimeout(autoattack, 1.5)", "target"},
     -- OCC CR.
}

-- Enter name and ID
-- this allows your cr to work on any language and at the same time remain readable
-- OPTIONAL!
local spell_ids = {}

local buffsBlacklist = {}
local debuffsBlacklist = {}

-- These are blacklisting exemples
-- (### means number)
-- OPTIONAL!
local blacklist = {
     units = {},
     buffs = buffsBlacklist,
     debuff = debuffsBlacklist,
}

-- SPEC_ID can be found on:
-- https://github.com/MrTheSoulz/NerdPack/wiki/Class-&-Spec-IDs
NeP.CR:Add(253, {
     wow_ver = "8.2", -- Optional!
     nep_ver = "1.11", -- Optional!
     name = '[NeP] Humter - Beast Mastery',
     ic = InCombat, -- Optional!
     ooc= OutCombat, -- Optional!
     load = ExeOnLoad, -- Optional!
     unload = ExeOnUnload, -- Optional!
     gui= GUI, -- Optional!
     gui_st = GUI_ST, -- Optional!
     ids = spell_ids, -- Optional!
     blacklist = blacklist, -- Optional!
     pooling = true, -- Optional! [[This makes nep wait for a spell if the conditions are true but the spell is on cooldown.]]
})
