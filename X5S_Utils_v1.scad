/*
 * Ultimate Tronxy X5S Upgrades - utility functions
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
 | 2018/10/25 | v1.0   |Ph.Gregoire |Put common utils functions in this file
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
include <X5S_Build_v2.scad>

module tnutHole(tx,ty,seatDepth,h) {
	translate([tx,ty,-$_EPSILON]) {
		cylinder(d=tnutScrewSeatDiam,h=seatDepth+2*$_EPSILON,$fn=$_FN_CYL);
		cylinder(d=tnutScrewDiam,h=h+2*$_EPSILON,$fn=$_FN_CYL);
	}
}

module tnutConicalHole(tx,ty,seatDepth,h,isRot=false) {
	//translate([tx,ty,-$_EPSILON]) {
	trrot(tx,ty,(isRot?wallThk+$_EPSILON:-$_EPSILON),0,isRot?180:0,0) {
		cylinder(d1=tnutScrewSeatDiam,d2=tnutScrewDiam,h=seatDepth+2*$_EPSILON,$fn=$_FN_CYL);
		cylinder(d=tnutScrewDiam,h=h+2*$_EPSILON,$fn=$_FN_CYL);
	}
}

module tnutTopPlateHole(tx,ty) {
    tnutHole(tx,ty,tnutScrewSeatDepth,thk);
}

module tnutSideWallHole(tx,ty,isRot=false) {
    tnutConicalHole(tx,ty,sideTNutSeatDepth,wallThk,isRot);
}

module shaftHoleScrew(x,y,t,screwDiam,screwHeadThk,screwHeadDiam,isScrew=true,isTop=false) {
    // make recess for pulley axle screw head
    if(isScrew) {
        trcyl_eps(x,y,isTop?0:t-screwHeadThk,screwHeadDiam,screwHeadThk);
    }
    
    // shaft for pulley axle screw
    trcyl_eps(x,y,0,screwDiam,t);
}

module shaftHoleScrewHexNut(x,y,t,screwDiam,screwHeadThk,screwHeadDiam,screwHexThk,screwHexDiam,isScrew=true,isHexNut=true) {
    shaftHoleScrew(x,y,t,screwDiam,screwHeadThk,screwHeadDiam,isScrew);
    // Imprint of hex nut
    if(isHexNut) {
        trcyl_eps(x,y,0,screwHexDiam,screwHexThk,fn=6);
    }
}   

module pulleyShaftHole(x,y,isScrew,isHexNut,offset=wallThk) {
    shaftHoleScrewHexNut(x+offset,y+offset,thk+tenonHeight,pulleyAxleDiam,pulleyAxleHeadThk+tenonHeight,pulleyAxleHeadDiam,pulleyAxleHexThk,pulleyAxleHexDiam,isScrew,isHexNut);
}

module _sideSlits() {
    _twoSlits(true,slitWidth,slitDepth);
    _twoSlits(false,slitWidth,slitDepth);  
}


module _twoSlits(isSide,sw,sd,deltaH=0) {
    _sideSlit(profW/2,thk+profW-deltaH,isSide?0:1,sw,sd);
    _sideSlit((isSide?lSide:lFront)-profW,thk+profW/2-deltaH,isSide?0:1,sw,sd);
}

/* Build slit for the side
	x: offset
	l: length
	m: mirror (1) or not (0) for side (vs front) 
	sw: slit width
	sd: slit depth
*/
module _sideSlit(x,l,m=0,sw=slitWidth,sd=slitDepth) {
    rotate([0,0,90*m]) {
        translate([x,0,0]) {
            mirror([0,m,0]) _slit(l,sw,sd);
        }
    }
}

/* Build one slit of given dimensions
	l: length
	sw: slit width
	sd: slit depth
*/
module _slit(l,sw=slitWidth,sd=slitDepth) {
    intersection() {
        linear_extrude(l) {
            polygon([[sd,0],[0,sd],[sw,sd],[sw-sd,0]]);
        }
        union() {
            trcube(0,0,0,sw,sd,l-sw/2);
            trrot(sw/2,sd,l-sw/2,90,0,0) cylinder(d1=sw,d2=sw-sd*2,h=sd);
        }
    }
}

/*	Holes for the assembly screws that connect the 40x20 and the top 20x20
*/
module assemblyScrews(x,y) {
	// Remove hole for the head of the profiles assembly screws
	// The position of that is in the middle of the second profile
	for(dx=[x,x+profW]) {
		trcyl(dx,y,thk+tenonHeight-assemblyScrewHeadThk,assemblyScrewHeadDiam,assemblyScrewHeadThk+$_EPSILON);
		shaftHoleScrew(dx,y,thk+tenonHeight,assemblyScrewDiam,assemblyScrewHeadThk,assemblyScrewHeadDiam,true,true);
	}
}

module tenons(xOff,yOff,tenonXLen,tenonYLen,outerAxleX) {
	// tenon along Front
	trcube(xOff+profW/2-tenonWidth/2,yOff,thk,
	  tenonWidth,tenonYLen,tenonHeight);

	// tenon along Side
	tenonSideX=xOff+profW;
	trcube(xOff+profW,yOff+profW/2-tenonWidth/2,thk,
	  tenonXLen,tenonWidth,tenonHeight);
}
