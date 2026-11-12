function love.conf(t)
	t.version = "11.5"
	t.identity = "not_pacman"
	t.console = false
	t.window.title = "Not Pacman"
	t.window.icon = "graphics/icon.png"
	t.window.vsync = 1
	t.window.msaa = 16
	t.window.width = 640
	t.window.height = 500

	if love._os == "Web" then
		t.window.resizable = true
		t.window.highdpi = true
	end
end
