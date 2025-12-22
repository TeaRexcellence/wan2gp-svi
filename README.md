# SVI (Stable Video Infinity) for WanGP

Generate **infinite-length videos** without drift or degradation using the SVI LoRA and clip-chaining technique.

## What is SVI?

Standard WanGP sliding windows blend clips in latent space, which causes:
- Color drift over time
- Face/object morphing
- Quality degradation after 3-4 clips

SVI (Stable Video Infinity) fixes this by:
- Using **pixel-level frame chaining** instead of latent blending
- A specially trained **LoRA** that makes transitions seamless
- Videos can go 10+ clips without noticeable degradation

## Installation

### Option 1: Run installer (Windows)
1. Copy the `wan2gp-svi` folder into your WanGP directory
2. Run `install.bat`

### Option 2: Manual install
1. Apply the patches:
   ```
   cd WanGP
   git apply wan2gp-svi/wgp.patch
   git apply wan2gp-svi/any2video.patch
   git apply wan2gp-svi/model.patch
   ```
2. Copy profiles to loras folder:
   ```
   copy "wan2gp-svi/profiles/*.json" "loras/wan_i2v/"
   ```

## Usage

1. Launch WanGP: `python wgp.py`
2. Select **Wan2.1** > **Image2Video 14B**
3. Choose profile: **"SVI-Shot Infinite - 50 Steps"**
4. Click **Apply**
5. Add a **Start Image**
6. Set **Number of frames** to **162+** (must be >81 to trigger multi-clip)
7. Enter your prompt
8. Click **Generate**

The SVI LoRA (~2.3GB) will auto-download on first use.

## Profiles

| Profile | Motion Frames | Best For |
|---------|---------------|----------|
| **SVI-Shot Infinite** | 1 | Stable, drift-free, consistent scenes |
| **SVI-2.0 Unified** | 5 | More creative transitions, dynamic scenes |

Start with **SVI-Shot** for testing - it's more stable.

## Tips

- **Steps**: 50 is recommended, but 25-30 works for faster testing
- **Frames**: 81 = 1 clip, 162 = 2 clips, 243 = 3 clips, etc.
- **Prompt**: Describe consistent motion (e.g., "slowly moves", "steady camera")
- Watch console for `[SVI Mode]` messages confirming it's active

## How It Works

Standard sliding window:
```
Clip 1 --[latent blend]--> Clip 2 --[latent blend]--> Clip 3
         (drift)                    (more drift)
```

SVI mode:
```
Clip 1 --[pixel frames]--> Clip 2 --[pixel frames]--> Clip 3
         (SVI LoRA)                 (SVI LoRA)
         (seamless)                 (seamless)
```

## Files Modified

- `wgp.py` - SVI parameters, clip-chaining logic
- `models/wan/any2video.py` - VAE encoding, mask construction
- `models/wan/modules/model.py` - LoRA format conversion

## Credits

- **SVI Research**: [Stable Video Infinity](https://github.com/vita-epfl/Stable-Video-Infinity)
- **WanGP**: [DeepBeepMeep](https://github.com/deepbeepmeep/Wan2GP)
- **Integration**: This patch

## License

Same as WanGP - for research/personal use.
