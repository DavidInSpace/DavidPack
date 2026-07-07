local mod = david_pack
local sfx = SFXManager()

---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlags)
    if player:HasTrinket(david_pack.Trinket.RGB_COUNTDOWN) then
        local runSave = mod.SaveManager.GetRunSave()

        if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
            if runSave.rgb_countdown_number > 0 then
                player.Damage = player.Damage + runSave.rgb_countdown_number
            else
                player.Damage = player.Damage - 1
            end
        end

        if cacheFlags & CacheFlag.CACHE_LUCK == CacheFlag.CACHE_LUCK then
            if runSave.rgb_countdown_number > 0 then
                player.Luck = player.Luck + runSave.rgb_countdown_number
            else
                player.Luck = player.Luck - 1
            end
        end

        if cacheFlags & CacheFlag.CACHE_RANGE == CacheFlag.CACHE_RANGE then
            if runSave.rgb_countdown_number > 0 then
                player.TearRange = player.TearRange + runSave.rgb_countdown_number * 400
            else
                player.TearRange = player.TearRange - 1 * 400
            end
        end

        if cacheFlags & CacheFlag.CACHE_SIZE == CacheFlag.CACHE_SIZE then
            if runSave.rgb_countdown_number > 0 then
                player.Size = player.Size + runSave.rgb_countdown_number * 100
            else
                player.Size = player.Size - 1 * 100
            end
        end
    end
end)


---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_PRE_PLAYERHUD_TRINKET_RENDER, function(_, slot, position, scale, player, cropOffset)
    --print("trinket render", player:HasTrinket(mod.Trinket.RGB_COUNTDOWN))
    if player:HasTrinket(mod.Trinket.RGB_COUNTDOWN) then
        local runSave = mod.SaveManager.GetRunSave()
        if runSave.rgb_countdown_number == 0 then
            return { CropOffset = Vector(96, 0) }
        elseif runSave.rgb_countdown_number == 1 then
            return { CropOffset = Vector(64, 0) }
        elseif runSave.rgb_countdown_number == 2 then
            return { CropOffset = Vector(32, 0) }
        elseif runSave.rgb_countdown_number == 3 then
            return { CropOffset = Vector(0, 0) }
        end
    elseif not player:HasTrinket(TrinketType.TRINKET_MONKEY_PAW) and not player:HasTrinket(mod.Trinket.PINK_COUNTDOWN) and not player:HasTrinket(mod.Trinket.ORANGE_COUNTDOWN) and not player:HasTrinket(mod.Trinket.RGB_COUNTDOWN) then
        return { CropOffset = Vector(0, 0) }
    end
end)

---@param player EntityPlayer
local function addCache(player)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
    player:AddCacheFlags(CacheFlag.CACHE_LUCK)
    player:AddCacheFlags(CacheFlag.CACHE_RANGE)
    player:AddCacheFlags(CacheFlag.CACHE_SIZE)
end

function mod:rgbCountdown()
    local room = Game():GetRoom()
    local player = Isaac.GetPlayer()
    if player == nil or not player:HasTrinket(mod.Trinket.RGB_COUNTDOWN) then return end
    local runSave = mod.SaveManager.GetRunSave()
    runSave.rgb_countdown_number = runSave.rgb_countdown_number or 3
    runSave.rgb_countdown_number = runSave.rgb_countdown_number - 1

    sfx:Play(SoundEffect.SOUND_1UP, 1, 2, false, math.random(60, 80) / 100)

    if runSave.rgb_countdown_number == 3 then
        addCache(player)
    elseif runSave.rgb_countdown_number == 2 then
        addCache(player)
    elseif runSave.rgb_countdown_number == 1 then
       addCache(player)
    elseif runSave.rgb_countdown_number == 0 then
        addCache(player)
    elseif runSave.rgb_countdown_number < 0 then
        runSave.rgb_countdown_number = 3
        addCache(player)
    end
    local count = Isaac.GetFrameCount()
    mod.wait.new("wait_rgb_count_down", count, math.random(120, 2400), mod.rgbCountdown)
    print("rgb count down", runSave.rgb_countdown_number)
end

---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_TRINKET_ADDED, function(_, player, trinketType, firstTime)
    print(mod.SaveManager.GetRunSave().rgb_countdown_number)
    mod.SaveManager.GetRunSave().rgb_countdown_number = 4
    mod:rgbCountdown()
end, mod.Trinket.RGB_COUNTDOWN)


---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_DROP_TRINKET, function(_, _, _, player, _, _, droppedTrinket)
    print(mod.SaveManager.GetRunSave().rgb_countdown_number)
    if mod.SaveManager.GetRunSave().rgb_countdown_number ~= nil and mod.SaveManager.GetRunSave().rgb_countdown_number ~= 3 then
        droppedTrinket:Remove()
        player:AddTrinket(mod.Trinket.RGB_COUNTDOWN)
    else
        mod.wait.remove("wait_rgb_count_down")
    end
end, mod.Trinket.RGB_COUNTDOWN)
