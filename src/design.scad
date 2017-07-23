use <../lib/3d-servo-model/model.scad>

// where to position the pen (circular movement in animation)
function position(t) = [ sin(t*360) * 30 + 60, cos(t*360) * 30 + 60 ];

x = position($t)[0];
y = position($t)[1];

servo_distance = 20;

// configuration of the robot
arm_length = 100;
arm_width  = 15;
arm_height = 5;

pen_max_width = 10;

screw = 3;

function a(x0) =
  let( a = atan(y / (x-x0)) )
  (x < x0 || y < 0) ? a+180 : a ;

function b(x0) = 
  acos(sqrt( pow(x-x0,2) + pow(y,2) )/2/arm_length);

$fn = 50;

function h1() = a(-servo_distance/2) + b(-servo_distance/2);
function h2() = a( servo_distance/2) - b( servo_distance/2);

module fore_arm() {
  rotate([0, 0, -90]) {
    difference() {
      union() {
        cylinder(arm_height, d=arm_width);
        translate([-arm_width/2, 0, 0]) {
          cube([arm_width, arm_length, arm_height]);
        }
        translate([0, arm_length, 0 ]) { cylinder(arm_height, d=arm_width); }
      }
      // hinge
      cylinder(arm_height, d=screw);
      // pen holder
      translate([0, arm_length, 0]) { cylinder(arm_height, d=pen_max_width); }
    }
  }
}

module upper_arm() {
  rotate([0, 0, -90]) {
    difference() {
      union() {
        cylinder(arm_height, d=arm_width);
        translate([-arm_width/2, 0, 0]) {
          cube([arm_width, arm_length, arm_height]);
        }
        translate([0, arm_length, 0 ]) { cylinder(arm_height, d=arm_width); }
      }
      // hinge
      cylinder(arm_height, d=screw);
    }
  }
}

module servo1() {
  translate([-servo_distance/2, 0, arm_height]) { servo(mounted=false); }
}

module servo2() {
  translate([ servo_distance/2, 0, 0]) { servo(mounted=false); }
}

module pen() {
  translate([x, y, 0]) {
    translate([0, 0, 10]) {  cylinder(150, d=7.5); }
    cylinder( 10, d2=7.5, d1=0);  
  }
}

module arm1() {
  translate([0, 0, arm_height]) {
    translate([-servo_distance/2, 0, servo_top()]) { rotate([0, 0, h1()]) { upper_arm(); } }
    x1 = cos( h1() ) * arm_length - (servo_distance / 2);
    y1 = sin( h1() ) * arm_length;
    r1b = atan((y-y1)/(x-x1));
    r1 = x < x1 ? r1b + 180 : r1b;
    translate([ x1, y1, servo_top() + arm_height ]) {
      rotate([0 ,0, r1]) { fore_arm(); }
    }
  }
}

module arm2() {
  translate([ servo_distance/2, 0, servo_top()]) { rotate([0, 0, h2()]) { upper_arm(); } }
  x2 = cos( h2() ) * arm_length + (servo_distance / 2);
  y2 = sin( h2() ) * arm_length;
  r2b = atan((y-y2)/(x-x2));
  r2 = x < x2 ? r2b + 180 : r2b;
  translate([x2, y2, servo_top() + arm_height ]) {
    rotate([0 ,0, r2]) { fore_arm(); }
  }
}

module demo() {
  servo1();
  servo2();

  pen();
  
  color("red")  { arm1(); }
  color("blue") { arm2(); }
}

demo();
// $vpr = [ 84.00, 0.00, 55.30 ];
// $vpt = [ 59.76, 18.02, 87.97 ];
// $vpd = 600;
