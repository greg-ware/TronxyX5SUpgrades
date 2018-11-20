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
gantryHeight=10;

armWidth=20;
armLength=70; //gantryDepth-gantryWidth;

wheelXOff=legWidth/2;
wheelXDelta=90;
wheelYOff=legWidth/2; //12.09;
wheelSpacing=40; // 40.06;
frontWheelOff=15;
rearWheelOff=10;

// Positions of wheels
wheelsPos=[[0,0,true],
           [wheelXDelta,0,false],
           [-rearWheelOff,wheelSpacing,true],
           [wheelXDelta+frontWheelOff,wheelSpacing,false]];
wheelAxlesDiam=5; // 5.3
wheelAxleHeadThk=3;
wheelAxleHeadDiam=9;

wheelWellDiam=28;   // 23=5.3+2*8.85: wheel base
//wheelWellOffset=12;

wheelPodHeight=3;
wheelPodDiam=7.8;

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
    gantryClearance=max(gantryWidth,pulleyAxleY()+pulleyAxleHeadDiam);
    
    // Adjust notch
    notchDepth=notchDepth==0?o:notchDepth;
    
    // Compute offset of bar so that head is aligned with middle of gantry
    barOffset=gantryLen/2-profW+printHeadOffset;
    //wellThk=thk+profW-wheelWellOffset;
    
	// base plate
	difference() {
		union() {
            tr(0,0,profW-gantryHeight)
			linear_extrude(height=thk+gantryHeight,convexity=2) difference() {
                union() {
                offset(r=o,$fn=$_FN_CHAMP)
				polygon(points=[
                    [o,o],
                    [gantryLen-o,o],  // Border
                    // Front Notch
                    [gantryLen-o,legWidth-o],
                    [gantryLen-notchDepth-o,legWidth-notchMargin-o],
                    [gantryLen-notchDepth-o,legWidth+notchWidth+o],
                    [gantryLen+frontWheelOff-o,legWidth+notchWidth+o],
                    [gantryLen+frontWheelOff-o,gantryWidth-o],
                    [pulleyAxleX(-1),gantryWidth-o],
 
                    // Bump for pulley shaft clearance
                    [pulleyAxleX(-1),gantryClearance-o],
                    [pulleyAxleX(),gantryClearance-o],
                    [pulleyAxleX(),gantryWidth-o],

                    // Back Notch
                    [o-rearWheelOff,gantryWidth-o],
                    [o-rearWheelOff,legWidth+notchWidth+o],
                    [o+notchDepth,legWidth+notchWidth+o],
                    [o+notchDepth,legWidth-o],
                    [o,legWidth-o]
					]);
                

                // Support for second X Axis TNut 
                //translate([armOffset+armWidth,gantryWidth]) circle(profW);
                translate([armOffset,gantryClearance]) circle(profW);
                
                // Bump for pulley axis support
                translate([pulleyAxleX(),pulleyAxleY()]) circle(pulleyAxleHeadDiam);
            }
                
            // Remove notches
            for(x=[notchDepth/2+o/2,gantryLen-notchDepth/2-o/2])
            translate([x,legWidth+notchWidth/2]) circle(d=notchWidth);
        }

        // Arm
        //o=0;
        linear_extrude(height=thk+profW,convexity=2)
            offset(r=o,$fn=$_FN_CHAMP)   
                polygon(points=[
                    // Arm
                    [gantryLen+frontWheelOff-o,gantryWidth-o],
                    [gantryLen+frontWheelOff-o,gantryWidth-o],
                    [armOffset+armWidth+profW-o,gantryWidth-o],
                    [armOffset+armWidth-o,gantryWidth+profW-o],
                    [armOffset+armWidth-o,armLength+gantryWidth-o],
                    [armOffset+o,armLength+gantryWidth-o],
                    [armOffset+o,legWidth+notchWidth+notchMargin+o],
                    [armOffset+o,legWidth+notchWidth+notchMargin],
                //    [armOffset+armWidth-o,legWidth+notchWidth+notchMargin],
                    [armOffset+armWidth-o,legWidth+notchWidth+notchMargin+o],
                    [gantryLen+frontWheelOff-o,legWidth+notchWidth+notchMargin+o]
                    ]);                    
    }
        // Carriage wheels shafts and well
        for(i=[0:len(wheelsPos)-1])
            tr(wheelXOff+wheelsPos[i][0],wheelYOff+wheelsPos[i][1]) {
                // Screw shaft
                cyl_eps(wheelAxlesDiam,thk+profW);
                
                // Screw head Seat
                trcyl_eps(0,0,thk+profW-wheelAxleHeadThk,wheelAxleHeadDiam,wheelAxleHeadThk);
                
                // wheel space
                cylinder(d=wheelWellDiam,h=profW);
                a=45;
                wellThk=gantryHeight+thk;
                // slanted wheel clearance
                if(i==3)
                rottrcube(wheelWellDiam/8,0,wellThk/16,0,a,wheelsPos[i][2]?0:180,wheelWellDiam,armLength*2+wheelWellDiam*2,wellThk,center=true);
                else
                trrotcube((7*wheelWellDiam/16)*(wheelsPos[i][2]?1:-1),0,1,0,a,wheelsPos[i][2]?0:180,wheelWellDiam,wheelWellDiam,wellThk,center=true);
        }
        
        // XBar notch
        trcube(barOffset,legWidth+notchWidth,0,profW,armLength+gantryWidth,profW);
        
        // XBar tnut holes
        for(y=[gantryClearance+3*profW/8,legWidth+notchWidth+profW/2]) {
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
                   
        // XBar Profile tunnel
        trcube_eps(-rearWheelOff,legWidth-notchMargin,0,gantryLen+frontWheelOff+rearWheelOff,notchWidth+2*notchMargin,profW+notchMargin);
        
        // Horizontal t-nut bores
        for(offset=[13*armLength/16,5*armLength/16]) {
            trrot(armOffset+armWidth,legWidth*2+notchWidth+offset,profW/2,0,-90,0)
            tnutHole(0,0,legWidth-tnutScrewSeatDepth,legWidth);
        }
	}
    
    // Wheel pods
    for(i=[0:len(wheelsPos)-1]) {        
        tr(wheelXOff+wheelsPos[i][0],wheelYOff+wheelsPos[i][1],profW-wheelPodHeight)
            difference() {
                cylinder(h=wheelPodHeight,d1=wheelPodDiam,d2=legWidth-notchMargin*2,fn=$_FN_CYL);
                cyl_eps(h=wheelPodHeight,d=wheelAxlesDiam);
            }
    }
}

difference() {
    //gantryTopPlate(true,0);
    gantryTopPlate(true,5);
}