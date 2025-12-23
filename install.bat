@echo off
echo ===================================
echo  SVI (Stable Video Infinity) Installer for WanGP
echo ===================================
echo.

cd /d "%~dp0"
cd ..

echo Applying patches...
git apply wan2gp-svi/wgp.patch
if errorlevel 1 (
    echo WARNING: wgp.patch may have failed - check manually
)

git apply wan2gp-svi/any2video.patch
if errorlevel 1 (
    echo WARNING: any2video.patch may have failed - check manually
)

git apply wan2gp-svi/model.patch
if errorlevel 1 (
    echo WARNING: model.patch may have failed - check manually
)

echo.
echo Copying Wan 2.1 profile files...
copy "wan2gp-svi\profiles\SVI-Shot Infinite - 50 Steps.json" "loras\wan_i2v\"
copy "wan2gp-svi\profiles\SVI-2.0 Unified - 50 Steps.json" "loras\wan_i2v\"
copy "wan2gp-svi\profiles\SVI-Shot Infinite + FusioniX - Min 10 Steps.json" "loras\wan_i2v\"
copy "wan2gp-svi\profiles\SVI-2.0 Unified + FusioniX - Min 10 Steps.json" "loras\wan_i2v\"
copy "wan2gp-svi\profiles\SVI-Shot Infinite + LightX2V - Min 4 Steps.json" "loras\wan_i2v\"
copy "wan2gp-svi\profiles\SVI-2.0 Unified + LightX2V - Min 4 Steps.json" "loras\wan_i2v\"

echo.
echo Copying Wan 2.2 profile files...
if not exist "profiles\wan_2_2" mkdir "profiles\wan_2_2"
copy "wan2gp-svi\profiles\wan_2_2\SVI-Shot Infinite - 50 Steps.json" "profiles\wan_2_2\"
copy "wan2gp-svi\profiles\wan_2_2\SVI-2.0 Unified - 50 Steps.json" "profiles\wan_2_2\"
copy "wan2gp-svi\profiles\wan_2_2\SVI-Shot Infinite + Lightning - Min 4 Steps.json" "profiles\wan_2_2\"
copy "wan2gp-svi\profiles\wan_2_2\SVI-2.0 Unified + Lightning - Min 4 Steps.json" "profiles\wan_2_2\"

echo.
echo ===================================
echo  Installation complete!
echo ===================================
echo.
echo To use SVI:
echo.
echo For Wan 2.1:
echo   1. Select Wan2.1 ^> Image2Video 14B
echo   2. Choose an SVI profile (e.g., "SVI-Shot Infinite - 50 Steps")
echo.
echo For Wan 2.2:
echo   1. Select Wan2.2 ^> Image2Video 14B
echo   2. Choose an SVI profile (e.g., "SVI-Shot Infinite - 50 Steps")
echo.
echo Then:
echo   - Add a Start Image (480x832 horizontal recommended)
echo   - Set frames to 162+ (longer than 81)
echo   - Generate!
echo.
echo The SVI LoRAs will auto-download on first use.
echo.
echo Available Profiles:
echo   Wan 2.1: 50-step, FusioniX (10-step), LightX2V (4-step)
echo   Wan 2.2: 50-step, Lightning (4-step)
echo.
echo For full documentation see: README.md
echo.
echo ===================================
echo.
echo You can now close this window and run: python wgp.py
echo.
pause
