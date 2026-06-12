function david_pack:runeCertificateUse()
	local roomConfigStage = RoomConfig.GetStage(StbType.SPECIAL_ROOMS)
	for i = 0, roomConfigStage:GetRoomSet(0).Size do
		local room = roomConfigStage:GetRoomSet(0):Get(i)
		if room == nil then return end
		if room.Name == "[DP] Rune Certificate Room" and Game():GetLevel():GetDimension() == Dimension.NORMAL then
			Isaac.ExecuteCommand("goto s.default." .. room.Variant)
			break
		end
	end
	return {
		Discharge = true,
		Remove = true,
		ShowAnim = true,
	}
end

function david_pack:onRuneCertificateEnter()
	local currentRoomDesc = Game():GetLevel():GetCurrentRoomDesc()

	if currentRoomDesc.Data.Name == "[DP] Rune Certificate Room" then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_TAROTCARD then
				--EID:AddPickupToHistory(pickupType, effectID, player, useFlags, pillColorID)
				entity:ToPickup().OptionsPickupIndex = 11
			end
		end
	end
end

david_pack:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, david_pack.onRuneCertificateEnter)
david_pack:AddCallback(ModCallbacks.MC_USE_ITEM, david_pack.runeCertificateUse, david_pack.Collectible.RUNE_CERTIFICATE)
