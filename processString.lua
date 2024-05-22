---@diagnostic disable: param-type-mismatch
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
    end,

    addProject = function(content, project)
	local time = os.date("*t")
	local minFiller, hourFiller

	if time.hour < 10 then
	    hourFiller = '0'
	else
	    hourFiller = ''
	end
	if time.min < 10 then
	    minFiller = '0'
	else
	    minFiller = ''
	end

	local timeString = "["..hourFiller..time.hour..":"..minFiller..time.min.."]"
	return content..timeString.." "..project
    end,

    endProject = function(content)
	local index = findLast(content, '%[')
	local endTime = os.date("*t")
	--print(content:sub(index+1, index+2).."and"..content:sub(index+4,index+5))
	local startTime = { hour = tonumber(content:sub(index+1, index+2)), min = tonumber(content:sub(index+4, index+5)) }

	local timeDiff = (endTime.hour * 60 + endTime.min) - (startTime.hour * 60 + startTime.min)

	return content.." ["..timeDiff.."]"
    end,

    changeProjectText = function(content, newName)
	local index = findLast(content, ']')
	--Check if project is finished
	if string.sub(content,index-3, index-3) ~= ':' then
	    local indexStartDuration = findLast(content, '%[')
	    local duration = string.sub(content,indexStartDuration,index)
	    --Ignore duration and go back to start time
	    index = findLast(content:sub(1,indexStartDuration-1), ']')
	    return content:sub(1, index).." "..newName.." "..duration
	else
	    return content:sub(1, index).." "..newName
	end

    end

}
