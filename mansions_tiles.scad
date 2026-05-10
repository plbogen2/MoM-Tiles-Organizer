// --- MANSIONS OF MADNESS: MASTER CONTROLLER ---
include <mom_config.scad>
include <mom_tiles.scad>
include <mom_manifest.scad>
include <mom_lib.scad>

// --- USER CONTROL ---
tray_index = 40;
font_choice = "Impact:style=Regular";
text_size = 2.2; // Reduced for the high-density 6mm bezel

// --- DATA ---
current_data = tray_manifest[tray_index];
tray_type = current_data[0];
tile_ids = current_data[1];

// --- RENDER ---
union() {
  // 1. Subtract pulls from the base structure
  difference() {
    base_structure(tray_type);
    finger_pull_subtraction(tray_type);
  }

  // 2. Add the RAISED labels and icons
  industrial_spine_label_raised(tile_ids, tiles, text_size, font_choice);
}

echo(str("TRAY RENDER: ", tray_index, " | BEZEL HEIGHT: ", BEZEL_HEIGHT));
