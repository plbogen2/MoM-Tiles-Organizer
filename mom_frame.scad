// --- MANSIONS OF MADNESS: HYBRID FRAME CONTROLLER ---
include <mom_config.scad>
include <mom_hybrid_lib.scad>

// --- PREVIEW SETTINGS ---
SHOW_PLYWOOD = true; 
RENDER_ONLY_ONE_LADDER = false; // Set to true to export a single STL

module assembly() {
    // 1. Vertical Ladders
    if (RENDER_ONLY_ONE_LADDER) {
        // For STL Export: Center T-Ladder
        ladder_pillar(is_end_piece = false);
    } else {
        // Left End
        ladder_pillar(is_end_piece = true, is_left = true);
        
        // Center Dividers (spaced at LANE_W)
        translate([LANE_W, 0, 0]) ladder_pillar(is_end_piece = false);
        translate([LANE_W * 2, 0, 0]) ladder_pillar(is_end_piece = false);
        
        // Right End
        translate([TOTAL_W - WALL_T, 0, 0]) 
            ladder_pillar(is_end_piece = true, is_left = false);

        // 2. Plywood Preview (Transparent Brown)
        if (SHOW_PLYWOOD) {
            total_h = (NUM_TRAYS * SLOT_PITCH) + (PLYWOOD_T * 2);
            color([0.6, 0.4, 0.2, 0.4]) {
                // Bottom Plate
                cube([TOTAL_W, TRAY_DEPTH, PLYWOOD_T]);
                // Top Plate
                translate([0, 0, total_h - PLYWOOD_T]) 
                    cube([TOTAL_W, TRAY_DEPTH, PLYWOOD_T]);
            }
        }
    }
}

assembly();

echo(str("Total Height: ", (NUM_TRAYS * SLOT_PITCH) + (PLYWOOD_T * 2), "mm"));