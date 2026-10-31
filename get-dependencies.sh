#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm boost lua51 premake sdl2_mixer xerces-c

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini sdl2_image-mini

echo "Building Shadow of the Wyrm..."
echo "---------------------------------------------------------------"
REPO=https://github.com/prolog/shadow-of-the-wyrm
VERSION="$(git ls-remote "$REPO" HEAD | cut -c1-9)"
echo "$VERSION" > ~/version

git clone --depth 1 "$REPO" ./sotw-src

wget --retry-connrefused --tries=30 -O ./assets.zip \
	https://www.shadowofthewyrm.org/assets/ShadowOfTheWyrm-assets.zip
unzip -q ./assets.zip -d ./sotw-src
rm -f ./assets.zip

cd ./sotw-src
premake5 --lua_include=/usr/include/lua5.1 --lua_link=lua5.1 gmake
make -j"$(nproc)" config=release
