local game = Game()
local level = game:GetLevel()
local dimension = level:GetDimension()

local forcedPrisonJumpsuitPickupSequence = false
local dirtyPrisonJumpsuitPedestal = nil


local player = Isaac.GetPlayer()
local coinAmount = 0
local keyAmount = 0
local bombAmount = 0


---@param player EntityPlayer
david_pack:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlags)
	if player:HasCollectible(david_pack.Collectible.DIRTY_PRISON_JUMPSUIT) then
		--print("Player Hearts: ", player:GetHearts(), player:GetRottenHearts())

		local copyCount = player:GetCollectibleNum(david_pack.Collectible.DIRTY_PRISON_JUMPSUIT)
		if cacheFlags & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed * (0.6 / copyCount)
		end

		if cacheFlags & CacheFlag.CACHE_LUCK == CacheFlag.CACHE_SPEED then
			player.Luck = player.Luck * (0.6 / copyCount)
		end

		if cacheFlags & CacheFlag.CACHE_SHOTSPEED == CacheFlag.CACHE_SHOTSPEED then
			if copyCount < 3 then
				player.ShotSpeed = player.ShotSpeed + (1.75 * copyCount)
			else
				player.ShotSpeed = player.ShotSpeed + (1.75 * 3)
			end
		end

		if cacheFlags & CacheFlag.CACHE_RANGE == CacheFlag.CACHE_RANGE then
			player.TearRange = player.TearRange * (0.6 / copyCount)
		end
	end
end)

local function startForcedPrisonJumpsuitPickupSquence()
	if forcedPrisonJumpsuitPickupSequence == true then
		return
	end

	player = Isaac.GetPlayer()
	coinAmount = player:GetNumCoins()
	keyAmount = player:GetNumKeys()
	bombAmount = player:GetNumBombs()

	player:AddCoins(-coinAmount)
	player:AddKeys(-keyAmount)
	player:AddBombs(-bombAmount)

	-- A lot of the forced prison jumpsuit pickup logic can be removed because it becomes redundant through this
	david_pack.actionsPermission.canUseActiveItem = false
	david_pack.actionsPermission.canUsePill = false
	david_pack.actionsPermission.canEnterTrapdoor = false
	david_pack.actionsPermission.canExitRoom = { false, 2 }
	david_pack.actionsPermission.canLeaveCreep = false

	forcedPrisonJumpsuitPickupSequence = true
end

david_pack:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, function(_, entityType, variant, subtype)
	level = Game():GetLevel()
	dimension = level:GetDimension()

	if dimension ~= Dimension.NORMAL then
		return
	end

	if entityType == 5 and variant == 100 and subtype == david_pack.Collectible.DIRTY_PRISON_JUMPSUIT then
		startForcedPrisonJumpsuitPickupSquence()
	end
end)

local function endPrisonJumpsuitSequence()
	forcedPrisonJumpsuitPickupSequence = false
	dirtyPrisonJumpsuitPedestal = nil
	player = Isaac.GetPlayer()
	player:AddCoins(coinAmount)
	player:AddKeys(keyAmount)
	player:AddBombs(bombAmount)
	david_pack.actionsPermission.canUseActiveItem = true
	david_pack.actionsPermission.canUsePill = true
	david_pack.actionsPermission.canEnterTrapdoor = true
	david_pack.actionsPermission.canExitRoom = { true, 0 }
end

---@param player EntityPlayer
david_pack:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, collectibleType, _, first_time, _, _, player)
	if
		collectibleType == david_pack.Collectible.DIRTY_PRISON_JUMPSUIT
		and forcedPrisonJumpsuitPickupSequence == true
		and first_time
	then
		Game():GetItemPool():RemoveCollectible(david_pack.Collectible.PRISON_JUMPSUIT)
		endPrisonJumpsuitSequence()
	end
end)

---@param tear EntityTear
david_pack:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
	player = Isaac.GetPlayer()
	if player:HasCollectible(david_pack.Collectible.DIRTY_PRISON_JUMPSUIT) then
		tear.Mass = tear.Mass / 6.5
	end
end)

david_pack:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function(_, continued)
	if continued then
	else
		forcedPrisonJumpsuitPickupSequence = false
		dirtyPrisonJumpsuitPedestal = nil
		david_pack.actionsPermission.canUseActiveItem = true
		david_pack.actionsPermission.canUsePill = true
		david_pack.actionsPermission.canEnterTrapdoor = true
		david_pack.actionsPermission.canExitRoom = { true, 0 }
		david_pack.actionsPermission.canLeaveCreep = true
	end
end)

david_pack:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, function(_, entityType, variant, subtype)
	level = Game():GetLevel()
	dimension = level:GetDimension()

	if dimension ~= Dimension.NORMAL then
		return
	end

	if variant == 100 and subtype == david_pack.Collectible.DIRTY_PRISON_JUMPSUIT then
		startForcedPrisonJumpsuitPickupSquence()
	end
end)

david_pack:AddCallback(ModCallbacks.MC_PRE_USE_CARD, function(_, card, player)
	if card == Card.CARD_GET_OUT_OF_JAIL and forcedPrisonJumpsuitPickupSequence then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE and entity.SubType == david_pack.Collectible.DIRTY_PRISON_JUMPSUIT then
				local poopTransformationItems = david_pack:getCollectiblesWithATag(ItemConfig.TAG_POOP)
				local randomtablePos = math.random(1, #poopTransformationItems)
				entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
					poopTransformationItems[randomtablePos], false, false, true)
				endPrisonJumpsuitSequence()
			end
		end
	elseif forcedPrisonJumpsuitPickupSequence then
		player:AddCard(card)
		return false
	end
end)

---@param pickup EntityPickup
david_pack:AddCallback(ModCallbacks.MC_PRE_PICKUP_UPDATE, function(_, pickup)
	if not forcedPrisonJumpsuitPickupSequence then return end


	if pickup.Variant == 100 and pickup.SubType == david_pack.Collectible.DIRTY_PRISON_JUMPSUIT then
		if dirtyPrisonJumpsuitPedestal == nil then
			dirtyPrisonJumpsuitPedestal = pickup
		end
	elseif pickup.Variant == 100 and pickup.SubType ~= david_pack.Collectible.DIRTY_PRISON_JUMPSUIT then
		if dirtyPrisonJumpsuitPedestal ~= nil then
			pickup.SubType = david_pack.Collectible.DIRTY_PRISON_JUMPSUIT
		end
	else
		endPrisonJumpsuitSequence()
	end
end)

---@param entity Entity
---@param flags DamageFlag
---@param entityRef EntityRef
david_pack:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(_, entity, amount, flags, entityRef, damageCountdown)
	--print("damage: ", entity, amount, flags, entityRef, damageCountdown)
	if entity.Type == EntityType.ENTITY_PLAYER and entity:ToPlayer():HasCollectible(david_pack.Collectible.DIRTY_PRISON_JUMPSUIT) then
		if flags == DamageFlag.DAMAGE_POOP or flags == DamageFlag.DAMAGE_ACID then
			--print("trigger damage")
			entity:ToPlayer():TakeDamage(1, DamageFlag.DAMAGE_NO_PENALTIES, entityRef, damageCountdown)
		end
	end
end)

---@param pickup EntityPickup
david_pack:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, function(_, pickup)
	if Isaac.GetPlayer():HasCollectible(david_pack.Collectible.DIRTY_PRISON_JUMPSUIT) and pickup.Variant == PickupVariant.PICKUP_HEART and (pickup.SubType == HeartSubType.HEART_FULL or pickup.SubType == HeartSubType.HEART_FULL) then
		pickup:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, HeartSubType.HEART_ROTTEN)
	end
end)


if EID then
	local function dirtyPrisonJumpsuitModifierCondition(descObj)
		if descObj.ObjType == 5 and descObj.ObjVariant == 100 and descObj.ObjSubType == david_pack.Collectible.DIRTY_PRISON_JUMPSUIT then return true end
	end
	local function dirtyPrisonJumpsuitModifierCallback(descObj)
		EID:appendToDescription(descObj,
			"#{{ModIcon}} Can be transformed in to a random Oh Crap transformation item by using a {{Card47}} Get Out Of Jail Free Card effectively avoiding it")
		return descObj
	end

	EID:addDescriptionModifier("dirtyPrisonJumpsuit_getOutOfJailCard", dirtyPrisonJumpsuitModifierCondition,
		dirtyPrisonJumpsuitModifierCallback)
end