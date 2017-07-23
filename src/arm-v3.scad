use <../lib/3d-servo-model/model.scad>

$fn                    = 200;

pen_diameter           =  12;

bearing_outer_diameter =  12;
bearing_inner_diameter =   6;
bearing_height         =   4;

bevel                  =   8;

arm_length             =  50;
arm_height             =   4;
arm_width              =  10;

pen_length             =  20;

servo_distance         =  30;

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

module upper_arm() {
  base_arm();
  // bearing push-on knob
  translate([0, arm_length,0]) {
    cylinder(h=arm_height+bearing_height, d=bearing_inner_diameter);
  }
}

// lower_arm();

module middle_arm() {
  difference() {
    upper_arm();
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
    cylinder(h=bearing_height, d=bearing_outer_diameter);    
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

a = 20;
b = 60;

module demo() {
  // left arm
  translate([-servo_distance/2, 0, 0]) {
    servo(mounted=false);
    rotate([0, 0, a]) {
      translate([0,0, servo_top()]) {
        upper_arm();
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
    rotate([0, 0, -a]) {
      translate([0,0, servo_top()]) {
        upper_arm();
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
}

$vpr = [ 61.60, 0.00, 57.90 ];
$vpt = [ -2.40, 33.28, 59.84 ];
$vpd = 466;
demo();


// lower_arm();
// upper_arm();
// upper_arm2();
