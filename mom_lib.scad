// --- MANSIONS OF MADNESS: GEOMETRY LIBRARY ---
include <mom_config.scad>

// Asset Resolver
function get_icon_file(set_name) = 
    let(path = "svgs/")
    (search("Core", set_name)[0] != undef)      ? str(path, "base.svg") : 
    (search("Arkham", set_name)[0] != undef)    ? str(path, "streets_of_arkham.svg") : 
    (search("Threshold", set_name)[0] != undef) ? str(path, "beyond_the_threshold.svg") : 
    (search("Twilight", set_name)[0] != undef)  ? str(path, "sanctum_of_twilight.svg") : 
    (search("Journeys", set_name)[0] != undef)  ? str(path, "horrific_jouneys.svg") : 
    (search("Serpent", set_name)[0] != undef)   ? str(path, "path_of_the_serpent.svg") :
    (search("Recurring", set_name)[0] != undef) ? str(path, "call_of_the_wild.svg") : 
    str(path, "base.svg");

// Raised Label Unit
module tile_unit_raised(id, tile_db, x_pos, t_size, font) {
    row_data = tile_db[id];
    if (row_data != undef) {
        set_name  = row_data[2];
        room_name = row_data[3]; 
        icon_path = get_icon_file(set_name);

        translate([x_pos, 0, 0]) {
            if (icon_path != "") {
                linear_extrude(height = RAISED_HEIGHT)
                    scale([SVG_SCALE, SVG_SCALE, 1]) import(icon_path, center=true);
            }
            translate([8, 0, 0]) 
                color("black") 
                    linear_extrude(height = RAISED_HEIGHT)
                        text(room_name, size=t_size, font=font, halign="left", valign="center");
        }
    }
}

// Raised Spine Engine
module industrial_spine_label_raised(ids, tile_db, t_size, font) {
    margin = 12;
    spacing = (len(ids) == 3) ? LANE_W : (len(ids) == 2) ? 135 : 0;
    
    // Positioned on the outside face (Y = -5)
    translate([margin, -5, BEZEL_HEIGHT / 2]) rotate([90, 0, 0]) {
        for (i = [0 : len(ids)-1]) tile_unit_raised(ids[i], tile_db, i * spacing, t_size, font);
    }
}

// Structural Factory
module base_structure(type) {
    union() {
        cube([TOTAL_W, TRAY_DEPTH, FLOOR_T]);
        // Side Lips
        cube([WALL_T, TRAY_DEPTH, TILE_THICKNESS + 1]); 
        translate([TOTAL_W - WALL_T, 0, 0]) cube([WALL_T, TRAY_DEPTH, TILE_THICKNESS + 1]); 
        // Back Wall
        translate([0, TRAY_DEPTH - WALL_T, 0]) cube([TOTAL_W, WALL_T, TILE_THICKNESS + 1]); 
        // --- CHISELED BONE FRONT BEZEL ---
        translate([0, -5, 0]) {
            difference() {
                // The Base Material
                cube([TOTAL_W, 5, BEZEL_HEIGHT]); 
                
                // The "Chisel Marks" (Subtracting random notches)
                seed = 42; 
                for (x = [0 : 8 : TOTAL_W]) {
                    // Top Edge Notches
                    translate([x + rands(-2,2,1,seed+x)[0], 5, BEZEL_HEIGHT])
                        rotate([rands(30,60,1,seed+x)[0], 0, rands(-10,10,1,seed+x)[0]])
                            cube([10, 4, 4], center=true);
                            
                    // Front Face Faceting
                    translate([x + rands(-4,4,1,seed+x*2)[0], 0, BEZEL_HEIGHT/2 + rands(-1,1,1,seed+x)[0]])
                        rotate([0, rands(-20,20,1,seed+x*3)[0], 0])
                            cube([6, 1.5, BEZEL_HEIGHT + 2], center=true);
                }
            }
        }

        // Internal Dividers
        if (type == 3) {
            for(i=[1:2]) translate([i * LANE_W - WALL_T/2, 0, 0]) cube([WALL_T, TRAY_DEPTH, TILE_THICKNESS]);
        } else if (type == 2) {
            translate([135 - WALL_T/2, 0, 0]) cube([WALL_T, TRAY_DEPTH, TILE_THICKNESS]);
        }
    }
}

module finger_pull_subtraction(type) {
    if (type == 3) {
        for(i=[0:2]) translate([45 + (i * LANE_W), FINGER_Y, -5]) cylinder(r=FINGER_R, h=30);
    } else if (type == 2) {
        for(i=[0:1]) translate([67.5 + (i * 135), FINGER_Y, -5]) cylinder(r=FINGER_R, h=30);
    } else {
        translate([TOTAL_W/2, FINGER_Y, -5]) cylinder(r=FINGER_R, h=30);
    }
}