-- Module for parsing Value-Like object from value

local Delimiter : string = '_' -- can be easy modified

local Prefixes = { -- data registered prefixes --TODO: Current prefix can have only 1 char
    ['n'] = 'NumberValue',
    ['b'] = 'BoolValue',
    ['i'] = 'IntValue',
    ['s'] = 'StringValue',
    ['v'] = 'Vector3Value',
    ['o'] = 'ObjectValue',
}

local Types = { -- type to value-like object
    ['number'] = 'NumberValue',
    ['string'] = 'StringValue',
    ['boolean'] = 'BoolValue'
}

function baseByPrefix(str : string) : string? -- returns prefixed base by value data
    for i, v in pairs(Prefixes) do
        if string.find(str, i..Delimiter) == 1 then return v end
    end
end

function prefixByBase(value_instance : ValueBase) : string? -- returns prefix from Value-Like object
    if typeof(value_instance) ~= 'Instance' then error('Value should be ValueBase!', 2) end
    if not value_instance:IsA('ValueBase') then error('Value should be ValueBase!', 2) end

    local class_name : string = value_instance.ClassName
    for i, v in pairs(Prefixes) do
        if v == class_name then return i end
    end
end

function baseFrom(value : any) : (string, any) -- get ValueBase class from data + value without prefix if it was
    if typeof(value) == 'string' then
        local prefixed = baseByPrefix(value) -- try to get prefixed value
        if prefixed then
            return prefixed, string.sub(value, 3, #value)
        end
    end

    local typed = Types[typeof(value)] -- get value by value's data type
    if not typed then error('Not declared type of data!', 2) end

    return typed, value
end

function dataFrom(value_instance : ValueBase) -- get formatted data (or normal) from ValueBase
    local vprefix : string = prefixByBase(value_instance)
    if vprefix then
        return `{vprefix}{Delimiter}{tostring(value_instance.Value)}` -- return formatted data
    end
    
    return value_instance.Value -- return normal data
end

return {
    baseFrom = baseFrom,
    dataFrom = dataFrom
}