function getFree(object : any) : () -> nil
    local obj_type : string = typeof(object)

    if obj_type == 'function' then return 
        function ()
            task.spawn(function()
                object()
            end)
        end
    end
    if obj_type == 'Instance' then return 
         function ()
            task.spawn(function()
                object:Destroy()
            end)
        end
    end
    if obj_type == 'RBXScriptConnection'  then return 
         function ()
            task.spawn(function()
                object:Disconnect()
            end)
        end
    end
    if obj_type == 'table' then
        if obj_type['Destroy'] then return 
             function ()
                task.spawn(function()
                    object:Destroy()
                end)
            end
        end
    end
end

local Trove = {}
Trove.__index = function(self, index)
    if Trove[index] then return Trove[index] end
    
    return self.troved[index]
end

Trove.__newindex = function(self, index, value)
    if self.troved[index] then
        getFree(self.troved[index])()
    end

    if not getFree(value) then error('Object should be Destroyable!', 2) end
    self.troved[index] = value
end

function Trove:add(object : any)
    if not getFree(object) then error('Object should be Destroyable!', 2) end
    
    table.insert(self.troved, object)
    return object
end

function Trove:Destroy()
    for i, v in ipairs(self.troved) do -- iter by indexes
        getFree(v)()
        self.troved[i] = nil
    end

    for _, v in pairs(self.troved) do -- iter by keys
        getFree(v)()
    end

    self.troved = {}
end

function Trove.new(initial : any)
    local self = {
        troved = {}
    }

    if initial then 
        if not getFree(initial) then error('Initial object should be Destroyable!', 2)  end
        table.insert(self.troved, initial)
    end

    return setmetatable(self, Trove)
end

return Trove