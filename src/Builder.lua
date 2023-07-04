-- Module for building instance

return function (class_name : string) : (properties : {string : any}) -> Instance
    return function (properties : {string : any}) : Instance
        local instance : Instance = Instance.new(class_name)
        local parent : Instance? = nil

        for p : string, value : any in pairs(properties) do
            if p == 'Parent' then parent = value; continue end
            instance[p] = value
        end

        instance.Parent = parent
        return instance
    end
end