function david_pack:sleep(time) -- Not used anywhere
	if time == nil then
		return
	end
	local sec = tonumber(os.clock() + time)
	while os.clock() < sec do
	end
end

function david_pack:findEntity(type, variant, subtype) -- Passing in no arguments will return all entities in the room
	if type ~= nil and variant ~= nil and subtype ~= nil then
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			if entity.Type == type and entity.Variant == variant and entity.SubType == subtype then
				return entity
			end
		end
		return nil
	else
		local roomEntities = {}
		for _, entity in pairs(Isaac.GetRoomEntities()) do
			table.insert(roomEntities, entity)
		end
		---@type Entity[]
		return roomEntities
	end
end

function david_pack:splitString(stringToSplit)
	local splitString = {}
	for word in string.gmatch(stringToSplit, "%S+") do
		table.insert(splitString, word)
	end
	return splitString
end

function david_pack:getRoomEnemies(excludeInvincible) -- Gets all room ENEMIES. NOT ENTITIES.
	local roomEnemies = {}
	for _, entity in pairs(Isaac.GetRoomEntities()) do
		if entity.Type ~= 1000 and entity.Type ~= 999 and entity.Type ~= 17 and entity.Type >= 10 and entity:IsActiveEnemy(false) and entity:IsVulnerableEnemy() == excludeInvincible and entity.EntityCollisionClass ~= EntityCollisionClass.ENTCOLL_NONE then
			table.insert(roomEnemies, entity)
		end
	end
	return roomEnemies
end

---@param position Vector
function david_pack:getNearestRoomEnemy(position)
	---@type EntityNPC[]
	local roomEnemies = david_pack:getRoomEnemies(true)
	--print("LENGTH OF ROOM ENEMIES: ", #roomEnemies)

	---@type EntityNPC
	local nearestEnemy = nil

	for _, enemy in pairs(roomEnemies) do
		if nearestEnemy ~= nil then
			if position:Distance(enemy.Position) < position:Distance(nearestEnemy.Position) then
				nearestEnemy = enemy
			end
		else
			nearestEnemy = enemy
		end
	end
	--print("Nearest Enemy To: ", position.X, position.Y, " is ", nearestEnemy.Position.X, nearestEnemy.Position.Y, nearestEnemy.Type, nearestEnemy.Variant)
	return nearestEnemy
end

function david_pack:getCollectibleFromRandomPool(decrease) -- Upgrade this function later on to make so it doesnt take from the greed pools since they basically have the same items as normal pools
	local pool = math.random(0, 30)
	return Game():GetItemPool():GetCollectible(pool, decrease)
end

function david_pack:getAvailableRoomPositions()

end

function david_pack:getCollectiblesWithATag(tag)
	local taggedItems = {}
	for collectibleID = 1, XMLData.GetNumEntries(XMLNode.ITEM) do
		print("collectibleID: ", collectibleID)
		local itemItemConfig = Isaac.GetItemConfig():GetCollectible(collectibleID)
		if itemItemConfig ~= nil and itemItemConfig:HasTags(tag) then
			table.insert(taggedItems, collectibleID)
		end
	end
	return taggedItems
end

function david_pack:calculateModItemsRatio()
	ItemAmountQ = { 0, 0, 0, 0, 0, 0 }
	for _, item in pairs(david_pack.Collectible) do
		local itemQuality = Isaac.GetItemConfig():GetCollectible(item).Quality
		if itemQuality ~= nil then
			ItemAmountQ[itemQuality + 1] = ItemAmountQ[itemQuality + 1] + 1
		end
	end


	local totalModItemsAmount = ItemAmountQ[1] + ItemAmountQ[2] + ItemAmountQ[3] + ItemAmountQ[4] + ItemAmountQ[5]

	local ITEM_RATIO_QUALITY_STANDARTS = { 12, 31, 28, 23, 5 }
	local ItemRatioQ = {}
	print("David Pack Items Ratio: (" .. tostring(totalModItemsAmount) .. ")")
	for quality = 1, 5 do
		ItemRatioQ[quality] = ItemAmountQ[quality] / totalModItemsAmount

		local status = ""
		if ItemRatioQ[quality] > ITEM_RATIO_QUALITY_STANDARTS[quality] - 2 and ItemRatioQ[quality] < ITEM_RATIO_QUALITY_STANDARTS[quality] + 2 then
			status = "Good (" .. ITEM_RATIO_QUALITY_STANDARTS[quality] .. "%)"
		elseif ItemRatioQ[quality] > ITEM_RATIO_QUALITY_STANDARTS[quality] - 4 and ItemRatioQ[quality] < ITEM_RATIO_QUALITY_STANDARTS[quality] + 4 then
			status = "Meh (" .. ITEM_RATIO_QUALITY_STANDARTS[quality] .. "%)"
		else
			status = "Sh*t (" .. ITEM_RATIO_QUALITY_STANDARTS[quality] .. "%)"
		end

		print("Q" .. tostring(quality - 1) .. "Items: ", ItemRatioQ[quality] * 100,
			"% (" .. tostring(ItemAmountQ[quality]) .. ")", status)
	end
end

function david_pack:getCollectiblesOfEachQualityFromAllItemPoolsSortedByQuality(quality)
	if quality == nil then
		print("Enter A Quality!", quality)
	end
	local itemPoolData = {}
	print("Sorted By Quality ", quality)
	for itemPool = 0, XMLData.GetNumEntries(XMLNode.ITEMPOOL) do
		local node = XMLData.GetEntryById(XMLNode.ITEMPOOL, itemPool)
		if node ~= nil then
			table.insert(itemPoolData, { node.name, 0, 0, 0, 0, 0, 0 })
			print("Number of items in ", node.name, itemPool, ": ", #node.item)
			for itemIndex = 1, #node.item do
				print("item name node: ", node.item[itemIndex].name)

				if node.item[itemIndex].name ~= nil and type(node.item[itemIndex].name) == "string" then
					local itemID = Isaac.GetItemIdByName(node.item[itemIndex].name)
					local itemConfig = Isaac.GetItemConfig():GetCollectible(itemID)
					if itemConfig ~= nil then
						if itemConfig.Quality == 0 then
							itemPoolData[itemPool][2] = itemPoolData[itemPool][2] + 1 or 0
						elseif itemConfig.Quality == 1 then
							itemPoolData[itemPool][3] = itemPoolData[itemPool][3] + 1 or 0
						elseif itemConfig.Quality == 2 then
							itemPoolData[itemPool][4] = itemPoolData[itemPool][4] + 1 or 0
						elseif itemConfig.Quality == 3 then
							itemPoolData[itemPool][5] = itemPoolData[itemPool][5] + 1 or 0
						elseif itemConfig.Quality == 4 then
							itemPoolData[itemPool][6] = itemPoolData[itemPool][6] + 1 or 0
						elseif itemConfig.Quality == 5 then
							itemPoolData[itemPool][7] = itemPoolData[itemPool][7] + 1 or 0
						end
					end
				end
			end
		else
			print("Node is nil ):")
		end
	end
	local totalItems = 0

	table.sort(itemPoolData, function(a, b)
		return a[quality + 2] / (a[2] + a[3] + a[4] + a[5] + a[6] + a[7]) <
			b[quality + 2] / (b[2] + b[3] + b[4] + b[5] + b[6] + b[7])
	end)
	print("Item Pools Data Results:")
	for _, data in pairs(itemPoolData) do
		totalItems = data[2] + data[3] + data[4] + data[5] + data[6] + data[7]
		print("Item Pool " .. tostring(data[1]) .. " Data: ", data[quality + 2] / totalItems)
	end
end

function david_pack:getRandomColor(randomizeAlpha, addAlpha)
	if randomizeAlpha then
		return Color(math.random(1, 100) / 100, math.random(1, 100) / 100, math.random(1, 100) / 100,
			math.random(1, 100) / 100 + addAlpha)
	else
		return Color(math.random(1, 100) / 100, math.random(1, 100) / 100, math.random(1, 100) / 100, 1)
	end
end

function david_pack:getRandomColorModifier(randomizeAlpha, addAlpha)
	if randomizeAlpha then
		return ColorModifier(math.random(1, 100) / 100, math.random(1, 100) / 100, math.random(1, 100) / 100,
			math.random(1, 100) / 100 + addAlpha, math.random(1, 100) / 100, math.random(1, 100) / 100)
	else
		return ColorModifier(math.random(1, 100) / 100, math.random(1, 100) / 100, math.random(1, 100) / 100, 1,
			math.random(1, 100) / 100, math.random(1, 100) / 100)
	end
end

function david_pack:getRandomVector(minX, maxX, minY, maxY)
	return Vector(math.random(minX, maxX), math.random(minY, maxY))
end
