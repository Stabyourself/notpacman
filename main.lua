--[[
        DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
                    Version 2, December 2004 

 Copyright (C) 2004 Sam Hocevar <sam@hocevar.net> 

 Everyone is permitted to copy and distribute verbatim or modified 
 copies of this license document, and changing it is allowed as long 
 as the name is changed. 

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 

  0. You just DO WHAT THE FUCK YOU WANT TO.
 ]]

function love.load()
	
	require "normal"
	require "menu"
	require "highscoreentry"
	require "options"
	require "intro"
	
	------------
	--SETTINGS--
	------------
	soundenabled = true
	fullscreen = false
	joystickdeadzone = 0.5
	
	numhighscores = 9
	
	gravitymul = 260
	
	scale = 2
	zoom = 1
	
	controlmethods = {"mouse", "keyboard", "mouse direction", "joystick", "wheel steering", "wheel direct"}
	controldescriptions = {	mouse="move the mouse\n\nleft and right",
							keyboard="use arrow keys to\n\nrotate, shift to\n\nspeed up",
							['mouse direction']="point with your\n\nmouse towards a\n\ndirection",
							joystick="point with your\n\njoystick",
							['wheel steering']="drive like a car",
							['wheel direct']="1:1 wheel to\n\ngame translation"}
	controlmethod = "mouse"
	
	pacfocus = false
	superpower = "normal" --clone, walls, normal
	powerupduration = 6
	superpelletblinkrate = 0.5
	wakkatimer = 0
	highscore = 0
	deathtime = 1.5
	deathdelay = 1
	mouse2rate = 0.05
	mouse2speed = 20 --50 for my macbook because who knows why, 20 else
	volume = 10
	
	pacmouthlimit = 0.25
	mouthduration = 0.22
	
	whitelist = "abcdefghijklmnopqrstuvwxyz 0123456789"
	
	scale = 2
	
	----END----
	
	loadhighscores()
	
	icon = love.graphics.newImage("graphics/icon.png");icon:setFilter("nearest", "nearest")
	changescale(scale)
	
	boardwidth = 220
	boardheight = 216
	
	--GRAPHICS--
	
	mainfield = love.graphics.newImage("graphics/field.png");mainfield:setFilter("nearest", "nearest") 
	mainfieldoverlay = love.graphics.newImage("graphics/fieldoverlay.png");mainfieldoverlay:setFilter("nearest", "nearest") 
	superpellet = love.graphics.newImage("graphics/superpellet.png");superpellet:setFilter("nearest", "nearest") 
	pacman = love.graphics.newImage("graphics/pacmanman.png")
	ghost1 = love.graphics.newImage("graphics/ghost1.png")
	ghost2 = love.graphics.newImage("graphics/ghost2.png")
	ghost3 = love.graphics.newImage("graphics/ghost3.png")
	ghostscared1 = love.graphics.newImage("graphics/ghostscared1.png")
	ghostscared2 = love.graphics.newImage("graphics/ghostscared2.png")
	ghosteyes = love.graphics.newImage("graphics/eyes.png")
	spinnyeyes = love.graphics.newImage("graphics/spinnyeyes.png")
	title = love.graphics.newImage("graphics/title.png");title:setFilter("nearest", "nearest") 
	gamescoreimg = love.graphics.newImage("graphics/gamescore.png");gamescoreimg:setFilter("nearest", "nearest") 
	highscoreimg = love.graphics.newImage("graphics/highscore.png");highscoreimg:setFilter("nearest", "nearest") 
	gameoverimg = love.graphics.newImage("graphics/gameover.png");gameoverimg:setFilter("nearest", "nearest") 
	clockimg = love.graphics.newImage("graphics/clock.png");clockimg:setFilter("nearest", "nearest") 
	optionsimg = love.graphics.newImage("graphics/options.png");optionsimg:setFilter("nearest", "nearest") 
	logo = love.graphics.newImage("graphics/logo.png")
	logoblood = love.graphics.newImage("graphics/logoblood.png")
	
	
	fontimage = love.graphics.newImage("graphics/font.png");fontimage:setFilter("nearest","nearest")
	pacmanfont = love.graphics.newImageFont(fontimage, "0123456789abcdefghijklmnopqrstuvwxyz.:/,'C-_> <")
	love.graphics.setFont(pacmanfont)
	
	--SOUNDS--
	wakka1 = love.audio.newSource("sounds/pacman_waka_wa.ogg", "static")
	wakka2 = love.audio.newSource("sounds/pacman_waka_ka.ogg", "static")
	eatghost = love.audio.newSource("sounds/eat_ghost.ogg", "static"); eatghost:setVolume(0.5)
	ghostsiren = love.audio.newSource("sounds/ghosts_siren.ogg", "static"); ghostsiren:setVolume(0); ghostsiren:setLooping(true)
	ghostrunaway = love.audio.newSource("sounds/ghosts_runaway.ogg", "static"); ghostrunaway:setVolume(0); ghostrunaway:setLooping(true)
	beginning = love.audio.newSource("sounds/pacman_beginning.ogg", "static")
	gamewin = love.audio.newSource("sounds/win.ogg", "static")
	death = love.audio.newSource("sounds/pacman_death.ogg", "static")
	stabsound = love.audio.newSource("sounds/stab.ogg", "static")
	
	intro_load()
end

function love.update(dt)
	if skipupdate then
		skipupdate = false
		return
	end
	
	dt = math.min(dt, 1/30)
	if _G[gamestate .. "_update"] then
		_G[gamestate .. "_update"](dt)
	end
end

function love.draw()
	if _G[gamestate .. "_draw"] then
		_G[gamestate .. "_draw"]()
	end
end

function love.keypressed(key, unicode)
	if _G[gamestate .. "_keypressed"] then
		_G[gamestate .. "_keypressed"](key, unicode)
	end
end

function love.mousepressed(x, y, button)
	if _G[gamestate .. "_mousepressed"] then
		_G[gamestate .. "_mousepressed"](x, y, button)
	end
end

function love.joystickpressed(joystick, button)
	if _G[gamestate .. "_joystickpressed"] then
		_G[gamestate .. "_joystickpressed"](joystick, button)
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

function changescale(s)
	local grabbed = love.mouse.isGrabbed()
	scale = s
	
	windowwidth = 320*scale
	windowheight = 250*scale

	screenwidth = windowwidth
	screenheight = windowheight
	
	
	fsaa = 16
	vsync = true
	love.graphics.setLineWidth(5/3*scale)
	
	if gamestate == "options" then
		options_createdemoworld()
	end
	
	if love.graphics.getWidth() ~= windowwidth or love.graphics.getHeight() ~= windowheight then
		love.graphics.setMode(windowwidth, windowheight, fullscreen, vsync, fsaa)
	end
	
	love.graphics.setIcon(icon)
	
	love.mouse.setGrab(grabbed)
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
		local s = love.filesystem.read("highscoreA"):split("#")
		if #s < 2 then
			s[3] = s[1]
		else
			controlmethod = s[1]
			scale = tonumber(s[2])
		end
		local t = s[3]
		highscoreA = t:split(";")
		for i = 1, #highscoreA do
			highscoreA[i] = highscoreA[i]:split(":")
			highscoreA[i][1] = tonumber(highscoreA[i][1])
			highscoreA[i][2] = tonumber(highscoreA[i][2])
		end
	else
		highscoreA = {}
		for i = 1, numhighscores do
			highscoreA[i] = {0, 0, "------"}
		end
	end
	
	savehighscoresA()
end

function savehighscoresA()
	local s = controlmethod .. "#"
	local s = s .. scale .. "#"
	for i = 1, numhighscores do
		if (highscoreA[i][1] and highscoreA[i][2] and highscoreA[i][3]) then
			s = s .. highscoreA[i][1] .. ":" .. highscoreA[i][2] .. ":" .. highscoreA[i][3]
		else
			s = s .. "------" .. ":0:0"
		end
		if i ~= numhighscores then
			s = s .. ";"
		end
	end
	
	love.filesystem.write("highscoreA", s)
end

function addzeros(s, i)
	for j = string.len(s)+1, i do
		s = "0" .. s
	end
	return s
end