# SVI (Stable Video Infinity) for WanGP

Generate **infinite-length videos** without drift or degradation. Supports Wan 2.1 and Wan 2.2.

## Installation

1. Copy `wan2gp-svi` folder into your WanGP directory
2. Run `install.bat`

## Usage

1. Select **Wan2.1** or **Wan2.2** > **Image2Video 14B**
2. Choose an SVI profile, click **Apply**
3. Add a **Start Image** (480x832 horizontal recommended)
4. Set **Number of frames** to **162+** (must exceed 81 for multi-clip)
5. Generate

SVI LoRAs auto-download on first use.

## Profiles

### Wan 2.1

| Profile | Steps | Best For |
|---------|-------|----------|
| SVI-Shot Infinite - 50 Steps | 50 | Best quality, stable scenes |
| SVI-2.0 Unified - 50 Steps | 50 | Best quality, dynamic scenes |
| SVI-Shot Infinite + FusioniX - Min 10 Steps | 10+ | Faster, stable scenes |
| SVI-2.0 Unified + FusioniX - Min 10 Steps | 10+ | Faster, dynamic scenes |
| SVI-Shot Infinite + LightX2V - Min 4 Steps | 4+ | Fastest, stable scenes |
| SVI-2.0 Unified + LightX2V - Min 4 Steps | 4+ | Fastest, dynamic scenes |

### Wan 2.2

| Profile | Steps | Best For |
|---------|-------|----------|
| SVI-Shot Infinite - 50 Steps | 50 | Best quality, stable scenes |
| SVI-2.0 Unified - 50 Steps | 50 | Best quality, dynamic scenes |
| SVI-Shot Infinite + Lightning - Min 4 Steps | 4+ | Fastest, stable scenes |
| SVI-2.0 Unified + Lightning - Min 4 Steps | 4+ | Fastest, dynamic scenes |

**Note**: Accelerator profiles show minimum steps. Increase steps in UI for better quality.

## Tips

- **SVI-Shot** (1 motion frame): Best for talking heads, static scenes
- **SVI-2.0 Unified** (5 motion frames): Best for action, camera movement
- **Aspect ratio**: Use 480x832 horizontal for best results
- **Prompts**: Use detailed prompts - weak prompts cause reference frame to dominate

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

When SVI is working, you'll see:
```
[SVI Mode] Enabled with motion_frames=1, ref_pad_num=-1
[SVI Mode] Clip 1/3 complete, chaining with 1 motion frame(s)
[SVI Mode] Window 2: Using new seed 123456789
[SVI Mode] Clip 2/3 complete, chaining with 1 motion frame(s)
```

## Manual Install

If `install.bat` fails:

```bash
cd WanGP
git apply wan2gp-svi/wgp.patch
git apply wan2gp-svi/any2video.patch
git apply wan2gp-svi/model.patch
copy "wan2gp-svi\profiles\*.json" "loras\wan_i2v\"
mkdir "profiles\wan_2_2"
copy "wan2gp-svi\profiles\wan_2_2\*.json" "profiles\wan_2_2\"
```

## Updating WanGP

After WanGP updates, re-apply patches:

```bash
cd WanGP
git checkout wgp.py models/wan/any2video.py models/wan/modules/model.py
git apply wan2gp-svi/wgp.patch
git apply wan2gp-svi/any2video.patch
git apply wan2gp-svi/model.patch
```

## Uninstall

```bash
cd WanGP
git checkout wgp.py models/wan/any2video.py models/wan/modules/model.py
```

## Credits

- [Stable Video Infinity](https://github.com/vita-epfl/Stable-Video-Infinity) by VITA@EPFL
- [WanGP](https://github.com/deepbeepmeep/Wan2GP) by DeepBeepMeep
- [SVI + LightX2V guidance](https://github.com/vita-epfl/Stable-Video-Infinity/tree/svi_wan22#12-10-2025-important-notes-on-using-lightx2v-with-svi) for accelerator LoRA settings
