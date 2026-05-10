// --- MANSIONS OF MADNESS: RACK ASSEMBLY CONTROLLER ---
include <mom_config.scad>
include <mom_rail_lib.scad>
include <mom_lib.scad>
include <mom_manifest.scad>
include <mom_tiles.scad>

/* [Preview Settings] */
// --- PREVIEW CONTROLS ---
font_choice     = "Special Elite:style=Regular";
text_size       = 2.2;
SHOW_PLYWOOD    = false;
SHOW_TRAYS      = true;
RENDER_MODE     = "assembly"; 

module assembly() {
    if (RENDER_MODE == "left_pillar") {
        side_left();
    } else if (RENDER_MODE == "right_pillar") {
        side_right();
    } else {
        // --- DUAL STANDALONE TOWERS (FINAL ALIGNMENT + 1mm CLEARANCE) ---
        for (tower_num = [0:1]) {
            translate([tower_num * (TOTAL_W + 70), 0, 0]) {
                // Left Panel (Industrial Blue)
                color("RoyalBlue") 
                    side_left();
                    
                // Right Panel (Structural Red)
                translate([TOTAL_W + 1, 0, 0]) 
                    color("Crimson") 
                        side_right();

                // --- PLYWOOD PREVIEW ---
                if ($preview && SHOW_PLYWOOD) {
                    total_rack_w = TOTAL_W + 21; // 291mm
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

                // Real Trays Preview
                if ($preview && SHOW_TRAYS) {
                    for(row=[0:NUM_TRAYS-1]) {
                        idx = row + (tower_num * 23);
                        data = tray_manifest[idx];
                        type = data[0];
                        tile_ids = data[1];
                        y_pull = (row % 10 == 0) ? 50 : 0; 
                        
                        // Centered tray
                        translate([0.5, -y_pull, row * SLOT_PITCH + RAIL_T]) {
                            color([0.8, 0.8, 0.8]) 
                                base_structure(type);
                            industrial_spine_label_raised(tile_ids, tiles, text_size, font_choice);
                        }
                    }
                }
            }
        }
    }
}

assembly();
