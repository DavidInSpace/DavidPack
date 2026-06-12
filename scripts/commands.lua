Console.RegisterCommand("dp_test", "Command Of David Pack Made For Testing", "", true, AutocompleteType.NONE)




function david_pack.onExecuteCommand(_, cmd, params)
    local lparams = string.lower(params)
    local lcmd = string.lower(cmd)
    if cmd ~= "dp_test" then return end

    local paramsTable = david_pack:splitString(lparams)
    --print(#paramsTable)

    -- Command to automaticly repeat another command X amount of times
    --print(type(paramsTable[1]), type(paramsTable[2]), type(paramsTable[3]), type(tonumber(paramsTable[4])))
    if paramsTable[1] == "repeat_command" then
        if type(paramsTable[2]) == "string" and type(paramsTable[3]) == "string" and type(tonumber(paramsTable[4])) == "number" then
            for i = 0, paramsTable[4] do
                Isaac.ExecuteCommand(paramsTable[2] .. " " .. paramsTable[3])
            end
        else
            Console.PrintError(
                "not enough arguments given! Syntax: dp_test repeat_command [COMMAND] [COMMAND PARAM] [REPEAT AMOUNT]")
        end
    end

    if paramsTable[1] == "get_mod_items_ratio" then
        david_pack:calculateModItemsRatio()
    end

    if paramsTable[1] == "get_collectible_quality_spread" then
        david_pack:getCollectiblesOfEachQualityFromAllItemPoolsSortedByQuality(paramsTable[2])
    end

    if paramsTable[1] == "spawn_all_items" then
        local spawnPosition
        for _, modCollectible in pairs(david_pack.RealCollectible) do
        
           while true do
                spawnPosition = Game():GetRoom():GetRandomPosition(20)
                local CollectiblesInRadius = Isaac.FindInRadius(spawnPosition, 20)
                    --print("ColInRad 1: ", CollectiblesInRadius, CollectiblesInRadius[1], #CollectiblesInRadius)
                if #CollectiblesInRadius == 0 then
                    break
                end
           end
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, modCollectible,
                spawnPosition, Vector(0, 0), nil)
        end
    end
end

david_pack:AddCallback(ModCallbacks.MC_EXECUTE_CMD, david_pack.onExecuteCommand)
