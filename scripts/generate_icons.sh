#!/bin/bash

function announce {
    # Announces a command before running it
    echo ">>> $*"
    "$@"
}

# Convert all svg to png
for svg_file in assets/icon/*.svg; do
  png_file="${svg_file%.svg}.png"
  announce rsvg-convert -o "$png_file" "$svg_file"
done
echo

# Generate launcher icons
# Since this is resizing an already rasterized image, we properly rasterize later on.
announce dart run icons_launcher:create
echo

# Resize for flatpak
function resize_for_flatpak {
    local size=$1
    announce rsvg-convert -w "$size" -h "$size" -o "assets/icon/resized/icon-${size}x${size}.png" assets/icon/icon.svg
}
resize_for_flatpak 16
resize_for_flatpak 24
resize_for_flatpak 32
resize_for_flatpak 48
resize_for_flatpak 64
resize_for_flatpak 114
resize_for_flatpak 128
resize_for_flatpak 256
resize_for_flatpak 512
echo

announce rsvg-convert -w 512 -h 512 -o android/app/src/main/ic_launcher-playstore.png assets/icon/icon.svg
function resize_for_android_mipmap {
    local size=$1
    local adaptiveSize=$2
    local sizeName=$3
    announce rsvg-convert -w "$size" -h "$size" -o "android/app/src/main/res/mipmap-$sizeName/ic_launcher.png" assets/icon/icon.svg
    announce rsvg-convert -w "$adaptiveSize" -h "$adaptiveSize" -o "android/app/src/main/res/mipmap-$sizeName/ic_launcher_foreground.png" assets/icon/icon_adaptive.svg
}
resize_for_android_mipmap 48 108 mdpi
resize_for_android_mipmap 72 162 hdpi
resize_for_android_mipmap 96 216 xhdpi
resize_for_android_mipmap 144 324 xxhdpi
resize_for_android_mipmap 192 432 xxxhdpi
echo

function resize_for_ios() {
  local size=$1
  local sizeName=$2
  announce rsvg-convert -w "$size" -h "$size" -o "ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-${sizeName}.png" assets/icon/icon_ios.svg
}
resize_for_ios 20 20x20@1x
resize_for_ios 40 20x20@2x
resize_for_ios 60 20x20@3x
resize_for_ios 29 29x29@1x
resize_for_ios 58 29x29@2x
resize_for_ios 87 29x29@3x
resize_for_ios 76 38x38@2x
resize_for_ios 114 38x38@3x
resize_for_ios 40 40x40@1x
resize_for_ios 80 40x40@2x
resize_for_ios 120 40x40@3x
resize_for_ios 120 60x60@2x
resize_for_ios 180 60x60@3x
resize_for_ios 128 64x64@2x
resize_for_ios 192 64x64@3x
resize_for_ios 136 68x68@2x
resize_for_ios 76 76x76@1x
resize_for_ios 152 76x76@2x
resize_for_ios 167 83.5x83.5@2x
resize_for_ios 1024 1024x1024@1x
echo

announce rsvg-convert -w 256 -h 256 -o snap/gui/app_icon.png assets/icon/icon.svg
announce rsvg-convert -w 32 -h 32 -o web/favicon.png assets/icon/icon.svg
announce rsvg-convert -w 192 -h 192 -o web/icons/Icon-192.png assets/icon/icon.svg
announce rsvg-convert -w 512 -h 512 -o web/icons/Icon-512.png assets/icon/icon.svg
announce rsvg-convert -w 256 -h 256 -o windows/runner/resources/app_icon.ico assets/icon/icon.svg
echo

echo "All done!"