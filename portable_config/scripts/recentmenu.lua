local utils = require("mp.utils")
local options = require("mp.options")

local o = {
    path = "~~/script-opts/recent.json",
    length = 10,
    title_length = 48,
}
options.read_options(o)

local path = mp.command_native({ "expand-path", o.path })

local menu = {
    type = 'recent_menu',
    title = 'Recently played',
    items = { { title = 'Nothing here', value = 'ignore' } },
}

function read_json()
    local meta, meta_error = utils.file_info(path)
    if not meta or not meta.is_file then return end

    local json_file = io.open(path, "r")
    if not json_file then return end

    local json = json_file:read("a")
    json_file:close()

    menu.items = utils.parse_json(json)
end

function write_json()
    local json_file = io.open(path, "w")
    if not json_file then return end

    local json = utils.format_json(menu.items)

    json_file:write(json)
    json_file:close()
end

function utf8_char_bytes(str, i)
    local char_byte = str:byte(i)
    if char_byte < 0xC0 then
        return 1
    elseif char_byte < 0xE0 then
        return 2
    elseif char_byte < 0xF0 then
        return 3
    elseif char_byte < 0xF8 then
        return 4
    else
        return 1
    end
end

function utf8_iter(str)
    local byte_start = 1
    return function()
        local start = byte_start
        if #str < start then return nil end
        local byte_count = utf8_char_bytes(str, start)
        byte_start = start + byte_count
        return start, str:sub(start, start + byte_count - 1)
    end
end

function utf8_subwidth(str, indexStart, indexEnd)
    local index = 1
    local substr = ""
    for _, char in utf8_iter(str) do
        if indexStart <= index and index <= indexEnd then
            local width = #char > 2 and 2 or 1
            index = index + width
            substr = substr .. char
        end
    end
    return substr
end

function is_same_folder(s1, s2, p1, p2)
    local i1 = p1:find(s1, 1, true)
    local i2 = p2:find(s2, 1, true)
    if i1 and i2 then
        local t1 = p1:sub(1, i1 - 1)
        local t2 = p2:sub(1, i2 - 1)
        return t1 == t2
    end
    return false
end

function is_same_series(s1, s2)
    local ratio = 0.5
    local limit = #s1 * ratio
    local temp = ""
    for start, char in utf8_iter(s1) do
        local sub1 = char
        local sub2 = s2:sub(start, start + #char - 1)
        if sub1 ~= sub2 then
            temp = temp .. sub1
        end
    end
    if limit > #temp then
        return true
    end
    return false
end

function append_item(path, filename, title)
    filename = utf8_subwidth(filename, 1, o.title_length)
    title = utf8_subwidth(title, 1, o.title_length)

    local new_items = {}
    new_items[1] = { title = filename, hint = title, value = { "loadfile", path } }
    for index, value in ipairs(menu.items) do
        local ofilename = value.title
        local opath = value.value[2]
        if #new_items < o.length and
            value.value ~= "ignore" and
            opath ~= path and
            not (is_same_folder(filename, ofilename, path, opath) and is_same_series(filename, ofilename))
        then
            new_items[#new_items + 1] = value
        end
    end
    menu.items = new_items
    write_json()
end

function open_menu()
    read_json()
    local json = utils.format_json(menu)
    mp.commandv('script-message-to', 'uosc', 'open-menu', json)
end

function play_last()
    mp.command_native(menu.items[1].value)
end

function get_filename_without_ext(filename)
    local idx = filename:match(".+()%.%w+$")
    if idx then
        filename = filename:sub(1, idx - 1)
    end
    return filename
end

function swap(a, b)
    local t = a
    a = b
    b = t
    return a, b
end

function is_protocol(path)
    return type(path) == 'string' and (path:find('^%a[%a%d-_]+://') ~= nil or path:find('^%a[%a%d-_]+:\\?') ~= nil)
end

function on_load()
    local path = mp.get_property("path")
    if not path then return end
    local filename = mp.get_property("filename")
    local filename_without_ext = get_filename_without_ext(filename)
    local title = mp.get_property("media-title") or path
    if filename == title or filename_without_ext == title then
        title = ""
    end
    if is_protocol(path) and title and title ~= "" then
        filename, title = swap(filename, title)
    end
    append_item(path, filename, title)
end

mp.add_key_binding(nil, "open", open_menu)
mp.add_key_binding(nil, "play_last", play_last)
mp.register_event("file-loaded", on_load)

read_json()
