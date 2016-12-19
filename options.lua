function options_load()
	gamestate = "options"
	optionsselection = 1
	for i = 1, #controlmethods do
		if controlmethods[i] == controlmethod then
			optionsselection = i
			break
		end
	end
	
	options_createdemoworld()
	
	demorotation = 0
	demotargetrotation = 0
	options_updategravity(1)
	demoupdates = 0
	
	ghostx = windowwidth+500
	
	optionsmouth = pacmouthlimit
	mouthdir = -1
	
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

function options_createdemoworld()
	--demo world
	demoworld = love.physics.newWorld( 0, 0, screenwidth*2, screenheight*2, 0, 800, false)
	
	demofieldbody = love.physics.newBody(demoworld, screenwidth / 2, screenheight / 2, 0, 0)
	
	demoworldshapes = {}
	demoworldshapes[1] = love.physics.newRectangleShape(demofieldbody, -25*scale, 0*scale, 10*scale, 50*scale)
	demoworldshapes[2] = love.physics.newRectangleShape(demofieldbody, 0*scale, -25*scale, 50*scale, 10*scale)
	demoworldshapes[3] = love.physics.newRectangleShape(demofieldbody, 25*scale, 0*scale, 10*scale, 50*scale)
	demoworldshapes[4] = love.physics.newRectangleShape(demofieldbody, 0*scale, 25*scale, 50*scale, 10*scale)
	demoworldshapes[5] = love.physics.newRectangleShape(demofieldbody, 0*scale, 0*scale, 5*scale, 5*scale)
	
	demopacmanbody = love.physics.newBody(demoworld, screenwidth/2-4*scale, screenheight/2-10*scale, 0.1)
	demopacmanbody:setBullet(true)
	demopacmanbody:setInertia( 0.001 )
	demopacmanshape = love.physics.newCircleShape(demopacmanbody, 0, 0, 6.5*scale)
	demopacmanshape:setFriction( 1000)
	demopacmanshape:setMask(3)
end

function options_update(dt)
	demoworld:update(dt)
	options_updategravity(dt)
	
	--Controls
	if controlmethod == "joystick" then
		x = love.joystick.getAxis( 0, 0 )
		y = -love.joystick.getAxis( 0, 1 )
		if math.abs(x) + math.abs(y) > joystickdeadzone then
			demotargetrotation = math.deg(math.atan2(x, y) )
		end
	elseif controlmethod == "wheel steering" then
		x = love.joystick.getAxis( 0, 0)
		demotargetrotation = demotargetrotation+x*dt*400
		if demotargetrotation < 0 then
			demotargetrotation = demotargetrotation + 360
		elseif demotargetrotation > 360 then
			demotargetrotation = demotargetrotation - 360
		end
	elseif controlmethod == "wheel direct" then
		x = love.joystick.getAxis( 0, 0)
		demotargetrotation = x*180
		if demotargetrotation < 0 then
			demotargetrotation = demotargetrotation + 360
		end
	elseif controlmethod == "keyboard" then
		local multiplier = 100
		if love.keyboard.isDown( "rshift" ) or love.keyboard.isDown( "lshift" ) then
			multiplier = 300
		end
		if love.keyboard.isDown( "left" ) then
			demotargetrotation = demotargetrotation - multiplier*dt
		end
		if love.keyboard.isDown( "right" ) then
			demotargetrotation = demotargetrotation + multiplier*dt
		end
	elseif controlmethod == "mouse direction" then
		x, y = love.mouse.getPosition( )
		x = x - (windowwidth/2+windowwidth/4.5)
		y = (windowheight/2-windowheight/5) - y
		demotargetrotation = math.deg(math.atan2(x, y))
	elseif controlmethod == "mouse" then
		x, y = love.mouse.getPosition()
		
		if oldx then
			diff = x-oldx
			demotargetrotation = demotargetrotation+diff*dt*mouse2speed
		end
		
		oldx, oldy = x, y
		
		demoupdates = demoupdates + dt
		if demoupdates > mouse2rate then
			demoupdates = 0
			oldx = windowwidth/2
			love.mouse.setPosition(windowwidth/2, windowheight/2)
		end
	end
	
	optionsmouth = optionsmouth + dt*mouthdir*3
	
	if optionsmouth < 0 then
		optionsmouth = 0
		mouthdir = 1
	elseif optionsmouth > pacmouthlimit then
		optionsmouth = pacmouthlimit
		mouthdir = -1
	end
	
	ghostx = ghostx - dt*150*scale
	if ghostx < -1000 then
		ghostx = windowwidth + 500
	end
end

function options_draw()
	--options
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(optionsimg, windowwidth/2-32*scale, 14*scale, 0, scale, scale)
	
	
	love.graphics.rectangle("line", 5*scale, 63*scale, 140*scale, 160*scale)
	love.graphics.rectangle("line", 5*scale, 63*scale, 140*scale, 122*scale)
	love.graphics.setColor(164, 0, 0)
	love.graphics.print("control scheme", 8*scale, 53*scale, 0, scale)
	love.graphics.setColor(255, 255, 255)
	local controlmethods = {unpack(controlmethods)}
	
	
	local s = "scale:  "
	if scale > 1 then
		s = s .. "<"
	else
		s = s .. " "
	end
	s = s .. " " .. scale .. " "
	if scale < 4 then
		s = s .. ">"
	end
	
	table.insert(controlmethods, s)
	
	
	local s = "volume: "
	if volume > 0 then
		s = s .. "<"
	else
		s = s .. " "
	end
	s = s .. " " .. volume .. " "
	if volume < 10 then
		s = s .. ">"
	end
	
	table.insert(controlmethods, s)
	
	for i = 1, #controlmethods do
		if optionsselection == i then
			love.graphics.setColor(255, 255, 255)
		else
			love.graphics.setColor(127, 127, 127)
		end
		love.graphics.print(controlmethods[i], 20*scale, ((i-1)*20+70)*scale, 0, scale)
	end
	
	local bla = 1
	for i = 1, #controlmethods do
		if controlmethods[i] == controlmethod then
			bla = i
			break
		end
	end
	
	love.graphics.setColor(252, 116, 96)
	love.graphics.print(">", 8*scale, ((bla-1)*20+70)*scale, 0, scale)
	love.graphics.setColor(255, 255, 255)
	if optionsselection < #controlmethods-1 then
		love.graphics.print(controldescriptions[controlmethods[optionsselection]], 153*scale, 150*scale, 0, scale)
	elseif optionsselection < #controlmethods then
		love.graphics.print("change the size\n\nof the window", 153*scale, 150*scale, 0, scale)
	else
		love.graphics.print("change volume", 153*scale, 150*scale, 0, scale)
	end
	love.graphics.rectangle("line", 150*scale, 145*scale, 165*scale, 53*scale)
	love.graphics.setColor(164, 0, 0)
	love.graphics.print("description", 153*scale, 135*scale, 0, scale)
	love.graphics.setColor(255, 255, 255)
	
	--Silly ghosts
	for i = 1, 3 do
		love.graphics.draw(ghostscared1, ghostx + i*25*scale, windowheight-20*scale, 0, scale/40, scale/40)
	end
	
	local x = ghostx + 120*scale
	local y = windowheight-13*scale
	
	coords = {}
	table.insert(coords, x) --add center
	table.insert(coords, y)
	
	for ang = 360*(optionsmouth/2), 360 - 360*(optionsmouth/2) do
		table.insert(coords, math.sin(math.rad(ang-90))*6.5*scale+x)
		table.insert(coords, -math.cos(math.rad(ang-90))*6.5*scale+y)
	end
	
	if #coords > 6 then
		love.graphics.setColor(255, 255, 50)
		love.graphics.polygon("fill", unpack(coords))
		love.graphics.setColor(255, 255, 255)
	end
	
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("line", -10, windowheight-22*scale, windowwidth+20, 18*scale)
	
	--Rotate da worl
	love.graphics.push()
	love.graphics.translate(windowwidth/2, windowheight/2)
	love.graphics.translate(windowwidth/4.5, -windowheight/5)
	love.graphics.rotate(math.rad(demorotation))
	love.graphics.translate(-windowwidth/2, -windowheight/2)
	
	--Demo Pacman
	local x = demopacmanbody:getX()
	local y = demopacmanbody:getY()
	coords = {}
	table.insert(coords, x) --add center
	table.insert(coords, y)
	
	for ang = 360*(pacmouthlimit/2), 360 - 360*(pacmouthlimit/2) do
		table.insert(coords, math.sin(math.rad(ang-90) + demopacmanbody:getAngle())*6.5*scale+x)
		table.insert(coords, -math.cos(math.rad(ang-90) + demopacmanbody:getAngle())*6.5*scale+y)
	end
	
	if #coords > 6 then
		love.graphics.setColor(255, 255, 50)
		love.graphics.polygon("fill", unpack(coords))
		love.graphics.setColor(255, 255, 255)
	end
	
	love.graphics.setColor(0, 0, 255)
	love.graphics.rectangle("line", windowwidth/2-21*scale, windowheight/2-21*scale, 42*scale, 42*scale)
	love.graphics.rectangle("line", windowwidth/2-24*scale, windowheight/2-24*scale, 48*scale, 48*scale)
	love.graphics.rectangle("line", windowwidth/2-2*scale, windowheight/2-2*scale, 4*scale, 4*scale)
	love.graphics.pop()
end

function options_updategravity(dt) --"rotates" the world. (It actually only changes the gravity "direction" because actually rotating the world caused centrifugalforces to be a bitch)
	--smooth targetrotation into rotation
	
	demotargetrotation = math.mod(demotargetrotation+360, 360)
	
	if demotargetrotation > demorotation + 180 then
		demorotation = demorotation + 360
	elseif demotargetrotation < demorotation - 180 then
		demorotation = demorotation - 360
	end
	
	if demotargetrotation > demorotation then
		demorotation = demorotation + (demotargetrotation-demorotation)*dt*20
	else
		demorotation = demorotation + (demotargetrotation-demorotation)*dt*20
	end
	
	demogravityX = math.sin(math.rad(demorotation))
	demogravityY = math.cos(math.rad(demorotation))	
	demoworld:setGravity( demogravityX*gravitymul*scale, demogravityY*gravitymul*scale )
end

function options_keypressed(key, uni)
	if key == "escape" then
		savehighscoresA()
		menu_load(true)
	end
	
	if key == "return" then
		if optionsselection <= #controlmethods then
			controlmethod = controlmethods[optionsselection]
			
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
	end
	
	if optionsselection == #controlmethods + 1 then
		if key == "right" then
			if scale < 4 then
				changescale(scale+1)
			end
		elseif key == "left" then
			if scale > 1 then
				changescale(scale-1)
			end
		end
	elseif optionsselection == #controlmethods + 2 then
		if key == "right" then
			if volume < 10 then
				volume = volume + 1
				love.audio.setVolume(volume/10)
				local sound = _G["wakka" .. math.mod(volume, 2)+1]
				sound:stop()
				sound:play()
			end
		elseif key == "left" then
			if volume > 0 then
				volume = volume - 1
				love.audio.setVolume(volume/10)
				local sound = _G["wakka" .. math.mod(volume, 2)+1]
				sound:stop()
				sound:play()
			end
		end
	end
	
	if key == "up" then
		optionsselection = math.max(optionsselection - 1, 1)
	elseif key == "down" then
		optionsselection = math.min(optionsselection + 1, #controlmethods+2)
	end
end