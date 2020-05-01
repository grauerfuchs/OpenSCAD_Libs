/*
  Keystone Module library 1.0 (2019-11-25) for OpenSCAD
  Author: @grauerfuchs
  Licensed under CC BY-SA https://creativecommons.org/use-remix/cc-licenses/#by-sa  
*/

// Test solids
translate([20, 0, 0]) keystone_Module(false);
translate([-20, 0, 0]) keystone_Receptacle();

module keystone_Receptacle(center=false) {
   translate([
        center ? (-0.5 * 26.5) : 0,
        center ? (-0.5 * 19) : 0,
        center ? (-0.5 * 10) : 0
    ])   
        difference(){
            cube([27, 19, 11]);
            keystone_Module(center=false);
        }
}
module keystone_Module(center=false){
    translate([center ? (23 * -0.5) : 2, center ? (15.0 * -0.5) : 2, center ? (11 * -0.5) : 0]){
                // Jack face
                translate([1.75, 0, -0.001])
                    cube([16.5, 15, 10.001]); // A little over to ensure the pre-render is clean
                // Jack back
                translate([1.75, 0, 8])
                    cube([19.5, 15, 3.001]); // A little over to ensure the pre-render is clean
                // Clip catches
                translate([0, 0, 5.5])
                    cube([23, 15, 3.5]);
                // Fix the edge of the clip catch so you can insert a block
                translate([15, 0, 2])
                    rotate([0, 40, 0])
                        cube([3, 15, 7]);
            } 
}