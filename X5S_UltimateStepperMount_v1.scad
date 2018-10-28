/*
 * Ultimate Tronxy X5S Stepper Mounts
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
 * 2018/10/20  v1     Ph.Gregoire Initial version
 +-------------------------------------------------------------------------
 *
 *  This work is licensed under the 
 *  Creative Commons Attribution 3.0 Unported License.
 *  To view a copy of this license, visit
 *    http://creativecommons.org/licenses/by/3.0/ 
 *  or send a letter to 
 *    Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*/

use <phgUtils_v1.scad>

/* Modify the following parameter to generate
    - corner for LEFT or RIGHT side 
    - pulley raiser
*/
SIDE="LEFT";
//SIDE="RIGHT";

// Parts build constants
include <X5S_Build_v1.scad>

// Physical defs of X5S
include <X5S_Physics_v1.scad>

module stepperTopPlate(isLeft) {
champRPlate=3;	
	// base plate
	difference() {
		linear_extrude(height=thk,convexity=2) {
			offset(r=champRPlate,$fn=$_FN_CHAMP)
			polygon(points=[
				[champRPlate,champRPlate-wallThk],
				[stepperWidth+wallThk+lSideStepper-champRPlate,champRPlate-wallThk],
				[stepperWidth+wallThk+lSideStepper-champRPlate,profW-champRPlate],
				[stepperWidth+wallThk+profW*2-champRPlate,profW-champRPlate],
				[stepperWidth+wallThk+profW-champRPlate,stepperWidth-champRPlate],
				[champRPlate,stepperWidth-champRPlate],
				[champRPlate,champRPlate-wallThk]]);
		}
		// Hole
		trcyl_eps(stepperWidth/2,stepperWidth/2,0,stepperHoleDiam,thk);
		
		// Screw holes
		for(x=[-stepperScrewSpacing/2,stepperScrewSpacing/2]) {
			for(y=[-stepperScrewSpacing/2,stepperScrewSpacing/2]) {
				trcyl_eps(stepperWidth/2+x,stepperWidth/2+y,0,stepperScrewDiam,thk);
				trcyl_eps(stepperWidth/2+x,stepperWidth/2+y,0,stepperScrewHeadDiam,stepperScrewHeadThk);
			}
		}
	}
}

module stepperSide(isLeft) {
	trrot(0,0,0,90,0,0) {
		intersection() {
			linear_extrude(height=wallThk,convexity=2) {
				offset(r=champR,$fn=$_FN_CHAMP)
				polygon(points=[
					[champR,champR],
					[stepperWidth+wallThk+lSideStepper-champR,champR],
					[stepperWidth+wallThk+lSideStepper-champR,thk+profW-champR],
					[stepperWidth+wallThk+profW*2-champR,thk+profW-champR],
					[stepperWidth+wallThk+profW-champR,thk+stepperHeight-champR],
					[stepperWidth,thk+stepperHeight-champR],
					[champR,thk],
					[champR,champR]]);
			}

			// round the corners
			translate([0,0,-stepperWidth]) 
			roundedBoundingBox(stepperWidth+lSideStepper+wallThk,thk+stepperHeight,stepperWidth+wallThk,champRPlate,champR,champRPlate,$fn=$_FN_CHAMP);
		}
	}
}

module stepperWall(isLeft) {
	trrot(stepperWidth+wallThk,0,thk,0,-90,0)
	linear_extrude(height=wallThk,convexity=2) {
		offset(r=champR,$fn=$_FN_CHAMP)
			polygon(points=[
				[0,0],
				[stepperHeight-champR,0],
				[stepperHeight-champR,profW-champR],
				[profW-champR,stepperWidth-champR],
				[0,stepperWidth-champR],
				[0,0]]);
			}
}

module stepperMotorMount(isLeft) {
	stepperTopPlate(isLeft);
	stepperSide(isLeft);
	stepperWall(isLeft);
}

stepperMotorMount(isLeft=SIDE=="LEFT");