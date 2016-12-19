function normal_load() --initializes all variables
	updates = 0
	gamestate = "normal"
	gamestarted = false
	
	if controlmethod == "mouse" then
		love.mouse.setVisible(false)
		love.mouse.setGrab(true)
	elseif controlmethod == "mouse direction" then
		love.mouse.setPosition(screenwidth/2, screenheight/4)
		love.mouse.setGrab(true)
	end
	
	normal_createworld()
	
	if soundenabled then
		love.audio.stop(beginning)
		love.audio.play(beginning)
	end
	
	waorka = 1
	prevghostpos = false
	ghostmove = {}
	ghostvolume = 0
	gametime = 0
	eatored = 0
	score = 0
	lives = 3
	superpellettimer = 0
	superpelletblink = false
	powerup = false
	starttimer = love.timer.getTime()
	deathtimer = deathtime+deathdelay
	pacmouthopenness = pacmouthlimit
	
	ghosttimer = {}
	for i = 1, 3 do
		ghosttimer[i] = 0
	end
	ghostdeadstartx = {}
	ghostdeadstarty = {}
	ghostdeadendx = {}
	ghostdeadendy = {}
	ghostdeadr = {}
	
	ghosttime = 1
	blinktime = 2
	blinkrate = 0.3
	
	rotation = 0
	targetrotation = 0
	normal_updategravity(1)
	
	pelletmap ={{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, --shit man
				{1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}, --26x29
				{2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2}, --1 = pellet
				{1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}, --2 = super pellet
				{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}, --244 total (240 normal + 4 super)
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
				{2, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 2},
				{1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1},
				{0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0},
				{0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0},
				{1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1},
				{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
				{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
				{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1}}
					
				
	if mousecontrol2 then
		love.mouse.setPosition(windowwidth/2, windowheight/2)
	end
	--skipupdate = true
end

function normal_afterdeath()
	if lives > 1 then
		lives = lives - 1
	
		superpellettimer = 0
		superpelletblink = false
		powerup = false
		starttimer = love.timer.getTime()
		deathtimer = deathtime+deathdelay
		pacmouthopenness = pacmouthlimit
		
		rotation = 0
		targetrotation = 0
		normal_updategravity(1)
		gamestarted = false
		normal_createworld()
		waorka = 1
		prevghostpos=false
		
		ghosttimer = {}
		for i = 1, 3 do
			ghosttimer[i] = 0
		end
		
		if controlmethod == "mouse direction" or controlmethod == "mouse" then
			love.mouse.setPosition(screenwidth/2, screenheight/4)
		end
	else
		normal_gamefinished()
	end
end

function normal_update(dt)	
	if gamestarted and eatored > 0 then
		gametime = gametime + dt
	end
	currenttime = love.timer.getTime()
	
	normal_updategravity(dt)
	if gamestarted == false then
		if currenttime - starttimer > 0 then
			normal_start()
		end
	elseif deathtimer < deathtime+deathdelay then
		deathtimer = deathtimer + dt
		
		if deathtimer > deathtime then
			pacmouthopenness = 1
		else
			pacmouthopenness = pacmouthlimit + (1-pacmouthlimit) * (deathtimer/deathtime)
		end
		
		if deathtimer > deathtime + deathdelay then
			deathtimer = deathtime + deathdelay
			normal_afterdeath()
		end
	else
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
		
		--powerup runout
		if powerup then
			if currenttime - poweruptimer > powerupduration then
				powerup = false
				if superpower == "walls" then
					pacmanshape:setMask()
				elseif superpower == "clone" then
					clonebody:destroy()
					cloneshape:destroy()
					pacmanshape:setMask()
				end
			end
		end
		
		--superpellet blink
		if currenttime - superpellettimer > superpelletblinkrate then
			superpelletblink = not superpelletblink
			superpellettimer = currenttime
		end
		
		--joystick
		if controlmethod == "joystick" then
			x = love.joystick.getAxis( 0, 0 )
			y = -love.joystick.getAxis( 0, 1 )
			if math.abs(x) + math.abs(y) > joystickdeadzone then
				targetrotation = math.deg(math.atan2(x, y) )
			end
		elseif controlmethod == "wheel steering" then
			x = love.joystick.getAxis( 0, 0)
			targetrotation = targetrotation+x*dt*400
			if targetrotation < 0 then
				targetrotation = targetrotation + 360
			elseif targetrotation > 360 then
				targetrotation = targetrotation - 360
			end
		elseif controlmethod == "wheel direct" then
			x = love.joystick.getAxis( 0, 0)
			targetrotation = x*180
			if targetrotation < 0 then
				targetrotation = targetrotation + 360
			end
		elseif controlmethod == "keyboard" then
			local multiplier = 100
			if love.keyboard.isDown( "rshift" ) or love.keyboard.isDown( "lshift" ) then
				multiplier = 300
			end
			if love.keyboard.isDown( "left" ) then
				targetrotation = targetrotation - multiplier*dt
				normal_updategravity(dt)
			end
			if love.keyboard.isDown( "right" ) then
				targetrotation = targetrotation + multiplier*dt
				normal_updategravity(dt)
			end
		elseif controlmethod == "mouse direction" then
			x, y = love.mouse.getPosition( )
			x = x - screenwidth/2
			y = (screenheight - y) - screenheight/2
			targetrotation = math.deg(math.atan2(x, y))
			normal_updategravity(dt)
		elseif controlmethod == "mouse" then
			x, y = love.mouse.getPosition()
			
			if oldx then
				diff = x-oldx
				targetrotation = targetrotation+diff*dt*mouse2speed
			end
			
			oldx, oldy = x, y
			
			updates = updates + dt
			if updates > mouse2rate then
				updates = 0
				oldx = windowwidth/2
				love.mouse.setPosition(windowwidth/2, windowheight/2)
			end
		end
		
		--pacman stuff
		x, y = normal_pacmangetposition(pacmanbody:getX(), pacmanbody:getY())
		normal_checkpellet(x, y)
		
		--check for death
		for i = 1, 3 do
			if ghosttimer[i] == 0 then
				local dist = math.sqrt((pacmanbody:getX()-ghostbody[i]:getX())^2 + (pacmanbody:getY()-ghostbody[i]:getY())^2)
				if dist < 12*2 then
					if powerup then
						--kill ghost
						ghostbody[i]:setLinearVelocity(0, 0)
						ghostbody[i]:setAngularVelocity(0)
						ghosttimer[i] = ghosttime
						ghostdeadstartx[i] = ghostbody[i]:getX()
						ghostdeadstarty[i] = ghostbody[i]:getY()
						ghostdeadendx[i] = (screenwidth/2 + (i-2)*15*2)
						ghostdeadendy[i] = (screenheight/2-(boardheight*0.125)*2)
						ghostbody[i]:setX(screenwidth/2)
						ghostbody[i]:setY(screenheight/2)
						ghostdeadr[i] = ghostbody[i]:getAngle()
						eatghost:stop()
						eatghost:play()
					else
						gamestarted = false
						superpelletblink = false
						deathtimer = 0
						normal_stopgamesounds()
						death:play()
					end
				end
			end
		end
		
		for i = 1, 3 do
			if ghosttimer[i] > 0 then
				ghosttimer[i] = ghosttimer[i] - dt
				if ghosttimer[i] <= 0 then
					ghostbody[i]:setX(screenwidth/2 + (i-2)*15*2)
					ghostbody[i]:setY(screenheight/2-(boardheight*0.125)*2)
					ghostbody[i]:setLinearVelocity(0, 0)
					ghostbody[i]:setAngularVelocity(0)
					ghosttimer[i] = 0
				else
					ghostbody[i]:setX(screenwidth/2)
					ghostbody[i]:setY(screenheight/2)
					ghostbody[i]:setLinearVelocity(0, 0)
					ghostbody[i]:setAngularVelocity(0)
				end
			end
		end
		
		
		--Teleport
		if y == 14 and x < 2 then
			pacmanbody:setX(screenwidth/2+11.5*8*2)
		elseif y == 14 and x > 25 then
			pacmanbody:setX(screenwidth/2-11.5*8*2)
		end
		
		for i = 1, 3 do
			x, y = normal_pacmangetposition(ghostbody[i]:getX(), ghostbody[i]:getY())
			--Teleport
			if y == 14 and x < 2 then
				ghostbody[i]:setX(screenwidth/2+11.5*8*2)
			elseif y == 14 and x > 25 then
				ghostbody[i]:setX(screenwidth/2-11.5*8*2)
			end
		end
		
		if gamestarted and prevghostpos then
			for i = 1, 3 do
				ghostmovediag = (ghostbody[i]:getX() - prevghostpos[i][1])+(ghostbody[i]:getY()- prevghostpos[i][2])
				if ghostmovediag < 0 then ghostmovediag = -ghostmovediag end
				ghostmove[i] = math.sqrt(ghostmovediag)
				prevghostpos[i] = {ghostbody[i]:getX(), ghostbody[i]:getY()}
			end
			calcghostvolume = (ghostmove[1]+ghostmove[2]+ghostmove[3])/3-0.15
			if calcghostvolume < 0 then calcghostvolume = 0 end
			if calcghostvolume > ghostvolume then
				ghostvolume = ghostvolume + 0.02
			elseif calcghostvolume == 0 then
				ghostvolume = ghostvolume - 0.06
			elseif calcghostvolume < ghostvolume then
				ghostvolume = ghostvolume - 0.02
			end
			if ghostvolume > 0.6 then ghostvolume = 0.6 end
			
		else
			prevghostpos = {}
			ghostvolume = 0
		end
		
		if powerup then
			ghostrunaway:setVolume(ghostvolume+0.3)
			ghostsiren:setVolume(0)
		else
			ghostrunaway:setVolume(0)
			ghostsiren:setVolume(ghostvolume)
		end
		
		
		
		
		--wake up ghosts so they don't get stuck. Fucking box2d, how does it work
		for i = 1, 3 do	
			ghostbody[i]:wakeUp()
			prevghostpos[i] = {ghostbody[i]:getX(), ghostbody[i]:getY()}
		end
		
		world:update(dt)
	end
end

function normal_stopgamesounds()
	ghostrunaway:setVolume(0)
	ghostsiren:setVolume(0)
	ghostvolume = 0
	beginning:stop()
	eatghost:stop()
	wakka1:stop()
	wakka2:stop()
	death:stop()
	love.audio.stop()
end

function normal_draw()
	--pac lives
	for i = 1, lives do
		love.graphics.draw( pacman, screenwidth/2-136*scale, screenheight/2+98*scale - (i-1)*17*scale, math.pi, scale/41, scale/41, 256, 256)
	end
	
	--score
	love.graphics.draw(gamescoreimg, screenwidth/2-151*scale, screenheight/2-107*scale, 0, scale, scale)
	
	score = math.floor(gametime*10)/10
	if score == math.floor(score) then
		score = score .. ".0"
	end
	for i = 1, 5 do
		if string.len(tostring(score)) >= 6 - i then
			love.graphics.print(string.sub(tostring(score), i-(5-string.len(tostring(score))), i-(5-string.len(tostring(score)))), screenwidth/2-141*scale, screenheight/2-94*scale+9*i*scale, 0, scale)
		else
			love.graphics.print("0", screenwidth/2-141*scale, screenheight/2-94*scale+9*i*scale, 0, scale)
		end
	end
	
	--guideline for joystick
	if joystickcontrol and deathtimer == deathtime+deathdelay then
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
	
	love.graphics.setColor(255, 255, 255, 255)
	--pac:			
	local x = (pacmanbody:getX()-screenwidth/2)*(scale/2)+screenwidth/2
	local y = (pacmanbody:getY()-screenheight/2)*(scale/2)+screenheight/2
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
	
	
	--ghosties:
	if deathtimer == deathtime+deathdelay then
		for i = 1, 3 do
			if ghosttimer[i] == 0 then
				if powerup then
					--powerup blink
					local timeleft = powerupduration - (love.timer.getTime() - poweruptimer)
					
					if timeleft < blinktime and math.mod((timeleft), blinkrate*2)<blinkrate then
						love.graphics.draw( ghostscared2, (ghostbody[i]:getX()-screenwidth/2)*(scale/2)+screenwidth/2, (ghostbody[i]:getY()-screenheight/2)*(scale/2)+screenheight/2, ghostbody[i]:getAngle(), scale/41, scale/41, 256, 256)
					else
						love.graphics.draw( ghostscared1, (ghostbody[i]:getX()-screenwidth/2)*(scale/2)+screenwidth/2, (ghostbody[i]:getY()-screenheight/2)*(scale/2)+screenheight/2, ghostbody[i]:getAngle(), scale/41, scale/41, 256, 256)
					end
				else
					love.graphics.push()
					love.graphics.translate((ghostbody[i]:getX()-screenwidth/2)*(scale/2)+screenwidth/2, (ghostbody[i]:getY()-screenheight/2)*(scale/2)+screenheight/2)
					love.graphics.rotate(ghostbody[i]:getAngle())
					love.graphics.draw( _G["ghost" .. i], 0, 0, 0, scale/41, scale/41, 256, 256)
					local down = -(ghostbody[i]:getAngle()+math.rad(rotation))+math.pi/2
					love.graphics.draw(spinnyeyes, math.cos(down)*1*scale, math.sin(down)*1.5*scale-0.5*scale, 0, scale/41, scale/41, 145, 35)
					love.graphics.pop()
				end
			else	
				local x = ghostdeadstartx[i] + (ghostdeadendx[i]-ghostdeadstartx[i])*(1-ghosttimer[i]/ghosttime)
				local y = ghostdeadstarty[i] + (ghostdeadendy[i]-ghostdeadstarty[i])*(1-ghosttimer[i]/ghosttime)
				love.graphics.draw(ghosteyes, (x-screenwidth/2)*(scale/2)+screenwidth/2, (y-screenheight/2)*(scale/2)+screenheight/2, ghostdeadr[i], scale/41, scale/41, 256, 256)
			end
		end
	end
	
	love.graphics.draw( mainfieldoverlay, fieldbody:getX()+1, fieldbody:getY()+1, 0, scale, scale, boardwidth/2, boardheight/2)
	
	
	love.graphics.setColor(255, 255, 255)
	
	
	--Rotate
	love.graphics.translate(screenwidth/2, screenheight/2)
	love.graphics.rotate(-math.rad(rotation))
	love.graphics.translate(-screenwidth/2, -screenheight/2)
	
end

function normal_createworld() --creates world and all physics objects
	local scale = 2
	world = love.physics.newWorld( screenwidth/2-400, screenwidth/2-400, screenwidth/2+400, screenwidth/2+400, 0, 800, false)
	
	fieldbody = love.physics.newBody(world, screenwidth / 2, screenheight / 2, 0, 0)
	fieldbody:setBullet(true)
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
	--paccy
	pacmanbody = love.physics.newBody(world, screenwidth/2, screenheight/2+(boardheight*0.26)*scale, 0.1)
	pacmanbody:setBullet(true)
	pacmanbody:setInertia( 0.001 )
	pacmanshape = love.physics.newCircleShape(pacmanbody, 0, 0, 6.5*scale)
	pacmanshape:setFriction( 1000)
	pacmanshape:setMask(3)
	
	--ghosties!
	ghostbody = {}
	ghostshape = {}
	for i = 1, 3 do
		ghostbody[i] = love.physics.newBody(world, screenwidth/2 + (i-2)*15*scale, screenheight/2-(boardheight*0.125)*scale, 0.1)
		ghostbody[i]:setBullet(true)
		ghostbody[i]:setInertia(0.001 )
		ghostshape[i] = love.physics.newCircleShape(ghostbody[i], 0, 0, 6.5*scale)
		ghostshape[i]:setFriction(1000)
		ghostshape[i]:setCategory(3)
	end
end

function normal_start() --when game becomes controllable
	gamestarted = true
	ghostsiren:play()
	ghostrunaway:play()
end

function normal_updategravity(dt) --"rotates" the world. (It actually only changes the gravity "direction" because actually rotating the world caused centrifugalforces to be a bitch)
	--smooth targetrotation into rotation
	
	targetrotation = math.mod(targetrotation+360, 360)
	
	if targetrotation > rotation + 180 then
		rotation = rotation + 360
	elseif targetrotation < rotation - 180 then
		rotation = rotation - 360
	end
	
	if targetrotation > rotation then
		rotation = rotation + (targetrotation-rotation)*dt*20
	else
		rotation = rotation + (targetrotation-rotation)*dt*20
	end
	
	gravityX = math.sin(math.rad(rotation))
	gravityY = math.cos(math.rad(rotation))	
	world:setGravity( gravityX*gravitymul*2, gravityY*gravitymul*2 )
end

function normal_pacmangetposition(worldx, worldy) --returns position of world coordinates converted to the pelletgrid
	local scale = 2
	worldx = worldx - (screenwidth/2 - boardwidth*scale/2) - 3*scale
	worldy = worldy - (screenheight/2 - boardheight*scale/2) - 3*scale
	x = math.floor((worldx-4*scale)/(8*scale)+1)
	y = math.floor((worldy-3.5*scale)/(7*scale)+1)
	return x, y
end

function normal_checkpellet(x, y) --checks a coordinate if it contains a pellet and does stuff
	if pelletmap[y] then
		if pelletmap[y][x] == 1 then
			pelletmap[y][x] = 0
			if currenttime - wakkatimer > 0.09 then --0.11
				if soundenabled then
					if waorka == 1 then
						love.audio.stop(wakka2)
						love.audio.play(wakka2)
						waorka = 0
					else
						love.audio.stop(wakka1)
						love.audio.play(wakka1)
						waorka = 1
					end
				end
				wakkatimer = currenttime
			end
			
			score = score + 10
			
			eatored = eatored + 1
			if eatored == 244 then
				normal_gamefinished()
			end
			
		elseif pelletmap[y][x] == 2 then
			pelletmap[y][x] = 0
			currenttime = love.timer.getTime()
			if currenttime - wakkatimer > 0.11 then
				if soundenabled then
					if waorka then
						love.audio.stop(wakka2)
						love.audio.play(wakka2)
						waorka = 0
					else
						love.audio.stop(wakka1)
						love.audio.play(wakka1)
						waorka = 1
					end
				end
				wakkatimer = currenttime
			end	
			
			--SUPER POWERS OMG
			poweruptimer = currenttime
			powerup = true
			
			score = score + 50
			
			eatored = eatored + 1
			if eatored == 244 then
				normal_gamefinished()
			end
		end
	end
end

function normal_keypressed(key)

	if key == "escape" then
		menu_load()
	end
	
end

function normal_mousepressed(x, y, button)

end

function normal_gamefinished()	
	normal_stopgamesounds()
	love.mouse.setGrab(false)
	love.mouse.setVisible(true)
	if eatored == 244 then
		gamewin:play()
	end	
	local high = 0
	for i = 1, 9 do
		if eatored > highscoreA[i][1] then
			high = i
			break
		elseif eatored == highscoreA[i][1] then
			if gametime < highscoreA[i][2] then
				high = i
				break
			end
		end
	end
	
	gametime = math.floor(gametime*10+0.5)/10
	
	if high ~= 0 then
		for i = numhighscores, high+1, -1 do
			highscoreA[i] = {highscoreA[i-1][1], highscoreA[i-1][2], highscoreA[i-1][3]}
		end
		highscoreA[high] = {eatored, gametime, ""}
		highscoreentry_load(high)
	else
		highscoreentry_load(0)
	end
end