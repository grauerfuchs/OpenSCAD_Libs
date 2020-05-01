/*
  Universal Joint library 1.0 (2020-05-01) for OpenSCAD
  Author: @grauerfuchs
  Licensed under CC BY-SA https://creativecommons.org/use-remix/cc-licenses/#by-sa  
*/
 
 
$fn=36;

function universalJoint_calculateGeometry(screw_d, thread_d, wall = 2, tolerance = 0.3) = [
  screw_d,                                                          //  0 - Screw diameter
  thread_d,                                                         //  1 - Threading diameter
  wall,                                                             //  2 - Wall width
  tolerance,                                                        //  3 - Spacing tolerance
  (screw_d * 3),                                                    //  4 - Ball/wafer diameter
  (screw_d * 3) + (tolerance * 2),                                  //  5 - Inner clearance XY, Outer Y
  (screw_d * 3) + (tolerance * 2) + (wall * 2),                     //  6 - Outer X
  (screw_d * 1.5) + (tolerance * 4) + (wall * 2),                   //  7 - Inner clearance Z Screw to inner Base
  (screw_d * 1.5) + (tolerance * 4) + (wall * 4),                   //  8 - Self-Reference: Screw to Base distance
  (screw_d * 3) + (tolerance * 4) + (wall * 4),                     //  9 - Outer Z (full height)
];


demoGeo = universalJoint_calculateGeometry(3, 2.5, 3);

universalJoint_RodTipWithCapturedBall(demoGeo, 5, 20, 9);
rotate([90, 180, 90]) universalJoint_RodTip(demoGeo, 5, 20, 9);

module universalJoint_Ball(geometry){
  difference(){
    sphere(d=geometry[4]);
    translate([geometry[4] * -0.5, 0, 0]) rotate([0, 90, 0]) cylinder(d=geometry[1], h=geometry[4]);
    translate([0, geometry[4] * 0.5, 0]) rotate([90, 0, 0]) cylinder(d=geometry[1], h=geometry[4]);
  }
}
module universalJoint_Wafer(geometry){
  difference(){
    translate([0, 0, geometry[0] * -1]) cylinder(d=geometry[5], h=geometry[4]);
    translate([geometry[4] * -0.5, 0, 0]) rotate([0, 90, 0]) cylinder(d=geometry[1], h=geometry[4]);
    translate([0, geometry[4] * 0.5, 0]) rotate([90, 0, 0]) cylinder(d=geometry[1], h=geometry[4]);
  }
}
module universalJoint_Yoke(geometry){
  iw = geometry[8] - geometry[2] - geometry[3];
  rotate([90, 0, 0]) difference(){
    hull(){
      // Rounded uppers
      rotate([0, 90, 0]) translate([0, 0, geometry[6] * -0.5]) cylinder(d=geometry[4], h=geometry[6]);
      // Rounded lower
      translate([0, (iw - (geometry[4] / 2)) * -1, geometry[4] * -0.5]) cylinder(d=geometry[6], h=geometry[4]);
      // Flatten the mount point
      translate([0, (geometry[8] - geometry[2]) * -1, 0]) rotate([90, 0, 0]) cylinder(d=geometry[4], h=geometry[2]);
    }
    // Hollow out the interior.
    hull(){
      // uppers
      translate([geometry[5] * -0.5, 0, geometry[4] * -0.5 - 0.1]) cube([geometry[5], geometry[4], geometry[4] + 0.2]);
      // Rounded lower
      translate([0, (iw - (geometry[4] / 2)) * -1, geometry[4] * -0.5]) cylinder(d=geometry[4], h=geometry[4]);
      // Knock out some of the rounding to ensure we can nest at 90deg without binding
      translate([0, (geometry[7] - (geometry[4] / 2)) * -1 + geometry[2], 0]) cube(geometry[5], center=true);
      // Flatten the mount point
      translate([0, (geometry[7]) * -1, 0]) rotate([90, 0, 0]) cylinder(d=geometry[4], h=geometry[2]);
    }
    // Screw hole
    rotate([0, 90, 0]) translate([0, 0, geometry[6] * -0.5 - 0.1]) 
      cylinder(d=geometry[0] + geometry[3], h=geometry[6] + 0.2);
  }
}
module universalJoint_RodTip(geometry, rod_d, shroud_length, shroud_diameter = -1){
  universalJoint_Yoke(geometry); // This is outside of the workspace because we don't want to eat into the wall.
  od = (shroud_diameter == -1) ? (rod_d + (geometry[2] * 2)) : shroud_diameter;
  tl = (shroud_length >= 5) ? 5 : shroud_length;
  difference(){
    union(){
      // Generate taper
      translate([0, 0, geometry[8] * -1 - tl]) cylinder(d1=od, d2=geometry[4], h=tl);
      // Generate remaining shroud.
      translate([0, 0, (geometry[8] * -1) + (shroud_length * -1)]) cylinder(d=od, h=shroud_length - tl);
    }
    // Clear out interior space to fit the rod
    translate([0, 0, (geometry[8] * -1) + (shroud_length * -1) - 0.1]) cylinder(d=rod_d, h=shroud_length + 0.2);
  }
}
module universalJoint_RodTipWithCapturedBall(geometry, rod_d, shroud_length, shroud_diameter = -1){
  universalJoint_RodTip(geometry, rod_d, shroud_length, shroud_diameter);
  difference(){
    union(){
      sphere(d=geometry[4]);
      rotate([0, 90, 0]) translate([0, 0, geometry[6] * -0.5]) cylinder(d=geometry[0] - geometry[3], h=geometry[6]);
    }
    translate([0, geometry[0] * 1.5, 0]) rotate([90, 0, 0]) cylinder(d=geometry[1], h=geometry[4]);
  }
  
}