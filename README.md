# SVI (Stable Video Infinity) for WanGP

Generate **infinite-length videos** without drift or degradation using the SVI LoRA and clip-chaining technique.

**Supports both Wan 2.1 and Wan 2.2 Image2Video models.**

## What is SVI?

Standard WanGP sliding windows blend clips in latent space, which causes:
- Color drift over time
- Face/object morphing
- Quality degradation after 3-4 clips

SVI (Stable Video Infinity) fixes this by:
- Using **pixel-level frame chaining** instead of latent blending
- A specially trained **LoRA** that makes transitions seamless
- **Different seed per clip** to prevent repetitive patterns
- Videos can go 10+ clips without noticeable degradation

## Installation

### Option 1: Run installer (Windows)
1. Copy the `wan2gp-svi` folder into your WanGP directory
2. Run `install.bat`

### Option 2: Manual install
1. Apply the patches:
   ```bash
   cd WanGP
   git apply wan2gp-svi/wgp.patch
   git apply wan2gp-svi/any2video.patch
   git apply wan2gp-svi/model.patch
   ```
2. Copy profiles:
   ```bash
   # Wan 2.1 profiles
   copy "wan2gp-svi/profiles/*.json" "loras/wan_i2v/"

   # Wan 2.2 profiles
   mkdir "profiles/wan_2_2"
   copy "wan2gp-svi/profiles/wan_2_2/*.json" "profiles/wan_2_2/"
   ```

## Usage

### Wan 2.1
1. Launch WanGP: `python wgp.py`
2. Select **Wan2.1** > **Image2Video 14B**
3. Choose a profile (see Profiles section below)
4. Click **Apply**
5. Add a **Start Image** (480x832 horizontal recommended)
6. Set **Number of frames** to **162+** (must be greater than 81 to trigger multi-clip)
7. Enter your prompt
8. Click **Generate**

### Wan 2.2
1. Launch WanGP: `python wgp.py`
2. Select **Wan2.2** > **Image2Video 14B**
3. Choose a profile (see Profiles section below)
4. Click **Apply**
5. Add a **Start Image** (480x832 horizontal recommended)
6. Set **Number of frames** to **162+** (must be greater than 81 to trigger multi-clip)
7. Enter your prompt
8. Click **Generate**

The SVI LoRAs will auto-download on first use (~2.3GB for Wan 2.1, ~2.5GB total for Wan 2.2).

## Profiles

### Wan 2.1 Profiles

| Profile | Steps | Accelerator | Motion Frames | Best For |
|---------|-------|-------------|---------------|----------|
| **SVI-Shot Infinite - 50 Steps** | 50 | None | 1 | Best quality, stable scenes |
| **SVI-2.0 Unified - 50 Steps** | 50 | None | 5 | Best quality, dynamic scenes |
| **SVI-Shot Infinite + FusioniX - 10 Steps** | 10 | FusioniX | 1 | 5x faster, stable scenes |
| **SVI-2.0 Unified + FusioniX - 10 Steps** | 10 | FusioniX | 5 | 5x faster, dynamic scenes |
| **SVI-Shot Infinite + LightX2V - 4 Steps** | 4 | LightX2V | 1 | 12x faster, stable scenes |
| **SVI-2.0 Unified + LightX2V - 4 Steps** | 4 | LightX2V | 5 | 12x faster, dynamic scenes |

### Wan 2.2 Profiles

| Profile | Steps | Accelerator | Motion Frames | Best For |
|---------|-------|-------------|---------------|----------|
| **SVI-Shot Infinite - 50 Steps** | 50 | None | 1 | Best quality, stable scenes |
| **SVI-2.0 Unified - 50 Steps** | 50 | None | 5 | Best quality, dynamic scenes |
| **SVI-Shot Infinite + Lightning - 4 Steps** | 4 | Lightning | 1 | 12x faster, stable scenes |
| **SVI-2.0 Unified + Lightning - 4 Steps** | 4 | Lightning | 5 | 12x faster, dynamic scenes |

> **Note**: FusioniX is NOT compatible with Wan 2.2 (different architecture). Use Lightning accelerator for Wan 2.2.

### Accelerator LoRA Strength

Based on [SVI team's guidance](https://github.com/vita-epfl/Stable-Video-Infinity/tree/svi_wan22#12-10-2025-important-notes-on-using-lightx2v-with-svi), accelerator LoRAs use reduced strength:
- **High-noise phase**: 0.5 strength
- **Low-noise phase**: 1.0 strength

This balances speed with motion dynamics. The profiles are pre-configured with these values.

### Which profile to choose?

- **Testing/iterating**: Use accelerated profiles (4-10 steps) for speed
- **Final render**: Use 50-step profiles for best quality
- **Talking heads/static scenes**: Use SVI-Shot (1 motion frame)
- **Action/movement**: Use SVI-2.0 Unified (5 motion frames)

## Tips from SVI Team

### Aspect Ratio Matters
The SVI model is trained on **480x832 (horizontal)**. Using different aspect ratios (especially vertical) can cause:
- Weaker motion/dynamics
- Reference image "snapping back"

**Solution**: Outpaint your input image to 480x832 or similar horizontal ratio.

### Use Strong Prompts
There's a trade-off between text control and reference frame control. Weak prompts cause the model to follow the reference pose instead of your instructions.

**Solution**: Use clear, detailed prompts. Prompt enhancement helps.

### CFG Values
- **50-step profiles**: CFG 5 (Wan 2.1) or CFG 1.5 (Wan 2.2)
- **Accelerated profiles**: CFG 1-1.5

These are pre-configured in the profiles.

### High-Quality Input Image
The first frame serves as the anchor guiding all subsequent generations. Use a high-quality input image.

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
         (new seed)                 (new seed)
         (seamless)                 (seamless)
```

## Console Output

When SVI is working correctly, you'll see:
```
[SVI Mode] Enabled with motion_frames=1, ref_pad_num=-1
[SVI Mode] Clip 1/3 complete, chaining with 1 motion frame(s)
[SVI Mode] Window 2: Using new seed 123456789
[SVI Mode] Clip 2/3 complete, chaining with 1 motion frame(s)
[SVI Mode] Window 3: Using new seed 987654321
[SVI Mode] Clip 3/3 complete, chaining with 1 motion frame(s)
```

If you don't see `[SVI Mode]` messages, the profile didn't load correctly.

## Wan 2.1 vs Wan 2.2 Differences

| Feature | Wan 2.1 | Wan 2.2 |
|---------|---------|---------|
| SVI LoRAs | 1 LoRA | 2 LoRAs (high/low noise) |
| Phases | 1 | 2 |
| CFG | 5 | 1.5 |
| LoRA multipliers | Simple (e.g., "1") | Phase-split (e.g., "1;0 0;1") |
| Accelerator | FusioniX or LightX2V | Lightning |

These differences are handled automatically by the profiles.

## Files Modified

- `wgp.py` - SVI parameters, clip-chaining logic, per-window seed randomization
- `models/wan/any2video.py` - VAE encoding, mask construction
- `models/wan/modules/model.py` - LoRA format conversion (DiffSynth to WanGP)

## Credits

- **SVI Research**: [Stable Video Infinity](https://github.com/vita-epfl/Stable-Video-Infinity) by VITA@EPFL
- **WanGP**: [DeepBeepMeep](https://github.com/deepbeepmeep/Wan2GP)
- **Integration**: This patch

## Troubleshooting

**Patches failed to apply?**
- Make sure you're using the latest WanGP version the patches were built for
- If WanGP updated, the patches may need to be regenerated
- You can try `git apply --3way` for better conflict handling

**No SVI profiles showing?**
- For Wan 2.1: Profiles must be in `loras/wan_i2v/` folder
- For Wan 2.2: Profiles must be in `profiles/wan_2_2/` folder
- Make sure you selected the correct model (Wan2.1 or Wan2.2 > Image2Video 14B)

**"[SVI Mode]" not appearing in console?**
- Check that `svi_mode: true` is set in the profile JSON
- Make sure total frames > sliding window size (e.g., 162 > 81)

**Video still has drift?**
- Ensure you're using the SVI LoRA (auto-downloads on first run)
- Try SVI-Shot profile instead of SVI-2.0 for more stability
- Check aspect ratio - use 480x832 horizontal

**Repetitive clips / same motion repeating?**
- This was fixed with per-window seed randomization
- Make sure you have the latest patch applied
- Look for `[SVI Mode] Window X: Using new seed` in console

**Reference image keeps reappearing?**
- Use stronger, more detailed prompts
- Outpaint image to 480x832 aspect ratio
- Try increasing CFG slightly (within 1-2 range for Wan 2.2)

**"Unexpected module keys" error with FusioniX on Wan 2.2?**
- FusioniX is only compatible with Wan 2.1
- For Wan 2.2, use Lightning accelerator profiles instead

## Updating WanGP

After updating WanGP, you'll need to re-apply the patches:

```bash
cd WanGP
git checkout wgp.py models/wan/any2video.py models/wan/modules/model.py
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
