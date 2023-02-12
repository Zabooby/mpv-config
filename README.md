# Personal mpv Configuration for Windows

<p align="center"><img width=100% src="https://user-images.githubusercontent.com/78969986/217233303-c7d31814-c58c-40a7-ab02-d42312c398ae.png" alt="mpv screenshot"></p>
<p align="center"><img width=100% src="https://user-images.githubusercontent.com/78969986/217888283-b72140a0-233f-444f-aeba-6b8562a2bc11.png" alt="mpv screenshot"></p>

## Overview
Just my personal config files for use in [mpv](https://mpv.io/), a free (as in freedom and free beer), open-source, and cross-platform media player, aiming to get the highest quality and best viewing experience. Contains custom key bindings, a GUI menu, tuned profiles (for upscaling, downscaling and anime), multiple scripts & filters serving different functions and various shaders & scalers for animated and live action media (specified below) suitable for both high and low end computers (with a few tweaks). Note there will be a few files in the [script-opts](https://github.com/Zabooby/mpv-config/tree/main/portable_config/script-opts) folder, where you will have to change file paths to point to where the files exist on your pc (detailed in File Structure section). 

## Scripts and Shaders
- [uosc](https://github.com/darsain/uosc) - Adds a minimalist customizable gui.
- [cycle-denoise](https://gist.github.com/myfreeer/d744c445aa71c0eeb165ca39cf6c0511) - Cycle between lavfi's denoise filters.
- [thumbfast](https://github.com/po5/thumbfast) - High-performance on-the-fly thumbnailer for mpv.
- [autodeint](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autodeint.lua) - Automatically insert the appropriate deinterlacing filter based on a short section of the current video.
- [autoload](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autoload.lua) - Automatically load playlist entries before and after the currently playing file, by scanning the directory.
- [sview](https://github.com/he2a/mpv-scripts/blob/main/scripts/sview.lua) - A simple script to show multiple shaders running, in a clean list. Triggered on shader activation or by toggle button.
- [webtorrent-mpv-hook](https://github.com/mrxdst/webtorrent-mpv-hook) - Adds a hook that allows mpv to stream torrents. 
    - **This script needs to be setup manually, follow installation steps [here](https://github.com/mrxdst/webtorrent-mpv-hook#install)**.
    - **Point to the same location in the file structure section below for the webtorrent.js file.**
    - **It provides a osd overlay to show info/progress.** **(Requires [node.js](https://nodejs.org/en/download/) to be installed)**.
- - - 
- [Anime4k](https://github.com/bloc97/Anime4K) - Shaders designed to scale and enhance anime. Includes shaders for line sharpening, artefact removal, denoising, upscaling, and more.
    - **Currently deciding whether to keep all of these shaders, or only keep those that I use the most**.
- [FSRCNN](https://github.com/igv/FSRCNN-TensorFlow/releases) - Very resource intensive upscaler that uses a neural network to upscale very accurately.
- [FidelityFX CAS](https://gist.github.com/agyild/bbb4e58298b2f86aa24da3032a0d2ee6) - Provides a mixed ability to sharpen and optionally scale an image. 
- [NVIDIA Image Sharpening](https://gist.github.com/agyild/7e8951915b2bf24526a9343d951db214) 
    - An adaptive-directional sharpening algorithm shaders.
- [SSimDownscaler, SSimSuperRes, KrigBilateral, Adaptive Sharpen](https://gist.github.com/igv) 
    - SSimDownscaler: Perceptually based downscaler.
    - SSimSuperRes: Make corrections to the image upscaled by mpv built-in scaler (removes ringing artifacts, restores original  sharpness, etc).
    - KrigBilateral: Chroma scaler that uses luma information for high quality upscaling.
    - Adaptive Sharpen: Another sharpening shader.
    
## Installation (on Windows)

* Download the latest 64bit (or 64bit-v3 for new CPUs) mpv Windows build by shinchiro [here](https://mpv.io/installation/) or directly from [here](https://sourceforge.net/projects/mpv-player-windows/files/) and extract its contents into a folder called mpv (or anything you want). mpv is portable so you can put this folder wherever you desire. 
* Run `mpv-install.bat`, which is located in the `installer` folder (see section below), with administrator privileges by right-clicking and selecting run as administrator, after it's done, you'll get a prompt to open Control Panel and set mpv as the default player.
* Extract the `portable_config` folder from this repo to the mpv folder and you are good to go. 
* Adjust any settings in [mpv.conf](https://github.com/Zabooby/mpv-config/blob/main/portable_config/mpv.conf) to fit your system's specs, use the [manual](https://mpv.io/manual/master/) to find out what different options do. 
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
│   │   ├── thumbfast.conf                    
│   │   ├── uosc.conf                         # Set desired default directory for uosc menu here
│   │   └── webtorrent.conf                   # Choose where to save donwloaded videos here
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
│   │
|   |       ├── lib
|   |           ├── ass.lua
|   |           ├── menus.lua
|   |           ├── std.lua
|   |           ├── text.lua
|   |           └── utils.lua
│   │
|   |       └── main.lua
│   │
│   │   ├── autodeint.lua
│   │   ├── autoload.lua                    
|   |   ├── cycle-denoise.lua                 # Change key binding here, not input.conf
|   |   ├── sview.lua
│   │   ├── thumbfast.lua                     
│   │   ├── uosc.lua
│   │   └── webtorrent.js                     # Created here when setting up webtorrent script
│   │
│   ├── shaders                               # Contains external shaders
│   │   ├── adasharp.glsl                     
│   │   ├── adasharpA.glsl                    # Adjusted for anime
│   │   ├── add Anime 4k shaders here                                   
│   │   ├──
│   │   ├── CAS.glsl
│   │   ├── F8.glsl
│   │   ├── F16.glsl
│   │   ├── krigbl.glsl
│   │   ├── NVSharpen.glsl
│   │   ├── ssimds.glsl
│   │   └── ssimsr.glsl
│   │
|   ├── watch_later                           # Video positions saved here (created automatically)
|   ├── fonts.conf
│   ├── input.conf                            # Change uosc menu and buttons shown above here
│   ├── mpv.conf                              # Adjust most settings here 
|   └── profiles.conf                         # Up/downscale profiles here, anime profile in mpv.conf
|   
├── d3dcompiler_43.dll
├── mpv.com
├── mpv.exe                                   # The mpv executable file
└── updater.bat                               # Run this with administrator priviledges to update mpv
```

## Key Bindings
Custom key bindings can be added/edited in the [input.conf](https://github.com/Zabooby/mpv-config/blob/main/portable_config/input.conf) file. Refer to the [manual](https://mpv.io/manual/master/) and uosc [commands](https://github.com/tomasklaen/uosc) for making any changes. Default key bindings can be seen from the [input.conf](https://github.com/Zabooby/mpv-config/blob/main/portable_config/input.conf) file but most of the player functions can be used through the menu accessed by `Right Click` and the buttons above the timeline as seen in the images above.

## Useful Links

* [mpv wiki](https://github.com/mpv-player/mpv/wiki) Official wiki with links to user scripts, FAQ's and much more.
* [mpv manual](https://mpv.io/manual/master/) Lists all the settings and configuration options mpv understands including key bindings, scripting, and other customizations. 
* [Mathematical evaluation of various scalers](https://artoriuz.github.io/blog/mpv_upscaling.html) My config uses the best scalers/settings from this analysis.

Huge shoutout to [@he2a](https://github.com/he2a) for their [config](https://github.com/he2a/mpv-config), most of my setup is inspired by it.
