/*
 * Ultimate Tronxy X5S Corner Pulley Mounts
 *   
 * Dimensioning assumptions:
 *   - Motor shafts are aligned 20 mm to the inside of the frame
 *   - Pulleys diameter is 12 mm, with a 5mm bore, mounted on M5 screws
 *
 * Note that most dimensions are not arbitrary, and computed from physical
 * values of the printer and pulleys, designed so that belts run parallel 
 * to axis movements
 *
 * The design is inspired but not quite remixed from several existing
 * ones available notably on Thingiverse
 *
 +--------------------------------------------------------------------------
 * History
 * Date       Version Author      Description
 * 2018/07/??  <= v2  Ph.Gregoire Initial version(s)
 * 2018/07/07  v3     Ph.Gregoire Proper belts alignement
 * 2018/07/16  v4     Ph.Gregoire Extend legs, add champfers
 * 2018/07/19  v4.01  Ph.Gregoire Fix TNut hammer size
 * 2018/07/19  v4.02  Ph.Gregoire Fix tenon issue
 * 2018/07/18  v5     Ph.Gregoire Endstop mount, zendstop arm, pulley raiser
 +-------------------------------------------------------------------------
 *
 *  This work is licensed under the 
 *  Creative Commons Attribution 3.0 Unported License.
 *  To view a copy of this license, visit
 *    http://creativecommons.org/licenses/by/3.0/ 
 *  or send a letter to 
 *    Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*/

use <../phgUtils.scad>

/* Modify the following parameter to generate
    - corner for LEFT or RIGHT side 
    - pulley raiser
*/
SIDE="LEFT";
//SIDE="RIGHT";
//SIDE="RAISER";
//SIDE="ZENDSTOP";    // Generate the Z endstop support

/* Modify following depending if endstop is Left or right, or to print Z endstop arm */
ENDSTOPS="LEFT";
//ENDSTOPS="RIGHT";


/* Arbitrary parameters */
// Top plate thickness (original acrylic plate is 8mm, but this makes screw seats thin)
thk=10;	

// Thickness of external side walls
wallThk=5;

// champfer radius
champR=4;
champRPlate=3;

// profile tenon dimensions
tenonHeight=5.5;
tenonWidth=6;

// Size of the corner plate. Original is 
lFront=65;	// length along front (x)
lSide=60;	// length along side (y)

/* Below are the physical characteristics and dimensions of the new pulleys and axles */
pulleyDiam=12;
pulleyAxleDiam=5;	// pulley axles diameter
pulleyAxleHeadThk=3.4;  // thickness of screwHead (M5) - keep mult of layer height
pulleyAxleHeadDiam=11.5; 	// Diameter of the M5 screw head
pulleyAxleHexThk=2.6;   // thickness of hex nut (M5) - keep mult of layer height
pulleyAxleHexDiam=9.5;  // diameter of hex nut (M5)

pulleyRaiserDiam=18;
pulleyHeight=8; // to determine raiser height

/********************************************************/
/* Fixed constants of X5S by construction               */
profW=20;	// width of profile
motorShaftInset=20; // Distance from outside frame by which the motors shafts are inset

// X-profile Assembly screws characteristics
assemblyScrewHeadDiam=9;
assemblyScrewHeadThk=2.5;

// T-nut screw dimensions
tnutScrewDiam=4;
tnutScrewSeatDiam=7.5;  // Diameter of the screw head
tnutHammerDiam=12;      // Diameter of the diagonal of the hammer nut

// top plate tnut positioning, this is somewhat arbitrary
tnutScrewSeatDepth=4;       // original has 8mm thickness
tnutScrewDistFromEdge=6;    // distance from edge of top plate tnut screw

// side TNut positioning, this is more or less arbitrary
sideTNutOffset=profW/2; // How much to inset the TNut holes on the sides
sideTNutSeatDepth=1.4;  // slightly countersunken side screw heads

// Endstops
endsHolesDiam=1;    // Diameter of the drill hole
endsHolesSpacing=10;// Spacing between the two screw holes
endsWidth=20;       // With of the endstop boxing

endsSwitchDepth=9;  // Distance from holes at which endstop closes
endsXHolesMegaGantryOffset=20; // How much to offset the holes for mega-gantry

// Z endstop support will be bolted on 20x40 frame
endsZSupportWidth=15;
endsZSupportLength=110;
switchHolesDiam=1.5;
switchHolesSpacing=10;
switchWidth=20;
switchHolesOffset=9;

/************************************************************************/
/* Begin computations                                                   */
/* Following parameters are computed from physical dimensions above     */

// positioning of outer pulley axle
outerAxleX=profW/2;
outerAxleY=motorShaftInset-pulleyDiam/2;

// positioning of inner pulley axle
innerAxleX=profW+pulleyAxleHeadDiam/2;
innerAxleY=outerAxleY+pulleyDiam;

// Compute overall widths
wFront=profW+wallThk;	// width along front (x)
wSide=profW+wallThk;	// width along sides (y)

// positions of shoulder notch: leave enough material for robustness
xNotch=wallThk+innerAxleX+pulleyAxleDiam+wallThk;
yNotch=wallThk+innerAxleY+pulleyAxleDiam;

// Cylinders $fn default
$_FN_CYL=32;
$_FN_CHAMP=16;

// Epsilon
$_EPSILON=0.2;

module tnutHole(tx,ty,seatDepth,h) {
	translate([tx,ty,-$_EPSILON]) {
		cylinder(d=tnutScrewSeatDiam,h=seatDepth+2*$_EPSILON,$fn=$_FN_CYL);
		cylinder(d=tnutScrewDiam,h=h+2*$_EPSILON,$fn=$_FN_CYL);
	}
}

module tnutTopPlateHole(tx,ty) {
    tnutHole(tx,ty,tnutScrewSeatDepth,thk);
}

module tnutSideWallHole(tx,ty) {
    tnutHole(tx,ty,sideTNutSeatDepth,wallThk);
}

module pulleyShaftNut(x,y,t,isHex=true) {
    // shaft for pulley axle screw
    trcyl_eps(x,y,0,pulleyAxleDiam,t);

    // Imprint of hex nut
    if(isHex) {
        trcyl_eps(x,y,0,pulleyAxleHexDiam,pulleyAxleHexThk,fn=6);
    }
}

module pulleyShaftHole(x,y,isScrew,isHex) {
    // make recess for pulley axle screw head
    if(isScrew) {
        trcyl_eps(wallThk+x,wallThk+y,thk-pulleyAxleHeadThk,pulleyAxleHeadDiam,pulleyAxleHeadThk);
    }
    pulleyShaftNut(wallThk+x,wallThk+y,thk,isHex);
}

module basePlate(isLeft) {
	difference() {
		union() {
			// base plate
			linear_extrude(height=thk,convexity=2) {
                offset(r=champRPlate,$fn=$_FN_CHAMP)
				polygon(points=[
                            [champRPlate,champRPlate],
                            [lSide-champRPlate,champRPlate],
                            [lSide-champRPlate,wSide-champRPlate],
                            [xNotch-champRPlate,wSide-champRPlate],
                            [xNotch-champRPlate,yNotch-champRPlate],
                            [wFront,lFront-champRPlate],
                            [champRPlate,lFront-champRPlate],
                            [champRPlate,champRPlate]]);
			}
            
			// tenon along Front
            tenonFront_Pos=wallThk+outerAxleY+pulleyAxleHeadDiam/2;
            trcube(wallThk+profW/2-tenonWidth/2,tenonFront_Pos,thk,
              tenonWidth,lFront-tnutScrewDistFromEdge-tnutHammerDiam/2-tenonFront_Pos,tenonHeight);

			// tenon along Side
            tenonSide_Pos=wallThk+max(outerAxleX+pulleyAxleHeadDiam/2,profW);
			trcube(tenonSide_Pos,wallThk+profW/2-tenonWidth/2,thk,
              lSide-tnutScrewDistFromEdge-tnutHammerDiam/2-tenonSide_Pos,tenonWidth,tenonHeight);
		}
        // Remove hole for the head of the profiles assembly screw
        // The position of that is in the middle of the second profile
		trcyl(wallThk+profW/2+profW,wallThk+profW/2,thk+tenonHeight-assemblyScrewHeadThk,assemblyScrewHeadDiam,assemblyScrewHeadThk+$_EPSILON);
		
        // Holes for the 3 TNuts
		tnutTopPlateHole(profW/2+wallThk,wallThk+tnutHammerDiam/2,0);
		tnutTopPlateHole(profW/2+wallThk,lFront-tnutScrewDistFromEdge);
		tnutTopPlateHole(lSide-tnutScrewDistFromEdge,profW/2+wallThk);
        
        // axle shafts: LEFT corner has outer LOW (hex imprint) and inner HIGH (no hex imprint)
        
        // outer axle shaft hole, always has recess for screw head
        // pulleyShaftHole(outerAxleX,outerAxleY,true);
		pulleyShaftHole(outerAxleX,outerAxleY,true,isLeft);
		
        // inner axle shaft hole, no need for screw head recess
		pulleyShaftHole(innerAxleX,innerAxleY,false,!isLeft);
	}
}

module sideWithLeg(l,isFront) {
    if(!isFront) mirror([1,0,0]) rotate([0,0,90]) sideWithLeg(l,true) children();
    else
    rotate([0,-90,-90])
    difference() {
        linear_extrude(height=wallThk,convexity=2)
            offset(r=champR,$fn=$_FN_CHAMP)
            polygon(points=[[0,champR],
                            [profW*2-champR,champR],
                            [profW*2-champR,wallThk+profW-champR],
                            [profW,wallThk+profW+profW/2-champR],
                            [profW,l-champR],
                            [0,l-champR]]);
        
        // Outermost top bar TNut hole
        tnutSideWallHole(profW/2,l-sideTNutOffset);

        // Leg TNut hole
        tnutSideWallHole(profW+profW/2,wallThk+profW/2);
        
        // extra holes
        children();
    }
}

module sides() {
    intersection() {
        translate([0,0,thk]) {
            // Side side with one hole
            sideWithLeg(lSide,true);
            
            // Front side with two holes
            sideWithLeg(lFront,false) {
                tnutSideWallHole(profW/2,wallThk+sideTNutOffset);
            }
        }
        
        // round the corners
        roundedBoundingBox(lSide,lFront,thk+2*profW,champRPlate,champRPlate,champR,$fn=$_FN_CHAMP);
    }
}

module _corner(isLeft,isEndStops) {
    difference() {
        union() {
            basePlate(isLeft);
            sides();
        }
        if(isEndStops) {
            // Holes for switch
            for(dx=[0,endsXHolesMegaGantryOffset/2,endsXHolesMegaGantryOffset]) {
                tr(lSide-switchHolesOffset-dx,0,switchWidth/2) rotate([-90,0,0])
            switchHoles();
            }
        }
    }
}
module switchHoles(x=0,y=0,z=0,ax=0,ay=0,az=0) {
    for(i=[-1,1]) {
        trrotcyl_eps(x,y+i*switchHolesSpacing/2,z,ax,ay,az,switchHolesDiam,wallThk);
    }
}

module zEndstopArm(isLeft) {
    if(!isLeft) translate([endsZSupportWidth,0,0]) mirror([1,0,0]) zEndstopArm(true);
    else difference() {
        union() {
            roundedFlatBox(endsZSupportWidth,endsZSupportLength,wallThk,champR);
            tr(-profW+endsZSupportWidth/2,profW) roundedFlatBox(profW*2,profW,wallThk,champR);
        }
        for(i=[-1,1]) tnutSideWallHole(endsZSupportWidth/2+i*profW/2,3*profW/2);
        tnutSideWallHole(endsZSupportWidth/2,profW/2);
        switchHoles(endsZSupportWidth-switchHolesOffset,endsZSupportLength-switchWidth/2,0);
    }
}

module pulleyRaiser() {
    tr(0,0,pulleyHeight) mirror([0,0,1]) difference() {
        cylinder(d=pulleyRaiserDiam,h=pulleyHeight,$fn=$_FN_CYL*2);
        pulleyShaftNut(0,0,pulleyHeight);
    }
}

module corner() {
    if(SIDE=="LEFT") {
        // Build for left
        _corner(true,ENDSTOPS=="LEFT");
    } else if(SIDE=="RIGHT") {
        // Mirror and build for right
        rotate([0,0,90]) {
            mirror([0,1,0]) {
                _corner(false,ENDSTOPS=="RIGHT");
            }
        }
    } else if(SIDE=="RAISER") {
        pulleyRaiser();
    } else if(SIDE=="ZENDSTOP") {
        zEndstopArm(ENDSTOPS=="LEFT");
    } else {
        echo("Set value of SIDE properly!");
    }
}

corner();