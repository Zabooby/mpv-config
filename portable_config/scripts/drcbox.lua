--[[
mpv dynaudnorm filter with visual feedback.

Copyright 2016 Avi Halachmi ( https://github.com/avih )
Copyright 2020 Paul B Mahol
License: public domain

Needs mpv with very recent FFmpeg build.

Default config:
- Enter/exit drcbox keys mode: ctrl+n
- Toggle dynaudnorm without changing its values: ctrl+N (ctrl+shift+n)
- Reset dynaudnorm values: alt+ctrl+n
--]]
-- ------ config -------
local start_keys_enabled = false  -- if true then choose the up/down keys wisely
local key_toggle_bindings = 'ctrl+n'  -- enable/disable drcbox key bindings
local key_toggle_drcbox = 'ctrl+N'  -- enable/disable drcbox
local key_reset_drcbox = 'alt+ctrl+n'

local options = {
  {keys = {'2', 'w'}, option = {'framelen',     1, 10, 8000,  500,  500 } },
  {keys = {'3', 'e'}, option = {'gausssize',    1,  3,  301,   31,   31 } },
  {keys = {'4', 'r'}, option = {'peak',      0.01,  0,    1, 0.95, 0.95 } },
  {keys = {'5', 't'}, option = {'maxgain',      1,  1,  100,   10,   10 } },
  {keys = {'6', 'y'}, option = {'targetrms', 0.01,  0,    1,    0,    0 } },
  {keys = {'7', 'u'}, option = {'coupling',     1,  0,    1,    1,    1 } },
  {keys = {'8', 'i'}, option = {'correctdc',    1,  0,    1,    0,    0 } },
  {keys = {'9', 'o'}, option = {'compress',   0.1,  0,   30,    0,    0 } },
}

local function get_cmd_full()
  f = options[1].option[5]
  g = options[2].option[5]
  p = options[3].option[5]
  m = options[4].option[5]
  r = options[5].option[5]
  n = options[6].option[5]
  c = options[7].option[5]
  s = options[8].option[5]
  return 'no-osd af toggle @dynaudnorm:lavfi=[dynaudnorm=f='..f..':g='..g..':p='..p..':m='..m..':r='..r..':n='..n..':c='..c..':s='..s..']'
end

local function get_cmd(option)
  return 'no-osd af-command dynaudnorm '.. option[1] ..' '.. option[5]
end

-- these two vars are used globally
local bindings_enabled = start_keys_enabled
local drcbox_enabled = false  -- but af is not touched before the dynaudnorm is modified

-- ------ OSD handling -------
local function ass(x)
  return x
end

local function fsize(s)  -- 100 is the normal font size
  return ass('{\\fscx' .. s .. '\\fscy' .. s ..'}')
end

local function color(c)  -- c is RRGGBB
  return ass('{\\1c&H' .. ss(c, 5, 7) .. ss(c, 3, 5) .. ss(c, 1, 3) .. '&}')
end

function iff(cc, a, b) if cc then return a else return b end end
function ss(s, from, to) return s:sub(from, to - 1) end

local function cnorm() return color('ffffff') end  -- white
local function cdis()  return color('909090') end  -- grey
local function ceq()   return iff(drcbox_enabled, color('ffff90'), cdis()) end  -- yellow-ish
local function ckeys() return iff(bindings_enabled, color('90FF90'), cdis()) end  -- green-ish

local DUR_DEFAULT = 1.5 -- seconds
local osd_timer = nil
-- duration: seconds, or default if missing/nil, or infinite if 0 (or negative)
local function ass_osd(msg, duration)  -- empty or missing msg -> just clears the OSD
  duration = duration or DUR_DEFAULT
  if not msg or msg == '' then
    msg = '{}'  -- the API ignores empty string, but '{}' works to clean it up
    duration = 0
  end
  mp.set_osd_ass(0, 0, msg)
  if osd_timer then
    osd_timer:kill()
    osd_timer = nil
  end
  if duration > 0 then
    osd_timer = mp.add_timeout(duration, ass_osd)  -- ass_osd() clears without a timer
  end
end

function round(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

-- some visual messing about
local function updateOSD()
  local msg1 = fsize(70) .. 'DynAudNorm: ' .. ceq() .. iff(drcbox_enabled, 'On', 'Off')
            .. ' [' .. key_toggle_drcbox .. ']' .. cnorm()
  local msg2 = fsize(70)
            .. 'Key-bindings: ' .. ckeys() .. iff(bindings_enabled, 'On', 'Off')
            .. ' [' .. key_toggle_bindings .. ']' .. cnorm()
  local msg3 = ''

  for i = 1, #options do
    local option = options[i].option[1]
    local value = round(options[i].option[5], 2)
    local default = options[i].option[6]
    local info =
      ceq() .. fsize(50) .. option .. ' ' .. fsize(100)
      .. iff(value ~= default and drcbox_enabled, '', cdis()) .. value .. ceq()
      .. fsize(50) .. ckeys() .. ' [' .. options[i].keys[1] .. '/' .. options[i].keys[2] .. ']'
      .. ceq() .. fsize(100) .. cnorm()

     msg3 = msg3 .. '   ' .. info
  end

  local nlb = '\n' .. ass('{\\an1}')  -- new line and "align bottom for next"
  local msg = ass('{\\an1}') .. msg3 .. nlb .. msg2 .. nlb .. msg1
  local duration = iff(start_keys_enabled, iff(bindings_enabled and drcbox_enabled, 5, nil)
                                         , iff(bindings_enabled, 0, nil))
  ass_osd(msg, duration)
end


local function update_key_binding(enable, key, name, fn)
  if enable then
    mp.add_forced_key_binding(key, name, fn, 'repeatable')
  else
    mp.remove_key_binding(name)
  end
end

local function updateAF()
  mp.command(get_cmd_full())
end

local function updateAF_options()
  if not drcbox_enabled then return end
  for i = 1, #options do
    local o = options[i].option
    mp.command(get_cmd(o))
  end
end

local function getBind(option, delta)
  return function()  -- onKey
    option[5] = option[5] + delta
    if option[5] > option[4] then
      option[5] = option[4]
    end
    if option[5] < option[3] then
      option[5] = option[3]
    end
    updateAF_options()
    updateOSD()
  end
end

local function toggle_bindings(explicit, no_osd)
  bindings_enabled = iff(explicit ~= nil, explicit, not bindings_enabled)
  for i = 1, #options do
    local keys = options[i].keys
    local option = options[i].option[1]
    local delta = options[i].option[2]
    update_key_binding(bindings_enabled, keys[1], 'eq' .. keys[1], getBind(options[i].option,  delta)) -- up
    update_key_binding(bindings_enabled, keys[2], 'eq' .. keys[2], getBind(options[i].option, -delta)) -- down
  end
  if not no_osd then updateOSD() end
end

local function toggle_drcbox()
  drcbox_enabled = not drcbox_enabled
  updateAF()
  updateOSD()
end

local function reset_drcbox()
  for i = 1, #options do
    options[i].option[5] = options[i].option[6]
  end
  updateAF_options()
  updateOSD()
end

mp.add_forced_key_binding(key_toggle_drcbox, toggle_drcbox)
mp.add_forced_key_binding(key_toggle_bindings, toggle_bindings)
mp.add_forced_key_binding(key_reset_drcbox, reset_drcbox)
if bindings_enabled then toggle_bindings(true, true) end