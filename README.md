# Personal MPV Configuration for Windows

<p align="center"><img width=100% src="https://raw.githubusercontent.com/Zabooby/mpv-config/main/images/image.png" alt="mpv screenshot"></p>

## Overview
Just my personal config files for use in [MPV](https://mpv.io/) aiming to get the highest quality. Contains custom keybindings, a GUI menu, multiple scripts & filters serving different functions and various shaders for animated and live action media. Note that some shaders won't run well with low end computers, but excluding those shaders this config should run fine on most computers. Also note there will be a few files in the [script-opts](https://github.com/Zabooby/mpv-config/tree/main/portable_config/script-opts) folder, which you will have to change file paths to point to where the files exist on your pc. 

Huge shoutout to [@he2a](https://github.com/he2a) for their [config](https://github.com/he2a/mpv-config), most of my setup is inspired by it.

## Scripts and Shaders
- [uosc](https://github.com/darsain/uosc) Adds a minimalist customizable gui.
- [thumbfast](https://github.com/po5/thumbfast) High-performance on-the-fly thumbnailer for mpv.
- [cycle-denoise](https://gist.github.com/myfreeer/d744c445aa71c0eeb165ca39cf6c0511) Cycle between lavfi's denoise filters.
- [autoload](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autoload.lua) Automatically load playlist entries before and after the currently playing file, by scanning the directory.
- [sview](https://github.com/he2a/mpv-scripts/blob/main/scripts/sview.lua) A simple script to show multiple shaders running, in a clean list. Triggered on shader activation or by toggle button.
- [webtorrent-mpv-hook](https://github.com/mrxdst/webtorrent-mpv-hook) Adds a hook that allows mpv to stream torrents. It also provides a osd overlay to show info/progress. (Requires [node.js](https://nodejs.org/en/download/) to be installed)
- [Anime4k](https://github.com/bloc97/Anime4K) Shaders designed to scale and enhance anime. Includes shaders for line sharpening, artefact removal, denoising, upscaling, and more.
- [FSRCNN](https://github.com/igv/FSRCNN-TensorFlow/releases) Very resource intensive upscaler that uses a neural network to upscale very accurately.
- [FidelityFX CAS](https://gist.github.com/agyild/bbb4e58298b2f86aa24da3032a0d2ee6) Provides a mixed ability to sharpen and optionally scale an image. 
- [FidelityFX FSR](https://gist.github.com/agyild/82219c545228d70c5604f865ce0b0ce5) A spatial upscaler, it works by taking the current anti-aliased frame and upscaling it to display resolution without relying on other data such as frame history or motion vectors.
- [NVIDIA Image Scaling/Sharpening](https://gist.github.com/agyild/7e8951915b2bf24526a9343d951db214) 
    - NVIDIA Image Scaling is a spatial scaling and sharpening algorithm. 
    - In addition, an adaptive-directional sharpening-only algorithm is available. The directional scaling and sharpening algorithm is named NVScaler while the adaptive-directional-sharpening-only algorithm is named NVSharpen.
- [SSimDownscaler, SSimSuperRes, Krig, Adaptive Sharpen](https://gist.github.com/igv) 
    - SSimDownscaler: Perceptually based downscaler.
    - SSimSuperRes: Make corrections to the image upscaled by MPV built-in scaler (removes ringing artifacts, restores original  sharpness, etc).
    - Krig: Chroma scaler that uses luma information for high quality upscaling.
    - Adaptive Sharpen: Another sharpening shader
    
## Usage
Download the latest windows build of MPV from [here](https://mpv.io/installation/) and extract its contents into a folder called mpv. MPV is portable so you can put this folder anywhere you want. Download and extract the `portable_config` folder from this repo to the mpv folder and you are good to go. Adjust any settings in mpv.conf to fit your system's specs.

## File Structure (on Windows)

```
MPV
│
|
├── doc
│   ├── manual.pdf
│   └── mpbindings.png
│
│
├── installer
│   ├── configure-opengl-hq.bat
│   ├── mpv-icon.ico
│   ├── mpv-install.bat                       # Run this with administrator priviledges to install mpv
│   ├── mpv-uninstall.bat                     # Run this with administrator priviledges to uninstall mpv
│   └── updater.ps1
│
│
├── portable_config                           # This is where this repository goes
│   ├── fonts
│   │   ├── Ubuntu-Medium.ttf
|   |   ├── uosc-icons.otf
|   |   └── uosc-textures.ttf
│   │
│   ├── script-opts                           # Contains configuration files for scripts
│   │   ├── thumbfast.conf
│   │   ├── uosc.conf
│   │   └── webtorrent.conf
│   │
│   ├── scripts      
│   │   ├── uosc_shared                       # Contains ui elements for the uosc gui
│   │       ├── elements 
|   |           ├── BufferingIndicator.lua
|   |           ├── Button.lua
|   |           ├── Controls.lua
|   |           ├── Curtain.lua
|   |           ├── CycleButtons.lua
|   |           ├── Element.lua
|   |           ├── Elements.lua
|   |           ├── Menu.lua
|   |           ├── PauseIndicator.lua
|   |           ├── Speed.lua
|   |           ├── Timeline.lua
|   |           ├── TopBar.lua
|   |           ├── Volume.lua
|   |           └── WindowBorder.lua
|   |
|   |       ├── lib
|   |           ├── ass.lua
|   |           ├── menus.lua
|   |           ├── std.lua
|   |           ├── text.lua
|   |           └── utils.lua
|   |
|   |       └── main.lua
|   |
│   │   ├── autoload.lua                    
|   |   ├── cycle-denoise.lua
|   |   ├── sview.lua
│   │   ├── thumbfast.lua                     
│   │   ├── uosc.lua
│   │   └── webtorrent.js
│   │
│   ├── shaders                               # Contains external shaders
│   │   ├── adasharp.glsl                     
│   │   ├── adasharpA.glsl
│   │   ├──                                    
│   │   ├──
│   │   ├──
│   │   ├── CAS.glsl
│   │   ├── F8.glsl
│   │   ├── F16.glsl
│   │   ├── FSR.glsl
│   │   ├── krigbl.glsl
│   │   ├── NVScaler.glsl
│   │   ├── NVSharpen.glsl
│   │   ├── ssimds.glsl
│   │   └── ssimsr.glsl
|   | 
|   ├── watch_later                           # Folder will be automatically, video positions will be saved here
│   │
|   ├── fonts.conf
│   ├── input.conf
│   ├── mpv.conf
|   └── profiles.conf
|   
│
├── d3dcompiler_43.dll
├── mpv.com
├── mpv.exe                                   # The mpv executable file
└── updater.bat                               # Run this with administrator priviledges to update mpv
```

## Key Bindings
Custom key bindings can be added from `input.conf` file. Refer to the [manual](https://mpv.io/manual/master/) and uosc [commands](https://github.com/tomasklaen/uosc) for making any changes. Default key bindings can be seen from the `input.conf` file but most of the player functions can be used through the menu accessed by <kbd>Right Click</kbd> and the buttons above the timeline.
