/*
 * Full Model of Tronxy X5S
 *   
 * Full assembly of the Ultimate Tronxy parts
 * 
 * Requires 2020profile.scad from https://www.thingiverse.com/thing:2533048
 *
 * The design is inspired but not quite remixed from several existing
 * ones available notably on Thingiverse
 * 
 * Source maintained in GitHub at https://github.com/greg-ware/TronxyX5SUpgrades
 *
 +--------------------------------------------------------------------------
 | History
 | Date       |Version |Author      |Description
 | 2018/07/26 | v7.0   |Ph.Gregoire |Tronxy model reconstitution
 | 2018/10/15 | v8.01  |Ph.Gregoire |Use slits
 | 2018/10/29 | v9     |Ph.Gregoire |Add stepper mounts
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

use <X5S_UltimateCornerPulleyMount_v9.scad>
use <X5S_UltimateStepperMount_v2.scad>
use <2020profile.scad>


FRONTBAR=490;
SIDEBAR=490;
HEIGHT=500;

//X5SPhysics=getX5SPhysics();

//thk=X5SPhysics[0];
//wallThk=X5SPhysics[1];
//profW=X5SPhysics[2];
/*
ENDSTOPS=X5SPhysics[3];
outerAxleX=X5SPhysics[4][0];
outerAxleY=X5SPhysics[4][1];
innerAxleX=X5SPhysics[5][0];
innerAxleY=X5SPhysics[5][1];
*/


module XProfile(length,x=0,y=0,z=0,ax=0,ay=0,az=0) {
     color("grey") trrot(x,y,z,ax,ay,az)
        linear_extrude(height = length, center = false, convexity = 10)
            children();
}

module X20x20(length,x=0,y=0,z=0,ax=0,ay=0,az=0) {
    XProfile(length,x,y,z,ax,ay,az) profile2020();
}

module X20x40(length,x=0,y=0,z=0,ax=0,ay=0,az=0) {
   XProfile(length,x,y,z,ax,ay,az+90) profile2040();
}

module fullModel() {
    trrot(-wallThk,FRONTBAR/2+wallThk,-thk,0,0,-90) {
        part("CORNER_RAISER","RIGHT",ENDSTOPS);
        #part("SLITS","LEFT",ENDSTOPS);
    }
        
    trrot(-wallThk,-FRONTBAR/2-wallThk,-thk) {
        part("CORNER_RAISER","LEFT",ENDSTOPS);
    }
    
    X20x20(FRONTBAR,profW/2,FRONTBAR/2,profW/2,90);
    for(s=[-1,1]) {
        X20x20(SIDEBAR,profW,s*(FRONTBAR-profW)/2,profW/2,0,90);
        X20x40(HEIGHT,profW,s*(FRONTBAR-profW)/2,profW,0,0);
    }
    
    trrot(0,-FRONTBAR/2-wallThk,profW*2,-90,-90) part("ZENDSTOP","LEFT",ENDSTOPS);
    trrot(SIDEBAR+lSideStepper+wallThk+profW,FRONTBAR/2,-thk,0,0,180) stepperMotorMount(true);
}

//part(PART,SIDE,ENDSTOPS);
fullModel();
