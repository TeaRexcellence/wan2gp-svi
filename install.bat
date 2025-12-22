@echo off
echo ===================================
echo  SVI (Stable Video Infinity) Installer for WanGP
echo ===================================
echo.

cd /d "%~dp0"
cd ..

echo Applying patches...
git apply SVI_PLUGIN/wgp.patch
if errorlevel 1 (
    echo WARNING: wgp.patch may have failed - check manually
)

git apply SVI_PLUGIN/any2video.patch
if errorlevel 1 (
    echo WARNING: any2video.patch may have failed - check manually
)

git apply SVI_PLUGIN/model.patch
if errorlevel 1 (
    echo WARNING: model.patch may have failed - check manually
)

echo.
echo Copying profile files...
copy "SVI_PLUGIN\profiles\SVI-Shot Infinite - 50 Steps.json" "loras\wan_i2v\"
copy "SVI_PLUGIN\profiles\SVI-2.0 Unified - 50 Steps.json" "loras\wan_i2v\"

echo.
echo ===================================
echo  Installation complete!
echo ===================================
echo.
echo To use SVI:
echo 1. Launch WanGP (python wgp.py)
echo 2. Select Wan2.1 ^> Image2Video 14B
echo 3. Choose "SVI-Shot Infinite - 50 Steps" profile
echo 4. Add a Start Image
echo 5. Set frames to 162+ (longer than 81)
echo 6. Generate!
echo.
echo The SVI LoRA will auto-download on first use.
echo.
pause
