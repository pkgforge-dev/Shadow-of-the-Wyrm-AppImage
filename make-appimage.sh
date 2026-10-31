#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DEPLOY_OPENGL=1

mkdir -p ./AppDir/bin
cp -r ./sotw-src/sotw/. ./AppDir/bin

quick-sharun ./AppDir/bin/sotw

quick-sharun --make-appimage

quick-sharun --test ./dist/*.AppImage
