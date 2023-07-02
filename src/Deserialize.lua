local Value = require(script.Parent.Value)
local Builder = require(script.Parent.Builder)

function createObjectHierarchy(slice : {any : any}, parent : Instance?)
    for key : string, value : any in pairs(slice) do
        if typeof(value) == 'table' then
            local holder : Folder = Builder'Folder'({Name = key, Parent = parent})
            createObjectHierarchy(value, holder)
            continue
        end

        local base : string, value : any = Value.baseFrom(value)
        Builder(base){Name = key, Parent = parent, Value = value}
    end
end

return function (data : {any : any}, parent : Instance?) : Instance
    local root : Folder?
    for key : string, value : any in pairs(data) do
        if typeof(value) ~= 'table' then error('You can\'t set normal values in high level of data table!', 2) end
        if root then
            error('Root should be only one!', 2)
        end

        root = Builder'Folder'{Name = key, Parent = parent}
    end

    createObjectHierarchy(data[root.Name], root)
    return root
end