local function makeLoginScreen()
	timer.Simple(.5,function() LocalPlayer().lgScreen = vgui.Create('LoginScreen') end)
end

net.Receive('PlayerInitialSpawn',makeLoginScreen)