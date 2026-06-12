local selectedTear = 0
local canRemoveWisp = false

MIXED_EMOTIONS_TEARS = {
	CollectibleType.COLLECTIBLE_C_SECTION, -- 1
	CollectibleType.COLLECTIBLE_BACKSTABBER,
	CollectibleType.COLLECTIBLE_CONTINUUM,
	CollectibleType.COLLECTIBLE_IPECAC,
	CollectibleType.COLLECTIBLE_CRICKETS_BODY,
	CollectibleType.COLLECTIBLE_DR_FETUS,
	CollectibleType.COLLECTIBLE_EPIC_FETUS,
	CollectibleType.COLLECTIBLE_TECHNOLOGY,
	CollectibleType.COLLECTIBLE_TECH_X,
	CollectibleType.COLLECTIBLE_LUDOVICO_TECHNIQUE,
	CollectibleType.COLLECTIBLE_LOST_CONTACT,
	CollectibleType.COLLECTIBLE_BRIMSTONE,
	CollectibleType.COLLECTIBLE_TRISAGION,
	CollectibleType.COLLECTIBLE_URANUS,
	CollectibleType.COLLECTIBLE_KNOCKOUT_DROPS,
	CollectibleType.COLLECTIBLE_HAEMOLACRIA,
	CollectibleType.COLLECTIBLE_RUBBER_CEMENT, -- 17
}



local function setNormalTears()
	if selectedTear == 0 then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == FamiliarVariant.ITEM_WISP and entity.SubType == MIXED_EMOTIONS_TEARS[17] then
				entity:Kill()
				break
			end
		end
		local mixedEmotionsItemConfig = Isaac.GetItemConfig():GetCollectible(david_pack.Collectible.MIXED_EMOTIONS)
		local player = Isaac.GetPlayer()
		local slot = player:GetActiveItemSlot(david_pack.Collectible.MIXED_EMOTIONS)
		mixedEmotionsItemConfig.GfxFileName = "gfx/items/collectibles/mixed_emotions.png"
		Game():GetHUD():InvalidateActiveItem(player, slot)
		return false
	end
	return true
end

---@param player EntityPlayer
local function addTearItemWisp(player)
	for _, entity in pairs(Isaac.GetRoomEntities()) do
		if selectedTear > 1 then
			if entity.Type == EntityType.ENTITY_FAMILIAR and entity.Variant == FamiliarVariant.ITEM_WISP and entity.SubType == MIXED_EMOTIONS_TEARS[selectedTear - 1] then
				entity:Kill()
				break
			end
		end
	end

	player:AddItemWisp(MIXED_EMOTIONS_TEARS[selectedTear], player.Position)
end


function david_pack:mixedEmotionsUse(itemID, _, player)
	if selectedTear < 17 then
		selectedTear = selectedTear + 1
	else
		selectedTear = 0
	end

	if not setNormalTears() then
		return {
			Discharge = true,
			Remove = false,
			ShowAnim = true,
		}
	end

	local mixedEmotionsItemConfig = Isaac.GetItemConfig():GetCollectible(david_pack.Collectible.MIXED_EMOTIONS)
	mixedEmotionsItemConfig.GfxFileName = Isaac.GetItemConfig():GetCollectible(MIXED_EMOTIONS_TEARS[selectedTear])
		.GfxFileName
	--mixedEmotionsItemConfig.GfxFileName = "gfx/items/collectibles/mixed_emotions/"
	--.. MIXED_EMOTIONS_TEARS[selectedTear][2]
	--.. ".png"

	--print(mixedEmotionsItemConfig.GfxFileName)
	local slot = ActiveSlot.SLOT_PRIMARY

	Game():GetHUD():InvalidateActiveItem(player, slot)

	addTearItemWisp(player)

	return {
		Discharge = true,
		Remove = false,
		ShowAnim = true,
	}
end

function david_pack:resetTearsOnGameStart(continued)
	selectedTear = 0
	local mixedEmotionsItemConfig = Isaac.GetItemConfig():GetCollectible(david_pack.Collectible.MIXED_EMOTIONS)
	mixedEmotionsItemConfig.GfxFileName = "gfx/items/collectibles/mixed_emotions.png"
end

---@param player EntityPlayer
function david_pack:giveAbilities(_, _, _, _, _, player)
	for i = 0, 3 do
		player:AddSmeltedTrinket(TrinketType.TRINKET_TEARDROP_CHARM)
	end
end

---@param player EntityPlayer
function david_pack:removeAbilities(player)
	selectedTear = 0
	setNormalTears()
	for i = 0, 3 do
		player:TryRemoveSmeltedTrinket(TrinketType.TRINKET_TEARDROP_CHARM)
	end
end

---@param entity Entity
david_pack:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function (_, entity)
	if not setNormalTears() then return end
	local wispEntity = entity:ToFamiliar()
	if wispEntity == nil then return end

	if entity.Type == EntityType.ENTITY_FAMILIAR and entity.SubType == MIXED_EMOTIONS_TEARS[selectedTear] then
		return false
	end
end, EntityType.ENTITY_FAMILIAR)

david_pack:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, david_pack.resetTearsOnGameStart)
david_pack:AddCallback(ModCallbacks.MC_USE_ITEM, david_pack.mixedEmotionsUse, david_pack.Collectible.MIXED_EMOTIONS)

david_pack:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, david_pack.giveAbilities,
	david_pack.Collectible.MIXED_EMOTIONS)
david_pack:AddCallback(ModCallbacks.MC_POST_TRIGGER_COLLECTIBLE_REMOVED, david_pack.removeAbilities,
	david_pack.Collectible.MIXED_EMOTIONS)
