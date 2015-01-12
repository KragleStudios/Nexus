-- save a pointer to globals that would be unreachable in sandbox
local e = _ENV

-- sample sandbox environment
sandbox_env = {
  ipairs = ipairs,
  next = next,
  pairs = pairs,
  pcall = pcall,
  tonumber = tonumber,
  tostring = tostring,
  type = type,
  unpack = unpack,
  coroutine = { create = coroutine.create, resume = coroutine.resume, 
      running = coroutine.running, status = coroutine.status, 
      wrap = coroutine.wrap },
  string = { byte = string.byte, char = string.char, find = string.find, 
      format = string.format, gmatch = string.gmatch, gsub = string.gsub, 
      len = string.len, lower = string.lower, match = string.match, 
      rep = string.rep, reverse = string.reverse, sub = string.sub, 
      upper = string.upper },
  table = { insert = table.insert, maxn = table.maxn, remove = table.remove, 
      sort = table.sort },
  math = { abs = math.abs, acos = math.acos, asin = math.asin, 
      atan = math.atan, atan2 = math.atan2, ceil = math.ceil, cos = math.cos, 
      cosh = math.cosh, deg = math.deg, exp = math.exp, floor = math.floor, 
      fmod = math.fmod, frexp = math.frexp, huge = math.huge, 
      ldexp = math.ldexp, log = math.log, log10 = math.log10, max = math.max, 
      min = math.min, modf = math.modf, pi = math.pi, pow = math.pow, 
      rad = math.rad, random = math.random, sin = math.sin, sinh = math.sinh, 
      sqrt = math.sqrt, tan = math.tan, tanh = math.tanh },
  //os = { clock = os.clock, difftime = os.difftime, time = os.time },
  Angle = Angle,
  cam = cam,
  chat = {AddText = chat.AddText},
  draw = draw,
  Entity = Entity,
  ents = ents,
  player = player,
  file = file,
  print = print,
  Msg = Msg,
  MsgC = MsgC,
  MsgN = MsgN,
  PrintTable = PrintTable,
  hook = hook,
  input = input,
  render = render,
  sound = sound,
  Vector = Vector,
  vgui = vgui,
  weapons = {Get = weapons.Get, GetList = weapons.GetList},
  CompileString = CompileString,
  LocalPlayer = LocalPlayer,
}

function run_sandbox(sb_env, sb_func, ...)
    local func = CompileString(sb_func, LocalPlayer():Nick(), false)
    if (type(func) == "string") then 
      print(func)
      return
    end    

    setfenv(func, sb_env)
    return pcall(func)
end

concommand.Add("runcode", function(ply, cmd, args, fullstring)
    fullstring = string.Replace(fullstring, "runcode ", "")

    run_sandbox(sandbox_env, fullstring)
end)