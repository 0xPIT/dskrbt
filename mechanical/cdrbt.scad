// ----------------------------------------------------------------------
// Disk Changer Robot
// github.com/0xPIT/dskrbt
// (c) 2013 karl@pitrich.com
// Insert Creative Commons License Terms Here
// 
// Credits:
//   * modified LM8UU holder by Jonas Kühling
// ----------------------------------------------------------------------

include <./MCAD/shapes.scad>
include <./MCAD/regular_shapes.scad>
include <./MCAD/boxes.scad>

aluminum = [0.9, 0.9, 0.9];
steel = [0.8, 0.8, 0.9];


LM8UU_dia = 15.4; // must be wider than bearing and adjust for printer
LM8UU_length = 24;
rod_dia = 6;

//screw/nut dimensions (M3) - hexagon socket head cap screw ISO 4762, hexagon nut ISO 4032
screw_thread_dia_iso = 3;
screw_head_dia_iso = 5.5;
nut_wrench_size_iso = 5.5;

// screw/nut dimensions for use (plus clearance for fitting purpose)
clearance_dia = 0.5;
screw_thread_dia = screw_thread_dia_iso + clearance_dia;
screw_head_dia = screw_head_dia_iso + clearance_dia;
nut_wrench_size = nut_wrench_size_iso + clearance_dia;
nut_dia_perimeter = (nut_wrench_size/cos(30));
nut_dia = nut_dia_perimeter;
nut_surround_thickness = 2;

// main body dimensions
body_wall_thickness = 2;
body_width = LM8UU_dia + (2*body_wall_thickness);
body_height = body_width;
body_length = LM8UU_length;
gap_width = rod_dia + 2;
screw_bushing_space = 1;

screw_elevation = LM8UU_dia + body_wall_thickness + screw_thread_dia / 2 + screw_bushing_space;

motor_holes    =  42;
arm_length     =  100;
stabilizer_pos = -60;
mount_length   =  60;

module carriage() {
  union() 
  {
    translate([0, LM8UU_dia/2 + body_wall_thickness, 0])
      rotate([90, 0, 0]) 
        lm8uu_holder();

    difference() {
      union() {
        translate([0, (arm_length / 2) - 4.5, -LM8UU_length/2 + 2])
          cube([18, arm_length - 9, 4], center=true);
        
        translate([0, arm_length - 9, -LM8UU_length/2 + 2]) 
          cylinder(r=9, h=4, center=true, $fn=40);
        
        // arm stabilizer
        translate([0, 8, -8])
          rotate([90, 0, -90])
            rightTriangle(arm_length/100*70, 10, 5);
      }

      // cut out inner cylinder
	  translate([0, 0, -(LM8UU_length + 1) / 2]) 
        polyhole(LM8UU_dia, LM8UU_length + 1);

      // payload bore
      translate([0, arm_length - 10, -10])
        cylinder(r=6, h=10, center=true, $fn=20);
    }

    difference() {
      union() {
        translate([-6.5, -23.5, -LM8UU_length/2 + 4])
          cube([5, 20, 8], center=true);
        //translate([-4, stabilizer_pos, -LM8UU_length/2 + 4])
        //  cube([8, 8, 8], center=true);
      }
      //translate([-4, stabilizer_pos, -8])
      //  cylinder(r=1.5, h=10, center=true, $fn=20);
    }
  }
}


module edgeMount(height, upper=false) 
{
  difference() {
    union() {
      cylinder(r=6.5, h=height, center=true, $fn=20);

      for(i = [3, -3])
        translate([i, -5, 0])
          cube([4, 10, height], center=true);

      translate([0, -27, 0]) 
        union() {
          intersection() {
            cylinder_tube(20, 18, 3, center=true, $fn=40);
            translate([0, 10, 0])
              cube([50, 20, height], center=true);
          }

		  if (upper)
            cube([18 * 2, 3, height], center=true);
          if (!upper)
            cube([motor_holes+6, 3, height], center=true);          
        }
    }

    // clamp screw mount holes
    for(i=[height / 2 - 5, -height / 2 + 5])
      translate([0, -6, i])
        rotate([0, 90, 0])
          cylinder(r=1.5, h=15, center=true, $fn=20);

    // rod bore
    cylinder(r=4.05, h=height, center=true, $fn=20);

    // split
    translate([0, -10, 0]) cube([3, 20, height], center=true); 
    if (!upper) {
      translate([0, -27, 0]) cube([18 * 2 - 6, 5, height], center=true);
      translate([0, -40, 0]) rotate([90, 90, 180]) motor42(false);
    }
    else { // upper: bore for pulley
      translate([0, -30, 0]) rotate([90, 0, 0]) cylinder(r=1.5, h=10, center=true, $fn=20);
    }
  }  
}


module motor42(with_body = true) {
    if (with_body)
      cylinder(r=21, h=16, center=true, $fn=20);

    // motor mount holes
    for(i=[motor_holes/2, -motor_holes/2])
      translate([0, i, 10])
          cylinder(r=1.5, h=10+2, center=true, $fn=20);

    // motor shaft hole
    translate([0, 0, 10])
        cylinder(r=5, h=10+2, center=true, $fn=20);
}


module motorCutOut() {  
  difference() {
    cylinder(r=17, h=6, center=true, $fn=20);
    cylinder(r=10, h=6, center=true, $fn=20);
    cube([40, 6, 4] ,center=true);
    cube([6, 40, 4] ,center=true);
  }
}


module rods() {
  // main rod
  translate([0, 0, -60])  color(steel) cylinder(r=4, h=200, center=false, $fn=20);

  // stabilizer rod
  //translate([-4, stabilizer_pos, -60])  color(steel) cylinder(r=1.5, h=400, center=false, $fn=20);
}


module compactDisc() {
  color([0, 1.0, 0]) 
    difference() {
      cylinder(r=60,  h=1, center=true, $fn=20);
      cylinder(r=7.5, h=1, center=true, $fn=20);  
    }
}


// nophead's polyhole module for better lm8uu-fit
module polyhole(d,h) {
    n = max(round(2 * d),3);
    rotate([0,0,180])
        cylinder(h = h, r = (d / 2) / cos (180 / n), $fn = n);
}


module mount_plate() {
  difference() {
    translate([0,0,1.5])
	  cube([body_width + 2 * screw_head_dia + 4 * nut_surround_thickness, screw_head_dia + 2 * nut_surround_thickness, 3], center=true);
		for(i = [-1, 1])
			translate([i * (body_width / 2 + nut_surround_thickness + screw_head_dia / 2), 0, -0.5])
              cylinder(r=screw_thread_dia / 2, h=4, $fn=20);
	}
}

// main body
module lm8uu_holder(with_mountplate=false, dia=LM8UU_dia)
{
	difference() {
		union() {
			if (with_mountplate) 
				mount_plate();
	
			// body
			//translate([0,0,body_height/4])
			//	cube([body_width,body_length,body_height/2], center=true);
			translate([0,0,(dia/2)+body_wall_thickness])		
				rotate([90,0,0])
					cylinder(r=(dia/2) + body_wall_thickness+1, h=LM8UU_length, center=true);
	
			// gap support
			translate([-(gap_width/2)-body_wall_thickness,-(body_length/2),body_height/2])
				cube([body_wall_thickness,LM8UU_length,(dia/2)+screw_bushing_space+(screw_thread_dia/2)]);
			translate([gap_width/2,-(body_length/2),body_height/2])
				cube([body_wall_thickness,LM8UU_length,(dia/2)+screw_bushing_space+(screw_thread_dia/2)]);
	
	
			// nut trap surround

			translate([gap_width/2, -7, screw_elevation])
				rotate([0,90,0])
					cylinder(r=(((nut_wrench_size+nut_surround_thickness*2)/cos(30))/2), h=(body_width-gap_width)/2, $fn=6);


			translate([gap_width/2, 7, screw_elevation])
				rotate([0,90,0])
					cylinder(r=(((nut_wrench_size+nut_surround_thickness*2)/cos(30))/2), h=(body_width-gap_width)/2, $fn=6);


			translate([gap_width/2 + (body_width-gap_width)/4, 
						0, 
						screw_elevation - 2])
				cube([ (body_width - gap_width)/2,
						LM8UU_length,
						nut_dia_perimeter + 5  ],
						center=true);


			// Screw hole surround

			translate([-gap_width/2, -7, screw_elevation])
				rotate([0,-90,0])
					cylinder(r=(screw_head_dia/2)+nut_surround_thickness, h=(body_width-gap_width)/2, $fn=20);

	translate([-gap_width/2, 7, screw_elevation])
				rotate([0,-90,0])
					cylinder(r=(screw_head_dia/2)+nut_surround_thickness, h=(body_width-gap_width)/2, $fn=20);

	translate([-(gap_width / 2 + (body_width - gap_width) / 4), 
				0,
				screw_elevation -2 ])
		cube([(body_width - gap_width) / 2,
			LM8UU_length,
			nut_dia_perimeter + 5],
			center=true);

		}
	
		// bushing hole
		translate([0, 0, dia / 2 + 2])
			rotate([90, 0, 0])
				translate([0, 0, -(LM8UU_length + 1) / 2]) polyhole(dia, LM8UU_length + 1);
	
		// top gap
		translate([
			-(gap_width / 2),
			-(body_length / 2) - 1,
			body_height / 2]
		)
			cube([gap_width,
				  LM8UU_length + 2,
				  (dia / 2) + screw_bushing_space + (screw_thread_dia / 2) + (nut_dia / 2) + nut_surround_thickness + 1]);


		// screw holes (one all the way through)
		translate([0, -7, screw_elevation])
			rotate([0, 90, 0])
				cylinder(r=screw_thread_dia/2, h=body_width+3, center=true, $fn=20);

		// screw hole (one all the way through)
		translate([0, 7, screw_elevation])
			rotate([0,90,0])
				cylinder(r=screw_thread_dia/2, h=body_width+3, center=true, $fn=20);
	
		// nut trap
		translate([gap_width/2+body_wall_thickness,-7,screw_elevation])
			rotate([0,90,0])
				cylinder(r=nut_dia/2, h=body_width/2-gap_width/2-body_wall_thickness+1,$fn=6);

		translate([gap_width/2+body_wall_thickness,7,screw_elevation])
			rotate([0,90,0])
				cylinder(r=nut_dia/2, h=body_width/2-gap_width/2-body_wall_thickness+1,$fn=6);

	
		// screw head hole
		translate([-(gap_width)/2-body_wall_thickness,-7,screw_elevation])
			rotate([0,-90,0])
				cylinder(r=screw_head_dia/2, h=body_width/2-gap_width/2-body_wall_thickness+1,$fn=20);
		translate([-(gap_width)/2-body_wall_thickness,7,screw_elevation])
			rotate([0,-90,0])
				cylinder(r=screw_head_dia/2, h=body_width/2-gap_width/2-body_wall_thickness+1,$fn=20);
	
	}
}


module bearing608() {
  difference() {
    cylinder(r=11.6, h=7.1, $fn=40, center=true);
    cylinder(r=4, h=7, $fn=40, center=true);
  }
}

module housing608() {
  difference() {
    difference() {
      cylinder(r=13, h=9, $fn=40, center=true);
      cylinder(r=6, h=9, $fn=40, center=true);
    }
    translate([0, 0, -1]) bearing608();
  }
}

module holder608() {
  housing608();

  difference() {
    cube([8, 46, 9], center=true);

    for(i=[-19, -16, 16, 19])
      translate([0, i, 0])
        cylinder(r=2, h=9, $fn=20, center=true);
    for(i=[-17, 17])
      translate([0, i, 0])
        cube([4, 3, 9], center=true);

    translate([0, 0, -1]) 
      cylinder(r=11.6, h=7.1, $fn=40, center=true);
    cylinder(r=6, h=9, $fn=40, center=true);
  }
}


module pulleyMock(innerR, innerH) {
edge=1.5;
edgeR=innerR*1.3;

  union() {
    cylinder(r=innerR, h=innerH, center=true, $fn=40);
    translate([0, 0, -innerH/2 - edge/2]) cylinder(r=edgeR, h=edge, center=true, $fn=40);
    translate([0, 0,  innerH/2 - edge/2]) cylinder(r=edgeR, h=edge, center=true, $fn=40);
  }
}


//rotate([180, 0, 0]) holder608();

rods();

translate([0, 0, 100]) edgeMount(10, true);

translate([0, -23, 100]) rotate([90, 0, 0]) pulleyMock(7.5, 3.6);

translate([0, 0, 50]) carriage();

translate([0, 0, 0]) edgeMount(20, false);

translate([0, -23, 0]) rotate([90, 0, 0]) pulleyMock(7.5, 3.6);


//for (a=[-90, 0, 90])
//  rotate([0, 0, a]) translate([0, 100, 0]) compactDisc();





