// --- MANSIONS OF MADNESS: HARDWARE CONFIGURATION ---

// Mechanical Specs
TILE_THICKNESS  = 3.2; 
WALL_T          = 1.6;      
FLOOR_T         = 0.8;      
LANE_W          = 90; 
TOTAL_W         = 270;      // 3 Lanes @ 90mm
TRAY_DEPTH      = 137;      // Increased from 135 to accommodate the 2mm bezel

// Rack / Frame Specs
PLYWOOD_T       = 5.0;      // Top/Bottom plate thickness
BACK_PLYWOOD_T  = 3.0;      // Back wall thickness for standalone rigidity
SLOT_PITCH      = 7.5;      // High-density spacing (6mm bezel + 1.5mm clearance)
NUM_TRAYS       = 23;       // Two towers of 23 trays = 46 total trays (4 pillars total)
RAIL_SUPPORT_W  = 5.0;      // Width of the tray support ledge

// Aesthetic Specs
BEZEL_HEIGHT    = 6.0;      // Compact bezel for high-density storage
RAISED_HEIGHT   = 0.8;      // Thinned slightly for the smaller bezel
SVG_SCALE       = 0.075;
FINGER_R        = 13;       
FINGER_Y        = 15;       

// Resolution
$fn = 64;
$epsilon = 0.1;
epsilon = 0.1; // Compatibility for code not using $

