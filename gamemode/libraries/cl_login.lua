local function makeLoginScreen()
	timer.Simple(.5,function() local main = vgui.Create('LoginScreen') end)
end

network.reader('PlayerInitialSpawn'):listen(makeLoginScreen)