# Personal MPV Configuration for Windows

<p align="center"><img width=100% src="https://raw.githubusercontent.com/zabooby/mpv-config/master/images/previews.png" alt="mpv screenshot"></p>

## Overview
Just my personal config files for use in MPV aiming to get the highest quality. Contains custom keybindings, a GUI menu, multiple scripts and various shaders for animated and live action media. Note that some shaders won't run well with low end computers, but excluding those shaders this config should run fine on most computers.

## Scripts and Shaders
- [uosc](https://github.com/darsain/uosc) Adds a minimalist customizable gui.
- [thumbfast](https://github.com/po5/thumbfast) High-performance on-the-fly thumbnailer for mpv.
- [cycle-denoise](https://gist.github.com/myfreeer/d744c445aa71c0eeb165ca39cf6c0511) Cycle between lavfi's denoise filters.
- [autoload](https://github.com/mpv-player/mpv/blob/master/TOOLS/lua/autoload.lua) Automatically load playlist entries before and after the currently playing file, by scanning the directory.
- [sview](https://github.com/he2a/mpv-scripts/blob/main/scripts/sview.lua) A simple script to show multiple shaders running, in a clean list. Triggered on shader activation or by toggle button.
- [webtorrent-mpv-hook](https://github.com/mrxdst/webtorrent-mpv-hook) Adds a hook that allows mpv to stream torrents. It also provides a osd overlay to show info/progress. (Requires [node.js](https://nodejs.org/en/download/) to be installed)
- [Anime4k](https://github.com/bloc97/Anime4K) Shaders designed to scale and enhance anime. Includes shaders for line sharpening, artefact removal, denoising, upscaling, and more.
- [FSRCNN](https://github.com/igv/FSRCNN-TensorFlow/releases) Very resource intensive upscaler that uses a neural network to uspscale very accurately.
- [FidelityFX CAS](https://gist.github.com/agyild/bbb4e58298b2f86aa24da3032a0d2ee6) Provides a mixed ability to sharpen and optionally scale an image. 
- [FidelityFX FSR](https://gist.github.com/agyild/82219c545228d70c5604f865ce0b0ce5) AMD FidelityFX Super Resolution is a spatial upscaler: it works by taking the current anti-aliased frame and upscaling it to display resolution without relying on other data such as frame history or motion vectors. At the heart of FSR is a cutting-edge algorithm that detects and recreates high-resolution edges from the source image. Those high-resolution edges are a critical element required for turning the current frame into a “super resolution” image. FSR provides consistent upscaling quality regardless of whether the frame is in movement, which can provide quality advantages compared to other types of upscalers.
- [NVIDIA Image Scaling/Sharpening](https://gist.github.com/agyild/7e8951915b2bf24526a9343d951db214) 
    - NVIDIA Image Scaling is a spatial scaling and sharpening algorithm. 
    - In addition, an adaptive-directional sharpening-only algorithm is available. The directional scaling and sharpening algorithm is named NVScaler while the adaptive-directional-sharpening-only algorithm is named NVSharpen.
- [SSimDownscaler, SSimSuperRes, Krig, Adaptive Sharpen](https://gist.github.com/igv) 
    - SSimDownscaler: Perceptually based downscaler.
    - SSimSuperRes: Make corrections to the image upscaled by MPV built-in scaler (removes ringing artifacts, restores original  sharpness, etc).
    - Krig: Chroma scaler that uses luma information for high quality upscaling.
    - Adaptive Sharpen: 
    
## Usage
Download the latest windows build of MPV from [here](https://mpv.io/installation/) and extract its contents into a folder called mpv. MPV is portable so you can put this folder anywhere you want. Download and copy `portable_config` folder from this repo to the mpv folder and you are good to go.

## Key Bindings
Custom key bindings can be added from `input.conf` file. Refer to the [manual](https://mpv.io/manual/master/) for making any changes. Default key bindings can be seen from the `input.conf` file but most of the player functions can be used through the menu accessed by <kbd>Right Click</kbd>.

