local r = {}


function r.read(path)
    local file = io.open(path, "r")
    if not file then
	return nil
    end
    local content = file:read("*a")
    file:close()
    return content
end

function r.write(content, path)
    local file = io.open(path, "wb")
    if not file then
	return nil
    end
    file:write(content)
    file:close()
end

function r.getInput()
    local line = io.read()
    return line
end


return r
