// --- MANSIONS OF MADNESS: MASTER ASSEMBLY PREVIEW ---
include <mom_config.scad>
include <mom_lib.scad>
include <mom_rail_lib.scad>
include <mom_manifest.scad>
include <mom_tiles.scad>

// --- PREVIEW CONTROLS ---
SHOW_PLYWOOD = false;
SHOW_TRAYS = true;
font_choice = "Special Elite:style=Regular";
text_size = 2.2;

// --- DUAL STANDALONE TOWERS ---
for (tower_num = [0:1]) {
  translate([tower_num * (TOTAL_W + 70), 0, 0]) {
    // 1. LEFT PANEL (Void Black / Cold Iron)
    color([0.1, 0.1, 0.1]) 
        side_left();
    
    // 2. RIGHT PANEL (Void Black / Cold Iron)
    translate([TOTAL_W + 1, 0, 0]) 
        color([0.1, 0.1, 0.1]) 
            side_right();

    // --- PLYWOOD PREVIEW ---
    if ($preview && SHOW_PLYWOOD) {
      total_rack_w = TOTAL_W + 21; 
      color([0.6, 0.4, 0.2, 0.4]) {
        // Bottom
        translate([-10, 0, -PLYWOOD_T])
          cube([total_rack_w, TRAY_DEPTH, PLYWOOD_T]);
        // Top
        translate([-10, 0, TOTAL_H])
          cube([total_rack_w, TRAY_DEPTH, PLYWOOD_T]);
        // Back Wall
        translate([-10, TRAY_DEPTH, -PLYWOOD_T])
          cube([total_rack_w, BACK_PLYWOOD_T, TOTAL_H + PLYWOOD_T * 2]);
      }
    }

    // --- REAL TRAY PREVIEW ---
    if (SHOW_TRAYS) {
      for (row = [0:NUM_TRAYS - 1]) {
        idx = row + (tower_num * 23);
        data = tray_manifest[idx];
        type = data[0];
        tile_ids = data[1];
        y_pull = (row % 10 == 0) ? 50 : 0; 
        
        // Tray (270mm) centered in 271mm gap
        translate([0.5, -y_pull, row * SLOT_PITCH + RAIL_T]) {
          color([0.9, 0.85, 0.7]) base_structure(type);
          industrial_spine_label_raised(tile_ids, tiles, text_size, font_choice);
        }
      }
    }
  }
}
