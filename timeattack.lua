function timeattack_load() --initializes all variables
	gamestate = "timeattack"
	gamestarted = false
	
	timeattack_createworld()
	
	eatored = 0
	finaltime = 0
	superpellettimer = 0
	superpelletblink = false
	powerup = false
	starttimer = love.timer.getTime()
	pacmouthopenness = pacmouthlimit
	
	score = 0
	rotation = 0
	targetrotation = 0
	timeattack_updategravity()
	
	love.mouse.setVisible( true )
	
	pelletmap ={{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, --shit man
				{1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}, --26x29
				{1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}, --1 = pellet
				{1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}, --2 = super pellet
				{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, --244 total (244 normals)
				{1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1}, --It's [y][x]!
				{1, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 1},
				{1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1},
				{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
				{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
				{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
				{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
				{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
				{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
				{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
				{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
				{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
				{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
				{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
				{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
				{1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1},
				{1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1},
				{1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1},
				{0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0},
				{0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0},
				{1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1},
				{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
				{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
				{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}}
					
	if soundenabled then
		love.audio.stop(beginning)
		love.audio.play(beginning)
	end
end

function timeattack_update(dt)
	currenttime = love.timer.getTime()
	
	if gamestarted == false then
		if currenttime - starttimer > 4.2 then
			starttimer = love.timer.getTime()
			timeattack_start()
		end
	else
		timeattack_updategravity()
		
		--update score
		score = math.floor((currenttime-starttimer)*10)/10
		
		--wakka animation
		if currenttime - wakkatimer < mouthduration then
			if currenttime - wakkatimer < mouthduration/2 then
				pacmouthopenness = pacmouthlimit-pacmouthlimit*((currenttime-wakkatimer)/(mouthduration/2))
			else
				pacmouthopenness = pacmouthlimit*((currenttime-wakkatimer-mouthduration/2)/(mouthduration/2))
			end
		else
			pacmouthopenness = pacmouthlimit
		end
		
		--joystick
		if joystickcontrol then
			x = love.joystick.getAxis( 0, 0 )
			y = -love.joystick.getAxis( 0, 1 )
			if math.abs(x) + math.abs(y) > joystickdeadzone then
				targetrotation = math.deg(math.atan2(x, y) )
			end
		end
	
		--keyboard
		if keyboardcontrol then
			if love.keyboard.isDown( "left" ) then
				targetrotation = targetrotation - 100*dt
				timeattack_updategravity()
			end
			if love.keyboard.isDown( "right" ) then
				targetrotation = targetrotation + 100*dt
				timeattack_updategravity()
			end
		end
		
		--mouse
		if mousecontrol then
			x, y = love.mouse.getPosition( )
			x = x - screenwidth/2
			y = (screenheight - y) - screenheight/2
			targetrotation = math.deg(math.atan2(x, y))
			timeattack_updategravity()
		end
		
		--pacman stuff
		x, y = timeattack_pacmangetposition(pacmanbody:getX(), pacmanbody:getY())
		timeattack_checkpellet(x, y)
		
		--Teleport
		if y == 14 and x < 2 then
			pacmanbody:setX(screenwidth/2+11.5*8*scale)
		elseif y == 14 and x > 25 then
			pacmanbody:setX(screenwidth/2-11.5*8*scale)
		end
		
		--clone stuff
		if powerup and superpower == "clone" then
			x, y = timeattack_pacmangetposition(clonebody:getX(), clonebody:getY())
			timeattack_checkpellet(x, y)
			
			--Teleport
			if y == 14 and x < 2 then
				clonebody:setX(screenwidth/2+12*8*scale)
			elseif y == 14 and x > 25 then
				clonebody:setX(screenwidth/2-12*8*scale)
			end
		end
		
		
		world:update(dt)
	end
end

function timeattack_draw()
	
	--score
	love.graphics.draw(gamescoreimg, screenwidth/2-151*scale, screenheight/2-107*scale, 0, scale, scale)
	
	local formattedscore = tostring(math.floor(score*10)/10)
	if string.sub(formattedscore, -2, -2) ~= "." then
		formattedscore = formattedscore .. ".0"
	end
	
	for i = 1, 5 do
		if string.len(formattedscore) >= 6 - i then
			love.graphics.print(string.sub(formattedscore, i-(5-string.len(formattedscore)), i-(5-string.len(formattedscore))), screenwidth/2-141*scale, screenheight/2-94*scale+9*i*scale, 0, scale)
		else
			love.graphics.print("0", screenwidth/2-141*scale, screenheight/2-94*scale+9*i*scale, 0, scale)
		end
	end
	
	--highscore	
	love.graphics.draw(highscoreimg, screenwidth/2+121*scale, screenheight/2-107*scale, 0, scale, scale)
	
	for i = 1, 5 do
		if string.len(tostring(highscoreB)) >= 6 - i then
			love.graphics.print(string.sub(tostring(highscoreB), i-(5-string.len(tostring(highscoreB))), i-(5-string.len(tostring(highscoreB)))), screenwidth/2+133*scale, screenheight/2-94*scale+9*i*scale, 0, scale)
		else
			love.graphics.print("0", screenwidth/2+133*scale, screenheight/2-94*scale+9*i*scale, 0, scale)
		end
	end
	--TEXT
	if textdebug then
		love.graphics.print("fps: " .. love.timer.getFPS(), 0, 12)
		love.graphics.print("pellets eaten: " .. eatored .. "/244", 0, 24)
		
		if finaltime ~= 0 or gamestarted == false then
			love.graphics.print("time: " .. math.floor(finaltime*100)/100, 0, 36)
		else
			currenttime = love.timer.getTime()
			love.graphics.print("time: " .. math.floor((currenttime - timer)*100)/100, 0, 36)
		end
		
		if keyboardcontrol then
			love.graphics.print("controls: keyboard", 0, 48)
		elseif mousecontrol then
			love.graphics.print("controls: mouse", 0, 48)
		elseif joystickcontrol then
			love.graphics.print("controls: joystick", 0, 48)
		end
	end
	
	--guideline for joystick
	if joystickcontrol then
		x = love.joystick.getAxis( 0, 0 )
		y = love.joystick.getAxis( 0, 1 )
		love.graphics.line(screenwidth/2, screenheight/2, screenwidth/2+x*(screenheight/2), screenheight/2+y*(screenheight/2))
	end
	
	--Rotate
	love.graphics.translate(screenwidth/2, screenheight/2)
	love.graphics.rotate(math.rad(rotation))
	love.graphics.translate(-screenwidth/2, -screenheight/2)
	
	--Change focus on pacman if pacfocus == true, also scale.
	if pacfocus then
		love.graphics.scale(zoom)
		love.graphics.translate(-pacmanbody:getX()+screenwidth/2/zoom, -pacmanbody:getY()+screenheight/2/zoom)
	end
	
	--Background, Pacman, clone and background overlay.
	love.graphics.draw( mainfield, fieldbody:getX()+1, fieldbody:getY()+1, 0, scale, scale, boardwidth/2, boardheight/2)
	--pac:			
	local x = pacmanbody:getX()
	local y = pacmanbody:getY()
	coords = {}
	table.insert(coords, x) --add center
	table.insert(coords, y)
	
	for ang = 360*(pacmouthopenness/2), 360 - 360*(pacmouthopenness/2) do
		table.insert(coords, math.sin(math.rad(ang-90) + pacmanbody:getAngle())*6.5*scale+x)
		table.insert(coords, -math.cos(math.rad(ang-90) + pacmanbody:getAngle())*6.5*scale+y)
	end
	
	if #coords > 6 then
		love.graphics.setColor(255, 255, 50)
		love.graphics.polygon("fill", unpack(coords))
		love.graphics.setColor(255, 255, 255)
	end
	--love.graphics.draw( pacman, pacmanbody:getX(), pacmanbody:getY(), pacmanbody:getAngle(), scale/41, scale/41, 256, 256)
	
	if powerup and superpower == "clone" then
		love.graphics.setColor(255, 255, 255, 255-255*((love.timer.getTime() - poweruptimer)/powerupduration))
		love.graphics.draw( clone, clonebody:getX(), clonebody:getY(), clonebody:getAngle(), scale/41, scale/41, 256, 256)
		love.graphics.setColor(255, 255, 255)
	end
	
	love.graphics.draw( mainfieldoverlay, fieldbody:getX()+1, fieldbody:getY()+1, 0, scale, scale, boardwidth/2, boardheight/2)
	
	--pellets!
	love.graphics.setColor(255, 255, 0)
	for y = 1, 29 do
		for x = 1, 26 do
		
			if pelletmap[y][x] == 1 then
				love.graphics.rectangle( "fill", math.floor(screenwidth/2+((x-13.5)*8-0.4)*scale), math.floor(screenheight/2+((y-15)*7-0.4)*scale), 2*scale, 2*scale)
			elseif pelletmap[y][x] == 2 and superpelletblink == false then
				love.graphics.draw(superpellet, math.floor(screenwidth/2+((x-13.5)*8-2.5)*scale), math.floor(screenheight/2+((y-15)*7-2.5)*scale), 0, scale, scale)
			end
			
		end
	end
	
	--debug
	if shapedebug then
		love.graphics.setColor(255, 0, 0)
		
		for i, v in pairs(worldshapes) do
			love.graphics.polygon("line",worldshapes[i]:getPoints())
		end
		
		love.graphics.circle("line", screenwidth/2, screenheight/2, 460, 100)
	end
	
	love.graphics.setColor(255, 255, 255)
end

function timeattack_createworld() --creates world and all physics objects
	world = love.physics.newWorld( 0, 0, screenwidth*2, screenheight*2, 0, 800, false)
	
	fieldbody = love.physics.newBody(world, screenwidth / 2, screenheight / 2, 0, 0)
	worldshapes = {}

	--Not to be masked: 1, 2, 3, 4, 5, 6, 20, 21, 23, 26
	--No, I wrote a program to grab these for me easily.
	worldshapes[1] = love.physics.newRectangleShape(fieldbody, 0.0*scale+1, -110.5*scale+1, 220.0*scale-1, 11.0*scale-1)
	worldshapes[2] = love.physics.newRectangleShape(fieldbody, -112.5*scale+1, -61.0*scale+1, 11.0*scale-1, 94.0*scale-1)
	worldshapes[3] = love.physics.newRectangleShape(fieldbody, -112.5*scale+1, 54.0*scale+1, 11.0*scale-1, 108.0*scale-1)
	worldshapes[4] = love.physics.newRectangleShape(fieldbody, 0.0*scale+1, 110.5*scale+1, 220.0*scale-1, 11.0*scale-1)
	worldshapes[5] = love.physics.newRectangleShape(fieldbody, 112.5*scale+1, -61.0*scale+1, 11.0*scale-1, 94.0*scale-1)
	worldshapes[6] = love.physics.newRectangleShape(fieldbody, 112.5*scale+1, 54.0*scale+1, 11.0*scale-1, 108.0*scale-1)
	worldshapes[7] = love.physics.newRectangleShape(fieldbody, -80.0*scale+1, -84.0*scale+1, 26.0*scale-1, 14.0*scale-1);worldshapes[7]:setCategory( 2 )
	worldshapes[8] = love.physics.newRectangleShape(fieldbody, -36.0*scale+1, -84.0*scale+1, 34.0*scale-1, 14.0*scale-1);worldshapes[8]:setCategory( 2 )
	worldshapes[9] = love.physics.newRectangleShape(fieldbody, 0.0*scale+1, -91.5*scale+1, 10.0*scale-1, 29.0*scale-1);worldshapes[9]:setCategory( 2 )
	worldshapes[10] = love.physics.newRectangleShape(fieldbody, 36.0*scale+1, -84.0*scale+1, 34.0*scale-1, 14.0*scale-1);worldshapes[10]:setCategory( 2 )
	worldshapes[11] = love.physics.newRectangleShape(fieldbody, 80.0*scale+1, -84.0*scale+1, 26.0*scale-1, 14.0*scale-1);worldshapes[11]:setCategory( 2 )
	worldshapes[12] = love.physics.newRectangleShape(fieldbody, -80.0*scale+1, -59.5*scale+1, 26.0*scale-1, 7.0*scale-1);worldshapes[12]:setCategory( 2 )
	worldshapes[13] = love.physics.newRectangleShape(fieldbody, -48.0*scale+1, -38.5*scale+1, 10.0*scale-1, 49.0*scale-1);worldshapes[13]:setCategory( 2 )
	worldshapes[14] = love.physics.newRectangleShape(fieldbody, -31.5*scale+1, -38.5*scale+1, 25.0*scale-1, 7.0*scale-1);worldshapes[14]:setCategory( 2 )
	worldshapes[15] = love.physics.newRectangleShape(fieldbody, 0.0*scale+1, -59.5*scale+1, 58.0*scale-1, 7.0*scale-1);worldshapes[15]:setCategory( 2 )
	worldshapes[16] = love.physics.newRectangleShape(fieldbody, 0.0*scale+1, -46.0*scale+1, 10.0*scale-1, 22.0*scale-1);worldshapes[16]:setCategory( 2 )
	worldshapes[17] = love.physics.newRectangleShape(fieldbody, 48.0*scale+1, -38.5*scale+1, 10.0*scale-1, 49.0*scale-1);worldshapes[17]:setCategory( 2 )
	worldshapes[18] = love.physics.newRectangleShape(fieldbody, 31.5*scale+1, -38.5*scale+1, 25.0*scale-1, 7.0*scale-1);worldshapes[18]:setCategory( 2 )
	worldshapes[19] = love.physics.newRectangleShape(fieldbody, 80.0*scale+1, -59.5*scale+1, 26.0*scale-1, 7.0*scale-1);worldshapes[19]:setCategory( 2 )
	worldshapes[20] = love.physics.newRectangleShape(fieldbody, 88.5*scale+1, -28.0*scale+1, 43.0*scale-1, 28.0*scale-1)
	worldshapes[21] = love.physics.newRectangleShape(fieldbody, -88.5*scale+1, -28.0*scale+1, 43.0*scale-1, 28.0*scale-1)
	worldshapes[22] = love.physics.newRectangleShape(fieldbody, 0.0*scale+1, -7.0*scale+1, 58.0*scale-1, 28.0*scale-1);worldshapes[22]:setCategory( 2 )
	worldshapes[23] = love.physics.newRectangleShape(fieldbody, -88.5*scale+1, 14.0*scale+1, 43.0*scale-1, 28.0*scale-1)
	worldshapes[24] = love.physics.newRectangleShape(fieldbody, -48.0*scale+1, 14.0*scale+1, 10.0*scale-1, 28.0*scale-1);worldshapes[24]:setCategory( 2 )
	worldshapes[25] = love.physics.newRectangleShape(fieldbody, 48.0*scale+1, 14.0*scale+1, 10.0*scale-1, 28.0*scale-1);worldshapes[25]:setCategory( 2 )
	worldshapes[26] = love.physics.newRectangleShape(fieldbody, 88.5*scale+1, 14.0*scale+1, 43.0*scale-1, 28.0*scale-1)
	worldshapes[27] = love.physics.newRectangleShape(fieldbody, 0.0*scale+1, 24.5*scale+1, 58.0*scale-1, 7.0*scale-1);worldshapes[27]:setCategory( 2 )
	worldshapes[28] = love.physics.newRectangleShape(fieldbody, 0.0*scale+1, 38.0*scale+1, 10.0*scale-1, 22.0*scale-1);worldshapes[28]:setCategory( 2 )
	worldshapes[29] = love.physics.newRectangleShape(fieldbody, -80.0*scale+1, 45.5*scale+1, 26.0*scale-1, 7.0*scale-1);worldshapes[29]:setCategory( 2 )
	worldshapes[30] = love.physics.newRectangleShape(fieldbody, -36.0*scale+1, 45.5*scale+1, 34.0*scale-1, 7.0*scale-1);worldshapes[30]:setCategory( 2 )
	worldshapes[31] = love.physics.newRectangleShape(fieldbody, 36.0*scale+1, 45.5*scale+1, 34.0*scale-1, 7.0*scale-1);worldshapes[31]:setCategory( 2 )
	worldshapes[32] = love.physics.newRectangleShape(fieldbody, 80.0*scale+1, 45.5*scale+1, 26.0*scale-1, 7.0*scale-1);worldshapes[32]:setCategory( 2 )
	worldshapes[33] = love.physics.newRectangleShape(fieldbody, -72.0*scale+1, 56.0*scale+1, 10.0*scale-1, 28.0*scale-1);worldshapes[33]:setCategory( 2 )
	worldshapes[34] = love.physics.newRectangleShape(fieldbody, -99.5*scale+1, 66.5*scale+1, 17.0*scale-1, 7.0*scale-1);worldshapes[34]:setCategory( 2 )
	worldshapes[35] = love.physics.newRectangleShape(fieldbody, 72.0*scale+1, 56.0*scale+1, 10.0*scale-1, 28.0*scale-1);worldshapes[35]:setCategory( 2 )
	worldshapes[36] = love.physics.newRectangleShape(fieldbody, 0.0*scale+1, 66.5*scale+1, 58.0*scale-1, 7.0*scale-1);worldshapes[36]:setCategory( 2 )
	worldshapes[37] = love.physics.newRectangleShape(fieldbody, 0.0*scale+1, 80.0*scale+1, 10.0*scale-1, 22.0*scale-1);worldshapes[37]:setCategory( 2 )
	worldshapes[38] = love.physics.newRectangleShape(fieldbody, 99.5*scale+1, 66.5*scale+1, 17.0*scale-1, 7.0*scale-1);worldshapes[38]:setCategory( 2 )
	worldshapes[39] = love.physics.newRectangleShape(fieldbody, -48.0*scale+1, 74.0*scale+1, 10.0*scale-1, 22.0*scale-1);worldshapes[39]:setCategory( 2 )
	worldshapes[40] = love.physics.newRectangleShape(fieldbody, -56.0*scale+1, 87.5*scale+1, 74.0*scale-1, 7.0*scale-1);worldshapes[40]:setCategory( 2 )
	worldshapes[41] = love.physics.newRectangleShape(fieldbody, 48.0*scale+1, 74.0*scale+1, 10.0*scale-1, 22.0*scale-1);worldshapes[41]:setCategory( 2 )
	worldshapes[42] = love.physics.newRectangleShape(fieldbody, 56.0*scale+1, 87.5*scale+1, 74.0*scale-1, 7.0*scale-1);worldshapes[42]:setCategory( 2 )
	
	--59 590
	pacmanbody = love.physics.newBody(world, screenwidth/2, screenheight/2+(boardheight*0.26)*scale, 0.1)
	pacmanbody:setBullet(true)
	pacmanbody:setInertia( 0.001 )
	pacmanshape = love.physics.newCircleShape(pacmanbody, 0, 0, 6.5*scale)
	pacmanshape:setFriction( 1000)
end

function timeattack_start() --when game becomes controllable
	timer = love.timer.getTime()
	gamestarted = true
end

function timeattack_updategravity() --"rotates" the world.
	--smooth targetrotation into rotation
	rotation = targetrotation --or not...
	
	gravityX = math.sin(math.rad(rotation))
	gravityY = math.cos(math.rad(rotation))	
	world:setGravity( gravityX*gravitymul*scale, gravityY*gravitymul*scale )
end

function timeattack_pacmangetposition(worldx, worldy) --returns position of world coordinates converted to the pelletgrid
	worldx = worldx - (screenwidth/2 - boardwidth*scale/2) - 3*scale
	worldy = worldy - (screenheight/2 - boardheight*scale/2) - 3*scale
	x = math.floor((worldx-4*scale)/(8*scale)+1)
	y = math.floor((worldy-3.5*scale)/(7*scale)+1)
	return x, y
end

function timeattack_checkpellet(x, y) --checks a coordinate if it contains a pellet and does stuff
	if pelletmap[y][x] == 1 or pelletmap[y][x] == 2 then
		pelletmap[y][x] = 0
		if currenttime - wakkatimer > 0.22 then
			if soundenabled then
				love.audio.stop(wakka)
				love.audio.play(wakka)
			end
			wakkatimer = currenttime
		end
		eatored = eatored + 1
		if eatored == 244 then
			finaltime = currenttime - timer
		end
		
		--if powerup -> powerup = true
	end
end

function timeattack_keypressed(key)

end

function timeattack_mousepressed(x, y, button)

end