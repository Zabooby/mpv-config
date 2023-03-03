# Personal mpv Configuration for Windows

<p align="center"><img width=100% src="https://user-images.githubusercontent.com/78969986/220438304-0f71df02-f81c-4c5e-a4bc-1d8430fd8e05.png" alt="mpv screenshot"></p>
<p align="center"><img width=100% src="https://user-images.githubusercontent.com/78969986/221602122-af51d5ff-7459-43fc-aed5-498200e72eee.png" alt="mpv screenshot"></p>

## Overview
Just my personal config files for use in [mpv](https://mpv.io/), a free, open-source, & cross-platform media player, with a focus on quality and a practical yet comfortable viewing experience. Contains custom key bindings, a GUI, tuned profiles (for up/downscaling, live action & anime), as well as multiple scripts, filters & shaders serving different functions. Suitable for both high and low end computers (with some tweaks).

## Scripts and Shaders
- [uosc](https://github.com/darsain/uosc) - Adds a minimalist but highly customizable gui.
- [thumbfast](https://github.com/po5/thumbfast) - High-performance on-the-fly thumbnailer for mpv.
- [recent-menu](https://github.com/natural-harmonia-gropius/recent-menu) - Recently played menu for mpv, integrated with uosc menu.
- [cycle-denoise](https://gist.github.com/myfreeer/d744c445aa71c0eeb165ca39cf6c0511) - Cycle between lavfi's denoise filters, triggered by toggle button. 
- [autodeint](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autodeint.lua) - Automatically insert the appropriate deinterlacing filter based on a short section of the current video.
- [autoload](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autoload.lua) - Automatically load playlist entries before and after the currently playing file, by scanning the directory.
- [sview](https://github.com/he2a/mpv-scripts/blob/main/scripts/sview.lua) - A simple script to show multiple shaders running, in a clean list. Triggered on shader activation or by toggle button.
- [webtorrent-mpv-hook](https://github.com/mrxdst/webtorrent-mpv-hook) - Adds a hook that allows mpv to stream torrents. It provides an osd overlay to show info/progress.
    - **Requires [node.js](https://nodejs.org/en/download/) to be installed**.
    - **This script needs some more setup, follow the simple installation steps [here](https://github.com/mrxdst/webtorrent-mpv-hook#install)**.
    - **Point to the same location in the file structure section below for the webtorrent.js file.**
- - - 
- [SSimDownscaler, SSimSuperRes, KrigBilateral, Adaptive Sharpen](https://gist.github.com/igv) 
    - Adaptive Sharpen: A sharpening shader.
    - SSimDownscaler: Perceptually based downscaler.
    - KrigBilateral: Chroma scaler that uses luma information for high quality upscaling.
    - SSimSuperRes: Make corrections to the image upscaled by mpv built-in scaler (removes ringing artifacts and restores original  sharpness).
- [Anime4k](https://github.com/bloc97/Anime4K) - Shaders designed to scale and enhance anime. Includes shaders for line sharpening, artefact removal, denoising, upscaling, and more.
    - I have only kept shaders that didn't stray too far from the source. 
- [NVIDIA Image Sharpening](https://gist.github.com/agyild/7e8951915b2bf24526a9343d951db214) - An adaptive-directional sharpening algorithm shaders.
- [FidelityFX CAS](https://gist.github.com/agyild/bbb4e58298b2f86aa24da3032a0d2ee6) - Sharpening shader that provides an even level of sharpness across the frame. 
- [FSRCNN-TensorFlow](https://github.com/igv/FSRCNN-TensorFlow/releases) - Very resource intensive upscaler that uses a neural network to upscale very accurately.
- [AMD FidelityFX Super Resolution](https://gist.github.com/agyild/82219c545228d70c5604f865ce0b0ce5) - A spatial upscaler which provides consistent upscaling quality regardless of whether the frame is in movement.

[mpv-prescalers](https://github.com/bjin/mpv-prescalers) 
    - **COMING SOON<sup>TM</sup>!**
   
## Installation (on Windows)

* Download the latest 64bit (or 64bit-v3 for new CPUs) mpv Windows build by shinchiro [here](https://mpv.io/installation/) or directly from [here](https://sourceforge.net/projects/mpv-player-windows/files/) and extract its contents into a folder of your choice (mine is called mpv). This is now your mpv folder and can be placed wherever you desire. 
* Run `mpv-install.bat`, which is located in the `installer` folder (see below), with administrator privileges by right-clicking and selecting run as administrator, after it's done, you'll get a prompt to open Control Panel and set mpv as the default player.
* Download and extract the `portable_config` folder from this repo to the mpv folder and you are good to go. 
* Change file paths, in [mpv.conf](https://github.com/Zabooby/mpv-config/blob/main/portable_config/mpv.conf) and 2 other files in the [script-opts](https://github.com/Zabooby/mpv-config/tree/main/portable_config/script-opts) folder (detailed below), to where the files/folders exist on your pc. 
* Adjust any settings in [mpv.conf](https://github.com/Zabooby/mpv-config/blob/main/portable_config/mpv.conf) to fit your system, use the [manual](https://mpv.io/manual/master/) to find out what different options do. 
* You're done. Go watch some videos!

After following the steps above, your mpv folder should have the following structure:

## File Structure (on Windows)

```
mpv
|
├── doc
│   ├── manual.pdf                            
│   └── mpbindings.png                        # System default key bindings when input.conf is empty
│
├── installer
│   ├── configure-opengl-hq.bat
│   ├── mpv-icon.ico
│   ├── mpv-install.bat                       # Run with administrator priviledges to install mpv
│   ├── mpv-uninstall.bat                     # Run with administrator priviledges to uninstall mpv
│   └── updater.ps1
│
├── portable_config                           # This is where this repository goes
│   ├── fonts
│   │   ├── Ubuntu-Medium.ttf
|   |   ├── uosc-icons.otf
|   |   └── uosc-textures.ttf
│   │
│   ├── script-opts                           # Contains configuration files for scripts
|   |   ├── recent.json                       # Will be created automatically   
|   |   ├── recentmenu.conf    
│   │   ├── thumbfast.conf                    
│   │   ├── uosc.conf                         # Set desired default directory for uosc menu here
│   │   └── webtorrent.conf                   # Choose where to save downloaded videos here
│   │
│   ├── scripts      
│   │   ├── uosc_shared                       # Contains ui elements for the uosc gui
│   │       ├── elements 
|   |           ├── BufferingIndicator.lua
|   |           ├── Button.lua
|   |           ├── Controls.lua
|   |           ├── Curtain.lua
|   |           ├── CycleButton.lua
|   |           ├── Element.lua
|   |           ├── Elements.lua
|   |           ├── Menu.lua
|   |           ├── PauseIndicator.lua
|   |           ├── Speed.lua
|   |           ├── Timeline.lua
|   |           ├── TopBar.lua
|   |           ├── Volume.lua
|   |           └── WindowBorder.lua
|   |       ├── lib
|   |           ├── ass.lua
|   |           ├── menus.lua
|   |           ├── std.lua
|   |           ├── text.lua
|   |           └── utils.lua
|   |       └── main.lua
│   │
│   │   ├── autodeint.lua                     # Change key binding here, not input.conf (Ctrl+d)
│   │   ├── autoload.lua                    
|   |   ├── cycle-denoise.lua                 # Change key binding here, not input.conf (n)
|   |   ├── recentmenu.lua
|   |   ├── sview.lua
│   │   ├── thumbfast.lua                     
│   │   ├── uosc.lua
│   │   └── webtorrent.js                     # Created here when setting up webtorrent script
│   │
│   ├── shaders                               # Contains external shaders
│   │   ├── A4K_Dark.glsl                         
│   │   ├── A4K_RestoreL.glsl
│   │   ├── A4K_Thin.glsl
│   │   ├── A4K_UpDeVL.glsl
│   │   ├── A4K_UpVL.glsl 
│   │   ├── adasharp.glsl                     
│   │   ├── adasharpA.glsl                    # Adjusted for anime
│   │   ├── CAS.glsl
│   │   ├── F8.glsl
│   │   ├── F8_LA.glsl
│   │   ├── FSR.glsl
│   │   ├── krigbl.glsl
│   │   ├── NVSharpen.glsl
│   │   ├── ssimds.glsl
│   │   └── ssimsr.glsl
│   │
|   ├── watch_later                           # Video positions saved here (created automatically)
|   ├── fonts.conf
│   ├── input.conf                            # Change uosc menu and buttons shown above here
│   ├── mpv.conf                              # Alter settings here, (general anime profile here)
|   └── profiles.conf                         # Up/downscale and more anime profiles here
|   
├── d3dcompiler_43.dll
├── mpv.com
├── mpv.exe                                   # The mpv executable file
└── updater.bat                               # Run this with administrator priviledges to update mpv
```

## Key Bindings
Custom key bindings can be added/edited in the [input.conf](https://github.com/Zabooby/mpv-config/blob/main/portable_config/input.conf) file. Refer to the [manual](https://mpv.io/manual/master/) and available [uosc](https://github.com/tomasklaen/uosc) commands for making any changes. Default key bindings can be seen from the [input.conf](https://github.com/Zabooby/mpv-config/blob/main/portable_config/input.conf) file but most of the player functions can be used through the menu accessed by `Right Click` and the buttons above the timeline as seen in the images above.

## Useful Links

* [mpv wiki](https://github.com/mpv-player/mpv/wiki) - Official wiki with links to user scripts, FAQ's and much more.
* [To-do's for this repo](https://github.com/users/Zabooby/projects/1/views/1) - Just a list of things I plan to implement into my mpv config. 
* [Mathematical evaluation of various scalers](https://artoriuz.github.io/blog/mpv_upscaling.html) - My config uses the best scalers/settings from this analysis.
* [mpv manual](https://mpv.io/manual/master/) - Lists all the settings and configuration options mpv understands including video/audio filters, scripting, and other customizations. 

Huge shoutout to [@he2a](https://github.com/he2a) for their [config](https://github.com/he2a/mpv-config), most of my setup is inspired by it.
