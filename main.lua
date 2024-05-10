local fh = require("inout")
local proc = require("processString")

local continue = true

local status = { NEWFILE = 0, TIMEMISSING = 1, TIMEADDED = 2 }

local function prepare(content)
    local r = {}
    if #content == 0 then
	r.status = status.NEWFILE
    else
	proc.removeNewLineChar(content)
	if proc.timeAlreadyAdded(content) then
	    r.status = status.TIMEADDED
	else
	    r.status = status.TIMEMISSING
	end
    end
    r.content = content
    return r
end

local function outputToUser(stat)
    if stat == status.NEWFILE then
	print("Start new project")
    elseif stat == status.TIMEMISSING then
	print("Start new project\ts:Stop\ta:Abort")
    elseif stat == status.TIMEADDED then
	print("Start new project\td:Delete")
    end
end

local function processCommand(content)
end

while continue do
    local fileContent = fh.read "timetrack.txt"
    local ret = prepare(fileContent)
    fileContent = ret.content

    outputToUser(ret.status)
    local input = fh.getInput()

    if #input == 0 then
	break
    elseif #input == 1 then
	processCommand(input)
    end


end
