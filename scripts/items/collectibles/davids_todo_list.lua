local mod = david_pack
local game = Game()
local player = Isaac.GetPlayer()
local sfx = SFXManager()
local level = Game():GetLevel()
local font = Font()
font:Load("font/terminus.fnt")

local startingRoomIndex = nil

local selectStartingRoom = false

local TODO_LIST_THINGS_COUNT = 6


---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlags)
	if player:HasCollectible(mod.Collectible.DAVIDS_TODO_LIST) then
		local copyCount = player:GetCollectibleNum(mod.Collectible.DAVIDS_TODO_LIST, true)
		if cacheFlags & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED then
			player.MoveSpeed = player.MoveSpeed + (TODO_LIST_THINGS_COUNT * 0.01 * copyCount)
		end

		if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
			player.Damage = player.Damage + (TODO_LIST_THINGS_COUNT * 0.4 * copyCount)
		end

		if cacheFlags & CacheFlag.CACHE_LUCK == CacheFlag.CACHE_LUCK then
			player.Luck = player.Luck + (TODO_LIST_THINGS_COUNT * 0.2 * copyCount)
		end
	end
end)


local function SpawnTodoListButton(isFirstTime)
	EID:addEntity(
		1000,
		mod.Effect.TODO_LIST_BUTTON,
		100,
		"Todo List Button",
		"Press to see the todo list for the mod DavidPack"
	)

	player = Isaac.GetPlayer(0)
	level = Game():GetLevel()
	local room = game:GetRoom()
	local effectPos = room.GetCenterPos(room) + Vector(0, 80)
	local currentRoomDesc = level:GetCurrentRoomDesc()

	if currentRoomDesc.Data.Type ~= RoomType.ROOM_SECRET and currentRoomDesc.Data.Type ~= RoomType.ROOM_SUPERSECRET then return end

	Isaac.Spawn(EntityType.ENTITY_EFFECT, mod.Effect.TODO_LIST_BUTTON, 100, effectPos, Vector(0, 0), nil)
	if isFirstTime == true then
		Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, effectPos, Vector(0, 0), nil)
	end
end

mod:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, function(_, type, charge, firstTime, slot, varData)
	if type ~= mod.Collectible.DAVIDS_TODO_LIST then
		return
	end
	SpawnTodoListButton()
end)



mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, effect)
	effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
end, mod.Effect.TODO_LIST_BUTTON)


mod:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, function(_, effect)
	local effectSpr = effect:GetSprite()
	local room = game:GetRoom()

	if effectSpr:IsPlaying("Off") then
		local nearestPlayer = game:GetNearestPlayer(effect.Position)

		if nearestPlayer and effect.Position:Distance(nearestPlayer.Position) <= effect.Size + nearestPlayer.Size then
			sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)
			effectSpr:Play("Switched")
		end
	end
	if effectSpr:IsFinished("Switched") then
		sfx:Play(SoundEffect.SOUND_BUTTON_PRESS)
		room:GetEffects():AddCollectibleEffect(david_pack.Collectible.DAVIDS_TODO_LIST)
		effectSpr:Play("On")
	end
end, mod.Effect.TODO_LIST_BUTTON)



mod:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, function(_, effect, offset)
	if game:GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
		return false
	end
end, mod.Effect.TODO_LIST_BUTTON)


function mod.respawnTodoListButton()
	local currentRoomDesc = Game():GetLevel():GetCurrentRoomDesc()
	if currentRoomDesc.Data.Type ~= RoomType.ROOM_SECRET and currentRoomDesc.Data.Type ~= RoomType.ROOM_SUPERSECRET then return end
	player = Isaac.GetPlayer()


	if player:HasCollectible(david_pack.Collectible.DAVIDS_TODO_LIST) then
		print("Spawn Todo List Button")
		SpawnTodoListButton()
	end
end

david_pack:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, david_pack.respawnGamblingButton)
