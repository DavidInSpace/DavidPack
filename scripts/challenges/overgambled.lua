--[[local mod = david_pack

-- {Type ,Variant}
local MONEY_ENEMIES = {
    { type = 50,  variant = 1, chance = 1 },  -- Super Greed
    { type = 50,  variant = 0, chance = 6 },  -- Greed
    { type = 299, variant = 0, chance = 32 }, -- Greed Gaper
    { type = 86,  variant = 0, chance = 68 }, -- Keeper
    { type = 293, variant = 0, chance = 147 } -- Ultra Greed Coin (Spinner)
}

mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, function(_)
    if Isaac.GetChallenge() ~= mod.Challenge.OVERGAMBLED then return end
    Isaac.GetPlayer():SetPocketActiveItem(CollectibleType.COLLECTIBLE_PORTABLE_SLOT, ActiveSlot.SLOT_POCKET, false)
end)


---@param slot LevelGeneratorRoom
---@param roomConfig RoomConfigRoom
mod:AddCallback(ModCallbacks.MC_PRE_LEVEL_PLACE_ROOM, function(_, slot, roomConfig, seed)
    --if Isaac.GetChallenge() ~= mod.Challenge.OVERGAMBLED then return end
    --if roomConfig.Type == RoomType.ROOM_TREASURE or roomConfig.Type == RoomType.ROOM_CURSE or roomConfig.Type == RoomType.ROOM_SACRIFICE or roomConfig.Type == RoomType.ROOM_CHEST or roomConfig.Type == RoomType.ROOM_DICE or roomConfig.Type == RoomType.ROOM_CHALLENGE then
        --print("replacing room")
        --local room = RoomConfig.GetRandomRoom(seed, false, StbType.BASEMENT, RoomType.ROOM_TREASURE)
        print(room)
        return room
    --end
end)

mod:AddCallback(ModCallbacks.MC_PRE_ROOM_ENTITY_SPAWN, function(_, type, variant, subType, gridIndex, seed)
    if Isaac.GetChallenge() ~= mod.Challenge.OVERGAMBLED then return end
    local roomEnemeies = mod:getRoomEnemies(true)
    local chance = math.random(1, 100)
    for _, enemy in pairs(roomEnemeies) do
        if chance <= 10 then
            local monster_chance = math.random(1, 147)
            if monster_chance > MONEY_ENEMIES[4].chance and monster_chance <= MONEY_ENEMIES[5].chance then
                Isaac.Spawn(MONEY_ENEMIES[5].type, MONEY_ENEMIES[5].variant, 0, enemy.Position, Vector.Zero, enemy)
            elseif monster_chance > MONEY_ENEMIES[3].chance and monster_chance <= MONEY_ENEMIES[4].chance then
                Isaac.Spawn(MONEY_ENEMIES[4].type, MONEY_ENEMIES[4].variant, 0, enemy.Position, Vector.Zero, enemy)
            elseif monster_chance > MONEY_ENEMIES[2].chance and monster_chance <= MONEY_ENEMIES[3].chance then
                Isaac.Spawn(MONEY_ENEMIES[3].type, MONEY_ENEMIES[3].variant, 0, enemy.Position, Vector.Zero, enemy)
            elseif monster_chance > MONEY_ENEMIES[1].chance and monster_chance <= MONEY_ENEMIES[2].chance then
                Isaac.Spawn(MONEY_ENEMIES[2].type, MONEY_ENEMIES[2].variant, 0, enemy.Position, Vector.Zero, enemy)
            elseif monster_chance <= MONEY_ENEMIES[1].chance then
                Isaac.Spawn(MONEY_ENEMIES[1].type, MONEY_ENEMIES[1].variant, 0, enemy.Position, Vector.Zero, enemy)
            end
        end
    end
end)]]
