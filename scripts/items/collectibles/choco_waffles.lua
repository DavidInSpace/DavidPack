local sfx = SFXManager()

local function calculateChocoWaffleVelocity(direction)
    if direction == Direction.UP then
        return Vector(0, -30)
    elseif direction == Direction.RIGHT then
        return Vector(30, 0)
    elseif direction == Direction.DOWN then
        return Vector(0, -30)
    elseif direction == Direction.LEFT then
        return Vector(-30, 0)
    end
    
end


function david_pack:onChocoWafflesPickup()
end

function david_pack:onChocoWafflesRemove()

end

local function giveEntityChocoWafflesEffect(entityType, variant, subType, gridIndex, seed)
    local player = Isaac.GetPlayer()
    if entityType == 1000 or entityType == 999 or entityType == 17 or entityType < 10 or not player:HasCollectible(david_pack.Collectible.ChocoWaffles) then return end
    local entityList = Isaac.FindInRadius(player.Position, 50, EntityPartition.ENEMY)
    for _, roomEntity in pairs(Isaac.GetRoomEntities()) do
        for _, entity in pairs(entityList) do
            --print("Entities: ", entity, roomEntity)
            if roomEntity == entity then
                roomEntity:GetData().canIHaveChocolateWafflesEffect = true
                break
            else
                roomEntity:GetData().canIHaveChocolateWafflesEffect = false
                break
            end
        end
    end
end

local chocolateWafflesSprite = Sprite()
chocolateWafflesSprite:Load("gfx/choco_waffles_sprites.anm2", true)
chocolateWafflesSprite:Play("EffectIcon", true)

---@param npc EntityNPC
function david_pack:ChocoWafflesEffectIconRender(npc)
    if npc:GetData().canIHaveChocolateWafflesEffect == false then
        local position = Isaac.WorldToScreen(npc.Position)
        chocolateWafflesSprite:Render(position + Vector(0, -30), Vector(0, 0), Vector(0, 0))
    end
end

---@param player EntityPlayer
function david_pack:useChocolateWaffles(_, _, player)
    Isaac.Spawn(EntityType.ENTITY_TEAR, david_pack.Tear.CHOCO_WAFFLES_TEAR, 100, player.Position, calculateChocoWaffleVelocity(player:GetFireDirection()), player)
    
end


function david_pack:chocolateWafflesCollision()
    
end

--david_pack:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, david_pack.giveEntityChocoWafflesEffect)
david_pack:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, david_pack.onChocoWafflesPickup,
    david_pack.Collectible.ChocoWaffles)
david_pack:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, david_pack.onChocoWafflesRemove,
    david_pack.Collectible.ChocoWaffles)
david_pack:AddCallback(ModCallbacks.MC_POST_NPC_RENDER, david_pack.ChocoWafflesEffectIconRender)
david_pack:AddCallback(ModCallbacks.MC_USE_ITEM, david_pack.useChocolateWaffles, david_pack.Collectible.CHOCO_WAFFLES)
david_pack:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, david_pack.chocolateWafflesCollision)
