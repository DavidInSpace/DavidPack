david_pack.actionsPermission = {
    canUseActiveItem = true,                      -- Isaac can not use active items
    canUseCard = true,                            -- This includes runes
    canUnlockDoors = true,                        -- Does not work currently
    canUseSlots = true,                           -- Wheter isaac can interact with slot machines
    canUsePill = true,
    canDrop = { true, true },                     -- Trinket, Pocket Item
    canPlaceBomb = true,
    canPickupCollectible = { true, true },        -- CanPickupCollectible, IgnoreStoryItems
    canPickupPickup = { true, true, true, true }, -- Hearts, Coins, Bombs, Keys [set everything to false to make isaac not able to pickup any pickups including batteries, poop, and such]
    canShoot = { true, true, true, true },        -- Up, Right, Down, Left (only the first value does something as of now)
    canMove = { true, true, true, true },         -- Up, Right, Down, Left (only the first value does something as of now)
    canExitRoom = { true, 0 },                    -- 0 Doors will stay open but isaac wont be able to leave -- 1 Doors Get Closed -- 2 Doors Get Closed With Bars On Them
    canEnterTrapdoor = true,
    canReroll = true,                             -- This will stop ALL pickups from morphing including the ones which are trying to be morphed with EntityPickup:Morph()
    canTakeDamage = true,                         -- Add an option to configure which damage types specificly to ignore
    canToggleFullscreen = true,
    canLeaveCreep = true,                         -- Items that make Isaac leave creep do not work
}

function david_pack:resetActionsPermission()
    david_pack.actionsPermission.canExitRoom = { true, 0 }
end

local function returnInputHook(inputHook)
    if inputHook == InputHook.IS_ACTION_PRESSED then
        return false
    elseif inputHook == InputHook.IS_ACTION_TRIGGERED then
        return false
    elseif inputHook == InputHook.GET_ACTION_VALUE then
        return 0
    end
end


function david_pack:preventActiveItemUse()
    if not david_pack.actionsPermission.canUseActiveItem then
        return 99999
    end
end

---@param player EntityPlayer
function david_pack:preventCardUse(cardID, player)
    if not david_pack.actionsPermission.canUseCard then
        player:AddCard(cardID)
        return false
    end
end

---@param player EntityPlayer
function david_pack:preventPillUse(pillEffectID, pillColorID, player)
    if not david_pack.actionsPermission.canUsePill then
        player:AddPill(pillColorID)
        return false
    end
end

---@param player EntityPlayer
---@param collider Entity
function david_pack:preventShopPurchase(player, collider)
    if not david_pack.actionsPermission.canBuy and collider.Type == EntityType.ENTITY_PICKUP and collider.Variant == PickupVariant.PICKUP_SHOPITEM then
        return true
    end
end

function david_pack:preventDoorUnlock()
    if not david_pack.actionsPermission.canUnlockDoors then
        for doorSlot = 0, 3 do
            local door = Game():GetRoom():GetDoor(doorSlot)
            if door ~= nil and door.TargetRoomType ~= 7 and door.TargetRoomType ~= 8 and door.TargetRoomType ~= 29 and door:IsLocked() then
                door:SetLocked(true)
                return false
            end
        end
    end
end

function david_pack:preventSlotUse()
    if not david_pack.actionsPermission.canUseSlots then
        return true
    end
end

function david_pack:preventDrop(_, inputHook, buttonAction)
    david_pack.actionsPermission.canDrop = david_pack.actionsPermission.canDrop or true
    if not david_pack.actionsPermission.canDrop[1] then

    end
end

function david_pack:preventBombPlace(_, inputHook, buttonAction)
    if not david_pack.actionsPermission.canPlaceBomb and buttonAction == ButtonAction.ACTION_BOMB then
        return returnInputHook(inputHook)
    end
end

---@param entityPickup EntityPickup
function david_pack:preventCollectiblePickup(entityPickup)
    if not david_pack.actionsPermission.canPickupCollectible[1] and not david_pack.actionsPermission.canPickupCollectible[2] and entityPickup.Variant == 100 then
        return false
    elseif not david_pack.actionsPermission.canPickupCollectible[1] and david_pack.actionsPermission.canPickupCollectible[2] and entityPickup.Variant == 100 then
        local itemConfig = Isaac.GetItemConfig()
        if itemConfig:GetCollectible(entityPickup.SubType).Tags == ItemConfig.TAG_QUEST then
            return nil
        else
            return false
        end
    end
end

---@param entityPickup EntityPickup
function david_pack:preventPickupPickup(entityPickup)
    if entityPickup.Variant == 100 then return nil end
    if not david_pack.actionsPermission.canPickupPickup[1] and not david_pack.actionsPermission.canPickupPickup[2] and not david_pack.actionsPermission.canPickupPickup[3] and not david_pack.actionsPermission.canPickupPickup[4] then
        return false
    elseif not david_pack.actionsPermission.canPickupPickup[1] and entityPickup.Variant == 10 then
        return false
    elseif not david_pack.actionsPermission.canPickupPickup[2] and entityPickup.Variant == 20 then
        return false
    elseif not david_pack.actionsPermission.canPickupPickup[3] and entityPickup.Variant == 40 then
        return false
    elseif not david_pack.actionsPermission.canPickupPickup[4] and entityPickup.Variant == 30 then
        return false
    end
end

function david_pack:preventShooting(_, inputHook, buttonAction)
    if not david_pack.actionsPermission.canShoot[1] and buttonAction == ButtonAction.ACTION_SHOOTUP then
        return returnInputHook(inputHook)
    elseif not david_pack.actionsPermission.canShoot[2] and buttonAction == ButtonAction.ACTION_SHOOTRIGHT then
        return returnInputHook(inputHook)
    elseif not david_pack.actionsPermission.canShoot[3] and buttonAction == ButtonAction.ACTION_SHOOTDOWN then
        return returnInputHook(inputHook)
    elseif not david_pack.actionsPermission.canShoot[4] and buttonAction == ButtonAction.ACTION_SHOOTLEFT then
        return returnInputHook(inputHook)
    end
end

function david_pack:preventMoving(_, inputHook, buttonAction)
    --[[if not david_pack.actionsPermission.canMove[1] and (buttonAction == ButtonAction.ACTION_UP or buttonAction == ButtonAction.ACTION_RIGHT or buttonAction == ButtonAction.ACTION_DOWN or buttonAction == ButtonAction.ACTION_LEFT) then
        return returnInputHook(inputHook)
    end]]
    --david_pack.actionsPermission.canMove = david_pack.actionsPermission.canMove or {true, true, true, true}
    if not david_pack.actionsPermission.canMove[1] and buttonAction == ButtonAction.ACTION_UP then
        return returnInputHook(inputHook)
    elseif not david_pack.actionsPermission.canMove[2] and buttonAction == ButtonAction.ACTION_RIGHT then
        return returnInputHook(inputHook)
    elseif not david_pack.actionsPermission.canMove[3] and buttonAction == ButtonAction.ACTION_DOWN then
        return returnInputHook(inputHook)
    elseif not david_pack.actionsPermission.canMove[4] and buttonAction == ButtonAction.ACTION_LEFT then
        return returnInputHook(inputHook)
    end
end

local canGetRoomIndex = true
local trappedRoomData = { Game():GetLevel():GetCurrentRoomIndex(), Game():GetLevel():GetDimension() }

---@param door GridEntityDoor
function david_pack:preventRoomExit(door)
    if not david_pack.actionsPermission.canExitRoom[1] then
        if canGetRoomIndex then
            trappedRoomData = { Game():GetLevel():GetCurrentRoomIndex(), Game():GetLevel():GetDimension() }
            canGetRoomIndex = false
        end

        if trappedRoomData[1] ~= Game():GetLevel():GetCurrentRoomIndex() then
            Game():ChangeRoom(trappedRoomData[1], trappedRoomData[2])
            return false
        end

        if door == nil or door.TargetRoomType == 7 or door.TargetRoomType == 8 or door.TargetRoomType == 29 then return end
        if david_pack.actionsPermission.canExitRoom[2] == 2 then
            door:Close(true)
            door:Bar()
        elseif david_pack.actionsPermission.canExitRoom[2] == 1 then
            door:Close(true)
        end
    else
        canGetRoomIndex = true
    end
end

function david_pack:preventTrapdoorEnter()
    if not david_pack.actionsPermission.canEnterTrapdoor then
        return false
    end
end

function david_pack:preventReroll()
    if not david_pack.actionsPermission.canReroll then
        return false
    end
end

function david_pack:preventDamage()
    if not david_pack.actionsPermission.canTakeDamage then
        return false
    end
end

function david_pack:preventToggleFullscreen(_, inputHook, buttonAction)
    if not david_pack.actionsPermission.canToggleFullscreen and buttonAction == ButtonAction.ACTION_FULLSCREEN then
        return returnInputHook(inputHook)
    end
end

function david_pack:preventRestart(_, inputHook, buttonAction)
    if not david_pack.actionsPermission.canRestart and buttonAction == ButtonAction.ACTION_RESTART then
        return returnInputHook(inputHook)
    end
end

function david_pack:preventCreepSpawn(effect) -- only applies to player creep
    --print("EFFECT: ", effect.Variant, david_pack.actionsPermission.canLeaveCreep)

    if not david_pack.actionsPermission.canLeaveCreep then
        if EntityEffect.IsPlayerCreep(effect.Variant) then
            effect:Remove()
            return false
        end
    end
end

david_pack:AddCallback(ModCallbacks.MC_PLAYER_GET_ACTIVE_MIN_USABLE_CHARGE, david_pack.preventActiveItemUse)
david_pack:AddCallback(ModCallbacks.MC_PRE_USE_CARD, david_pack.preventCardUse)
david_pack:AddCallback(ModCallbacks.MC_PRE_USE_PILL, david_pack.preventPillUse)
david_pack:AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, david_pack.preventShopPurchase)
david_pack:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_UPDATE, david_pack.preventDoorUnlock)
david_pack:AddCallback(ModCallbacks.MC_PRE_SLOT_COLLISION, david_pack.preventSlotUse)
david_pack:AddCallback(ModCallbacks.MC_INPUT_ACTION, david_pack.preventDrop)
david_pack:AddCallback(ModCallbacks.MC_INPUT_ACTION, david_pack.preventBombPlace)
david_pack:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, david_pack.preventCollectiblePickup)
david_pack:AddCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, david_pack.preventPickupPickup)
david_pack:AddCallback(ModCallbacks.MC_INPUT_ACTION, david_pack.preventShooting) -- will probably require callback MC_POST_TEAR_INIT too
david_pack:AddCallback(ModCallbacks.MC_INPUT_ACTION, david_pack.preventMoving)
david_pack:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_DOOR_UPDATE, david_pack.preventRoomExit)
david_pack:AddCallback(ModCallbacks.MC_PRE_GRID_ENTITY_TRAPDOOR_UPDATE, david_pack.preventTrapdoorEnter)
david_pack:AddCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, david_pack.preventReroll)
david_pack:AddCallback(ModCallbacks.MC_PRE_PLAYER_TAKE_DMG, david_pack.preventDamage)
david_pack:AddCallback(ModCallbacks.MC_INPUT_ACTION, david_pack.preventToggleFullscreen)
david_pack:AddCallback(ModCallbacks.MC_INPUT_ACTION, david_pack.preventRestart)
david_pack:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, david_pack.preventCreepSpawn)

david_pack:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, david_pack.resetActionsPermission)
