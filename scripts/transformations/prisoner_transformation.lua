local mod = david_pack

---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, function(_, item, _, firsttime, _, _, player)
	--if not firsttime then return end
	if
		item == mod.Collectible.PRISON_JUMPSUIT or item == mod.Collectible.DIRTY_PRISON_JUMPSUIT or item == mod.Collectible.HANDCUFFS or CollectibleType.COLLECTIBLE_BAR_OF_SOAP
	then
		local playerEffects = player:GetEffects()
		playerEffects:AddNullEffect(mod.NullItem.PRISONER_TRANSFORMATION_COUNTER)
		if playerEffects:GetNullEffectNum(mod.NullItem.PRISONER_TRANSFORMATION_COUNTER) >= 3 then
			if playerEffects:HasNullEffect(mod.NullItem.PRISONER_TRANSFORMATION) == false then
				Game():GetHUD():ShowItemText("Prisoner!", "", false)
				Isaac.Spawn(1000, 15, 0, player.Position, Vector.Zero, player)
				SFXManager():Play(SoundEffect.SOUND_DOOR_HEAVY_CLOSE, 10)
				playerEffects:AddNullEffect(mod.NullItem.PRISONER_TRANSFORMATION)
				playerEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_SAMSONS_CHAINS)
				mod.Value.KEYED_ENTITIES_CHANCE = 75
			end
		end
	end
end)


mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
	local player = Isaac.GetPlayer()
	local playerEffects = player:GetEffects()
	if playerEffects:HasNullEffect(mod.NullItem.PRISONER_TRANSFORMATION) then
		playerEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_SAMSONS_CHAINS)
	end
end)


---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, function(_, player, cacheFlags)
	local playerEffects = player:GetEffects()
	if playerEffects:HasNullEffect(mod.NullItem.PRISONER_TRANSFORMATION) then
		if cacheFlags & CacheFlag.CACHE_SPEED == CacheFlag.CACHE_SPEED then
			if player.MoveSpeed > 0.5 then
				local removeSpeed = player.MoveSpeed - 0.5
				player.MoveSpeed = player.MoveSpeed - removeSpeed
			else
				player.MoveSpeed = player.MoveSpeed
			end
		end

		if cacheFlags & CacheFlag.CACHE_SHOTSPEED == CacheFlag.CACHE_SHOTSPEED then
			if player.ShotSpeed < 2.5 then
				local removeSpeed = player.ShotSpeed + 2.5
				player.ShotSpeed = player.ShotSpeed + removeSpeed
			else
				player.ShotSpeed = player.ShotSpeed
			end
		end

		if cacheFlags & CacheFlag.CACHE_RANGE == CacheFlag.CACHE_RANGE then
			if player.TearRange > 3.5 then
				local removeSpeed = player.TearRange - 3.5
				player.TearRange = player.TearRange - removeSpeed
			else
				player.TearRange = player.TearRange
			end
		end
	end
end)


---@param player EntityPlayer
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
end)
