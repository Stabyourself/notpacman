function menu_load()
	gamestate = "menu"
	menutimer = love.timer.getTime()
	introdelay = 3
	menustarted = false
	menuselection = 1
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
		love.graphics.setColor(102, 102, 102)
		love.graphics.print("time attack", screenwidth/2-31*scale, 170*scale+yoffset, 0, scale)
		love.graphics.setColor(255, 255, 255)
		love.graphics.print("> regular", screenwidth/2-48*scale, 154*scale+yoffset, 0, scale)
	
		love.graphics.print(addzeros(tostring(highscoreA), 5), screenwidth/2-15*scale, 58*scale+yoffset, 0, scale)
	elseif menuselection == 2 then
		love.graphics.setColor(102, 102, 102)
		love.graphics.print("regular", screenwidth/2-31*scale, 154*scale+yoffset, 0, scale)
		love.graphics.setColor(255, 255, 255)
		love.graphics.print("> time attack", screenwidth/2-48*scale, 170*scale+yoffset, 0, scale)
	
		love.graphics.print(addzeros(tostring(highscoreB), 5), screenwidth/2-15*scale, 58*scale+yoffset, 0, scale)
	end
end

function menu_keypressed(key)
	if menustarted == false then
		menustarted = true
	elseif key == "return" then
		if menuselection == 1 then
			normal_load()
		else
			timeattack_load()
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
		timeattack_load()
	end
end

function savehighscoresA()
	local s = ""
	for i = 1, 10 do
		s = s .. highscoreA[i][1] .. ":" .. highscoreA[i][2] .. ":" .. highscoreA[i][3]
		if i ~= 10 then
			s = s .. ";"
		end
	end
	
	love.filesystem.write("highscoreA", s)
end