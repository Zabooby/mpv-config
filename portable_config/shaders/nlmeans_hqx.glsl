/* vi: ft=c
 *
 * Based on vf_nlmeans.c from FFmpeg.
 *
 * Copyright (c) 2022 an3223 <ethanr2048@gmail.com>
 * Copyright (c) 2016 Clément Bœsch <u pkh me>
 *
 * This program is free software: you can redistribute it and/or modify it 
 * under the terms of the GNU Lesser General Public License as published by 
 * the Free Software Foundation, either version 2.1 of the License, or (at 
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License 
 * for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License 
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

// Description: nlmeans_hqx.glsl: Very slow, should offer the best quality.

/* The recommended usage of this shader and its variant profiles is to add them 
 * to input.conf and then dispatch the appropriate shader via a keybind during 
 * media playback. Here is an example input.conf entry:
 *
 * F4 no-osd change-list glsl-shaders toggle "~~/shaders/nlmeans_luma.glsl"; show-text "Non-local means (LUMA only)"
 *
 * These shaders can also be enabled by default in mpv.conf, for example:
 *
 * glsl-shaders='~~/shaders/nlmeans.glsl'
 *
 * Both of the examples above assume the shaders are located in a subdirectory 
 * named "shaders" within mpv's config directory. Refer to the mpv 
 * documentation for more details.
 *
 * This shader is highly configurable via user variables below. Although the 
 * default settings should offer good quality at a reasonable speed, you are 
 * encouraged to tweak them to your preferences. Be mindful that certain 
 * settings may greatly affect speed.
 *
 * Denoising is most useful for noisy content. If there is no perceptible 
 * noise, you probably won't see a positive difference.
 *
 * The default settings are generally tuned for low noise and high detail 
 * preservation. The "medium" and "heavy" profiles are tuned for higher levels 
 * of noise.
 *
 * The denoiser will not work properly if the content has been upscaled 
 * beforehand (whether it was done by you or not). In such cases, consider 
 * issuing a command to downscale in the mpv console (backtick ` key):
 *
 * vf toggle scale=-2:720
 *
 * ...replacing 720 with whatever resolution seems appropriate. Rerun the 
 * command to undo the downscale. It may take some trial-and-error to find the 
 * proper resolution.
 */

/* Regarding speed
 *
 * Speed may vary wildly for different vo and gpu-api settings. Generally 
 * vo=gpu-next and gpu-api=vulkan are recommended for the best speed, but this 
 * may be different for your system.
 *
 * If your GPU doesn't support textureGather, or if you are on a version of mpv 
 * prior to 0.35.0, then consider setting RI/RFI to 0, or try the LQ profile
 *
 * If you plan on tinkering with NLM's settings, read below:
 *
 * textureGather only applies to luma and limited to the these configurations:
 *
 * - PS={3,7}:P=3:PST=0:RI={0,1,3}:RFI={0,1,2}
 *   - Default, very fast, rotations and reflections should be free
 *   - If this is unusually slow then try changing gpu-api and vo
 *   - If it's still slow, try setting RI/RFI to 0.
 *
 * - PS=6:RI={0,1,3}:RFI={0,1,2}
 *   - Currently the only scalable variant
 *   - Patch shape is asymmetric on two axis
 *   - Rotations should have very little speed impact
 *   - Reflections may have a significant speed impact
 *
 * Options which always disable textureGather:
 * 	- PD
 * 	- NG
 */

// The following is shader code injected from guided.glsl
/* vi: ft=c
 *
 * Copyright (c) 2022 an3223 <ethanr2048@gmail.com>
 *
 * This program is free software: you can redistribute it and/or modify it 
 * under the terms of the GNU Lesser General Public License as published by 
 * the Free Software Foundation, either version 2.1 of the License, or (at 
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY;  without even the implied warranty of MERCHANTABILITY or 
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License 
 * for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License 
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 */

// Description: guided.glsl: Guided by the downscaled image

/* The radius can be adjusted with the MEANI stage's downscaling factor. 
 * Higher numbers give a bigger radius.
 *
 * The E variable can be found in the A stage.
 *
 * The subsampling (fast guided filter) can be adjusted with the I stage's 
 * downscaling factor. Higher numbers are faster.
 *
 * The guide's subsampling can be adjusted with the PREI stage's downscaling 
 * factor. Higher numbers downscale more.
 */

//!HOOK LUMA
//!HOOK CHROMA
//!BIND HOOKED
//!WIDTH HOOKED.w 1.25 /
//!HEIGHT HOOKED.h 1.25 /
//!DESC Guided filter (PREI)
//!SAVE _INJ_PREI

vec4 hook()
{
	 return HOOKED_texOff(0); 
}

//!HOOK LUMA
//!HOOK CHROMA
//!BIND _INJ_PREI
//!WIDTH HOOKED.w
//!HEIGHT HOOKED.h
//!DESC Guided filter (I)
//!SAVE _INJ_I

vec4 hook()
{
return _INJ_PREI_texOff(0);
}


//!HOOK LUMA
//!HOOK CHROMA
//!DESC Guided filter (P)
//!BIND HOOKED
//!WIDTH _INJ_I.w
//!HEIGHT _INJ_I.h
//!SAVE _INJ_P

vec4 hook()
{
	 return HOOKED_texOff(0); 
}

//!HOOK LUMA
//!HOOK CHROMA
//!DESC Guided filter (MEANI)
//!BIND _INJ_I
//!WIDTH _INJ_I.w 1.5 /
//!HEIGHT _INJ_I.h 1.5 /
//!SAVE _INJ_MEANI

vec4 hook()
{
return _INJ_I_texOff(0);
}

//!HOOK LUMA
//!HOOK CHROMA
//!DESC Guided filter (MEANP)
//!BIND _INJ_P
//!WIDTH _INJ_MEANI.w
//!HEIGHT _INJ_MEANI.h
//!SAVE _INJ_MEANP

vec4 hook()
{
return _INJ_P_texOff(0);
}

//!HOOK LUMA
//!HOOK CHROMA
//!DESC Guided filter (_INJ_I_SQ)
//!BIND _INJ_I
//!WIDTH _INJ_I.w
//!HEIGHT _INJ_I.h
//!SAVE _INJ_I_SQ

vec4 hook()
{
return _INJ_I_texOff(0) * _INJ_I_texOff(0);
}

//!HOOK LUMA
//!HOOK CHROMA
//!DESC Guided filter (_INJ_IXP)
//!BIND _INJ_I
//!BIND _INJ_P
//!WIDTH _INJ_I.w
//!HEIGHT _INJ_I.h
//!SAVE _INJ_IXP

vec4 hook()
{
return _INJ_I_texOff(0) * _INJ_P_texOff(0);
}

//!HOOK LUMA
//!HOOK CHROMA
//!DESC Guided filter (CORRI)
//!BIND _INJ_I_SQ
//!WIDTH _INJ_MEANI.w
//!HEIGHT _INJ_MEANI.h
//!SAVE _INJ_CORRI

vec4 hook()
{
return _INJ_I_SQ_texOff(0);
}

//!HOOK LUMA
//!HOOK CHROMA
//!DESC Guided filter (CORRP)
//!BIND _INJ_IXP
//!WIDTH _INJ_MEANI.w
//!HEIGHT _INJ_MEANI.h
//!SAVE _INJ_CORRP

vec4 hook()
{
return _INJ_IXP_texOff(0);
}

//!HOOK LUMA
//!HOOK CHROMA
//!DESC Guided filter (A)
//!BIND _INJ_MEANI
//!BIND _INJ_MEANP
//!BIND _INJ_CORRI
//!BIND _INJ_CORRP
//!WIDTH _INJ_I.w
//!HEIGHT _INJ_I.h
//!SAVE _INJ_A

#define E 0.0013

vec4 hook()
{
vec4 var = _INJ_CORRI_texOff(0) - _INJ_MEANI_texOff(0) * _INJ_MEANI_texOff(0);
vec4 cov = _INJ_CORRP_texOff(0) - _INJ_MEANI_texOff(0) * _INJ_MEANP_texOff(0);
	 return cov / (var + E); 
}

//!HOOK LUMA
//!HOOK CHROMA
//!DESC Guided filter (B)
//!BIND _INJ_A
//!BIND _INJ_MEANI
//!BIND _INJ_MEANP
//!WIDTH _INJ_I.w
//!HEIGHT _INJ_I.h
//!SAVE _INJ_B

vec4 hook()
{
return _INJ_MEANP_texOff(0) - _INJ_A_texOff(0) * _INJ_MEANI_texOff(0);
}

//!HOOK LUMA
//!HOOK CHROMA
//!DESC Guided filter (MEANA)
//!BIND _INJ_A
//!WIDTH _INJ_MEANI.w
//!HEIGHT _INJ_MEANI.h
//!SAVE _INJ_MEANA

vec4 hook()
{
return _INJ_A_texOff(0);
}

//!HOOK LUMA
//!HOOK CHROMA
//!DESC Guided filter (MEANB)
//!BIND _INJ_B
//!WIDTH _INJ_MEANI.w
//!HEIGHT _INJ_MEANI.h
//!SAVE _INJ_MEANB

vec4 hook()
{
return _INJ_B_texOff(0);
}

//!HOOK LUMA
//!HOOK CHROMA
//!DESC Guided filter
//!BIND HOOKED
//!BIND _INJ_MEANA
//!BIND _INJ_MEANB
//!SAVE RF_LUMA

vec4 hook()
{
return _INJ_MEANA_texOff(0) * HOOKED_texOff(0) + _INJ_MEANB_texOff(0);
}

// End of source code injected from guided.glsl 

//!HOOK LUMA
//!HOOK CHROMA
//!BIND RF_LUMA
//!WIDTH RF_LUMA.w
//!HEIGHT RF_LUMA.h
//!DESC Non-local means (RF, share)
//!SAVE RF

vec4 hook()
{
	return RF_LUMA_texOff(0);
}

//!HOOK LUMA
//!HOOK CHROMA
//!BIND HOOKED
//!BIND RF_LUMA
//!BIND RF
//!DESC Non-local means (nlmeans_hqx.glsl)

// User variables

// It is generally preferable to denoise luma and chroma differently, so the 
// user variables for luma and chroma are split.

// Denoising factor (level of blur, higher means more blur)
#ifdef LUMA_raw
#define S 2.25
#else
#define S 5.0
#endif

/* Adaptive sharpening
 *
 * Performs an unsharp mask by subtracting the spatial kernel's blur from the 
 * NLM blur. For sharpen+denoise the sharpening is limited to edge areas and 
 * denoising is done everywhere else.
 *
 * Use V=4 to visualize which areas are sharpened (black means sharpen).
 *
 * AS:
 * 	- 0: disable
 * 	- 1: sharpen+denoise
 * 	- 2: sharpen only
 * ASF: Higher numbers make a sharper image
 */
#ifdef LUMA_raw
#define AS 0
#define ASF 0.5
#else
#define AS 0
#define ASF 0.5
#endif

/* Starting weight
 *
 * Also known as the center weight. This represents the weight of the 
 * pixel-of-interest. Lower numbers may help handle heavy noise & ringing.
 *
 * EPSILON should be used instead of zero to avoid divide-by-zero errors.
 */
#ifdef LUMA_raw
#define SW 1.0
#else
#define SW 0.5
#endif

/* Weight discard
 *
 * Discard weights that fall below a fraction of the average weight. This culls 
 * the most dissimilar samples from the blur, yielding a much more pleasant 
 * result, especially around edges.
 * 
 * WD:
 * 	- 2: True average. Better quality, but slower and requires GLSL 4.0 or later
 * 	- 1: Moving cumulative average. Inaccurate, tends to blur directionally.
 * 	- 0: Disable
 *
 * WDT: Threshold coefficient, higher numbers discard more
 * WDP (only for WD=1): Increasing reduces the threshold for small sample sizes
 */
#ifdef LUMA_raw
#define WD 2
#define WDT 0.5
#define WDP 6.0
#else
#define WD 2
#define WDT 0.75
#define WDP 6.0
#endif

/* Extremes preserve
 *
 * Reduce denoising in very bright/dark areas.
 *
 * Disabled by default now. If you want to reenable this, set EP=3/ in 
 * Makefile.nlm and rebuild.
 *
 * The downscaling factor of the EP shader stage affects what is considered a 
 * bright/dark area.
 *
 * This is incompatible with RGB. If you have RGB hooks enabled then you will 
 * have to delete the EP shader stage or specify EP=0 through shader_cfg.
 *
 * EP: 1 to enable, 0 to disable
 * DP: EP strength on dark areas, 0 to fully denoise
 * BP: EP strength on bright areas, 0 to fully denoise
 */
#ifdef LUMA_raw
#define EP 0
#define BP 0.75
#define DP 0.25
#else
#define EP 0
#define BP 0.0
#define DP 0.0
#endif

/* ADVANCED OPTIONS * ADVANCED OPTIONS * ADVANCED OPTIONS * ADVANCED OPTIONS */
/* ADVANCED OPTIONS * ADVANCED OPTIONS * ADVANCED OPTIONS * ADVANCED OPTIONS */
/* ADVANCED OPTIONS * ADVANCED OPTIONS * ADVANCED OPTIONS * ADVANCED OPTIONS */
/* ADVANCED OPTIONS * ADVANCED OPTIONS * ADVANCED OPTIONS * ADVANCED OPTIONS */
/* ADVANCED OPTIONS * ADVANCED OPTIONS * ADVANCED OPTIONS * ADVANCED OPTIONS */

/* Patch & research sizes
 *
 * Patch size should be an odd number greater than or equal to 3. Higher values 
 * are slower and not always better.
 *
 * Research size be an odd number greater than or equal to 3. Higher values are 
 * generally better, but slower, blurrier, and gives diminishing returns.
 */
#ifdef LUMA_raw
#define P 5
#define R 5
#else
#define P 5
#define R 5
#endif

/* Patch and research shapes
 *
 * Different shapes have different speed and quality characteristics. Every 
 * shape (besides square) is smaller than square.
 *
 * PS applies applies to patches, RS applies to research zones.
 *
 * Be wary of gather optimizations (see the Regarding Speed comment at the top)
 *
 * 0: square (symmetrical)
 * 1: horizontal line (asymmetric)
 * 2: vertical line (asymmetric)
 * 3: diamond (symmetrical)
 * 4: triangle (asymmetric, pointing upward)
 * 5: truncated triangle (asymmetric on two axis, last row halved)
 * 6: even sized square (asymmetric on two axis)
 * 7: plus (symmetrical)
 */
#ifdef LUMA_raw
#define RS 3
#define PS 6
#else
#define RS 3
#define PS 3
#endif

/* Robust filtering
 *
 * This setting is dependent on code generation from shader_cfg, so this 
 * setting can only be enabled via shader_cfg.
 *
 * Compares the pixel-of-interest against a guide, which could be a downscaled 
 * image or the output of another shader
 */
#define RF_LUMA 1
#define RF 1

/* Rotational/reflectional invariance
 *
 * Number of rotations/reflections to try for each patch comparison. Can be 
 * slow, but improves feature preservation. More rotations/reflections gives 
 * diminishing returns. The most similar rotation/reflection will be used.
 *
 * The angle in degrees of each rotation is 360/(RI+1), so RI=1 will do a 
 * single 180 degree rotation, RI=3 will do three 90 degree rotations, etc.
 *
 * RI: Rotational invariance
 * RFI (0 to 2): Reflectional invariance
 */
#ifdef LUMA_raw
#define RI 0
#define RFI 0
#else
#define RI 0
#define RFI 0
#endif

/* Temporal denoising
 *
 * This setting is dependent on code generation from shader_cfg, so this 
 * setting can only be enabled via shader_cfg.
 *
 * Caveats:
 * 	- Slower:
 * 		- Each frame needs to be researched (more samples & more math)
 * 		- Gather optimizations only apply to the current frame
 * 	- Requires vo=gpu-next
 * 	- Luma-only (this is a bug)
 * 	- Buggy
 *
 * May cause motion blur and may struggle more with noise that persists across 
 * multiple frames (e.g., from compression or duplicate frames), but can work 
 * very well on high quality video.
 *
 * Motion estimation (ME) should improve quality without impacting speed.
 *
 * T: number of frames used
 * ME: motion estimation, 0 for none, 1 for max weight, 2 for weighted avg
 * MEF: estimate factor, compensates for ME being one frame behind
 * TRF: compare against the denoised frames
 */
#ifdef LUMA_raw
#define T 0
#define ME 1
#define MEF 2
#define TRF 0
#else
#define T 0
#define ME 0
#define MEF 2
#define TRF 0
#endif

/* Spatial kernel
 *
 * Increasing the spatial denoising factor (SS) reduces the weight of further 
 * pixels.
 *
 * Spatial distortion instructs the spatial kernel to view that axis as 
 * closer/further, for instance SD=(1,1,0.5) would make the temporal axis 
 * appear closer and increase blur between frames.
 *
 * The intra-patch variants are supposed to help with larger patch sizes.
 *
 * SST: enables spatial kernel if R>=PST, 0 fully disables
 * SS: spatial sigma
 * SD: spatial distortion (X, Y, time)
 * PSS: intra-patch spatial sigma
 * PST: enables intra-patch spatial kernel if P>=PST, 0 fully disables
 * PSD: intra-patch spatial distortion (X, Y)
 */
#ifdef LUMA_raw
#define SST 1
#define SS 0.25
#define SD vec3(1,1,1)
#define PST 0
#define PSS 0.0
#define PSD vec2(1,1)
#else
#define SST 1
#define SS 0.25
#define SD vec3(1,1,1)
#define PST 0
#define PSS 0.0
#define PSD vec2(1,1)
#endif

/* Kernels
 *
 * SK: spatial kernel
 * RK: range kernel (takes patch differences)
 * PSK: intra-patch spatial kernel
 *
 * List of available kernels:
 *
 * bicubic
 * cos
 * gaussian
 * lanczos
 * quadratic
 * sinc
 * sphinx
 */
#ifdef LUMA_raw
#define SK gaussian
#define RK gaussian
#define PSK gaussian
#else
#define SK gaussian
#define RK gaussian
#define PSK gaussian
#endif

// Scaling factor (should match WIDTH/HEIGHT)
#ifdef LUMA_raw
#define SF 1
#else
#define SF 1
#endif

/* Visualization
 *
 * 0: off
 * 1: absolute difference between input/output to the power of 0.25
 * 2: difference between input/output centered on 0.5
 * 3: post-WD weight map
 * 4: pre-WD weight map
 * 5: unsharp mask
 * 6: EP
 */
#ifdef LUMA_raw
#define V 0
#else
#define V 0
#endif

// Blur factor (0.0 returns the input image, 1.0 returns the output image)
#ifdef LUMA_raw
#define BF 1.0
#else
#define BF 1.0
#endif

// Force disable textureGather
#ifdef LUMA_raw
#define NG 0
#else
#define NG 0
#endif

// Patch donut (probably useless)
#ifdef LUMA_raw
#define PD 0
#else
#define PD 0
#endif

// Duplicate 1st weight (for luma-guided-chroma)
#ifdef LUMA_raw
#define D1W 0
#else
#define D1W 0
#endif

// Skip patch comparison
#ifdef LUMA_raw
#define SKIP_PATCH 0
#else
#define SKIP_PATCH 0
#endif

// Shader code

#define EPSILON 0.00000000001
#define M_PI 3.14159265358979323846
#define POW2(x) ((x)*(x))
#define POW3(x) ((x)*(x)*(x))
#define bicubic(x) ((1.0/6.0) * (POW3((x)+2) - 4 * POW3((x)+1) + 6 * POW3(x) - 4 * POW3(max((x)-1, 0))))
#define gaussian(x) exp(-1 * POW2(x))
#define lanczos(x) POW2(sinc(x))
#define quadratic(x) ((x) < 0.5 ? 0.75 - POW2(x) : 0.5 * POW2((x) - 1.5))
#define sinc(x) ((x) < 1e-8 ? 1.0 : sin((x)*M_PI) / ((x)*M_PI))
#define sphinx(x) ((x) < 1e-8 ? 1.0 : 3.0 * (sin((x)*M_PI) - (x)*M_PI * cos((x)*M_PI)) / POW3((x)*M_PI))

// XXX could maybe be better optimized on LGC
// XXX return original alpha component instead of 1.0
#if defined(LUMA_raw)
#define val float
#define val_swizz(v) (v.x)
#define unval(v) vec4(v.x, 0, 0, 1.0)
#define val_packed val
#define val_pack(v) (v)
#define val_unpack(v) (v)
#elif defined(CHROMA_raw)
#define val vec2
#define val_swizz(v) (v.xy)
#define unval(v) vec4(v.x, v.y, 0, 1.0)
#define val_packed uint
#define val_pack(v) packUnorm2x16(v)
#define val_unpack(v) unpackUnorm2x16(v)
#else
#define val vec3
#define val_swizz(v) (v.xyz)
#define unval(v) vec4(v.x, v.y, v.z, 1.0)
#define val_packed val
#define val_pack(v) (v)
#define val_unpack(v) (v)
#endif

#if PS == 6
const int hp = P/2;
#else
const float hp = int(P/2) - 0.5*(1-(P%2)); // sample between pixels for even patch sizes
#endif

#if RS == 6
const int hr = R/2;
#else
const float hr = int(R/2) - 0.5*(1-(R%2)); // sample between pixels for even research sizes
#endif

// donut increment, increments without landing on (0,0,0)
// much faster than a continue statement
#define DINCR(z,c) (z.c++,(z.c += int(z == vec3(0))))

// patch/research shapes
// each shape is depicted in a comment, where Z=5 (Z corresponds to P or R)
// dots (.) represent samples (pixels) and X represents the pixel-of-interest

// Z    .....
// Z    .....
// Z    ..X..
// Z    .....
// Z    .....
#define S_SQUARE(z,hz,incr) for (z.x = -hz; z.x <= hz; z.x++) for (z.y = -hz; z.y <= hz; incr)

// (in this instance Z=4)
// Z    ....
// Z    ....
// Z    ..X.
// Z    ....
#define S_SQUARE_EVEN(z,hz,incr) for (z.x = -hz; z.x < hz; z.x++) for (z.y = -hz; z.y < hz; incr)

// Z-4    .
// Z-2   ...
// Z    ..X..
#define S_TRIANGLE(z,hz,incr) for (z.y = -hz; z.y <= 0; z.y++) for (z.x = -abs(abs(z.y) - hz); z.x <= abs(abs(z.y) - hz); incr)

// Z-4    .
// Z-2   ...
// hz+1 ..X
#define S_TRUNC_TRIANGLE(z,hz,incr) for (z.y = -hz; z.y <= 0; z.y++) for (z.x = -abs(abs(z.y) - hz); z.x <= abs(abs(z.y) - hz)*int(z.y!=0); incr)
#define S_TRIANGLE_A(hz,Z) int(hz*hz+Z)

// Z-4    .
// Z-2   ...
// Z    ..X..
// Z-2   ...
// Z-4    .
#define S_DIAMOND(z,hz,incr) for (z.x = -hz; z.x <= hz; z.x++) for (z.y = -abs(abs(z.x) - hz); z.y <= abs(abs(z.x) - hz); incr)
#define S_DIAMOND_A(hz,Z) int(hz*hz*2+Z)

//
// Z    ..X..
//
#define S_HORIZONTAL(z,hz,incr) for (z.x = -hz; z.x <= hz; incr) for (z.y = 0; z.y <= 0; z.y++)

// 90 degree rotation of S_HORIZONTAL
#define S_VERTICAL(z,hz,incr) for (z.x = 0; z.x <= 0; z.x++) for (z.y = -hz; z.y <= hz; incr)

// 1      .
// 1      . 
// Z    ..X..
// 1      . 
// 1      .
#define S_PLUS(z,hz,incr) for (z.x = -hz; z.x <= hz; z.x++) for (z.y = -hz * int(z.x == 0); z.y <= hz * int(z.x == 0); incr)
#define S_PLUS_A(hz,Z) (Z*2 - 1)

// XXX implement S_PLUS w/ an X overlayed:
// 3    . . .
// 3     ...
// Z    ..X..
// 3     ...
// 3    . . .

// XXX implement an X shape:
// 2    .   .
// 2     . .
// 1      X  
// 2     . .
// 2    .   .

// 1x1 square
#define S_1X1(z) for (z = vec3(0); z.x <= 0; z.x++)

#define T1 (T+1)
#define FOR_FRAME(r) for (r.z = 0; r.z < T1; r.z++)

#ifdef LUMA_raw
#define RF_ RF_LUMA
#else
#define RF_ RF
#endif

// Skip comparing the pixel-of-interest against itself, unless RF is enabled
#if RF_
#define RINCR(z,c) (z.c++)
#else
#define RINCR DINCR
#endif

#define R_AREA(a) (a * T1 + RF_-1)

// research shapes
// XXX would be nice to have the option of temporally-varying research sizes
#if R == 0 || R == 1
#define FOR_RESEARCH(r) S_1X1(r)
const int r_area = R_AREA(1);
#elif RS == 7
#define FOR_RESEARCH(r) S_PLUS(r,hr,RINCR(r,y))
const int r_area = R_AREA(S_PLUS_A(hr,R));
#elif RS == 6
#define FOR_RESEARCH(r) S_SQUARE_EVEN(r,hr,RINCR(r,y))
const int r_area = R_AREA(R*R);
#elif RS == 5
#define FOR_RESEARCH(r) S_TRUNC_TRIANGLE(r,hr,RINCR(r,x))
const int r_area = R_AREA(S_TRIANGLE_A(hr,hr));
#elif RS == 4
#define FOR_RESEARCH(r) S_TRIANGLE(r,hr,RINCR(r,x))
const int r_area = R_AREA(S_TRIANGLE_A(hr,R));
#elif RS == 3
#define FOR_RESEARCH(r) S_DIAMOND(r,hr,RINCR(r,y))
const int r_area = R_AREA(S_DIAMOND_A(hr,R));
#elif RS == 2
#define FOR_RESEARCH(r) S_VERTICAL(r,hr,RINCR(r,y))
const int r_area = R_AREA(R);
#elif RS == 1
#define FOR_RESEARCH(r) S_HORIZONTAL(r,hr,RINCR(r,x))
const int r_area = R_AREA(R);
#elif RS == 0
#define FOR_RESEARCH(r) S_SQUARE(r,hr,RINCR(r,y))
const int r_area = R_AREA(R*R);
#endif

#define RI1 (RI+1)
#define RFI1 (RFI+1)

#if RI
#define FOR_ROTATION for (float ri = 0; ri < 360; ri+=360.0/RI1)
#else
#define FOR_ROTATION
#endif

#if RFI
#define FOR_REFLECTION for (int rfi = 0; rfi < RFI1; rfi++)
#else
#define FOR_REFLECTION
#endif

#if PD
#define PINCR DINCR
#else
#define PINCR(z,c) (z.c++)
#endif

#define P_AREA(a) (a - PD)

// patch shapes
#if P == 0 || P == 1
#define FOR_PATCH(p) S_1X1(p)
const int p_area = P_AREA(1);
#elif PS == 7
#define FOR_PATCH(p) S_PLUS(p,hp,PINCR(p,y))
const int p_area = P_AREA(S_PLUS_A(hp,P));
#elif PS == 6
#define FOR_PATCH(p) S_SQUARE_EVEN(p,hp,PINCR(p,y))
const int p_area = P_AREA(P*P);
#elif PS == 5
#define FOR_PATCH(p) S_TRUNC_TRIANGLE(p,hp,PINCR(p,x))
const int p_area = P_AREA(S_TRIANGLE_A(hp,hp));
#elif PS == 4
#define FOR_PATCH(p) S_TRIANGLE(p,hp,PINCR(p,x))
const int p_area = P_AREA(S_TRIANGLE_A(hp,P));
#elif PS == 3
#define FOR_PATCH(p) S_DIAMOND(p,hp,PINCR(p,y))
const int p_area = P_AREA(S_DIAMOND_A(hp,P));
#elif PS == 2
#define FOR_PATCH(p) S_VERTICAL(p,hp,PINCR(p,y))
const int p_area = P_AREA(P);
#elif PS == 1
#define FOR_PATCH(p) S_HORIZONTAL(p,hp,PINCR(p,x))
const int p_area = P_AREA(P);
#elif PS == 0
#define FOR_PATCH(p) S_SQUARE(p,hp,PINCR(p,y))
const int p_area = P_AREA(P*P);
#endif

const float r_scale = 1.0/r_area;
const float p_scale = 1.0/p_area;

#define sample(tex, pos, size, pt, off) tex(pos + pt * (vec2(off) + 0.5 - fract(pos*size)))
#define load_(off) sample(HOOKED_tex, HOOKED_pos, HOOKED_size, HOOKED_pt, off)

#if RF_ && defined(LUMA_raw)
#define load2_(off) sample(RF_LUMA_tex, RF_LUMA_pos, RF_LUMA_size, RF_LUMA_pt, off)
#define gather_offs(off, off_arr) (RF_LUMA_mul * vec4(textureGatherOffsets(RF_LUMA_raw, RF_LUMA_pos + vec2(off) * RF_LUMA_pt, off_arr)))
#define gather(off) RF_LUMA_gather(RF_LUMA_pos + (off) * RF_LUMA_pt, 0)
#elif RF_ && D1W
#define load2_(off) sample(RF_tex, RF_pos, RF_size, RF_pt, off)
#define gather_offs(off, off_arr) (RF_mul * vec4(textureGatherOffsets(RF_raw, RF_pos + vec2(off) * RF_pt, off_arr)))
#define gather(off) RF_gather(RF_pos + (off) * RF_pt, 0)
#elif RF_
#define load2_(off) sample(RF_tex, RF_pos, RF_size, RF_pt, off)
#else
#define load2_(off) load_(off)
#define gather_offs(off, off_arr) (HOOKED_mul * vec4(textureGatherOffsets(HOOKED_raw, HOOKED_pos + vec2(off) * HOOKED_pt, off_arr)))
#define gather(off) HOOKED_gather(HOOKED_pos + (off)*HOOKED_pt, 0)
#endif

#if T
val load(vec3 off)
{
	switch (min(int(off.z), frame)) {
	case 0: return val_swizz(load_(off));

	}
}
val load2(vec3 off)
{
	return off.z == 0 ? val_swizz(load2_(off)) : load(off);
}
#else
#define load(off) val_swizz(load_(off))
#define load2(off) val_swizz(load2_(off))
#endif

val poi = load(vec3(0)); // pixel-of-interest
val poi2 = load2(vec3(0)); // guide pixel-of-interest

#if RI // rotation
vec2 rot(vec2 p, float d)
{
	return vec2(
		p.x * cos(radians(d)) - p.y * sin(radians(d)),
		p.y * sin(radians(d)) + p.x * cos(radians(d))
	);
}
#else
#define rot(p, d) (p)
#endif

#if RFI // reflection
vec2 ref(vec2 p, int d)
{
	switch (d) {
	case 0: return p;
	case 1: return p * vec2(1, -1);
	case 2: return p * vec2(-1, 1);
	}
}
#else
#define ref(p, d) (p)
#endif

#if SST && R >= SST
float spatial_r(vec3 v)
{
	v.xy += 0.5 - fract(HOOKED_pos*HOOKED_size);
	return SK(length(v*SD)*SS);
}
#else
#define spatial_r(v) (1)
#endif

#if PST && P >= PST
#define spatial_p(v) PSK(length(v*PSD)*PSS)
#else
#define spatial_p(v) (1)
#endif

val range(val pdiff_sq)
{
	const float h = S*0.013;
	const float pdiff_scale = 1.0/(h*h);
	pdiff_sq = sqrt(pdiff_sq * pdiff_scale);
#if defined(LUMA_raw)
	return RK(pdiff_sq);
#elif defined(CHROMA_raw)
	return vec2(RK(pdiff_sq.x), RK(pdiff_sq.y));
#else
	return vec3(RK(pdiff_sq.x), RK(pdiff_sq.y), RK(pdiff_sq.z));
#endif
}

val patch_comparison(vec3 r, vec3 r2)
{
	vec3 p;
	val min_rot = val(p_area);

	FOR_ROTATION FOR_REFLECTION {
		val pdiff_sq = val(0);
		FOR_PATCH(p) {
			vec3 transformed_p = vec3(ref(rot(p.xy, ri), rfi), p.z);
			val diff_sq = load2(p + r2) - load2((transformed_p + r) * SF);
			diff_sq *= diff_sq;
			diff_sq = 1 - (1 - diff_sq) * spatial_p(p.xy);
			pdiff_sq += diff_sq;
		}
		min_rot = min(min_rot, pdiff_sq);
	}

	return min_rot * p_scale;
}

#define NO_GATHER (PD == 0 && NG == 0) // never textureGather if any of these conditions are false
#define REGULAR_ROTATIONS (RI == 0 || RI == 1 || RI == 3)

#if (defined(LUMA_gather) || D1W) && ((PS == 3 || PS == 7) && P == 3) && PST == 0 && REGULAR_ROTATIONS && NO_GATHER
// 3x3 diamond/plus patch_comparison_gather
// XXX extend to support arbitrary sizes (probably requires code generation)
// XXX extend to support 3x3 square
// XXX support PSS
const ivec2 offsets[4] = { ivec2(0,-1), ivec2(-1,0), ivec2(0,1), ivec2(1,0) };
const ivec2 offsets_sf[4] = { ivec2(0,-1) * SF, ivec2(-1,0) * SF, ivec2(0,1) * SF, ivec2(1,0) * SF };
vec4 poi_patch = gather_offs(0, offsets);
float patch_comparison_gather(vec3 r, vec3 r2)
{
	float min_rot = p_area - 1;
	vec4 transformer = gather_offs(r, offsets_sf);
	FOR_ROTATION {
		FOR_REFLECTION {
			float diff_sq = dot((poi_patch - transformer) * (poi_patch - transformer), vec4(1));
			min_rot = min(diff_sq, min_rot);
#if RFI
			switch(rfi) {
			case 0: transformer = transformer.zyxw; break;
			case 1: transformer = transformer.zwxy; break; // undoes last mirror, performs another mirror
			case 2: transformer = transformer.zyxw; break; // undoes last mirror
			}
#endif
		}
#if RI == 3
		transformer = transformer.wxyz;
#elif RI == 1
		transformer = transformer.zwxy;
#endif
	}
	float center_diff_sq = poi2.x - load2(r).x;
	center_diff_sq *= center_diff_sq;
	return (min_rot + center_diff_sq) * p_scale;
}
#elif (defined(LUMA_gather) || D1W) && PS == 6 && RI == 0 && RFI == 0 && NO_GATHER
// tiled even square patch_comparison_gather
// XXX extend to support odd square?
float patch_comparison_gather(vec3 r, vec3 r2)
{
	vec2 tile;
	float min_rot = p_area;

	/* gather order:
	 * w z
	 * x y
	 */
	float pdiff_sq = 0;
	for (tile.x = -hp; tile.x < hp; tile.x+=2) for (tile.y = -hp; tile.y < hp; tile.y+=2) {
		vec4 diff_sq = gather(tile + r.xy) - gather(tile + r2.xy);
		diff_sq *= diff_sq;
		diff_sq = 1 - (1 - diff_sq) * vec4(spatial_p(tile+vec2(0,1)), spatial_p(tile+vec2(1,1)),
			                                 spatial_p(tile+vec2(1,0)), spatial_p(tile+vec2(0,0)));
		pdiff_sq += dot(diff_sq, vec4(1));
	}
	min_rot = min(min_rot, pdiff_sq);

	return min_rot * p_scale;
}
#else
#define patch_comparison_gather patch_comparison
#endif

vec4 hook()
{
	val total_weight = val(0);
	val sum = val(0);
	val total_weight_s = val(0);
	val sum_s = val(0);
	val result = val(0);

	vec3 r = vec3(0);
	vec3 p = vec3(0);
	vec3 me = vec3(0);

#if T && ME == 1 // temporal & motion estimation
	vec3 me_tmp = vec3(0);
	float maxweight = 0;
#elif T && ME == 2 // temporal & motion estimation
	vec3 me_sum = vec3(0);
	float me_weight = 0;
#endif

#if WD == 2 // weight discard
	int r_index = 0;
	val_packed all_weights[r_area];
	val_packed all_pixels[r_area];
#elif WD == 1 // weight discard
	val no_weights = val(0);
	val discard_total_weight = val(0);
	val discard_sum = val(0);
#endif

	FOR_FRAME(r) {
	// XXX ME is always a frame behind, should have the option to re-research after applying ME (could do it an arbitrary number of times per frame if desired)
#if T && ME == 1 // temporal & motion estimation max weight
	if (r.z > 0) {
		me += me_tmp * MEF;
		me_tmp = vec3(0);
		maxweight = 0;
	}
#elif T && ME == 2 // temporal & motion estimation weighted average
	if (r.z > 0) {
		me += round(me_sum / me_weight * MEF);
		me_sum = vec3(0);
		me_weight = 0;
	}
#endif
	FOR_RESEARCH(r) {
		float spatial_weight = spatial_r(r);
		val px = load(r+me);

#if SKIP_PATCH
		val weight = val(1);
#else
		val pdiff_sq = (r.z == 0) ? val(patch_comparison_gather(r+me, vec3(0))) : patch_comparison(r+me, vec3(0));
		val weight = range(pdiff_sq);
#endif

#if T && ME == 1 // temporal & motion estimation max weight
		me_tmp = vec3(r.xy,0) * step(maxweight, weight.x) + me_tmp * (1 - step(maxweight, weight.x));
		maxweight = max(maxweight, weight.x);
#elif T && ME == 2 // temporal & motion estimation weighted average
		me_sum += vec3(r.xy,0) * weight.x;
		me_weight += weight.x;
#endif

#if D1W
		weight = val(weight.x);
#endif

		weight *= spatial_weight;
		sum_s += px * spatial_weight;
		total_weight_s += spatial_weight;

#if WD == 2 // weight discard
		all_weights[r_index] = val_pack(weight);
		all_pixels[r_index] = val_pack(px);
		r_index++;
#elif WD == 1 // weight discard
		val wd_scale = 1.0/max(no_weights, 1);
		val keeps = step(total_weight*wd_scale * WDT*exp(-wd_scale*WDP), weight);
		discard_sum += px * weight * (1 - keeps);
		discard_total_weight += weight * (1 - keeps);
		no_weights += keeps;
#endif

		sum += px * weight;
		total_weight += weight;
	} // FOR_RESEARCH
	} // FOR_FRAME

	val avg_weight = total_weight * r_scale;
	val old_avg_weight = avg_weight;

#if WD == 2 // true average
	total_weight = val(0);
	sum = val(0);
	val no_weights = val(0);

	for (int i = 0; i < r_area; i++) {
		val w = val_unpack(all_weights[i]);
		val px = val_unpack(all_pixels[i]);
		val keeps = step(avg_weight*WDT, w);

		w *= keeps;
		sum += px * w;
		total_weight += w;
		no_weights += keeps;
	}
#elif WD == 1 // moving cumulative average
	total_weight -= discard_total_weight;
	sum -= discard_sum;
#endif
#if WD // weight discard
	avg_weight = total_weight / no_weights;
#endif

	total_weight += SW * spatial_r(vec3(0));
	sum += poi * SW * spatial_r(vec3(0));
	result = val(sum / total_weight);

	// store frames for temporal
#if T > 1

#endif
#if T && TRF
	imageStore(PREV1, ivec2(HOOKED_pos*imageSize(PREV1)), unval(result));
#elif T
	imageStore(PREV1, ivec2(HOOKED_pos*imageSize(PREV1)), unval(poi2));
#endif

#define USM ((result - sum_s/total_weight_s) * ASF)
#if AS == 1 // sharpen+denoise
	val sharpened = result + USM;
#elif AS == 2 // sharpen only
	val sharpened = poi + USM;
#endif

#if EP // extremes preserve
	float luminance = EP_texOff(0).x;
	// EPSILON is needed since pow(0,0) is undefined
	float ep_weight = pow(max(min(1-luminance, luminance)*2, EPSILON), (luminance < 0.5 ? DP : BP));
	result = mix(poi, result, ep_weight);
#else
	float ep_weight = 0;
#endif

#if AS == 1 // sharpen+denoise
	result = mix(sharpened, result, old_avg_weight);
#elif AS == 2 // sharpen only
	result = sharpened;
#endif

#if V == 1
	result = clamp(pow(abs(poi - result), val(0.25)), 0.0, 1.0);
#elif V == 2
	result = (poi - result) * 0.5 + 0.5;
#elif V == 3 // post-WD weight map
	result = avg_weight;
#elif V == 4 // pre-WD edge map
	result = old_avg_weight;
#elif V == 5
	result = 0.5 + USM;
#elif V == 6
	result = val(1 - ep_weight);
#endif

// XXX visualize chroma for these
#if defined(CHROMA_raw) && (V == 3 || V == 4 || V == 6)
	return vec4(0.5);
#endif

	return unval(mix(poi, result, BF));
}

