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

/* Arbitrary parameters for the Ultimate parts */
// Top plate thickness (original acrylic plate is 8mm, but this makes screw seats thin)
thk=10;	

// Thickness of external side walls
wallThk=5;

// Layer Height
layerH=0.2;

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
pulleyAxleHexThk=2.6;   // thickness of hex nut (M5) - keep mult of layer height

pulleyAxleHeadThk=3.6;  // thickness of screwHead (M5) - keep mult of layer height

/* M5x30 Axle screw */
pulleyAxleHeadDiam=11.5; 	// Diameter of the M5 screw head
pulleyAxleHeadThk=3.6;  // thickness of screwHead (M5) - keep mult of layer height

/* M5x50 Axle Screw (Poeliers) 
pulleyAxleHeadDiam=12; 	// Diameter of the M5 screw head
pulleyAxleHeadThk=2.8;  // thickness of screwHead (M5) - keep mult of layer height
*/

pulleyAxleHexDiam=9.5;  // diameter of hex nut (M5)

pulleyRaiserDiam=18;
pulleyHeight=8; // to determine raiser height

/* Rigidification slits 
   The slits will be sliced across the top plate and half way into the height */
slitDepth=3;
slitWidth=10;

/* Modify following depending if endstop is Left or right, or to print Z endstop arm */
ENDSTOPS="LEFT";
//ENDSTOPS="RIGHT";

/* Arbitrary constants for rounding */
// Cylinders $fn default
$_FN_CYL=32;
$_FN_CHAMP=16;

// Epsilon
$_EPSILON=0.2;
