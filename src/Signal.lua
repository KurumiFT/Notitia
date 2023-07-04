local Builder = require(script.Parent.Builder)
local Trove = require(script.Parent.Trove)

local Signal = {}
Signal.__index = Signal

function Signal.new()
    local _trove = Trove.new()

    return setmetatable({
        destroyed = false,
        trove = _trove,
        signal = _trove:add(Builder'BindableEvent'{})
    }, Signal)
end

function Signal:Connect(callback : (...any) -> nil ) : RBXScriptConnection
    if self.destroyed then error('Signal destroyed!', 2) end
    
    return self.trove:add(self.signal.Event:Connect(callback))
end

function Signal:Destroy()
    self.destroyed = true
    self.trove:Destroy()
end

function Signal:Fire(... : any) : nil
    if self.destroyed then error('Signal destroyed!', 2) end

    self.signal:Fire(...)
end

function Signal:bind(...) : nil
    if self.destroyed then error('Signal destroyed!', 2) end

    for _, signal in ipairs({...}) do
        signal:Connect(function(...)
            self:Fire(...)
        end)
    end
end

return Signal