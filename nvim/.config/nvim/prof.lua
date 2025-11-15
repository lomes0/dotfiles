-- ===== Lua profiler: start/stop around YOUR scrolling =====
local uv = vim.loop
local PROF_PATH = vim.fn.stdpath("cache") .. "/lua-scroll-profile.txt"
local stack, selftime, running = {}, {}, false

local function hook(ev)
  local info = debug.getinfo(2, "nSl")
  if not info or not info.short_src then return end
  local key = (info.short_src or "?") .. ":" .. (info.linedefined or 0)
  local now = uv.hrtime()
  if ev == "call" then
    table.insert(stack, { key = key, t0 = now })
  elseif ev == "return" then
    local fr = stack[#stack]
    if fr and fr.key == key then
      local dt = now - fr.t0
      table.remove(stack)
      selftime[key] = (selftime[key] or 0) + dt
      if stack[#stack] then
        -- subtract from parent so we approximate self time
        selftime[stack[#stack].key] = (selftime[stack[#stack].key] or 0) - dt
      end
    end
  end
end

vim.api.nvim_create_user_command("LuaProfileStart", function()
  if running then return end
  stack, selftime = {}, {}
  debug.sethook(hook, "cr")
  running = true
  vim.notify("Lua profiling STARTED. Scroll around, then :LuaProfileStop")
end, {})

vim.api.nvim_create_user_command("LuaProfileStop", function()
  if not running then return end
  debug.sethook(); running = false
  -- build top lists
  local arr = {}
  for k, ns in pairs(selftime) do table.insert(arr, { k = k, ns = ns }) end
  table.sort(arr, function(a,b) return (a.ns or 0) > (b.ns or 0) end)
  local out = {}
  local function ms(ns) return string.format("%.2f", (ns or 0)/1e6) end
  table.insert(out, "=== Lua scroll profile (self time) ===")
  table.insert(out, "Top 40 callsites:")
  for i = 1, math.min(#arr, 40) do
    table.insert(out, string.format("%2d. %-70s %8s ms", i, arr[i].k, ms(arr[i].ns)))
  end
  -- aggregate by file
  local perfile = {}
  for _, r in ipairs(arr) do
    local f = r.k:match("^(.*):%d+$") or r.k
    perfile[f] = (perfile[f] or 0) + r.ns
  end
  local files = {}
  for f, ns in pairs(perfile) do table.insert(files, { f=f, ns=ns }) end
  table.sort(files, function(a,b) return a.ns > b.ns end)
  table.insert(out, "\nTop files:")
  for i = 1, math.min(#files, 25) do
    table.insert(out, string.format("%2d. %-70s %8s ms", i, files[i].f, ms(files[i].ns)))
  end
  local f = assert(io.open(PROF_PATH, "w")); f:write(table.concat(out, "\n")); f:close()
  vim.notify("Lua profile written → " .. PROF_PATH)
end, {})

