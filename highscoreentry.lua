function highscoreentry_load(i)
	high = i
	gamestate = "highscoreentry"
	currentletter = 1
	lockletter = false
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
end

function highscoreentry_draw()
	love.graphics.translate(0, -20)
	local x = screenwidth/2
	if high ~= 0 then
		love.graphics.draw(highscoreimg, x, 50*scale, 0, 3*scale, 3*scale, 16, 9)
		love.graphics.setColor(120/255, 0, 0)
		love.graphics.print("number " .. high, x-35*scale, 75*scale, 0, scale)
	else
		love.graphics.draw(gameoverimg, x, 50*scale, 0, 3*scale, 3*scale, 16, 9)
	end
	love.graphics.setColor(1, 1, 1)
	love.graphics.print("pellets eaten:", x-125*scale, 100*scale, 0, scale)
	love.graphics.print("time taken:", x+25*scale, 100*scale, 0, scale)
	if timeblink then
		love.graphics.setColor(1, 1, 0)
		love.graphics.print(eatored, x-95*scale, 112*scale, 0, scale*2)
	
		local gt = gametime
		
		if math.fmod(gt, 1) == 0 then
			gt = gt .. ".0"
		end
		
		love.graphics.setColor(127/255, 127/255, 127/255)
		love.graphics.print(gt, x+37*scale, 112*scale, 0, scale*2)
	love.graphics.setColor(1, 1, 1)
	end
	
	love.graphics.setColor(252/255, 152/255, 56/255)
	love.graphics.print("highscores:", x-50*scale, 160*scale, 0, scale)
	
	if high ~= 0 then
		love.graphics.setColor(1, 1, 1)
		local name = highscoreA[high][3]
		if name:len() < 6 then
			local letter = " "
			if cursorblink then
				letter = letters:sub(currentletter, currentletter)
				if letter == " " then
					letter = "_"
				end
			end
			name = name .. letter .. string.rep("_", 5-name:len())
		end
		love.graphics.print("> " .. name, x-55*scale, 137*scale, 0, scale*1.5)
	end
	for x = 1, 3 do
		for y = 1, 3 do
			local i = (x-1)*3+y
			love.graphics.setColor(1, 1, 1)
			love.graphics.print(i .. ":" .. highscoreA[i][3], (20+(y-1)*100)*scale, (175+(x-1)*30)*scale, 0, scale)
			love.graphics.setColor(1, 1, 0)
			love.graphics.print(highscoreA[i][1], (20+(y-1)*100)*scale, (183+(x-1)*30)*scale, 0, scale)
			love.graphics.rectangle("fill", (14+(y-1)*100)*scale, (185+(x-1)*30)*scale, 4*scale, 4*scale)
			love.graphics.setColor(127/255, 127/255, 127/255)
			love.graphics.print(highscoreA[i][2], (60+(y-1)*100)*scale, (183+(x-1)*30)*scale, 0, scale)
			love.graphics.setColor(1, 1, 1)
			love.graphics.draw(clockimg, (51+(y-1)*100)*scale, (183+(x-1)*30)*scale, 0, scale, scale)
		end
	end
end

function highscoreentry_joystickpressed(joy, button)

end

function highscoreentry_keyreleased(key)
	if key == "lshift" and lockletter then
		lockletter = false
		if high ~= 0 and string.len(highscoreA[high][3]) < 6 then
			cursorblink = true
			highscoreA[high][3] = highscoreA[high][3] .. letters:sub(currentletter, currentletter)
			local sound = _G["wakka" .. math.fmod(#highscoreA[high][3], 2)+1]
			sound:stop()
			sound:play()
		end
	end
end

function highscoreentry_textinput(text)
	lockletter = false
	if high == 0 then
		return
	end

	local char
	for i = 1, #whitelist do
		if text:lower() == whitelist:sub(i, i) then
			char = whitelist:sub(i, i)
		end
	end

	if char then
		if string.len(highscoreA[high][3]) < 6 then
			cursorblink = true
			highscoreA[high][3] = highscoreA[high][3] .. char
			currentletter = 1
			local sound = _G["wakka" .. math.fmod(#highscoreA[high][3], 2)+1]
			sound:stop()
			sound:play()
		end
	end
end

function highscoreentry_keypressed(key)
	if high == 0 then
		menu_load()
		return
	end

	if key == "return" then
		savehighscoresA()
		menu_load()
	elseif key == "down" or key == "up" then
		if key == "down" then
			currentletter = currentletter % #letters + 1
		else
			currentletter = (currentletter - 2) % #letters + 1
		end
		cursorblink = true
		cursortimer = 0
	elseif key == "lshift" then
		--locked in when it's let go, unless it was held for a capital letter
		lockletter = true
	elseif key == "backspace" then
		if highscoreA[high][3]:len() > 0 then
			cursorblink = true
			highscoreA[high][3] = string.sub(highscoreA[high][3], 1, highscoreA[high][3]:len()-1)
		end
	end
end