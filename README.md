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
3. Choose profile: **"SVI-Shot Infinite - 50 Steps"** or **"SVI-2.0 Unified - 50 Steps"**
4. Click **Apply**
5. Add a **Start Image**
6. Set **Number of frames** to **162+** (for example: Must be set greater than 81 to trigger multi-clip if sliding window is set to 81)
7. Enter your prompt
8. Click **Generate**

The SVI LoRA (~2.3GB) will auto-download on first use.

## Profiles

| Profile | Motion Frames | Best For |
|---------|---------------|----------|
| **SVI-Shot Infinite** | 1 | Stable, drift-free, consistent scenes |
| **SVI-2.0 Unified** | 5 | More creative transitions, dynamic scenes |

I suggest starting with SVI-Shot for testing - it's simpler and more predictable. Use SVI-2.0 Unified when you want more dynamic/creative results.

### SVI-Shot (1 motion frame):
  - Passes only the last frame to the next clip
  - Creates tighter continuity - almost like a seamless loop
  - Best for: talking heads, static backgrounds, consistent scenes
  - Less creative freedom but maximum stability

### SVI-2.0 Unified (5 motion frames):
  - Passes last 5 frames to the next clip
  - Gives the model more motion context
  - Allows more dynamic movement and scene evolution
  - Better for: action scenes, camera pans, gradual scene changes
  - Inherits motion dynamics of SVI-Film while retaining stability of SVI-Shot

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

## Troubleshooting

**Patches failed to apply?**
- Make sure you're using the latest WanGP version the patches were built for
- If WanGP updated, the patches may need to be regenerated
- You can try `git apply --3way` for better conflict handling

**No SVI profiles showing?**
- Profiles must be in `loras/wan_i2v/` folder, NOT `profiles/`
- Make sure you selected **Wan2.1 > Image2Video 14B** (not Wan2.2)

**"[SVI Mode]" not appearing in console?**
- Check that `svi_mode: true` is set in the profile JSON
- Make sure total frames > sliding window size (e.g., 162 > 81)

**Video still has drift?**
- Ensure you're using the SVI LoRA (auto-downloads on first run)
- Try SVI-Shot profile instead of SVI-2.0 for more stability

## Updating WanGP

After updating WanGP, you'll need to re-apply the patches:

```bash
cd WanGP
git apply wan2gp-svi/wgp.patch
git apply wan2gp-svi/any2video.patch
git apply wan2gp-svi/model.patch
```

If patches fail due to conflicts, you may need updated patches for the new WanGP version.

## Uninstall

To remove SVI and restore original WanGP:

```bash
cd WanGP
git checkout wgp.py
git checkout models/wan/any2video.py
git checkout models/wan/modules/model.py
```

## License

Same as WanGP - for research/personal use.
