$fn = 50;

module stift() {
  translate([0, 0, 10]) {  cylinder(150, d=7.5); }
  cylinder( 10, d2=7.5, d1=0);
}

module arm() {
  difference() {
    union() {
      cylinder(5, d=15);
      translate([-7.5, 0, 0]) { cube([15, 100, 5]); }
    }
    cylinder(5, d=10);
  }
}

module demo() {
  stift();
  color("red") { translate([0 , 0, 20]) { arm(); } }
  color("blue") { rotate([0,0,90]) { translate([0 , 0, 20+5]) { arm(); } } }
}

demo();
$vpr = [ 72.50, 0.00, 39.00 ];
$vpt = [ -9.52, 3.76, 33.00 ];

