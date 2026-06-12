local function crash()
    local itemPool = Game():GetItemPool()
    while true do
        local pool = math.random(1, 30)
        itemPool:GetCollectible(pool, true)
    end
end

function david_pack:useBlueScreen()
    Console.PrintError(" ):  YOUR ISAAC RAN IN TO A PROBLEM!")
    crash()
    return {
        Discharge = true,
        Remove = true,
        ShowAnim = true,
    }
end




david_pack:AddCallback(ModCallbacks.MC_USE_ITEM, david_pack.useBlueScreen, david_pack.Collectible.BLUE_SCREEN)