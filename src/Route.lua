local Separator : string = '/'

function get(root : Instance, path : string) : Instance?
    local current = root
    local splitted_path = string.split(path, Separator)

    for _, v in ipairs(splitted_path) do
        local child = current:FindFirstChild(v)
        if not child then return end

        current = child
    end

    return current
end

return get