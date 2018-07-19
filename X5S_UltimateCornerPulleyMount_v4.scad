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
 +---------------------------------------------------------
 * History
 * Date       Version Author      Description
 * 2018/07/??  <= v2  Ph.Gregoire Initial version(s)
 * 2018/07/07  v3     Ph.Gregoire Proper belts alignement
 * 2018/07/16  v4     Ph.Gregoire Extend legs, add champfers
 * 2018/07/16  v4.01  Ph.Gregoire Fix TNut hammer size
 +---------------------------------------------------------
 *
 *  This work is licensed under the 
 *  Creative Commons Attribution 3.0 Unported License.
 *  To view a copy of this license, visit
 *    http://creativecommons.org/licenses/by/3.0/ 
 *  or send a letter to 
 *    Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*/

use <../phgUtils.scad>

/* Modify the following parameter to generated corner for LEFT or RIGHT side */
SIDE="LEFT";
SIDE="RIGHT";

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

module pulleyShaftHole(x,y,isScrew,isHex) {
    // make recess for pulley axle screw head
    if(isScrew) {
        trcyl_eps(wallThk+x,wallThk+y,thk-pulleyAxleHeadThk,pulleyAxleHeadDiam,pulleyAxleHeadThk);
    }
    
    // shaft for pulley axle screw
    trcyl_eps(wallThk+x,wallThk+y,0,pulleyAxleDiam,thk);

    // Imprint of hex nut
    if(isHex) {
        trcyl_eps(wallThk+x,wallThk+y,0,pulleyAxleHexDiam,pulleyAxleHexThk,fn=6);
    }
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
            
			// tenon X
            tenonX_Y=wallThk+outerAxleY+pulleyAxleHeadDiam/2;
            trcube(wallThk+profW/2-tenonWidth/2,tenonX_Y,thk,
            tenonWidth,lFront-tnutScrewDistFromEdge-tnutHammerDiam/2-tenonX_Y,tenonHeight);

			// tenon Y
            tenonY_X=wallThk+outerAxleX+pulleyAxleHeadDiam/2;
			trcube(tenonY_X,wallThk+profW/2-tenonWidth/2,thk,
            lSide-tnutScrewDistFromEdge-tnutHammerDiam/2-tenonY_X,tenonWidth,tenonHeight);
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
            sideWithLeg(lSide,true) {
                trcyl_eps(profW/2,lSide-sideTNutOffset,0,tnutScrewDiam,wallThk);
            }
            // Front side with two holes
            sideWithLeg(lFront,false) {
                tnutSideWallHole(profW/2,wallThk+sideTNutOffset);
            }
        }
        
        // round the corners
        roundedBoundingBox(lSide,lFront,thk+2*profW,champRPlate,champRPlate,champR,$fn=$_FN_CHAMP);
    }
}

module _corner(isLeft) {
	basePlate(isLeft);
	sides();
}

module corner() {
    if(SIDE=="LEFT") {
        _corner(true);
    } else {
        rotate([0,0,90]) {
            mirror([0,1,0]) {
                _corner(false);
            }
        }
    }
}

corner();