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
 * 2018/10/29  v2     Ph.Gregoire Final version
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
include <X5S_Build_v2.scad>

use <X5S_Utils_v1.scad>

/* computed constants */
frameXOff=stepperWidth+wallThk;

// Position and legth of slits (inner slit at index 0, side 1-3)
_SLITS_POSLEN=[
    [stepperWidth/2+slitWidth/2,thk+profW*2-champRPlate],
    [stepperHeight/2-slitWidth/2,thk+stepperHeight/2-slitDepth/2],
    [frameXOff-slitWidth/2,thk+2*profW-champRPlate],
    [frameXOff+2*profW-slitWidth/2,thk+profW]
];

module stepperTopPlate(isLeft) {
champRPlate=3;	
	// base plate
	difference() {
		union() {
			linear_extrude(height=thk,convexity=2) {
				offset(r=champRPlate,$fn=$_FN_CHAMP)
				polygon(points=[
					[champRPlate,champRPlate-wallThk],
					[frameXOff+lSideStepper-champRPlate,champRPlate-wallThk],
					[frameXOff+lSideStepper-champRPlate,profW-champRPlate],
					[frameXOff+profW*2-champRPlate,profW-champRPlate],
					[frameXOff+profW-champRPlate,stepperWidth-champRPlate],
					[champRPlate,stepperWidth-champRPlate],
					[champRPlate,champRPlate-wallThk]]);
			}
		
			tenons(frameXOff,0,lSideStepper-profW-tnutScrewDistFromEdge-tnutHammerDiam/2,stepperWidth-tnutScrewDistFromEdge-tnutHammerDiam/2);
		}
		
		// Hole for stepper motor
		trcyl_eps(stepperWidth/2,stepperWidth/2,0,stepperHoleDiam,thk);
		
		// Screw holes for stepper
		for(x=[-stepperScrewSpacing/2,stepperScrewSpacing/2]) {
			for(y=[-stepperScrewSpacing/2,stepperScrewSpacing/2]) {
				trcyl_eps(stepperWidth/2+x,stepperWidth/2+y,0,stepperScrewDiam,thk);
				trcyl_eps(stepperWidth/2+x,stepperWidth/2+y,0,stepperScrewHeadDiam,stepperScrewHeadThk);
			}
		}
		
		// TNut holes
		tnutTopPlateHole(frameXOff+lSideStepper-tnutScrewDistFromEdge,profW/2);
		tnutTopPlateHole(frameXOff+profW/2,stepperWidth-tnutScrewDistFromEdge);
		
		// Holes for frame assembly screws access
		assemblyScrews(frameXOff+profW/2,profW/2);
	}
}

/* Side flange */
module stepperSide(isLeft) {
	trrot(0,0,0,90,0,0) {
		difference() {
			intersection() {
				linear_extrude(height=wallThk,convexity=2) {
					offset(r=champR,$fn=$_FN_CHAMP)
					polygon(points=[
						[champR,champR],
						[frameXOff+lSideStepper-champR,champR],
						[frameXOff+lSideStepper-champR,thk+profW-champR],
						[frameXOff+profW*2-champR,thk+profW-champR],
						[frameXOff+profW-champR,thk+stepperHeight-champR],
						[stepperWidth,thk+stepperHeight-champR],
						[champR,thk],
						[champR,champR]]);
				}

				// round the corners
				translate([0,0,-stepperWidth]) 
				roundedBoundingBox(stepperWidth+lSideStepper+wallThk,thk+stepperHeight,frameXOff,champRPlate,champR,champRPlate,$fn=$_FN_CHAMP);
			}
			
			// Side screw heads			
			tnutSideWallHole(frameXOff+profW/2,thk+3*profW/2,true);
			tnutSideWallHole(frameXOff+3*profW/2,thk+profW/2,true);
		}
	}
}

module stepperWall(isLeft) {
	trrot(frameXOff,0,thk,0,-90,0) {
		difference() {
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
			// Side Tnut holes
			tnutSideWallHole(3*profW/2,profW/2,true);
			tnutSideWallHole(profW/2,3*profW/2,true);
		}
	}
}

module stepperMotorMount(isLeft,slitsPosLen=_SLITS_POSLEN) {
   
	difference() {
		union() {
			stepperTopPlate(isLeft);
			stepperSide(isLeft);
			stepperWall(isLeft);
		}

        // Carve out Middle wall slit groove
        trrot(stepperWidth,slitsPosLen[0][0],0,0,0,-90) {
            _slit(slitsPosLen[0][1]);
        }
							
		// Carve out Side slits grooves
        for(s=[1:len(slitsPosLen)-1]) {
            translate([slitsPosLen[s][0],-wallThk,0]) {
				_slit(slitsPosLen[s][1]);
			}
		}
    }
}

/* Generate the slits positives to fill the grooves
    slitsPosLen: array of tuples with slit position and length
    deltaH: height and width delta
*/
module stepperMotorSlits(deltaH,slitsPosLen=_SLITS_POSLEN) {
	// Lay out in a row
    for(s=[0:len(slitsPosLen)-1]) {
        trrot(slitWidth*3+slitWidth*s*3/2,-wallThk*2,slitDepth,-90,0,180) {
            _slit(slitsPosLen[s][1]-deltaH,slitWidth-2*deltaH,slitDepth-deltaH);
		}
	}
}

stepperMotorSlits(layerH);
stepperMotorMount(isLeft=SIDE=="LEFT");