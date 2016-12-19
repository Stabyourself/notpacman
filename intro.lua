function intro_load()
	gamestate = "intro"
	
	introduration = 2.5
	blackafterintro = 0.3
	introfadetime = 0.5
	introprogress = -0.2 
end

function intro_update(dt)
	if introprogress < introduration+blackafterintro then
		introprogress = introprogress + dt
		if introprogress > introduration+blackafterintro then
			introprogress = introduration+blackafterintro
		end
		
		if introprogress > 0.5 and playedwilhelm == nil then
			stabsound:stop();stabsound:play()
			playedwilhelm = true
		end
		
		if introprogress == introduration + blackafterintro then
			menu_load()
		end
	end
end

function intro_draw()
	local s = 1
	if scale == 1 then
		s = 0.5
	end
	if introprogress >= 0 and introprogress < introduration then
		local a = 255
		if introprogress < introfadetime then
			a = introprogress/introfadetime * 255
		elseif introprogress >= introduration-introfadetime then
			a = (1-(introprogress-(introduration-introfadetime))/introfadetime) * 255
		end
		
		love.graphics.setColor(255, 255, 255, a)
		
		if introprogress > introfadetime+0.3 and introprogress < introduration - introfadetime then
			local y = (introprogress-0.2-introfadetime) / (introduration-introfadetime) * screenheight*5
			love.graphics.draw(logo, screenwidth/2, screenheight/2, 0, s, s, 142, 150)
			love.graphics.setScissor(0, screenheight - y, screenwidth, y)
			love.graphics.draw(logoblood, screenwidth/2, screenheight/2, 0, s, s, 142, 150)
			love.graphics.setScissor()
		elseif introprogress >= introduration - introfadetime then
			love.graphics.draw(logoblood, screenwidth/2, screenheight/2, 0, s, s, 142, 150)
		else
			love.graphics.draw(logo, screenwidth/2, screenheight/2, 0, s, s, 142, 150)
		end
	end
end

function intro_mousepressed()
	stabsound:stop()
	menu_load()
end

function intro_keypressed()
	stabsound:stop()
	menu_load()
end
	