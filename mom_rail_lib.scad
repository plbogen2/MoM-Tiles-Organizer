// --- MANSIONS OF MADNESS: SERVER-RACK RAIL LIBRARY ---
include <mom_config.scad>

SCREW_D = 3.2; // For M3 screws
RAIL_T = 1.4; // Thickness of the rail ledge
POST_W = 10.0; // Width of the vertical posts
WEB_T = 1.6; // Thickness of the side wall

// Derived
TOTAL_H = (NUM_TRAYS * SLOT_PITCH);

// --- THE TWO MIRRORED SIDE DESIGNS ---
// Origin (x=0) is the INNER FACE (Tray Entry).
module side_left() {
  master_pillar_side();
}

module side_right() {
  mirror([1, 0, 0]) master_pillar_side();
}

// --- INTERNAL MASTER MODULE ---
module master_pillar_side() {
  // Designed as the LEFT side: 
  // Inner Face at x=0. Post sits at -10 to 0. Rails sit at 0 to 5.
  // Web sits at -WEB_T to 0 (Flush with rails but outside the tray path).
  difference() {
    union() {
      // 1. Structural Posts
      translate([-POST_W, 0, 0]) {
        cube([POST_W, POST_W, TOTAL_H]);
        translate([0, TRAY_DEPTH - POST_W, 0])
          cube([POST_W, POST_W, TOTAL_H]);
      }

      // 2. Honeycomb Web (Flush with rails at x=0, but behind them)
      translate([-WEB_T, 0, 0])
      union() {
        difference() {
          cube([WEB_T, TRAY_DEPTH, TOTAL_H]);
          // Mesh Cutouts
          hex_size = 19.5;
          v_step = 3 * SLOT_PITCH;
          spacing = v_step / 0.866;
          margin_z = SLOT_PITCH;

          for (z = [margin_z + (v_step / 2):v_step:TOTAL_H - margin_z]) {
            row_idx = round((z - (margin_z + v_step / 2)) / v_step);
            for (y = [POST_W:spacing:TRAY_DEPTH - POST_W]) {
              y_offset = (row_idx % 2 == 0) ? spacing / 2 : 0;
              translate([-1, y + y_offset, z])
                rotate([0, 90, 0]) cylinder(h=WEB_T + 2, d=hex_size, $fn=6);
            }
          }
        }

        // 3. Reinforcement Bands (behind rails)
        for (i = [0:NUM_TRAYS - 1]) {
          band_h = 3.0;
          z_pos = (i * SLOT_PITCH) + (RAIL_T / 2) - (band_h / 2);
          translate([0, 0, z_pos])
            cube([WEB_T, TRAY_DEPTH, band_h]);
        }
      }

      // 4. The Rails (Pointed Inward)
      for (i = [0:NUM_TRAYS - 1]) {
        z_pos = (i * SLOT_PITCH);
        translate([0, 0, z_pos]) rail_geometry();
      }
    }

    // --- HARDWARE CUTOUTS ---
    translate([-POST_W, 0, 0]) {
      for (y_pos = [0, TRAY_DEPTH - POST_W]) {
        translate([0, y_pos, 0]) {
          for (z_off = [0, TOTAL_H - 12]) {
            translate([POST_W / 2, POST_W / 2, (z_off == 0) ? -1 : z_off])
              cylinder(d=SCREW_D, h=15, $fn=24);
            // Nut Pocket
            z_nut = (z_off == 0) ? (1 * SLOT_PITCH) + (RAIL_T / 2) - 1.2 : (21 * SLOT_PITCH) + (RAIL_T / 2) - 1.2;
            translate([-1, POST_W / 2 - 3, z_nut])
              cube([POST_W + 2, 6, 2.4]);
          }
        }
      }
      // Back Wall Mounting
      translate([0, TRAY_DEPTH - POST_W, 0]) {
        z_safe_1 = floor(NUM_TRAYS * 0.25) * SLOT_PITCH + (SLOT_PITCH / 2);
        z_safe_2 = floor(NUM_TRAYS * 0.75) * SLOT_PITCH + (SLOT_PITCH / 2);
        for (z_pos = [z_safe_1, z_safe_2]) {
          translate([POST_W / 2, POST_W + 1, z_pos])
            rotate([90, 0, 0]) cylinder(d=SCREW_D, h=POST_W + 2, $fn=24);
          translate([-1, POST_W / 2 - 1.3, z_pos - 2])
            cube([POST_W + 2, 2.6, 4]);
        }
      }
    }
  }
}

module rail_geometry() {
  cube([RAIL_SUPPORT_W, TRAY_DEPTH, RAIL_T]);
}
