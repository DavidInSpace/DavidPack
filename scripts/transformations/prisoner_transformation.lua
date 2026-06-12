
---@param player EntityPlayer
function david_pack:prisonerTransformationAdd(item, _, firsttime, _, _, player)
	--if not firsttime then return end

	if
		item == david_pack.Collectible.PRISON_JUMPSUIT or item == david_pack.Collectible.HANDCUFFS
	then
		local playerEffects = player:GetEffects()
		playerEffects:AddNullEffect(david_pack.NullItem.PRISONER_TRANSFORMATION_COUNTER)
		if playerEffects:GetNullEffectNum(david_pack.NullItem.PRISONER_TRANSFORMATION_COUNTER) >= 3 then
			if playerEffects:HasNullEffect(david_pack.NullItem.PRISONER_TRANSFORMATION) == false then
				Game():GetHUD():ShowItemText("Prisoner!", "", false)
				Isaac.Spawn(1000, 15, 0, player.Position, Vector.Zero, player)
				SFXManager():Play(SoundEffect.SOUND_DOOR_HEAVY_CLOSE, 10)
				playerEffects:AddNullEffect(david_pack.NullItem.PRISONER_TRANSFORMATION)
				playerEffects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_SAMSONS_CHAINS)
			end
		end
	end
end


david_pack:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, david_pack.prisonerTransformationAdd)
