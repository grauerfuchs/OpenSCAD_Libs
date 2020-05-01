/*
  Author: @grauerfuchs; 2020-04-29
  Licensed under CC BY-SA https://creativecommons.org/use-remix/cc-licenses/#by-sa
*/
v_rail_extrusion();
module v_rail_extrusion(size=20, height=100, smoothing=true) {
  // The polygon points are based on a 2020 extrusion, so scale based on 2020 sizing.
  linear_extrude(height) scale([size / 20, size / 20, 1]) difference() {
    oe = (smoothing) ? 9.00 : 10.00; // Outer Edge - If smoothing is enabled, knock the point off of the corners.
    for (az = [0, 90, 180, 270], mx = [0, 1]) rotate([0, 0, az]) mirror([mx, 0, 0])
      polygon(points = [
        [ 0.00,  0.00], 
        [ 0.00,  2.50], [  0.00,  4.00], [  2.73,  4.00],
        [ 5.30,  6.57], [  5.30,  8.00], [  3.10,  8.00], [  4.75, 10.00],
        [   oe, 10.00], [ 10.00,    oe]
      ]);
    circle(r=2.40, $fn=36); // Central cutout
  
  }
}
