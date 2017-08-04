use <../lib/3d-servo-model/model.scad>

$fn                    = 200;

pen_diameter           =  12;

bearing_outer_diameter =  12;
bearing_inner_diameter =   6;
bearing_height         =   4;

bearing2_outer_diameter = 11;
bearing2_inner_diameter =  5;
bearing2_height         =  4;

bevel                  =   8;

arm_length             =  50;
arm_height             =   4;
arm_width              =  10;

pen_length             =  20;

servo_distance         =  30;

badge_width            =  80;
badge_length           =  80;

module base_arm(diameter = bearing_outer_diameter + bevel,
                width    = arm_width,
                length   = arm_length,
                height   = arm_height)
{
  // arm "head"
  cylinder(h=height, d=diameter);
  // arm
  translate([-width/2,0,0]) { cube([width, length, height]); }
  // arm "head"
  translate([0, length, 0]) {
    cylinder(h=height, d=diameter);
  }
}

// base_arm();

servo_hole_diameter = 7;

module servo_arm(diameter      = bearing_inner_diameter,
                 height        = arm_height,
                 hole_diameter = servo_hole_diameter )
{
  difference() {
    base_arm();
    cylinder(height, d=hole_diameter);
    translate([-5.2/2, 0, height-1]) {
      cube([5.2, 17, 1]);
    }    
  }
  // bearing push-on knob
  translate([0, arm_length,0]) {
    cylinder(h=arm_height+bearing_height, d=diameter);
  }
}

// servo_arm();

module middle_arm() {
  difference() {
    servo_arm();
    // hole for bearing
    cylinder(h=bearing_height, d=bearing_outer_diameter);
  }
}

// middle_arm();

module lower_arm() {
  difference() {
    union() {
      base_arm();
      translate([0, -arm_length, 0]) { base_arm(); }
    }
    // hole for bearing 1
    cylinder(h=bearing2_height, d=bearing2_outer_diameter);    
    // hole for bearing 2
    translate([0,arm_length,0]) {
      cylinder(h=bearing_height, d=bearing_outer_diameter);
    }
    // hole for pen
    translate([0,-arm_length,0]) {
      cylinder(h=bearing_height, d=pen_diameter);
    }    
  }
}

// lower_arm();

module bearing(inner_diameter=bearing_inner_diameter,
               outer_diameter=bearing_outer_diameter,
               height=bearing_height)
{
  difference() {
    cylinder(h=height, d=outer_diameter);
    cylinder(h=height, d=inner_diameter);
  }
}

module pen() {
  translate([0, 0, 10]) {  cylinder(75, d=pen_diameter); }
  cylinder( 10, d2=pen_diameter, d1=0);  
}

module pcb(width=badge_width, length=badge_length, height=1.52) {
  difference() {
    translate([-width/2, -length/2-25, 0]) { cube([width, length, height]); }
    translate([-servo_distance/2, 0, -10]) {
      servo(mounted=false);
    }
    translate([ servo_distance/2, 0, -10]) {
      servo(mounted=false);
    }
  }
}

// pcb();

// TODO: bereken hoeken op basis van x,y doelpunt van stift
a1 =  20;
a2 = -20;

b = 60;

module demo() {
  // left arm
  translate([-servo_distance/2, 0, 0]) {
    servo(mounted=false);
    rotate([0, 0, a1]) {
      translate([0,0, servo_top()]) {
        servo_arm();
        translate([0, arm_length, bearing_height]) {
          color("red") { bearing(); }
          rotate([0,0,-b]) { middle_arm(); }
        }
      }
    }
  }
  // right arm
  translate([servo_distance/2, 0, bearing_height]) {
    servo(mounted=false);
    rotate([0, 0, a2]) {
      translate([0,0, servo_top()]) {
        servo_arm();
        translate([0, arm_length, bearing_height]) {
          color("red") { bearing(); }
          rotate([0,0,b]) {
            translate([0, arm_length, 0]) {
              color("red") { bearing(); }
            }
            lower_arm();
            translate([0, -arm_length, -servo_top()]) { color("blue") { pen(); } }
          }
        }
      }
    }
  }
  translate([0, 0, servo_wing_top()]) {
    color("white") { pcb(); }
  }
  translate([0, -40, 12]) {
    rotate([0, 90, 90]) {
      color("red") { servo(); }
    }
  }
}

// $vpr = [ 61.60, 0.00, 57.90 ];
// $vpt = [ -2.40, 33.28, 59.84 ];
// $vpd = 466;
// demo();

module plate() {
  d = bearing_outer_diameter + bevel + 2;
  translate([0, -arm_length/2,0]) {
    translate([-d*2, 0, 0]) { middle_arm(); }
    translate([-d,   0, 0]) { servo_arm(); }
    translate([ 0,   0, 0]) { servo_arm(bearing2_inner_diameter); }
  }
  translate([ d-5,   0, 0]) { lower_arm(); }
}

// plate();

// middle_arm();
// servo_arm();
// lower_arm();
servo_arm(bearing2_inner_diameter);