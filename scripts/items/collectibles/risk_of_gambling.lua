local game = Game()
local player = Isaac.GetPlayer()
local sfx = SFXManager()
local level = Game():GetLevel()
local font = Font()
font:Load("font/terminus.fnt")

local gambling_risk = 1

local startingRoomIndex = nil

local selectStartingRoom = false

local function SpawnItem()
	local player = Isaac.GetPlayer(0)

	local pool = math.random(0, 30)
	local entry = Game():GetItemPool():GetCollectible(pool, false, Random(), CollectibleType.COLLECTIBLE_BREAKFAST)
	local collectibleConfig = Isaac.GetItemConfig():GetCollectible(entry)

	while entry == nil
		or collectibleConfig.Quality == nil
		or tonumber(collectibleConfig.Quality) < 2
		or collectibleConfig:HasTags(ItemConfig.TAG_QUEST) do
		pool = math.random(0, 30)
		entry = Game():GetItemPool():GetCollectible(pool, false, Random(), CollectibleType.COLLECTIBLE_BREAKFAST)
		collectibleConfig = Isaac.GetItemConfig():GetCollectible(entry)
	end

	local room = Game():GetRoom()
	sfx:Play(
		david_pack.Sound.I_CANT_STOP_WINNING,
		1,
		1,
		false,
		(math.random(80, 100) / 100) + collectibleConfig.Quality / 25
	)
	Isaac.Spawn(
		EntityType.ENTITY_PICKUP,
		PickupVariant.PICKUP_COLLECTIBLE,
		entry,
		room:GetRandomPosition(0),
		Vector(0, 0),
		player
	)
end

-- TODO: add epic animation when pressing button and rolling
local function Gamble(sprite)
	if player:HasCollectible(david_pack.Collectible.RISK_OF_GAMBLING) then
		local random = math.random(1, 100)

		if random <= gambling_risk then
			player = Isaac.GetPlayer(0)
			print(player:GetCollectiblesList())

			local collectibleIDcount = 0
			for _, collectible in pairs(player:GetCollectiblesList()) do
				collectibleIDcount = collectibleIDcount + 1
				local CurrentItemConfig = Isaac.GetItemConfig():GetCollectible(collectibleIDcount)

				if CurrentItemConfig ~= nil then
					if
						collectible > 0
						and CurrentItemConfig.Type ~= ItemType.ITEM_ACTIVE
						and CurrentItemConfig.Type ~= ItemType.ITEM_NULL
						and not CurrentItemConfig:HasTags(ItemConfig.TAG_QUEST)
						and collectibleIDcount ~= david_pack.Collectible.RISK_OF_GAMBLING
					then
						player:RemoveCollectible(collectibleIDcount)
					end
				end
			end
			for _, entity in pairs(Isaac.GetRoomEntities()) do
				if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
					entity:Remove()
				end
			end
			if david_pack.SaveManager.GetSettingsSave().shake == 1 then
				Game():ShakeScreen(10)
			end
			sfx:Play(david_pack.Sound.AW_DANG_IT, 1, 1, false, math.random(95, 105) / 100)
		else
			SpawnItem()
		end

		if gambling_risk <= 100 then
			gambling_risk = gambling_risk + 1
		else
			gambling_risk = 100
		end

		sprite:Play("Off")

		EID:addEntity(
			1000,
			david_pack.Effect.GAMBLING_BUTTON,
			100,
			"Gambling Button",
			"{{ColorYellow}}Gambling Risk: "
			.. tostring(gambling_risk)
			.. "%#Increases by 1% every press#Goes down by [1 + Luck Stat / 2] every floor"
		)
	else
		local room = game:GetRoom()
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == EntityType.ENTITY_EFFECT and entity.Variant == david_pack.Effect.GAMBLING_BUTTON and entity.SubType == 100 then
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BOMB_EXPLOSION, 0, entity.Position, Vector(0, 0), nil)
				entity:Kill()
				break
			end
		end
	end
end

local function SpawnRiskOfGamblingButton(isFirstTime)
	EID:addEntity(
		1000,
		david_pack.Effect.GAMBLING_BUTTON,
		100,
		"Gambling Button",
		"{{ColorYellow}}Gambling Risk: "
		.. tostring(gambling_risk)
		.. "%#Increases by 1% every press#Goes down by [1 + Luck Stat / 2] every floor"
	)
	player = Isaac.GetPlayer(0)
	level = Game():GetLevel()
	local currentRoomDesc = level:GetCurrentRoomDesc()
	if level:GetCurrentRoomIndex() == startingRoomIndex or (currentRoomDesc.Data.Name == "Starting Room" and currentRoomDesc.Data.StageID == 13 and currentRoomDesc.Data.Type == 1) then
		local room = game:GetRoom()
		local effectPos = room.GetCenterPos(room) + Vector(0, 80)
		Isaac.Spawn(EntityType.ENTITY_EFFECT, david_pack.Effect.GAMBLING_BUTTON, 100, effectPos, Vector(0, 0), nil)
		if isFirstTime == true then
			Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0, effectPos, Vector(0, 0), nil)
		end
	end
end

function david_pack:onRiskOfGamblingPickup(Type, Charge, FirstTime, Slot, VarData)
	if Type ~= david_pack.Collectible.RISK_OF_GAMBLING then
		return
	end
	gambling_risk = 1
	sfx:Play(david_pack.Sound.LETS_GO_GAMBLING, 1, 1, false, math.random(90, 100) / 100, 0)
	SpawnRiskOfGamblingButton()
end

david_pack:AddCallback(ModCallbacks.MC_PRE_ADD_COLLECTIBLE, david_pack.onRiskOfGamblingPickup)

david_pack:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, function(_, effect)
	effect.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
	effect.SortingLayer = SortingLayer.SORTING_BACKGROUND
end, david_pack.Effect.GAMBLING_BUTTON)



function david_pack:gamblingButtonToggle(effect)
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
		room:GetEffects():AddCollectibleEffect(david_pack.Collectible.RISK_OF_GAMBLING)
		effectSpr:Play("On")
		Gamble(effectSpr)
	end
end

david_pack:AddCallback(ModCallbacks.MC_POST_EFFECT_UPDATE, david_pack.gamblingButtonToggle,
david_pack.Effect.GAMBLING_BUTTON)

david_pack:AddCallback(ModCallbacks.MC_PRE_EFFECT_RENDER, function(_, effect, offset)
	if game:GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then
		return false
	end
end, david_pack.Effect.GAMBLING_BUTTON)

function david_pack:resetRiskOfGambling(continued)
	if continued then
	else
		gambling_risk = 1
	end
end

function david_pack.respawnGamblingButton()
	player = Isaac.GetPlayer()
	if selectStartingRoom == true then
		selectStartingRoom = false
		startingRoomIndex = level:GetCurrentRoomIndex()
	end

	if player:HasCollectible(david_pack.Collectible.RISK_OF_GAMBLING) then
		print("Spawn Gambling Button")
		SpawnRiskOfGamblingButton()
	end
end

function david_pack.spawnGamblingButton(level, type)
	level = Game():GetLevel()
	selectStartingRoom = true

	if
		level == LevelStage.STAGE1_1
		and (type == StageType.STAGETYPE_ORIGINAL or type == StageType.STAGETYPE_AFTERBIRTH)
	then
		gambling_risk = 0
	else
		player = Isaac.GetPlayer()
		if player:HasCollectible(david_pack.Collectible.RISK_OF_GAMBLING) then
			SpawnRiskOfGamblingButton(true)
			local remove_value = math.floor(1 + (player.Luck / 2))
			gambling_risk = gambling_risk - remove_value
			while gambling_risk <= 0 do
				gambling_risk = gambling_risk + 1
			end
		end
	end
end

david_pack:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, david_pack.respawnGamblingButton)
david_pack:AddCallback(ModCallbacks.MC_PRE_LEVEL_SELECT, david_pack.spawnGamblingButton)
