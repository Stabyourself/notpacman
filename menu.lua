function menu_load(skip)
	gamestate = "menu"
	menutimer = love.timer.getTime()
	introdelay = 3
	menustarted = false
	menuselection = 1
	
	normal_stopgamesounds()
	
	if skip then
		menustarted = true
	end
	
	if controlmethod == "mouse" then
		love.mouse.setVisible(false)
		love.mouse.setGrab(true)
	elseif controlmethod == "mouse direction" then
		love.mouse.setGrab(true)
		love.mouse.setVisible(true)
	else
		love.mouse.setGrab(false)
		love.mouse.setVisible(true)
	end
end

function menu_update(dt)
	if menustarted == false then
		currenttime = love.timer.getTime()
		if currenttime - menutimer > introdelay then
			menustarted = true
		end
	end
end

function menu_draw()
	local yoffset = 0
	if menustarted == false then
		currenttime = love.timer.getTime()
		yoffset = math.floor(250*scale-250*((currenttime-menutimer)/introdelay)*scale)
	end
	
	love.graphics.draw(title, screenwidth/2-150*scale, screenheight/2-150*scale+yoffset, 0, scale, scale)
	
	if menuselection == 1 then
		love.graphics.setColor(255, 255, 255)
		love.graphics.print("> play", screenwidth/2-48*scale, 134*scale+yoffset, 0, scale)
		love.graphics.setColor(102, 102, 102)
		love.graphics.print("options", screenwidth/2-31*scale, 150*scale+yoffset, 0, scale)
	
		love.graphics.setColor(255, 255, 255)
	elseif menuselection == 2 then
		love.graphics.setColor(102, 102, 102)
		love.graphics.print("play", screenwidth/2-31*scale, 134*scale+yoffset, 0, scale)
		love.graphics.setColor(255, 255, 255)
		love.graphics.print("> options", screenwidth/2-48*scale, 150*scale+yoffset, 0, scale)
	end
	
	
	local gt = highscoreA[1][2]
	
	if math.mod(gt, 1) == 0 then
		gt = gt .. ".0"
	end
	
	love.graphics.setColor(255, 255, 255)
	love.graphics.print(highscoreA[1][3], 137*scale, 35*scale+yoffset, 0, scale)
	love.graphics.setColor(255, 255, 0)
	love.graphics.print(highscoreA[1][1], 125*scale, 45*scale+yoffset, 0, scale)
	love.graphics.rectangle("fill", 117*scale, 46*scale+yoffset, 4*scale, 4*scale)
	love.graphics.setColor(127, 127, 127)
	love.graphics.print(gt, 165*scale, 45*scale+yoffset, 0, scale)
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(clockimg, 155*scale, 45*scale+yoffset, 0, scale, scale)
end

function menu_keypressed(key)
	if key == "escape" then
		love.event.push("q")
	end
	
	if menustarted == false then
		menustarted = true
	elseif key == "return" then
		if menuselection == 1 then
			normal_load()
		else
			options_load()
		end
	elseif key == "up" or key == "down" then
		if menuselection == 1 then
			menuselection = 2
		else
			menuselection = 1
		end
	end
end

function menu_joystickpressed(joystick, button)
	if menustarted == false then
		menustarted = true
	else
		normal_load()
	end
end