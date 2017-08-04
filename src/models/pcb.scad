width_servo     = 22.75;
width_space     = 10;

height_servo    = 12.50;
height_space    = 5;

width_pcb       = 2*width_servo + 2*width_space;
height_pcb      = height_servo + 2*height_space;

thickness       = 2.54;
target          = 4;
thickness_extra = target-thickness;


difference() {
  cube([width_pcb, height_pcb, thickness]);
  translate([width_space/2, width_servo/4, 0]) {
    cube([width_servo, height_servo, thickness]);
  }
  translate([width_pcb-width_servo-width_space/2, width_servo/4, 0]) {
    cube([width_servo, height_servo, thickness+thickness_extra]);
  }
  translate([width_pcb-width_servo-width_space/2-width_space/2, width_servo/4, thickness_extra]) {
    cube([width_servo+width_space, height_servo, target]);
  }
}
