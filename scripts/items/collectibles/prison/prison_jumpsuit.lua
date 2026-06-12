local game = Game()
local level = game:GetLevel()
local dimension = level:GetDimension()

local forcedPrisonJumpsuitPickupSequence = false
local prisonJumpsuitPedestal = nil

local player = Isaac.GetPlayer()
local coinAmount = 0
local keyAmount = 0
local bombAmount = 0


---@param player EntityPlayer
david_pack:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlags)
	if player:HasCollectible(david_pack.Collectible.PRISON_JUMPSUIT) then
		local copyCount = player:GetCollectibleNum(david_pack.Collectible.PRISON_JUMPSUIT)

		if cacheFlags & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed * (0.7 / copyCount)
		end

		if cacheFlags & CacheFlag.CACHE_LUCK == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck * (0.7 / copyCount)
		end

		if cacheFlags & CacheFlag.CACHE_SHOTSPEED == CacheFlag.CACHE_SHOTSPEED then
			player.ShotSpeed = player.ShotSpeed + (1.25 * copyCount)
		end

		if cacheFlags & CacheFlag.CACHE_RANGE == CacheFlag.CACHE_RANGE then
			player.TearRange = player.TearRange * (0.7 / copyCount)
		end
	end
end)

local function startFrocedPrisonJumpsuitPickupSquence()
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

	forcedPrisonJumpsuitPickupSequence = true
end


function david_pack:prisonJumpsuitEntitySpawn(entityType, variant, subtype)
	level = Game():GetLevel()
	dimension = level:GetDimension()

	if dimension ~= Dimension.NORMAL then
		return
	end

	if entityType == 5 and variant == 100 and subtype == david_pack.Collectible.PRISON_JUMPSUIT then
		startFrocedPrisonJumpsuitPickupSquence()
	end
end

local function endPrisonJumpsuitSequence()
	forcedPrisonJumpsuitPickupSequence = false
	prisonJumpsuitPedestal = nil
	player = Isaac.GetPlayer()
	player:AddCoins(coinAmount)
	player:AddKeys(keyAmount)
	player:AddBombs(bombAmount)
	david_pack.actionsPermission.canUseActiveItem = true
	david_pack.actionsPermission.canUsePill = true
	david_pack.actionsPermission.canEnterTrapdoor = true
	david_pack.actionsPermission.canExitRoom = { true, 0 }
end

function david_pack:prisonJumpsuitPickup(collectibleType, _, first_time)
	if
		collectibleType == david_pack.Collectible.PRISON_JUMPSUIT
		and forcedPrisonJumpsuitPickupSequence == true
		and first_time
	then
		Game():GetItemPool():RemoveCollectible(david_pack.Collectible.DIRTY_PRISON_JUMPSUIT)
		endPrisonJumpsuitSequence()
	end
end

function david_pack:resetPrisonJumpsuit(_, continued)
	if continued then
	else
		forcedPrisonJumpsuitPickupSequence = false
		prisonJumpsuitPedestal = nil
		david_pack.actionsPermission.canUseActiveItem = true
		david_pack.actionsPermission.canUsePill = true
		david_pack.actionsPermission.canEnterTrapdoor = true
		david_pack.actionsPermission.canExitRoom = { true, 0 }
	end
end

function david_pack:prisonJumpsuitPickupSelection(entityType, variant, subtype)
	level = Game():GetLevel()
	dimension = level:GetDimension()

	if dimension ~= Dimension.NORMAL then
		return
	end

	if entityType == 5 and variant == 100 and subtype == david_pack.Collectible.PRISON_JUMPSUIT then
		startFrocedPrisonJumpsuitPickupSquence()
	end
end

david_pack:AddCallback(ModCallbacks.MC_PRE_USE_CARD, function(_, card, player)
	if card == Card.CARD_GET_OUT_OF_JAIL and forcedPrisonJumpsuitPickupSequence then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE and entity.SubType == david_pack.Collectible.PRISON_JUMPSUIT then
				entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
					CollectibleType.COLLECTIBLE_DEATH_CERTIFICATE, false, false, true)
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
	if pickup.Variant == 100 and pickup.SubType == david_pack.Collectible.PRISON_JUMPSUIT then
		if prisonJumpsuitPedestal == nil then
			prisonJumpsuitPedestal = pickup
		end
	elseif pickup.Variant == 100 and pickup.SubType ~= david_pack.Collectible.PRISON_JUMPSUIT and Isaac.GetPlayer():GetPlayerType() == PlayerType.PLAYER_ISAAC_B then
		if prisonJumpsuitPedestal ~= nil then
			pickup.SubType = david_pack.Collectible.PRISON_JUMPSUIT
		end
	else
		endPrisonJumpsuitSequence()
	end
end)

---@param tear EntityTear
david_pack:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
	player = Isaac.GetPlayer()
	if player:HasCollectible(david_pack.Collectible.PRISON_JUMPSUIT) then
		tear.Mass = tear.Mass / 4.5
	end
end)


if EID then
	local function prisonJumpsuitModifierCondition(descObj)
		if descObj.ObjType == 5 and descObj.ObjVariant == 100 and descObj.ObjSubType == david_pack.Collectible.PRISON_JUMPSUIT then return true end
	end
	local function prisonJumpsuitModifierCallback(descObj)
		EID:appendToDescription(descObj,
			"#{{ModIcon}} Can be transformed in to {{Collectible628}} using {{Card47}} Get Out Of Jail Free Card effectively avoiding it")
		return descObj
	end

	EID:addDescriptionModifier("prisonJumpsuit_getOutOfJailCard", prisonJumpsuitModifierCondition,
		prisonJumpsuitModifierCallback)
end


david_pack:AddCallback(ModCallbacks.MC_POST_PICKUP_SELECTION, david_pack.prisonJumpsuitPickupSelection)
david_pack:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, david_pack.resetPrisonJumpsuit)
david_pack:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, david_pack.prisonJumpsuitPickup)
david_pack:AddCallback(ModCallbacks.MC_PRE_ENTITY_SPAWN, david_pack.prisonJumpsuitEntitySpawn)
