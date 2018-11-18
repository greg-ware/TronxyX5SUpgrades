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

carriageWidth=30;
printHeadOffset=25;

gantryLen=110; //113.85;
legWidth=20;

notchMargin=1;  // margin on each side
notchWidth=profW;
notchDepth=0;//notchWidth/2;


gantryWidth=legWidth+notchWidth+legWidth;    //71.5;

armWidth=20;
armLength=70; //gantryDepth-gantryWidth;

wheelXOff=legWidth/2;
wheelXDelta=90;
wheelYOff=legWidth/2; //12.09;
wheelSpacing=40; // 40.06;
frontWheelOff=15;
rearWheelOff=10;

// Positions of wheels
wheelsPos=[[0,0,180],
           [wheelXDelta,0,0],
           [-rearWheelOff,wheelSpacing,180],
           [wheelXDelta+frontWheelOff,wheelSpacing,0]];
wheelAxlesDiam=5; // 5.3
wheelAxleHeadThk=3;
wheelAxleHeadDiam=9;

wheelWellDiam=28;   // 23=5.3+2*8.85: wheel base
wheelWellOffset=12;

wheelPodHeight=5;
wheelPodDiam=8;

module gantryTopPlate(isLeft,o=champRPlate) {
    // shorthand for offset
    //o=0;
    
    // Offset of X carriage bar
    barOffset=gantryLen/2-profW+printHeadOffset;
    armOffset=barOffset+profW;
    
    // The axles are aligned in Y so that the belt aligns with the motor pulley
    function pulleyAxleY()=legWidth+(notchWidth-profW)/2+motorShaftInset+motorPulleyDiam/2+pulleyDiam/2+beltThk;
    function pulleyAxleX(i=1)=barOffset+profW/2-i*(carriageWidth+pulleyDiam)/2;
    
    // Compute clearance Width of gantry
    gantryClerance=max(gantryWidth,pulleyAxleY()+pulleyAxleHeadDiam);
    
    // Adjust notch
    notchDepth=notchDepth==0?o:notchDepth;
    
    // Compute offset of bar so that head is aligned with middle of gantry
    barOffset=gantryLen/2-profW+printHeadOffset;
    wellThk=thk+profW-wheelWellOffset;
    
	// base plate
	difference() {
		union() {
			linear_extrude(height=thk+profW,convexity=2) difference() {
                union() {
                offset(r=o,$fn=$_FN_CHAMP)
				polygon(points=[
                    [o,o],
                    [gantryLen-o,o],  // Border
                    // Front Notch
                    [gantryLen-o,legWidth-notchMargin-o],
                    [gantryLen-notchDepth-o,legWidth-notchMargin-o],
                    [gantryLen-notchDepth-o,legWidth+notchWidth+notchMargin+o],
                    [gantryLen+frontWheelOff-o,legWidth+notchWidth+notchMargin+o],
                    [gantryLen+frontWheelOff-o,gantryWidth-o],
                    // Arm
                    [armOffset+armWidth+profW-o,gantryWidth-o],
                    [armOffset+armWidth-o,gantryWidth+profW-o],
                    [armOffset+armWidth-o,armLength+gantryWidth-o],
                    [armOffset+o,armLength+gantryWidth-o],
                    // Bump for pulley shaft clearance
                    [armOffset+o,gantryClerance-o],
                    [pulleyAxleX(),gantryClerance-o],
                    [pulleyAxleX(),gantryWidth-o],
                   
                    
                    // Back Notch
                    [o-rearWheelOff,gantryWidth-o],
                    [o-rearWheelOff,legWidth+notchWidth+notchMargin+o],
                    [o+notchDepth,legWidth+notchWidth+notchMargin+o],
                    [o+notchDepth,legWidth-notchMargin-o],
                    [o,legWidth-notchMargin-o]
					]);
                //translate([armOffset+armWidth,gantryWidth]) circle(profW);
                translate([armOffset,gantryClerance]) circle(profW);
                
                translate([pulleyAxleX(),pulleyAxleY()]) circle(pulleyAxleHeadDiam);
            }
            for(x=[notchDepth/2+o/2,gantryLen-notchDepth/2-o/2])
            translate([x,legWidth+notchWidth/2]) circle(d=notchWidth+2*notchMargin);
        }  
		}
        
        // Carriage wheels shafts and well
        for(i=[0:len(wheelsPos)-1])
            tr(wheelXOff+wheelsPos[i][0],wheelYOff+wheelsPos[i][1]) {
                // Screw shaft
                cyl_eps(wheelAxlesDiam,thk+profW);
                
                // Screw head Seat
                trcyl_eps(0,0,thk+profW-wheelAxleHeadThk,wheelAxleHeadDiam,wheelAxleHeadThk);
                
                // wheel space
                cyl_eps(wheelWellDiam,wellThk);
                 rottrcube(wheelWellDiam/2,0,wellThk/2,0,0,wheelsPos[i][2],wheelWellDiam,wheelWellDiam,wellThk,center=true);
                rottrcube(wheelWellDiam/4,0,wellThk/8,0,45,180+wheelsPos[i][2],wheelWellDiam,wheelWellDiam*2,wellThk,center=true);
        }
        
        // XBar notch
        trcube(barOffset,legWidth+notchWidth,0,profW,armLength+gantryWidth,profW);
        // XBar tnut holes
        for(y=[gantryClerance+3*profW/8,legWidth+notchWidth+profW/2]) {
    trrot(armOffset-profW/2,y,thk+profW,180) tnutHole(0,0,tnutScrewSeatDepth,thk);
        }
        
        // Pulley axles shafts
        // And align in X so that the belts are aligned with the X carriage
        for(i=[-1,1]) {
            //pulleyAxleX=barOffset+profW/2+i*(carriageWidth+pulleyDiam)/2;
            t=profW;
            trrot(pulleyAxleX(i),pulleyAxleY(),thk+profW,0,180,0)
            shaftHoleScrewHexNut(0,0,thk+t,pulleyAxleDiam,pulleyAxleHeadThk+t,pulleyAxleHeadDiam,pulleyAxleHexThk,pulleyAxleHexDiam,true,i==1?isLeft:!isLeft);
        }
                   
        // Profile tunnel
        trcube_eps(0,legWidth-notchMargin,0,gantryLen,notchWidth+2*notchMargin,profW+notchMargin);
	}
    
    for(i=[0:len(wheelsPos)-1]) {        
        tr(wheelXOff+wheelsPos[i][0],wheelYOff+wheelsPos[i][1],wellThk-wheelPodHeight)
            difference() {
                cylinder(h=wheelPodHeight,d1=wheelPodDiam-notchMargin,d2=legWidth,fn=$_FN_CYL);
                cyl_eps(h=wheelPodHeight,d=wheelAxlesDiam);
            }
    }
}

difference() {
    //gantryTopPlate(true,0);
    gantryTopPlate(true,5);
}