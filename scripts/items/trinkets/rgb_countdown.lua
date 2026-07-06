local mod = david_pack
local sfx = SFXManager()



---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlags)
    if player:HasTrinket(david_pack.Trinket.RGB_COUNTDOWN) then
        local runSave = mod.SaveManager.GetRunSave()

        if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
            if runSave.rgb_countdown_number > 0 then
                player.Damage = player.Damage * runSave.rgb_countdown_number
            else
                player.Damage = player.Damage * 0.4
            end
        end

        if cacheFlags & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED then
            if runSave.rgb_countdown_number > 0 then
                player.MoveSpeed = player.MoveSpeed * runSave.rgb_countdown_number
            else
                player.MoveSpeed = player.MoveSpeed * 0.4
            end
        end

        if cacheFlags & CacheFlag.CACHE_LUCK == CacheFlag.CACHE_LUCK then
            if runSave.rgb_countdown_number > 0 then
                player.Luck = player.Luck * runSave.rgb_countdown_number
            else
                player.Luck = player.Luck * 0.25
            end
        end

        if cacheFlags & CacheFlag.CACHE_FIREDELAY == CacheFlag.CACHE_FIREDELAY then
            if runSave.rgb_countdown_number > 0 then
                player.MaxFireDelay = player.MaxFireDelay * runSave.rgb_countdown_number
            else
                player.MaxFireDelay = player.MaxFireDelay * 1.25
            end
        end

        if cacheFlags & CacheFlag.CACHE_SHOTSPEED == CacheFlag.CACHE_SHOTSPEED then
            if runSave.rgb_countdown_number > 0 then
                player.ShotSpeed = player.ShotSpeed * runSave.rgb_countdown_number
            else
                player.ShotSpeed = player.ShotSpeed * 0.35
            end
        end

        if cacheFlags & CacheFlag.CACHE_RANGE == CacheFlag.CACHE_RANGE then
            if runSave.rgb_countdown_number > 0 then
                player.TearRange = player.TearRange * runSave.rgb_countdown_number
            else
                player.TearRange = player.TearRange * 0.4
            end
        end

        if cacheFlags & CacheFlag.CACHE_SIZE == CacheFlag.CACHE_SIZE then
            if runSave.rgb_countdown_number > 0 then
                player.Size = player.Size * runSave.rgb_countdown_number
            else
                player.Size = player.Size * 0.35
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


function mod:rgbCountdown()
    local room = Game():GetRoom()
    local player = Isaac.GetPlayer()
    if player == nil or not player:HasTrinket(mod.Trinket.RGB_COUNTDOWN) then return end
    local runSave = mod.SaveManager.GetRunSave()
    runSave.rgb_countdown_number = runSave.rgb_countdown_number or 3
    runSave.rgb_countdown_number = runSave.rgb_countdown_number - 1

    if runSave.rgb_countdown_number == 3 then
        mod:addRandomCache(math.random(2, 4))
    elseif runSave.rgb_countdown_number == 2 then
        mod:addRandomCache(math.random(2, 4))
    elseif runSave.rgb_countdown_number == 1 then
        mod:addRandomCache(math.random(2, 4))
    elseif runSave.rgb_countdown_number == 0 then
        mod:addRandomCache(math.random(2, 4))
    elseif runSave.rgb_countdown_number < 0 then
        runSave.rgb_countdown_number = 3
        mod:addRandomCache(math.random(2, 4))
    end
    local count = Isaac.GetFrameCount()
    mod.wait.new("wait_rgb_count_down", count, math.random(120, 1200), mod.rgbCountdown)
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
    if mod.SaveManager.GetRunSave().rgb_countdown_number ~= nil and mod.SaveManager.GetRunSave().rgb_countdown_number == 0 then
        droppedTrinket:Remove()
        player:AddTrinket(mod.Trinket.RGB_COUNTDOWN)
    else
        mod.wait.remove("wait_rgb_count_down")
    end
end, mod.Trinket.RGB_COUNTDOWN)
