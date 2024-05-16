local function findLast(string, toFind)
    local i = string:match(".*"..toFind.."()")
    if i == nil then
	return nil
    else
	return i - 1
    end
end


return {

    removeNewLineChar = function(content)
	if string.sub(content,-1) == '\n' then
	    content = content:sub(1, -2)
	end
	return content
	--[[
	local lastNewLine = string.find(content, "\n[^\n]*$")
	print(lastNewLine)
	--]]
    end,

    timeAlreadyAdded = function(content)
	for var = 1, 10 do
	    if string.sub(content,var * -1) == ']' then
		return true
	    elseif string.sub(content,var * -1) ~= ' ' then
		return false
	    end
	end
    end,

    deleteLastProject = function(content)
	local index = findLast(content, '\n')
	--Check if first line
	if index == nil then
	    return ""
	else
	    return content:sub(1, index)
	end
    end

}
