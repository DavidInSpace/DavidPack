local mod = david_pack
local sfx = SFXManager()



local font = Font()
font:Load("font/pftempestasevencondensed.fnt")

local curseSprite = Sprite()
curseSprite:Load("gfx/ui/super_curse_icons.anm2", true)
curseSprite:Play("Blackout", true)

--print("Update Icons")
MinimapAPI:AddMapFlag("curse_of_blackout",
    function()
        return Game():GetLevel():GetCurses() & mod.LevelCurse.CURSE_OF_BLACKOUT > 0
    end,
    curseSprite, "Blackout", 1)

MinimapAPI:AddMapFlag("curse_of_the_catacomb",
    function()
        return Game():GetLevel():GetCurses() & mod.LevelCurse.CURSE_OF_THE_CATACOMB > 0
    end,
    curseSprite, "Catacomb", 1)

MinimapAPI:AddMapFlag("curse_of_absolute_disorientation",
    function()
        return Game():GetLevel():GetCurses() & mod.LevelCurse.CURSE_OF_ABSOLUTE_DISORIENTATION > 0
    end,
    curseSprite, "AbsoluteDisorientation", 1)

MinimapAPI:AddMapFlag("curse_of_unfathomable",
    function()
        return Game():GetLevel():GetCurses() & mod.LevelCurse.CURSE_OF_UNFATHOMABLE > 0
    end,
    curseSprite, "Unfathomable", 1)

MinimapAPI:AddMapFlag("curse_of_unpredictability",
    function()
        return Game():GetLevel():GetCurses() & mod.LevelCurse.CURSE_OF_UNPREDICTABILITY > 0
    end,
    curseSprite, "Unpredictability", 1)

MinimapAPI:AddMapFlag("curse_of_visionless",
    function()
        return Game():GetLevel():GetCurses() & mod.LevelCurse.CURSE_OF_VISIONLESS > 0
    end,
    curseSprite, "Visionless", 1)

mod:AddCallback(ModCallbacks.MC_POST_CURSE_EVAL,
    function(_, curses)
        --print("super curses: ", mod.SaveManager.GetSettingsSave().super_curses)
        local tryReplaceCurse = mod.SaveManager.GetSettingsSave().super_curses or 1
        if tryReplaceCurse == 1 then
            local chance = math.random(1, 100)
            local curseReplacementChance = mod.SaveManager.GetSettingsSave().super_curses_chance or 10
            if chance <= curseReplacementChance then
                --print("Replace Curse With Super Curse")
                --print(mod.LevelCurse.CURSE_OF_ABSOLUTE_DISORIENTATION, mod.LevelCurse.CURSE_OF_BLACKOUT, mod.LevelCurse.CURSE_OF_THE_CATACOMB)

                if curses & LevelCurse.CURSE_OF_LABYRINTH > 0 then
                    --print("Curse Of Labyrinth")
                    return mod.LevelCurse.CURSE_OF_THE_CATACOMB
                elseif curses & LevelCurse.CURSE_OF_THE_LOST > 0 then
                    --print("Curse Of The Lost")
                    return mod.LevelCurse.CURSE_OF_ABSOLUTE_DISORIENTATION
                elseif curses & LevelCurse.CURSE_OF_THE_UNKNOWN > 0 then
                    --print("Curse Of The Unknown")
                    return mod.LevelCurse.CURSE_OF_UNFATHOMABLE
                end
                --[[if curses & LevelCurse.CURSE_OF_DARKNESS > 0 then
                    print("Curse Of Darnkess")
                    return mod.LevelCurse.CURSE_OF_BLACKOUT
                elseif curses & LevelCurse.CURSE_OF_LABYRINTH > 0 then
                    print("Curse Of Labyrinth")
                    return mod.LevelCurse.CURSE_OF_THE_CATACOMB
                elseif curses & LevelCurse.CURSE_OF_THE_LOST > 0 then
                    print("Curse Of The Lost")
                    return mod.LevelCurse.CURSE_OF_ABSOLUTE_DISORIENTATION
                elseif curses & LevelCurse.CURSE_OF_THE_UNKNOWN > 0 then
                    print("Curse Of The Unknown")
                    return mod.LevelCurse.CURSE_OF_UNFATHOMABLE
                elseif curses & LevelCurse.CURSE_OF_MAZE > 0 then
                    print("Curse Of The Maze")
                    return mod.LevelCurse.CURSE_OF_UNPREDICTABILITY
                elseif curses & LevelCurse.CURSE_OF_BLIND > 0 then
                    print("Curse Of The Blind")
                    return mod.LevelCurse.CURSE_OF_VISIONLESS
                end]]
            end
        end
    end)



local function spawnItems()
    --print("Spawning items")
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod:getCollectibleFromRandomPool(false),
        Game():GetRoom():GetCenterPos() - Vector(-200, 300), Vector.Zero, nil)
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, mod:getCollectibleFromRandomPool(false),
        Game():GetRoom():GetCenterPos() - Vector(200, 300), Vector.Zero, nil)
end


mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    local curses = Game():GetLevel():GetCurses()
    if (curses & mod.LevelCurse.CURSE_OF_ABSOLUTE_DISORIENTATION > 0) or (curses & mod.LevelCurse.CURSE_OF_BLACKOUT > 0) or (curses & mod.LevelCurse.CURSE_OF_THE_CATACOMB > 0) or (curses & mod.LevelCurse.CURSE_OF_UNFATHOMABLE > 0) or (curses & mod.LevelCurse.CURSE_OF_UNPREDICTABILITY > 0) or (curses & mod.LevelCurse.CURSE_OF_VISIONLESS > 0) then
        spawnItems()
        --print("super curse detected")
    end
end)

----> Curse Of Blackout <----
mod:AddCallback(ModCallbacks.MC_GET_SHADER_PARAMS, function(_, shaderName)
    --[[ if shaderName == "CurseOfBlackLight" and Game():GetLevel():GetCurses() & mod.LevelCurse.CURSE_OF_BLACKOUT > 0 then
        local player = Isaac.GetPlayer()
        local screenPos = Isaac.WorldToScreen(player.Position)
        local params

        params = {
            PlayerPos = { screenPos.X, screenPos.Y },
            Radius = 0.01,
            Softness = 0.1,
            Ambient = 0.1
        }

        return params
    else
        return {}
    end]]
end)


----> Curse Of Blackout <----


----> Curse Of Catacomb <----

local rooms = Game():GetLevel():GetRooms()
local clearedRooms = 0
local function getRoomsCleared()
    for i = 0, rooms.Size - 1 do
        local room = rooms:Get(i)
        if room.Clear then
            clearedRooms = clearedRooms + 1
        end
    end
    return { clearedRooms, rooms.Size }
end

---@param door GridEntityDoor
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_UPDATE, function(_, door)
    if door.TargetRoomType == RoomType.ROOM_BOSS and getRoomsCleared()[1] <= getRoomsCleared()[2] - 4 and Game():GetLevel():GetCurses() & mod.LevelCurse.CURSE_OF_THE_CATACOMB > 0 then
        door:Close()
        door:Bar()
    end
end)

---@param door GridEntityDoor
mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_RENDER, function(_, door)
    if door.TargetRoomType == RoomType.ROOM_BOSS and getRoomsCleared()[1] <= getRoomsCleared()[2] - 4 and Game():GetLevel():GetCurses() & mod.LevelCurse.CURSE_OF_THE_CATACOMB > 0 then
        local hintTextPosition = Isaac.WorldToRenderPosition(Game():GetRoom():GetDoorSlotPosition(door.Slot) -
            Vector(25, 0))
        if hintTextPosition == nil then return end
        font:DrawStringScaled(
            "Curse Of The Catacomb is active!",
            hintTextPosition.X, hintTextPosition.Y, 0.75, 0.75, KColor(1, 1, 1, 1), 1, true)
        font:DrawStringScaled(
            " you first need to clear all rooms to access the boss",
            hintTextPosition.X, hintTextPosition.Y + 10, 0.75, 0.75, KColor(1, 1, 1, 1), 1, true)
    end
end)


mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    --getRoomsCleared()
    local roomDesc = Game():GetLevel():GetCurrentRoomDesc()
    if roomDesc.Data.Type == RoomType.ROOM_BOSS and getRoomsCleared()[1] <= getRoomsCleared()[2] - 4 and Game():GetLevel():GetCurses() & mod.LevelCurse.CURSE_OF_THE_CATACOMB > 0 then
        local startingRoomIndex = Game():GetLevel():GetStartingRoomIndex()
        Game():ChangeRoom(startingRoomIndex, -1)
        SFXManager():Play(SoundEffect.SOUND_BOSS2INTRO_ERRORBUZZ, 1.5, 2, false, 1.1)
    end
    --  renderHintText = false
end)

mod:AddCallback(ModCallbacks.MC_POST_ROOM_TRIGGER_CLEAR, function()
    if Game():GetLevel():GetCurses() & mod.LevelCurse.CURSE_OF_THE_CATACOMB > 0 then
        local currentRoomIndex = Game():GetLevel():GetCurrentRoomIndex()
        for doorSlot = 0, 7 do
            if Game():GetRoom():IsDoorSlotAllowed(doorSlot) then
                Game():GetLevel():MakeRedRoomDoor(currentRoomIndex, doorSlot)
            end
        end
    end
end)
----> Curse Of Catacomb <----


----> Curse Of The Absolute Disorientation <----

mod:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_RENDER, function()
    if (Game():GetLevel():GetCurses() & mod.LevelCurse.CURSE_OF_ABSOLUTE_DISORIENTATION > 0) then
        return false
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    if (Game():GetLevel():GetCurses() & mod.LevelCurse.CURSE_OF_ABSOLUTE_DISORIENTATION > 0) then
        local room = Game():GetRoom()
        room:SetFloorColor(mod:getRandomColor(true, 0.05))
    end
end)

----> Curse Of The Absolute Disorientation <----


----> Curse Of Unfathomable <----


mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    local roomDesc = Game():GetLevel():GetCurrentRoomDesc()
    --print("Room Desc: ", roomDesc.Clear)
    if roomDesc.Clear and (Game():GetLevel():GetCurses() & mod.LevelCurse.CURSE_OF_UNFATHOMABLE > 0) then
        Game():GetHUD():SetVisible(false)
    elseif not roomDesc.Clear and (Game():GetLevel():GetCurses() & mod.LevelCurse.CURSE_OF_UNFATHOMABLE > 0) then
        Game():GetHUD():SetVisible(true)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_ROOM_TRIGGER_CLEAR, function()
    if Game():GetLevel():GetCurses() & mod.LevelCurse.CURSE_OF_UNFATHOMABLE > 0 then
        Game():GetHUD():SetVisible(false)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function ()
   Game():GetHUD():SetVisible(true) 
end)

----> Curse Of Unfathomable <----


----> Curse Of Unpredictability <----



----> Curse Of Unpredictability <----


----> Curse Of Visionless <----



----> Curse Of Visionless <----
