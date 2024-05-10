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
	    if string.sub(content,var * -1) ~= ' ' then
		return false
	    elseif string.sub(content,var * -1) == ']' then
		return true
	    end
	end
    end

}
