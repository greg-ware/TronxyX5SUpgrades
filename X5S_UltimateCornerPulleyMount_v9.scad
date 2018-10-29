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
 * Full Tronxy model requires 2020profile.scad from https://www.thingiverse.com/thing:2533048/files
 *
 * The design is inspired but not quite remixed from several existing
 * ones available notably on Thingiverse
 * 
 * Source maintained in GitHub at https://github.com/greg-ware/TronxyX5SUpgrades
 *
 +--------------------------------------------------------------------------
 | History
 | Date       |Version |Author      |Description
 | 2018/07/?? | <= v2  |Ph.Gregoire |Initial version(s)
 | 2018/07/07 | v3     |Ph.Gregoire |Proper belts alignement
 | 2018/07/16 | v4     |Ph.Gregoire |Extend legs, add champfers
 | 2018/07/19 | v4.01  |Ph.Gregoire |Fix TNut hammer size
 | 2018/07/19 | v4.02  |Ph.Gregoire |Fix tenon issue
 | 2018/07/18 | v5     |Ph.Gregoire |Endstop mount, zendstop arm, pulley raiser
 | 2018/07/25 | v5.1   |Ph.Gregoire |Fix pulley raiser
 | 2018/07/26 | v6.01  |Ph.Gregoire |Fix dimentional issues: sides too high
 | 2018/07/26 | v6.02  |Ph.Gregoire |Remove unusable TNut hole
 | 2018/07/26 | v6.03  |Ph.Gregoire |Fix pulley shaft position for belt paralelism
 | 2018/07/26 | v6.04  |Ph.Gregoire |Through-holes to access or replace corner screws
 | 2018/07/26 | v6.05  |Ph.Gregoire |Switches repositioning
 | 2018/07/26 | v6.06  |Ph.Gregoire |Side T-Nut repositioning
 | 2018/07/26 | v7.0   |Ph.Gregoire |Full Tronxy model reconstitution
 | 2018/10/14 | v8.0   |Ph.Gregoire |Use Conical head side TNut screws
 | 2018/10/14 | v8.01  |Ph.Gregoire |Add rigidification slits on the sides
 | 2018/10/25 | v9.0   |Ph.Gregoire |Reorganize dependencies into separate files
 +-------------------------------------------------------------------------
 *
 *  This work is licensed under the 
 *  Creative Commons Attribution 3.0 Unported License.
 *  To view a copy of this license, visit
 *    http://creativecommons.org/licenses/by/3.0/ 
 *  or send a letter to 
 *    Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*/

/* Modify the following parameter to generate
    - corner for LEFT or RIGHT side 
    - pulley raiser
*/
SIDE="LEFT";
//SIDE="RIGHT";

PART="CORNER";
//PART="RAISER";
//PART="ZENDSTOP";    // Generate the Z endstop support
//PART="CORNER_RAISER";
//PART="SLITS";

use <phgUtils_v1.scad>
include <X5S_Build_v2.scad>
use <X5S_Utils_v1.scad>

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
            // add tenons
			
			tenons(wallThk,wallThk,
				lSide-tnutScrewDistFromEdge-tnutHammerDiam/2-wallThk-profW,
				lFront-tnutScrewDistFromEdge-tnutHammerDiam/2-wallThk);
		}
		
		assemblyScrews(wallThk+profW/2,wallThk+profW/2);

        // Holes for the 3 TNuts
		/*v6.02*/ //tnutTopPlateHole(profW/2+wallThk,wallThk+tnutHammerDiam/2,0);
		tnutTopPlateHole(profW/2+wallThk,lFront-tnutScrewDistFromEdge);
		tnutTopPlateHole(lSide-tnutScrewDistFromEdge,profW/2+wallThk);
        
        // axle shafts: LEFT corner has outer LOW (hex imprint) and inner HIGH (no hex imprint)
        
        // outer axle shaft hole, always has recess for screw head
        // pulleyShaftHole(outerAxleX,outerAxleY,true);
		pulleyShaftHole(outerAxleX,outerAxleY,true,isLeft);
		
        // inner axle shaft hole, no need for screw head recess
		pulleyShaftHole(innerAxleX,innerAxleY,true,!isLeft);
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
                            [profW-champR,wallThk+profW+profW/2-champR],
                            [profW-champR,l-champR],
                            [0,l-champR]]);
        
        // Outermost top bar TNut hole
        tnutSideWallHole(profW/2,sideTNutInset>0?l-sideTNutInset:sideTNutOffset+wallThk);

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
                /*v6.02*///tnutSideWallHole(profW/2,wallThk+sideTNutInset);
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
            children();
        }
		
		// Remove slits for ABS
        _sideSlits();
		
		// If this is the side which has the ends stops, drill the screw holes
        if(isEndStops) {
            // Holes for switch
            for(dx=[0,endsXHolesMegaGantryOffset/2,endsXHolesMegaGantryOffset,3*endsXHolesMegaGantryOffset/2]) {
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

module pulleyRaiser(isLeft) {
    tr(0,0,pulleyHeight) mirror([0,0,1]) difference() {
        cylinder(d=pulleyRaiserDiam,h=pulleyHeight,$fn=$_FN_CYL*2);
        shaftHoleScrewHexNut(0,0,pulleyHeight,pulleyAxleDiam,pulleyAxleHeadThk,pulleyAxleHeadDiam,pulleyAxleHexThk,pulleyAxleHexDiam,false);
       
        //pulleyShaftNut(0,0,pulleyHeight);
		if(!isLeft) {
            // drill a hole to access for screwing the T-Nut
  trcyl_eps(0,outerAxleX,0,assemblyScrewHeadDiam,pulleyHeight);
		}
    }
}

module part(partType,side,endStops) {
    isLeft=side=="LEFT";
    isRight=side=="RIGHT";
    if(partType=="CORNER") {
		if(isLeft) {
			// Build for left
			_corner(true,endStops==side) children();
		} else if(isRight) {
			// Mirror and build for right
			rotate([0,0,90]) {
				mirror([0,1,0]) {
					_corner(false,endStops==side) children();
				}
			}
		} else {
			echo("Specify a valid SIDE for CORNER PART");
		}
    } else if(partType=="RAISER") {
        pulleyRaiser(side=="LEFT");
    } else if(partType=="ZENDSTOP") {
        zEndstopArm(endStops=="LEFT");
    } else if(partType=="CORNER_RAISER") {
        part("CORNER",side,endStops)
        trrot(wallThk+((isLeft)?innerAxleX:outerAxleX),wallThk+(isLeft?innerAxleY:outerAxleY),0,180) part("RAISER",side,endStops);
    } else if(partType=="SLITS") {
        trrot(0,0,slitDepth,-90,0,0) {
            _twoSlits(true,slitWidth-layerH*2,slitDepth-layerH,layerH);
        }
    } else {
        echo("Set value of PART properly!");
    }
}

part(PART,SIDE,ENDSTOPS);
