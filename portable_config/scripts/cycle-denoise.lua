-- settings
-- key_binding: press the key specified below
--      to cycle between denoise filters below,
--      set it to nil to disable the binding
local key_binding = "n"
-- key_binding_reverse cycle between denoise filters below
--      in reverse order, set it to nil to disable the binding,
--      set it to a single-char string to enable
local key_binding_reverse = nil

-- denoisers: specify names of denoise libavfilter filters
--     from `mpv --vf=lavfi=help` command
--     where the last 3 filters (dctdnoiz, owdenoise, nlmeans)
--     are too slow to be used in playback
local denoisers = {
    "removegrain"
    ,"atadenoise"
    ,"hqdn3d"
    ,"vaguedenoiser"
--    ,"dctdnoiz"
--    ,"owdenoise"
--    ,"nlmeans"
}

local denoiser_count = #denoisers
local filter_index = 0
local script_name = mp.get_script_name()
local denoise_label = string.format("%s-denoise", script_name)

-- from https://github.com/mpv-player/mpv/blob/39e04e929483847a3e0722d86d53f69837ed99db/TOOLS/lua/autocrop.lua
function del_filter_if_present(label)
    -- necessary because mp.command('vf del @label:filter') raises an
    -- error if the filter doesn't exist
    local vfs = mp.get_property_native("vf")
    for i,vf in pairs(vfs) do
        if vf["label"] == label then
            table.remove(vfs, i)
            mp.set_property_native("vf", vfs)
            return true
        end
    end
    return false
end

function cycle_denoise()
    if not del_filter_if_present(denoise_label) then
        filter_index = 0
    end

    filter_index = filter_index + 1
    if filter_index > denoiser_count then
        mp.osd_message("denoise filters removed", osd_time)
        return
    end

    -- insert the filter
    mp.command(
        string.format(
            'vf add @%s:lavfi=graph="%s"',
            denoise_label, denoisers[filter_index]
        )
    )

end

function cycle_denoise_reverse()
    if not del_filter_if_present(denoise_label) then
        filter_index = denoiser_count
    else
        filter_index = filter_index - 1
    end

    if filter_index < 1 then
        mp.osd_message("denoise filters removed", osd_time)
        return
    end

    -- insert the filter
    mp.command(
        string.format(
            'vf add @%s:lavfi=graph="%s"',
            denoise_label, denoisers[filter_index]
        )
    )

end

if key_binding then
    mp.add_key_binding(key_binding, "denoise", cycle_denoise)
end

if key_binding_reverse then
    mp.add_key_binding(key_binding_reverse, "denoise-reverse", cycle_denoise_reverse)
end
