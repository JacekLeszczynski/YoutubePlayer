#!/bin/sh

DESKNAME="youtube-player"
APPNAME="studio_jahu"
ICONNAME="$APPNAME.png"

mkdir -p usr/share/applications/
mkdir -p usr/share/icons/hicolor/512x512/apps/
mkdir -p usr/share/icons/hicolor/16x16/apps/
mkdir -p usr/share/icons/hicolor/22x22/apps/
mkdir -p usr/share/icons/hicolor/32x32/apps/
mkdir -p usr/share/icons/hicolor/64x64/apps/
mkdir -p usr/share/icons/hicolor/128x128/apps/
mkdir -p usr/share/icons/hicolor/192x192/apps/
mkdir -p usr/share/icons/hicolor/256x256/apps/
mkdir -p usr/share/icons/hicolor/512x512/apps/
mkdir -p usr/share/icons/hicolor/scalable/apps/
mkdir -p usr/share/pixmaps/
cp -f *.desktop usr/share/applications/
convert $ICONNAME -resize 16x16 usr/share/icons/hicolor/16x16/apps/$APPNAME.png
convert $ICONNAME -resize 22x22 usr/share/icons/hicolor/22x22/apps/$APPNAME.png
convert $ICONNAME -resize 32x32 usr/share/icons/hicolor/32x32/apps/$APPNAME.png
convert $ICONNAME -resize 64x64 usr/share/icons/hicolor/64x64/apps/$APPNAME.png
convert $ICONNAME -resize 128x128 usr/share/icons/hicolor/128x128/apps/$APPNAME.png
convert $ICONNAME -resize 192x192 usr/share/icons/hicolor/192x192/apps/$APPNAME.png
convert $ICONNAME -resize 256x256 usr/share/icons/hicolor/256x256/apps/$APPNAME.png
convert $ICONNAME -resize 512x512 usr/share/icons/hicolor/512x512/apps/$APPNAME.png
convert $ICONNAME -resize 128x128 usr/share/icons/hicolor/scalable/apps/$APPNAME.png
convert $ICONNAME -resize 48x48 usr/share/pixmaps/$APPNAME.xpm
