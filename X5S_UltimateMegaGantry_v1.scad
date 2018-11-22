/*
 * Ultimate Tronxy X5S Mega Gantry Plate
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
 * 2018/11/10  v1     Ph.Gregoire Initial version
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

/* arbitrary size */
gantryLen=95; //113.85;
legWidth=20;

gantryHeight=10;    // thickness of gantry plate

armWidth=20;
armLength=70; 

/* offset for the inner wheels */
frontWheelOff=20;
rearWheelOff=20;

/* Print head dimensions */
carriageWidth=30;   // Width of the print head carriage
printHeadOffset=25;

// Offset of X carriage bar
barOffset=gantryLen/2-profW/2+printHeadOffset;
armOffset=barOffset+profW;

// Notch values
notchMargin=1;  // margin on each side
notchWidth=profW;
notchDepth=notchWidth/2;

// Wheels physics
wheelSpacing=40;
wheelAxlesDiam=5; // 5.3
wheelAxleHeadThk=3;
wheelAxleHeadDiam=9;

wheelWellDiam=28;   // 23=5.3+2*8.85: wheel base

wheelPodHeight=5;
wheelPodDiam=7.8;

YBarClearance=7; //7.6;

cutCorner=7;

/* Compute some derived constants shorthands */
gantryWidth=legWidth+notchWidth+legWidth;    //71.5;

wheelXOff=legWidth/2;
wheelXDelta=gantryLen-legWidth;
wheelYOff=legWidth/2;

// Positions of wheels: X,Y, isFront, isInner
wheelsPos=[[0,0,true,false],
           [wheelXDelta,0,false,false],
           [-rearWheelOff,wheelSpacing,true,true],
           [wheelXDelta+frontWheelOff,wheelSpacing,false,true]];
   
// The axles are aligned in Y so that the belt aligns with the motor pulley
function pulleyAxleY()=legWidth+(notchWidth-profW)/2+motorShaftInset+motorPulleyDiam/2+pulleyDiam/2+beltThk;
function pulleyAxleX(i=1)=barOffset+profW/2-i*(carriageWidth+pulleyDiam)/2;

// Compute clearance Width of gantry
gantryClearance=max(gantryWidth,pulleyAxleY()+pulleyAxleHeadDiam);

    
module gantryTopPlate(isLeft,o=champRPlate) {
    // shorthand for offset
    //o=0;
        
    // Compute offset of bar so that head is aligned with middle of gantry
    barOffset=gantryLen/2-profW+printHeadOffset;

	// base plate
    difference() {
        union() {
            difference() {
                union() {
                    gantryBasePlate(o);
                    gantryArm(o);                    
                }
                // Clearance for wheels
                wheelWells();
            }
            wheelPods(o);  
        }
        
        // YBar profile longitudinal tunnel
        trcube_eps(-rearWheelOff,legWidth-notchMargin,0,
        gantryLen+frontWheelOff+rearWheelOff,
        notchWidth+2*notchMargin,
        profW-wheelPodHeight+YBarClearance);
        
        // XBar transversal slot
        trcube(armOffset-profW,legWidth+notchWidth,0,profW,armLength+gantryWidth,profW);
        
        // XBar top plate vertical tnut holes
        for(y=[gantryClearance+3*profW/8,legWidth+notchWidth+profW/2]) {
            trrot(armOffset-profW/2,y,thk+profW,180) tnutHole(0,0,tnutScrewSeatDepth,thk);
        }
        
        // XBar arm horizontal t-nut holes
        for(offset=[13*armLength/16,5*armLength/16]) {
            trrot(armOffset+armWidth,legWidth*2+notchWidth+offset,profW/2,0,-90,0)
            tnutHole(0,0,legWidth-tnutScrewSeatDepth,legWidth);
        }
        
        // Pulley axles shafts
        // And align in X so that the belts are aligned with the X carriage
        for(i=[-1,1]) {
            t=profW;
            trrot(pulleyAxleX(i),pulleyAxleY(),thk+profW,0,180,0)
            shaftHoleScrewHexNut(0,0,thk+t,pulleyAxleDiam,pulleyAxleHeadThk+t,pulleyAxleHeadDiam,pulleyAxleHexThk,pulleyAxleHexDiam,true,i==1?isLeft:!isLeft);
        }
	}  
}

module gantryPlateShape(o) {
    difference() {
        notchOffset=notchDepth-notchWidth/2;
        innerOffset=legWidth+notchWidth+notchMargin;
        union() {
            offset(r=o,$fn=$_FN_CHAMP) polygon(points=[
                [o,o],
                [gantryLen-o,o],  // Border
                // Front Notch
                [gantryLen-o,               legWidth-o],
                [gantryLen-notchOffset-o,   legWidth-o],
                [gantryLen-notchOffset-o,   innerOffset+o],
                [gantryLen+frontWheelOff-o-cutCorner, innerOffset+o],
                [gantryLen+frontWheelOff-o, innerOffset+o+cutCorner],
                [gantryLen+frontWheelOff-o, gantryWidth-o],
                [pulleyAxleX(-1),           gantryWidth-o],

                // Bump for pulley shaft clearance
                [pulleyAxleX(-1),gantryClearance-o],
                [pulleyAxleX(),gantryClearance-o],
                [pulleyAxleX(),gantryWidth-o],

                // Back Notch
                [o-rearWheelOff,            gantryWidth-o],
                [o-rearWheelOff,            innerOffset+o+cutCorner],
                [o-rearWheelOff+cutCorner,  innerOffset+o],
                [notchOffset+o,             innerOffset+o],
                [notchOffset+o,             legWidth-o],
                [o,                         legWidth-o]
                ]);
            
            // Support for second X Axis TNut 
            //translate([armOffset+armWidth,gantryWidth]) circle(profW);
            translate([armOffset,gantryClearance]) circle(profW);
        
            // Bump for pulley axis support
            translate([pulleyAxleX(),pulleyAxleY()]) circle(pulleyAxleHeadDiam);
        }

        // Remove notches
        for(x=[notchOffset,gantryLen-notchOffset]) {
            translate([x,legWidth+notchWidth/2+notchMargin/2]) circle(d=notchWidth+notchMargin);
        }
    }
}

module gantryBasePlate(o,gantryClearance) {
    tr(0,0,profW-gantryHeight) {
        linear_extrude(height=thk+gantryHeight,convexity=2) {
            gantryPlateShape(o,gantryClearance);
        }
    }
}

module gantryArm(o) {
    linear_extrude(height=thk+profW,convexity=2) {
        offset(r=o,$fn=$_FN_CHAMP) {
            polygon(points=[
                [gantryLen+frontWheelOff-o-cutCorner, legWidth+notchWidth+notchMargin+o],
                [gantryLen+frontWheelOff-o, legWidth+notchWidth+notchMargin+o+cutCorner],
                [gantryLen+frontWheelOff-o, gantryWidth-o],
                [armOffset+armWidth+profW-o,gantryWidth-o],
                [gantryLen+frontWheelOff-o, gantryWidth-o],
                [armOffset+armWidth-o,      gantryWidth+profW-o],
                [armOffset+armWidth-o,      armLength+gantryWidth-o],
                [armOffset+o,               armLength+gantryWidth-o],
                [armOffset+o,               legWidth+notchWidth+notchMargin+o],
                [armOffset+armWidth-o,      legWidth+notchWidth+notchMargin+o]
                
                ]);
        }
    }
}

module wheelWells() {
    // Carriage wheels shafts and well
    for(i=[0:len(wheelsPos)-1]) {
        tr(wheelXOff+wheelsPos[i][0],wheelYOff+ wheelsPos[i][1]) {
            // Screw shaft
            cyl_eps(wheelAxlesDiam,thk+profW);
            
            // Screw head Seat
            trcyl_eps(0,0,thk+profW-wheelAxleHeadThk,wheelAxleHeadDiam,wheelAxleHeadThk);
                        
            // wheel clearance
            cylinder(d=wheelWellDiam,h=profW);
            a=45;
            wellThk=gantryHeight+thk;
            
            // slanted wheel clearance
            if(i==3) {
                rottrcube(-wheelWellDiam/2,-armLength-armWidth/2,-wellThk*3/4,
                0,45,wheelsPos[i][2]?0:180,
                wheelWellDiam,armLength+profW,wellThk,
                center=false);
            } else {
                trrotcube((7*wheelWellDiam/16)*(wheelsPos[i][2]?1:-1),0,1,0,a,wheelsPos[i][2]?0:180,wheelWellDiam,wheelWellDiam,wellThk,center=true);
            }
        }
    }
}

module wheelPods(o) {
    // Wheel pods
    intersection() {
        for(i=[0:len(wheelsPos)-1]) {        
            tr(wheelXOff+wheelsPos[i][0],wheelYOff+wheelsPos[i][1],profW-wheelPodHeight) {
                difference() {
                    cylinder(h=wheelPodHeight,d1=wheelPodDiam,d2=1.1*legWidth,fn=$_FN_CYL);
             
                    cyl_eps(h=wheelPodHeight,d=wheelAxlesDiam);
                }    
            }
        }
        linear_extrude(height=thk+profW,convexity=2) {
            gantryPlateShape(o);
        }
    }
}

//projection()
//difference() {
//    gantryTopPlate(true,0);
    gantryTopPlate(true,5);
//}