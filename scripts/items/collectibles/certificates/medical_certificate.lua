local unidentifiedPills = {}


function david_pack:MedicalCertificateUse(itemID, _, _, _, activeSlot)
	if itemID == david_pack.Collectible.MEDICAL_CERTIFICATE then
		local roomConfigStage = RoomConfig.GetStage(StbType.SPECIAL_ROOMS)
		for i = 0, roomConfigStage:GetRoomSet(0).Size do
			local room = roomConfigStage:GetRoomSet(0):Get(i)
			if room == nil then return end
			if room.Name == "[DP] Medical Certificate Room" then
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
end

function david_pack:MedicalCertificateEnter()
	local currentRoomDesc = Game():GetLevel():GetCurrentRoomDesc()



	local lastRoomDesc = Game():GetLevel():GetLastRoomDesc()

	if lastRoomDesc.Data.Name == "[DP] Medical Certificate Room" then
		local itemPool = Game():GetItemPool()
		for _, pill in pairs(unidentifiedPills) do
			--print("Reseting: ", pill, " back to unidentified state")
			--itemPool:UnidentifyPill(pill)
			--unidentifiedPills = {}
		end
	end



	if currentRoomDesc.Data.Name == "[DP] Medical Certificate Room" then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_PILL then
				entity:ToPickup().OptionsPickupIndex = 12
				local subType = entity:ToPickup().SubType
				entity:ToPickup():Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_PILL, subType + 2048)
				local itemPool = Game():GetItemPool()
				for i = 1, 13 do

				end
			end
		end
	end
end

david_pack:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, david_pack.MedicalCertificateEnter)
david_pack:AddCallback(ModCallbacks.MC_USE_ITEM, david_pack.MedicalCertificateUse)
