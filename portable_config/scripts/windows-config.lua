local platform = mp.get_property_native("platform")

if platform == "windows" or platform == "win32" then
    mp.commandv(
        "load-config-file",
        mp.command_native({"expand-path", "~~/windows.conf"})
    )
end