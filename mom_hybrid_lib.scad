// --- MANSIONS OF MADNESS: HYBRID RAIL LIBRARY ---
include <mom_config.scad>

module ladder_pillar(is_end_piece = false, is_left = true) {
    total_h = (NUM_TRAYS * SLOT_PITCH) + (PLYWOOD_T * 2);
    
    union() {
        // 1. The Vertical Spine
        color([0.3, 0.3, 0.3]) // Dark Grey Industrial
        difference() {
            cube([WALL_T, TRAY_DEPTH, total_h]);
            
            // Plywood Mounting Grooves (Top & Bottom)
            translate([-epsilon, -epsilon, 0]) 
                cube([WALL_T + 2, TRAY_DEPTH + 2, PLYWOOD_T]);
            translate([-epsilon, -epsilon, total_h - PLYWOOD_T]) 
                cube([WALL_T + 2, TRAY_DEPTH + 2, PLYWOOD_T]);
            
            // Truss-style weight reduction
            for(i=[0 : NUM_TRAYS - 1]) {
                z_center = PLYWOOD_T + (i * SLOT_PITCH) + (SLOT_PITCH/2);
                translate([-epsilon, TRAY_DEPTH/2, z_center])
                    rotate([0, 90, 0])
                        cylinder(h=WALL_T + 2, r=SLOT_PITCH/4, $fn=6);
            }
        }

        // 2. The Integrated Guide Rails
        color([0.5, 0.5, 0.5])
        for (i = [0 : NUM_TRAYS - 1]) {
            z_pos = PLYWOOD_T + (i * SLOT_PITCH);
            
            // Inner-facing rail (Right side of pillar)
            if (!is_end_piece || is_left) {
                translate([WALL_T - epsilon, 0, z_pos])
                    cube([RAIL_SUPPORT_W, TRAY_DEPTH, 1.2]);
            }
            
            // Inner-facing rail (Left side of pillar)
            if (!is_end_piece || !is_left) {
                translate([-RAIL_SUPPORT_W + epsilon, 0, z_pos])
                    cube([RAIL_SUPPORT_W, TRAY_DEPTH, 1.2]);
            }
        }
    }
}