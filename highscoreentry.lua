function highscoreentry_load(i)
	high = i
	gamestate = "highscoreentry"
	currentletter = 1
	cursortimer = 0
	timetimer = 0
	cursorblink = true
	timeblink = true
end

function highscoreentry_update(dt)
	cursortimer = cursortimer + dt
	if cursortimer >= 0.14 then
		cursortimer = 0
		cursorblink = not cursorblink
	end
	
	timetimer = timetimer + dt
	if timetimer >= 0.5 then
		timetimer = 0
		timeblink = not timeblink
	end
	
	if hatstate then
		local c = love.joystick.getHat(0, 0)
		if c:match("u") and not hatstate:match("u") then
			currentletter = currentletter - 10
			if currentletter < 1 then
				currentletter = currentletter + 40
			end
			cursorblink = true
			cursortimer = 0
		elseif c:match("d") and not hatstate:match("d") then
			currentletter = currentletter + 10
			if currentletter > string.len(whitelist) then
				currentletter = currentletter - 40
			end
			cursorblink = true
			cursortimer = 0
		elseif c:match("l") and not hatstate:match("l") then
			currentletter = currentletter -1
			if currentletter < 1 then
				currentletter = currentletter + 40
			end
			cursorblink = true
			cursortimer = 0
		elseif c:match("r") and not hatstate:match("r") then
			currentletter = currentletter + 1
			if currentletter > string.len(whitelist) then
				currentletter = currentletter - 40
			end
			cursorblink = true
			cursortimer = 0
		end
	end
	
	hatstate = love.joystick.getHat(0, 0)
end

function highscoreentry_draw()
	local x = screenwidth/2
	love.graphics.draw(highscoreimg, x, 200, 0, 3*scale, 3*scale, 16, 9)
	love.graphics.setColor(120, 0, 0)
	love.graphics.print("number " .. high, x-140, 300, 0, scale)
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("pellets eaten:", x-500, 400, 0, scale)
	love.graphics.print("time taken:", x+100, 400, 0, scale)
	if timeblink then
		love.graphics.setColor(255, 255, 0)
		love.graphics.print(eatored, x-380, 450, 0, scale*2)
	
		local gt = gametime
		
		if math.mod(gt, 1) == 0 then
			gt = gt .. ".0"
		end
		
		love.graphics.setColor(127, 127, 127)
		love.graphics.print(gt, x+150, 450, 0, scale*2)
	love.graphics.setColor(255, 255, 255)
	end
	
	love.graphics.setColor(252, 152, 56)
	love.graphics.print("enter your name using the d-pad and the x button", x-400, 920, 0, 2)
	
	love.graphics.setColor(255, 255, 255)
	for y = 1, 4 do
		for cox = 1, 10 do
			love.graphics.print(string.sub(whitelist, (y-1)*10+cox, (y-1)*10+cox), x-400+cox*70, 600+y*60, 0, 5)
		end
	end
	
	love.graphics.setColor(252, 152, 56)
	local cox = math.mod(currentletter-1, 10)+1
	local coy = math.ceil(currentletter/10)
	love.graphics.setLineWidth(6)
	love.graphics.rectangle("line", x-407+cox*70, 593+coy*60, 50, 50)
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("> " .. highscoreA[high][3] .. string.rep("_", 6-string.len(highscoreA[high][3])), x-220, 550, 0, 6)
end

function highscoreentry_joystickpressed(joy, button)
	button = button + 1
	if button == 2 or button == 4 then --A
		if string.len(highscoreA[high][3]) < 5 then
			cursorblink = true
			highscoreA[high][3] = highscoreA[high][3] .. string.sub(whitelist, currentletter, currentletter)
		else
			highscoreA[high][3] = highscoreA[high][3] .. string.sub(whitelist, currentletter, currentletter)
			savehighscoresA()
			normal_load()
		end
	elseif button == 1 or button == 3 then --B
		if highscoreA[high][3]:len() > 0 then
			cursorblink = true
			highscoreA[high][3] = string.sub(highscoreA[high][3], 1, highscoreA[high][3]:len()-1)
		end
	elseif button == 10 or button == 9 then --START
		savehighscoresA()
		normal_load()
	end
end