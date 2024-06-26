local fh = require("inout")
local proc = require("processString")

local status = { NEWFILE = 0, TIMEMISSING = 1, TIMEADDED = 2 }

local function prepare(content)
    local r = {}
    if #content == 0 then
	r.status = status.NEWFILE
    else
	content = proc.removeNewLineChar(content)
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
	print("Start new project\ts:Stop\ta:Abort\tc:Change")
    elseif stat == status.TIMEADDED then
	print("Start new project\td:Delete last\tc:Change last")
    end
end

local function commandOk(input, stat)
    if stat == status.TIMEMISSING and ( input == "s" or input == "a" or input == "c" ) then
	return true
    elseif stat == status.TIMEADDED and ( input == "d" or input == "c" ) then
	return true
    elseif input == "p" or input == "x" then
	return true
    end
    return false
end

local function getTodayFileName()
    local date = os.date("*t")
    local fName = string.sub(date.year, -2)

    if date.month < 10 then
	fName = fName..".0"..date.month
    else
	fName = fName.."."..date.month
    end

    if date.day < 10 then
	fName = fName..".0"..date.day..".txt"
    else
	fName = fName.."."..date.day..".txt"
    end
    return fName
end

local function processCommand(input, content)
    if input == "d" or input == "a" then
	content = proc.deleteLastProject(content)
    elseif input == "s" then
	content = proc.endProject(content)
    elseif input == "c" then
	content = proc.changeProjectText(content, fh.getInput())
    --hidden functions
    elseif input == "p" then
	print(content)
    elseif input == "x" then
	fh.write(content, getTodayFileName())
    end
    return content
end

local function processNewProject(ret, userInput)
    if ret.status == status.NEWFILE then
	ret.content = proc.addProject(ret.content, userInput)
    elseif ret.status == status.TIMEMISSING then
	ret.content = proc.endProject(ret.content)
	ret.content = ret.content.."\n"
	ret.content = proc.addProject(ret.content, userInput)
    elseif ret.status == status.TIMEADDED then
	ret.content = ret.content.."\n"
	ret.content = proc.addProject(ret.content, userInput)
    end
    return ret.content
end

while true do
    local fileContent = fh.read "timetrack.txt"
    local ret = prepare(fileContent)

    outputToUser(ret.status)
    local input = fh.getInput()

    if #input == 0 then
	break
    elseif #input == 1 then
	if commandOk(input, ret.status) then
	    ret.content = processCommand(input, ret.content)
	else
	    print("Wrong input\n")
	end
    else
	ret.content = processNewProject(ret, input)
    end
    fh.write(ret.content, "timetrack.txt")
end
