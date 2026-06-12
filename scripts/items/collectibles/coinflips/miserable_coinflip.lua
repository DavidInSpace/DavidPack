local sfx = SFXManager()

local player = Isaac.GetPlayer()

local function calculateCoinflipStats(success)
    local playerEffects = player:GetEffects()
    if success then
        if playerEffects:GetNullEffectNum(david_pack.NullItem.MISERABLE_COINFLIP_DOWN) > 0 then
            playerEffects:RemoveNullEffect(david_pack.NullItem.MISERABLE_COINFLIP_DOWN)
        else
            playerEffects:AddNullEffect(david_pack.NullItem.MISERABLE_COINFLIP_UP)
        end
    else
        if playerEffects:GetNullEffectNum(david_pack.NullItem.MISERABLE_COINFLIP_UP) > 0 then
            playerEffects:RemoveNullEffect(david_pack.NullItem.MISERABLE_COINFLIP_UP)
        else
            playerEffects:AddNullEffect(david_pack.NullItem.MISERABLE_COINFLIP_DOWN)
        end
    end
end

local function flipCoin()
    player = Isaac.GetPlayer()
    local random = math.random(1, 10)
    if random <= 5 then
        sfx:Play(SoundEffect.SOUND_THUMBSUP, 1, 0, false, math.random(90, 105) / 100, 0)
        calculateCoinflipStats(true)
    elseif random > 5 then
        sfx:Play(SoundEffect.SOUND_THUMBS_DOWN, 1, 0, false, math.random(90, 105) / 100, 0)
        calculateCoinflipStats(false)
    end
end


function david_pack:useMiserableCoinflip(itemID, _, _, _, activeSlot)
    player = Isaac.GetPlayer()
    local activeItemCharges = player:GetActiveCharge(activeSlot)
    if activeItemCharges >= 2 then
        player:SetActiveCharge(activeItemCharges - 1, activeSlot)
        flipCoin()
    else
        flipCoin()
        player:RemoveCollectible(itemID, false, activeSlot, false)
    end
end

function david_pack:onMiserableCoinflip(itemID, _, _, _, activeSlot)
    return {
        Discharge = false,
        Remove = false,
        ShowAnim = true,
    }
end

david_pack:AddCallback(ModCallbacks.MC_USE_ITEM, david_pack.onMiserableCoinflip, david_pack.Collectible.MISERABLE_COINFLIP)
david_pack:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, david_pack.useMiserableCoinflip, david_pack.Collectible.MISERABLE_COINFLIP)