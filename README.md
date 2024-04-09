# Personal mpv Configuration for Windows

<p align="center"><img width=100% src="https://github.com/Zabooby/mpv-config/assets/78969986/3d95db6f-4ebd-4e84-94cc-c1825297f18e" alt="mpv screenshot"></p>
<p align="center"><img width=100% src="https://github.com/Zabooby/mpv-config/assets/78969986/e4dec0a5-fb4a-438e-96f0-4b87a0f59d34" alt="mpv screenshot"></p>

## Overview
Just my personal config files for use in [mpv](https://mpv.io/), a free, open-source, & cross-platform media player, with a focus on quality and a practical yet comfortable viewing experience. Contains tuned profiles (for up/downscaling, live action & anime), custom key bindings, a GUI, as well as multiple scripts, shaders & filters, all serving different functions. Suitable for both high and low-end computers (with some tweaks).

Before installing, please take your time to read this whole README as common issues can be easily solved by simply reading carefully.

## Scripts and Shaders
- [uosc](https://github.com/darsain/uosc) - Adds a minimalist but highly customisable GUI.
- [evafast](https://github.com/po5/evafast) - Fast-forwarding and seeking on a single key.
- [thumbfast](https://github.com/po5/thumbfast) - High-performance on-the-fly thumbnailer.
- [memo](https://github.com/po5/memo) - Saves watch history, and displays it in a nice menu, integrated with uosc.
- [InputEvent](https://github.com/natural-harmonia-gropius/input-event) - Enhances input.conf with better, conflict-free, low-latency event mechanisms.
- [autoload](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autoload.lua) - Automatically load playlist entries before and after the currently playing file, by scanning the directory.
- [autodeint](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autodeint.lua) - Automatically insert the appropriate deinterlacing filter based on a short section of the current video, triggered by key bind. 
- [webtorrent-mpv-hook](https://github.com/mrxdst/webtorrent-mpv-hook) - Adds a hook that allows mpv to stream torrents. It provides an osd overlay to show info/progress.
    - **This script needs some extra setup, follow the simple installation steps [here](https://github.com/mrxdst/webtorrent-mpv-hook#install)**.
    - **Point to the same location specified in the File Structure section below when installing the webtorrent.js file.**
- - - 
- [nlmeans](https://github.com/AN3223/dotfiles/tree/master/.config/mpv/shaders) - Highly configurable and featureful denoiser.
- [NVIDIA Image Sharpening](https://gist.github.com/agyild/7e8951915b2bf24526a9343d951db214) - An adaptive-directional sharpening algorithm shaders.
- [FidelityFX CAS](https://gist.github.com/agyild/bbb4e58298b2f86aa24da3032a0d2ee6) - Sharpening shader that provides an even level of sharpness across the frame. 
- [FSRCNNX-TensorFlow](https://github.com/igv/FSRCNN-TensorFlow) - Very resource intensive upscaler that uses a neural network to upscale accurately.
- [Anime4k](https://github.com/bloc97/Anime4K) - Shaders designed to scale and enhance anime. Includes shaders for line sharpening and upscaling.
- [CfL-Prediction](https://github.com/Artoriuz/glsl-chroma-from-luma-prediction) - Shader thst implement chroma upscaling based on the closed least squares solution for linear regression.
- [AMD FidelityFX Super Resolution EASU](https://gist.github.com/agyild/82219c545228d70c5604f865ce0b0ce5) (FSR without RCAS) - A spatial upscaler which provides consistent upscaling quality regardless of whether the frame is in movement.
- [mpv-prescalers](https://github.com/bjin/mpv-prescalers) - RAVU (Rapid and Accurate Video Upscaling) is a set of prescalers with an overall performance consumption design slightly higher than the built-in ewa scaler, while providing much better results. 
- [SSimDownscaler, SSimSuperRes, KrigBilateral, Adaptive Sharpen](https://gist.github.com/igv) 
    - Adaptive Sharpen: Another sharpening shader.
    - SSimDownscaler: Perceptually based downscaler.
    - SSimSuperRes: Make corrections to the image upscaled by mpv built-in scaler (removes ringing artifacts and restores original  sharpness).
   
## Installation (on Windows)

(Not tested on Linux and macOS but once mpv is installed, copying the contents of my `portable_config` into the [relevant](https://mpv.io/manual/master/#files) folders should be sufficient.)

* Download the latest 64bit (or 64bit-v3 for newer CPUs) mpv Windows build by shinchiro [here](https://mpv.io/installation/) or directly from [here](https://sourceforge.net/projects/mpv-player-windows/files/) and extract its contents into a folder of your choice (mine is called mpv). This is now your mpv folder and can be placed wherever you want. 
* Run `mpv-install.bat`, which is located in the `installer` folder (see File Structure section), with administrator privileges by right-clicking and selecting run as administrator, after it's done, you'll get a prompt to open Control Panel and set mpv as the default player.
* Download and extract the `portable_config` folder from this repo to the mpv folder you just made. 
* Add file paths, to 2 files in the [script-opts](https://github.com/Zabooby/mpv-config/tree/main/portable_config/script-opts) folder (detailed in the File Structure section), to match your preferences. 
* **Adjust relevant settings in [mpv.conf](https://github.com/Zabooby/mpv-config/blob/main/portable_config/mpv.conf) to fit your system, use the [manual](https://mpv.io/manual/master/) to find out what different options do or open an issue if you need any help.**
* You're all set up. Go watch some videos!

After following the steps above, your mpv folder should have the following structure:

## File Structure (on Windows)

```
mpv
|
├── doc
│   ├── manual.pdf                            
│   └── mpbindings.png                    # Default key bindings if not overridden in input.conf
│
├── installer
│   ├── mpv-icon.ico
│   ├── mpv-install.bat                   # Run with administrator priviledges to install mpv
│   ├── mpv-uninstall.bat                 # Run with administrator priviledges to uninstall mpv
│   └── updater.ps1
│
├── portable_config                       # This is where my config is placed
│   ├── cache                             # Created automatically   
│   │ 
│   ├── fonts
│   │   ├── ClearSans-Bold.ttf
│   │   ├── JetBrainsMono-Regular.ttf
|   |   ├── uosc-icons.otf
|   |   └── uosc-textures.ttf
│   │
│   ├── script-opts                       # Contains configuration files for scripts
|   |   ├── console.conf
|   |   ├── evafast.conf 
|   |   ├── memo.conf
|   |   ├── memo-history.log              # Created automatically 
│   │   ├── thumbfast.conf                    
│   │   ├── uosc.conf                     # Set desired default directory for uosc menu here
│   │   └── webtorrent.conf               # Specify where to save downloaded videos here
│   │
│   ├── scripts      
│   │   ├── uosc              
│   │       ├── bin 
|   |           ├── ziggy-darwin
|   |           ├── ziggy-linux
|   |           ├── ziggy-windows.exe
│   │       ├── char_conv
|   |           ├── zh.json
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
|   |           ├── Updater.lua
|   |           ├── Volume.lua
|   |           └── WindowBorder.lua
|   |       ├── intl
|   |           ├── de.lua
|   |           ├── es.lua
|   |           ├── fr.json
|   |           ├── ro.json
|   |           ├── ru.json
|   |           ├── uk.json
|   |           └── zh-hans.json
|   |       ├── lib
|   |           ├── ass.lua
|   |           ├── char_conv.lua
|   |           ├── cursor.lua
|   |           ├── intl.lua
|   |           ├── menus.lua
|   |           ├── std.lua
|   |           ├── text.lua
|   |           └── utils.lua
|   |       └── main.lua
│   │
│   │   ├── autodeint.lua
│   │   ├── autoload.lua 
│   │   ├── evafast.lua                   # Activated by holding right arrow key
│   │   ├── inputevent.lua
|   |   ├── memo.lua
│   │   ├── thumbfast.lua                     
│   │   └── webtorrent.js                 # Point here when setting up the webtorrent script
│   │
│   ├── shaders                          
│   │   ├── A4K_Dark.glsl                         
│   │   ├── A4K_Thin.glsl
│   │   ├── A4K_Upscale_L.glsl
│   │   ├── adasharp.glsl                     
│   │   ├── adasharpA.glsl                # Adjusted for anime
│   │   ├── CAS.glsl
│   │   ├── CfL_P.glsl
│   │   ├── F16.glsl
│   │   ├── F16_LA.glsl
│   │   ├── FSR_EASU.glsl       
│   │   ├── nlmeans_HQ.glsl
│   │   ├── nlmeans_L_HQ.glsl
│   │   ├── NVSharpen.glsl
│   │   ├── ravu_L_ar_r4.hook
│   │   ├── ravu_Z_ar_r3.hook
│   │   ├── ssimds.glsl
│   │   └── ssimsr.glsl
│   │
|   ├── watch_later                       # Video timestamps saved here (created automatically)
|   ├── fonts.conf                        # Delete the duplicate made when installing mpv
│   ├── input.conf                        # Customise uosc menu here
│   ├── mpv.conf                          
|   └── profiles.conf                     
|   
├── d3dcompiler_43.dll
├── mpv.com
├── mpv.exe                               # The mpv executable file
└── updater.bat                           # Run with administrator priviledges to update mpv
```

## Key Bindings
Custom key bindings can be added/edited in the [input.conf](https://github.com/Zabooby/mpv-config/blob/main/portable_config/input.conf) file. Refer to the [manual](https://mpv.io/manual/master/) and [uosc](https://github.com/tomasklaen/uosc#commands) commands for making any changes. Default key bindings can be seen from the [input.conf](https://github.com/Zabooby/mpv-config/blob/main/portable_config/input.conf) file but most of the player functions can be used through the menu accessed by `Right Click` and the buttons above the timeline as seen in the images above.

## Useful Links

* [mpv wiki](https://github.com/mpv-player/mpv/wiki) - Official wiki with links to all user scripts/shaders, FAQ's and much more.
* [Mathematical evaluation of various scalers](https://artoriuz.github.io/blog/mpv_upscaling.html) - My config uses (mostly) the best scalers/settings from this analysis.
* [mpv manual](https://mpv.io/manual/master/) - Lists all the settings and configuration options available including video/audio settings, scripting, and countless other customisations.
* [To-do's](https://github.com/users/Zabooby/projects/1) - Just a list of things I'm currently testing, tracking or improving as well as major changes/improvements I've already implemented (click on items for more information).
