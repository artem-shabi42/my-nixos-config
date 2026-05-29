{ pkgs }:

pkgs.runCommand "minecraft-crosshair-cursor-theme" {
  nativeBuildInputs = [
    pkgs.imagemagick
    pkgs.xcursorgen
  ];
} ''
  theme_dir="$out/share/icons/MinecraftCrosshair"
  cursor_dir="$theme_dir/cursors"
  mkdir -p "$cursor_dir"

  magick -size 32x32 xc:none \
    -fill '#f2f2f280' \
    -draw 'rectangle 15,7 16,13' \
    -draw 'rectangle 15,18 16,24' \
    -draw 'rectangle 7,15 13,16' \
    -draw 'rectangle 18,15 24,16' \
    -fill '#20202080' \
    -draw 'rectangle 15,14 16,14' \
    -draw 'rectangle 15,17 16,17' \
    -draw 'rectangle 14,15 14,16' \
    -draw 'rectangle 17,15 17,16' \
    crosshair.png

  cat > cursor.cfg <<EOF
32 16 16 crosshair.png
EOF
  xcursorgen cursor.cfg "$cursor_dir/left_ptr"

  for cursor in \
    arrow default pointer hand1 hand2 cross crosshair center_ptr \
    left_ptr_watch watch wait progress move fleur grabbing grab \
    dnd-none dnd-copy dnd-move not-allowed no-drop \
    sb_h_double_arrow sb_v_double_arrow h_double_arrow v_double_arrow \
    top_left_corner top_right_corner bottom_left_corner bottom_right_corner \
    xterm text; do
    ln -s left_ptr "$cursor_dir/$cursor"
  done

  cat > "$theme_dir/index.theme" <<EOF
[Icon Theme]
Name=MinecraftCrosshair
Comment=Minecraft-style crosshair cursor theme
Inherits=Adwaita
EOF
''
