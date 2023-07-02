return setmetatable({
    Deserialize = require(script.Deserialize), --* Data -> Hierarchy
    Serialize = require(script.Serialize), --* Hierarchy -> Data
}, {
    __newindex = function()
        error('You can\'t add new dependencies into package!', 2)
    end,
    __index = function()
        error('Index doesn\'t exist!', 2)
    end
})