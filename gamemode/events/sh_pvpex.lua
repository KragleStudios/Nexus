local EVENT = {}

EVENT.restrictions = {
	maxplayers = 4;
	maxplaytime = 210;
	maxrounds = 2;
	maxscore = 100;
}

EVENT.default_settings = {
	maxplayers = 2;
	maxplaytime = 210;
	location = 1;
	maxrounds = 2;
	maxscore = 50;
	private = false;
}

EVENT.locations = {
	[1] = {
		Vector();
		Vector();
		Vector();
		Vector();
	};

	[2] = {
		Vector();
		Vector();
		Vector();
		Vector();
	}
}

EVENT.hooks = {
	["PlayerDeath"] = {call = function(ply)
		//do stuff; add points etc
	end, "Server"},

	["HUDPaint"] = {call = function()
		draw.SimpleText("TITS", "Default", 0, 0, Color(255, 255, 255), 0, 0)
	end, "Client"},

}

function EVENT:CanPlayerJoin(ply, eventinfo)

end

function EVENT:ShouldStart(ply, eventinfo)

end

function EVENT:Kill(eventinfo)

end

function EVENT:Pause(eventinfo)

end

function EVENT:Continue(eventinfo)

end

function EVENT:ShouldEnd(eventinfo)

end

function EVENT:EndPretty(eventinfo)

end

nx.Events:Register("Crap", EVENT)
