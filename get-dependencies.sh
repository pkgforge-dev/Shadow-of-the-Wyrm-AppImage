#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm boost gtest lua51 sdl2_mixer xerces-c

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini sdl2_image-mini

echo "Building Shadow of the Wyrm..."
echo "---------------------------------------------------------------"
REPO="https://github.com/prolog/shadow-of-the-wyrm"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --depth 1 "$REPO" ./sotw
echo "$VERSION" > ~/version

wget https://www.shadowofthewyrm.org/assets/ShadowOfTheWyrm-assets.zip

mkdir -p ./AppDir/bin
# Put the assets in the right folder
cp -R ../assets ./
sed -i 's/"boost_system",//g' ${srcdir}/shadow-of-the-wyrm/premake5.lua
premake5 --lua_include=/usr/include/lua5.1 --lua_link=lua5.1 gmake
make -j$(nproc) config=release
