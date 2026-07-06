local mod = david_pack

local wait_instances = {}

mod.wait = {}
mod.wait.__index = mod.wait

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    for i = 0, #wait_instances do
        local table_index = i + 1
        local instance = wait_instances[table_index]
        if not instance then return end
        --print("wait: ", table_index, Isaac.GetFrameCount(), instance.time, instance.wait_time, instance.func)
        if Isaac.GetFrameCount() == instance.time + instance.wait_time then
            instance.func()
            table.remove(wait_instances, table_index)
            break
        end
    end
end)

function mod.wait.new(name, time, wait_time, func) -- Time in frames
    local Instance = {}
    Instance.name = name
    Instance.time = time
    Instance.wait_time = wait_time
    Instance.func = func
    table.insert(wait_instances, setmetatable(Instance, mod.wait))
end


---@param name string
function mod.wait.remove(name)
    for i = 0, #wait_instances do
        local table_index = i + 1
        local instance = wait_instances[table_index]

        if instance ~= nil and instance.name == name then
            table.remove(wait_instances, table_index)
            break
        end
    end
end
