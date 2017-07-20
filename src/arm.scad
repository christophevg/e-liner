use <../lib/3d-servo-model/model.scad>

$fn                    = 200;

pen_diameter           =  12;

arm_length             =  50;

bearing_outer_diameter =  12;
bearing_inner_diameter =   6;
bearing_height         =   4;

bevel                  =   8;

module lower_arm(inner_diameter = bearing_inner_diameter,
                 outer_diameter = bearing_outer_diameter + bevel,
                 length         = 50,
                 height         = bearing_height,
                 joint_height   = bearing_height)
{
  cylinder(h=height, d=outer_diameter);
  cylinder(h=height+joint_height, d=inner_diameter);
  translate([-outer_diameter/4,0,0]) { cube([outer_diameter/2, length, height]); }
}

module base_upper_arm(inner_diameter = bearing_outer_diameter,
                      outer_diameter = bearing_outer_diameter + bevel,
                      length         = 50,
                      width          = (bearing_outer_diameter + bevel)/2,
                      height         = bearing_height)
{
  difference() {
    union() {
      // arm
      translate([-width/2,0,0]) { cube([width, length, height]); }
      // bearing holder (full)
      cylinder(h=height, d=outer_diameter);
    }
    // hole for bearing
    cylinder(h=height, d=inner_diameter);
  }
}

// base_upper_arm();

module upper_arm1(inner_diameter = bearing_outer_diameter,
                  outer_diameter = bearing_outer_diameter + bevel,
                  length         = arm_length,
                  width          = (bearing_outer_diameter + bevel)/2,
                  height         = bearing_height)
{
  difference() {
    union() {
      base_upper_arm(inner_diameter, outer_diameter, length, width, height);
      // heigher part of arm for raised upper part of pen holder
      translate([-width/2,length-outer_diameter/2-bevel/2,0]) {
        cube([width, bevel, height*1.5]);
      }
      // pen holder (full)
      translate([0, length, 0])      { cylinder(h=height*1.5, d=outer_diameter); }
    }
    // vertical hole for pen
    translate([0, length, 0])        { cylinder(h=height*1.5, d=pen_diameter); }
    // horizontal space for other arm
    translate([0, length, height/2]) { cylinder(h=height/2, d=outer_diameter); }
  }
}

// upper_arm1();

spacing = 0.2;

module upper_arm2(inner_diameter = bearing_outer_diameter,
                  outer_diameter = bearing_outer_diameter + bevel,
                  length         = arm_length,
                  width          = (bearing_outer_diameter + bevel)/2,  
                  height         = bearing_height)
{
  difference() {
    union() {
      base_upper_arm(inner_diameter, outer_diameter, length, width, height);
      // pen holder (full)
      translate([0, length, 0]) { cylinder(h=height, d=outer_diameter); }
    }
    // vertical hole for pen
    translate([0, length, 0]) { cylinder(h=height, d=pen_diameter+spacing); }
    // horizontal space for other arm
    translate([0, length, 0]) { cylinder(h=height/2+spacing, d=outer_diameter);}
  }
}

// upper_arm2();

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

servo_distance = 30;

module servo1() {
  translate([-servo_distance/2, 0, 0]) { servo(mounted=false); }
}

module servo2() {
  translate([ servo_distance/2, 0, 0]) { servo(mounted=false); }
}

module demo() {
  servo1();
  servo2();

  translate([0,65,33]) {
    rotate([0,0,180]) {
      rotate([0,0,35]) {
        translate([arm_length,0,0]) {
          translate([ 0, 0, bearing_height]) { rotate([0,0,90])  { upper_arm1(); } }
          translate([ 0, 0, bearing_height]) {      color("red") { bearing();    } }
          translate([ 0, 0, 0]) {                                  lower_arm();    }
        }
      }
      rotate([0,0,-35]) {
        translate([-arm_length, 0, 0]) {
          translate([ 0, 0, bearing_height]) { rotate([0,0,-90]) { upper_arm2(); } }
          translate([ 0, 0, bearing_height]) {      color("red") { bearing();    } }
          translate([ 0, 0, 0]) {                                  lower_arm();    }
        }
      }
      translate([0,0,-33]) {
        color("blue") { pen(); }
      }
    }
  }
}

demo();

module demo_bearing_joint() {
  translate([0, 0, bearing_height*5]) { rotate([0,0,135]) { upper_arm2(); }}
  translate([0 ,0, bearing_height*3]) {  color("red") { bearing(); } }
  lower_arm();
}

// demo_bearing_joint();

// lower_arm();
// upper_arm();
// upper_arm2();
