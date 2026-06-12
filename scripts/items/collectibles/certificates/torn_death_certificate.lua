local randomRoom =  math.random(0, 4)

function david_pack:tornDeathCertificateUse()
		randomRoom = math.random(0, 4)
		local roomConfigStage = RoomConfig.GetStage(StbType.SPECIAL_ROOMS)
		for i = 0, roomConfigStage:GetRoomSet(0).Size do
			local room = roomConfigStage:GetRoomSet(0):Get(i)
			if room == nil then return end
			if room.Name == "[DP] Torn Death Certificate Room 0" then
				Isaac.ExecuteCommand("goto s.default." .. room.Variant + randomRoom)
				break
			
			end
		end
		return {
			Discharge = true,
			Remove = true,
			ShowAnim = true,
		}
end


function david_pack:onTornDeathCertificateEnter()
	local currentRoomDesc = Game():GetLevel():GetCurrentRoomDesc()


	if currentRoomDesc.Data.Name == "[DP] Torn Death Certificate Room 0" or currentRoomDesc.Data.Name == "[DP] Torn Death Certificate Room 1" or currentRoomDesc.Data.Name == "[DP] Torn Death Certificate Room 2" or currentRoomDesc.Data.Name == "[DP] Torn Death Certificate Room 3" or currentRoomDesc.Data.Name == "[DP] Torn Death Certificate Room 4" then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == EntityType.ENTITY_PICKUP and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
				entity:ToPickup().OptionsPickupIndex = 10
			end
		end
	end
end

function david_pack.stopReroll()
	local currentRoomDesc = Game():GetLevel():GetCurrentRoomDesc()
	if currentRoomDesc.Data.Name == "[DP] Torn Death Certificate Room 0" or currentRoomDesc.Data.Name == "[DP] Torn Death Certificate Room 1" or currentRoomDesc.Data.Name == "[DP] Torn Death Certificate Room 2" or currentRoomDesc.Data.Name == "[DP] Torn Death Certificate Room 3" or currentRoomDesc.Data.Name == "[DP] Torn Death Certificate Room 4" then
		return false
	end
end



david_pack:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, david_pack.onTornDeathCertificateEnter)
david_pack:AddCallback(ModCallbacks.MC_USE_ITEM, david_pack.tornDeathCertificateUse, david_pack.Collectible.TORN_DEATH_CERTIFICATE)
david_pack:AddCallback(ModCallbacks.MC_PRE_PICKUP_MORPH, david_pack.stopReroll)
