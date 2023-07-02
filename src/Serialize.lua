local Value = require(script.Parent.Value)

function createSlice(source : Folder, parent : {})
    for _, v in ipairs(source:GetChildren()) do
        if v:IsA('ValueBase') then
            parent[v.Name] = Value.dataFrom(v)
            continue
        end

        if v:IsA('Folder') then
            parent[v.Name] = {}
            createSlice(v, parent[v.Name])
        end
    end
end

return function(source : Folder) : {string : any} -- TODO: Make prefix ignore!
    local initial_table : table = { --! don't touch this
        [source.Name] = {}
    }

    createSlice(source, initial_table[source.Name])

    return initial_table
end