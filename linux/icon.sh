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
cp -f youtube-player.desktop usr/share/applications/
cp -f youtube_player.png usr/share/icons/hicolor/512x512/apps/
convert youtube_player.png -resize 16x16 usr/share/icons/hicolor/16x16/apps/youtube_player.png
convert youtube_player.png -resize 22x22 usr/share/icons/hicolor/22x22/apps/youtube_player.png
convert youtube_player.png -resize 32x32 usr/share/icons/hicolor/32x32/apps/youtube_player.png
convert youtube_player.png -resize 64x64 usr/share/icons/hicolor/64x64/apps/youtube_player.png
convert youtube_player.png -resize 128x128 usr/share/icons/hicolor/128x128/apps/youtube_player.png
convert youtube_player.png -resize 192x192 usr/share/icons/hicolor/192x192/apps/youtube_player.png
convert youtube_player.png -resize 256x256 usr/share/icons/hicolor/256x256/apps/youtube_player.png
convert youtube_player.png -resize 512x512 usr/share/icons/hicolor/512x512/apps/youtube_player.png
convert youtube_player.png usr/share/icons/hicolor/scalable/apps/youtube_player.svg
convert youtube_player.png -resize 32x32 usr/share/pixmaps/youtube_player.xpm
