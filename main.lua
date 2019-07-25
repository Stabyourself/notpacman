--function love.errhand(msg)
--	love.audio.stop()
--	love.run()
--end

function love.load()
	require "sasorgasm"
	loadtrack()
	savetrack()
	
	require "timeattack"
	require "normal"
	require "menu"
	require "highscoreentry"
	
	------------
	--SETTINGS--
	------------
	shapedebug = false
	textdebug = false
	soundenabled = true
	fullscreen = true
	joystickdeadzone = 0.5
	
	gravitymul = 260
	
	scale = 4
	zoom = 1
	
	keyboardcontrol = false
	mousecontrol = false
	wheelcontrol1 = true
	wheelcontrol2 = false
	joystickcontrol = false
	
	pacfocus = false
	superpower = "normal" --clone, walls, normal
	powerupduration = 6
	superpelletblinkrate = 0.5
	wakkatimer = 0
	highscore = 0
	deathtime = 1.5
	deathdelay = 1
	
	pacmouthlimit = 0.25
	mouthduration = 0.22
	
	whitelist = "abcdefghijklmnopqrstuvwxyz    0123456789"
	
	----END----
	
	windowwidth = 1680
	windowheight = 1050

	screenwidth = 1500
	screenheight = 1050
	
	fsaa = 2
	vsync = true
	
	love.graphics.setMode(windowwidth, windowheight, fullscreen, vsync, fsaa)
	
	boardwidth = 220
	boardheight = 216
	
	--GRAPHICS--
	
	titlesideways = love.graphics.newImage("graphics/titlesideways.png");titlesideways:setFilter("nearest", "nearest") 
	mainfield = love.graphics.newImage("graphics/field.png");mainfield:setFilter("nearest", "nearest") 
	mainfieldoverlay = love.graphics.newImage("graphics/fieldoverlay.png");mainfieldoverlay:setFilter("nearest", "nearest") 
	superpellet = love.graphics.newImage("graphics/superpellet.png");superpellet:setFilter("nearest", "nearest") 
	pacman = love.graphics.newImage("graphics/pacmanman.png")
	ghost1 = love.graphics.newImage("graphics/ghost1.png")
	ghost2 = love.graphics.newImage("graphics/ghost2.png")
	ghost3 = love.graphics.newImage("graphics/ghost3.png")
	ghostscared = love.graphics.newImage("graphics/ghostscared.png")
	title = love.graphics.newImage("graphics/title.png");title:setFilter("nearest", "nearest") 
	gamescoreimg = love.graphics.newImage("graphics/gamescore.png");gamescoreimg:setFilter("nearest", "nearest") 
	highscoreimg = love.graphics.newImage("graphics/highscore.png");highscoreimg:setFilter("nearest", "nearest") 
	clockimg = love.graphics.newImage("graphics/clock.png");clockimg:setFilter("nearest", "nearest") 
	
	fontimage = love.graphics.newImage("graphics/font.png");fontimage:setFilter("nearest","nearest")
	pacmanfont = love.graphics.newImageFont(fontimage, "0123456789abcdefghijklmnopqrstuvwxyz.:/,'C-_> ")
	love.graphics.setFont(pacmanfont)
	
	--SOUNDS--
	wakka = love.audio.newSource("sounds/pacman_chomp.wav", "static")
	beginning = love.audio.newSource("sounds/pacman_beginning.wav", "static")
	death = love.audio.newSource("sounds/pacman_death.wav", "static")
	
	loadhighscores()
	
	--menu_load()
	
	eatored = 201
	gametime = 12
	
	normal_load()
end

function love.update(dt)
	if gamestate == "timeattack" then
		timeattack_update(dt)
	elseif gamestate == "normal" then
		normal_update(dt)
	elseif gamestate == "menu" then
		menu_update(dt)
	elseif gamestate == "highscoreentry" then
		highscoreentry_update(dt)
	end
end

function love.draw()
	if gamestate == "timeattack" then
		timeattack_draw()
	elseif gamestate == "normal" then
		normal_draw()
	elseif gamestate == "menu" then
		menu_draw()
	elseif gamestate == "highscoreentry" then
		highscoreentry_draw()
	end
	
	love.graphics.draw(titlesideways, 6*scale, (screenheight-224*scale)/2, 0, scale, scale)
	
	
	--Highscores n shit	
	love.graphics.draw(highscoreimg, windowwidth-49*scale, screenheight/2-115*scale, 0, scale, scale)
	for i = 1, #highscoreA do
		if tonumber(highscoreA[i][1]) >= 0 then
			--name
			love.graphics.setColor(252, 152, 56)
			love.graphics.print(string.lower(string.sub(highscoreA[i][3], 1, 6)), windowwidth-49*scale, (20+20*i)*scale, 0, scale)
			love.graphics.setColor(255, 255, 255)
			--score
			local s = highscoreA[i][1] .. " "
			local s2 = highscoreA[i][2] .. ""
			
			if math.mod(highscoreA[i][2], 1) == 0 then
				s2 = s2 .. ".0"
			end
			
			if string.len(s2) > 5 then
				s2 = string.sub(s2, 1, string.len(s2)-2)
			end
			
			local offsetX = -64*scale
			love.graphics.print(s, windowwidth-(1+9)*scale+offsetX, (28+20*i)*scale, 0, scale)
			love.graphics.setColor(255, 255, 0)
			love.graphics.rectangle( "fill", windowwidth-(9+7)*scale+offsetX, (30+20*i)*scale, 4*scale, 4*scale)
			love.graphics.setColor(127, 127, 127)
			
			local offsetX = 0
			for i = 1, s2:len() - 1 do
				offsetX = offsetX - 8*scale
			end
			love.graphics.print(s2, windowwidth-9*scale+offsetX, (28+20*i)*scale, 0, scale)
			love.graphics.setColor(255, 255, 255)
			love.graphics.draw(clockimg, windowwidth-(8+9)*scale+offsetX, (28+20*i)*scale, 0, scale)
			
			love.graphics.setColor(120, 0, 0)
			love.graphics.rectangle("fill", windowwidth-81*scale, (17+20*i)*scale, 80*scale, scale)
			love.graphics.setColor(255, 255, 255)
		end
	end
end

function love.keypressed(key)
	if key == "escape" then
		love.event.push("q")
	end
	if gamestate == "timeattack" then
		timeattack_keypressed(key)
	elseif gamestate == "normal" then
		normal_keypressed(key)
	elseif gamestate == "menu" then
		menu_keypressed(key)
	elseif gamestate == "highscoreentry" then
	
	end
end

function love.mousepressed(x, y, button)
	if gamestate == "timeattack" then
		timeattack_mousepressed(x, y, button)
	elseif gamestate == "normal" then
		normal_mousepressed(x, y, button)
	end
end

function love.joystickpressed(joystick, button)
	if gamestate == "menu" then
		menu_joystickpressed(joystick, button)
	elseif gamestate == "highscoreentry" then
		highscoreentry_joystickpressed(joystick, button)
	end
end

function string:split(delimiter) --Not by me
	local result = {}
	local from  = 1
	local delim_from, delim_to = string.find( self, delimiter, from  )
	while delim_from do
		table.insert( result, string.sub( self, from , delim_from-1 ) )
		from = delim_to + 1
		delim_from, delim_to = string.find( self, delimiter, from  )
	end
	table.insert( result, string.sub( self, from  ) )
	return result
end


function print_r (t, indent) --Not by me
	local indent=indent or ''
	for key,value in pairs(t) do
		io.write(indent,'[',tostring(key),']') 
		if type(value)=="table" then io.write(':\n') print_r(value,indent..'\t')
		else io.write(' = ',tostring(value),'\n') end
	end
end

function loadhighscores()
	if love.filesystem.exists("highscoreA") then
		local t = love.filesystem.read("highscoreA")
		highscoreA = t:split(";")
		for i = 1, #highscoreA do
			highscoreA[i] = highscoreA[i]:split(":")
			highscoreA[i][1] = tonumber(highscoreA[i][1])
			highscoreA[i][2] = tonumber(highscoreA[i][2])
		end
	else
		highscoreA = {}
		for i = 1, 10 do
			highscoreA[i] = {0, 0, "------"}
		end
	end
	
	savehighscoresA()
	
	if love.filesystem.exists("highscoreB") then
		local t = love.filesystem.read("highscoreB")
		highscoreB = tonumber(t)
	else
		highscoreB = 0
		love.filesystem.write("highscoreB", "0")
	end
end

function addzeros(s, i)
	for j = string.len(s)+1, i do
		s = "0" .. s
	end
	return s
end