/*
 * Ultimate Tronxy X5S Physics
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
 * 2018/07/26  v1     Ph.Gregoire Initial version(s)
 * 2018/10/29  v2     Ph.Gregoire Fix Stepper hole size
 +-------------------------------------------------------------------------
 *
 *  This work is licensed under the 
 *  Creative Commons Attribution 3.0 Unported License.
 *  To view a copy of this license, visit
 *    http://creativecommons.org/licenses/by/3.0/ 
 *  or send a letter to 
 *    Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
*/

/********************************************************/
/* Fixed constants of X5S by construction               */
profW=20;	// width of profile
motorShaftInset=20; // Distance from outside frame by which the motors shafts are inset
motorPulleyDiam=12; // Diameter of the motor pulley

// X-profile Assembly screws characteristics
assemblyScrewHeadDiam=9;
assemblyScrewHeadThk=2.5;
assemblyScrewDiam=5;

// T-nut screw dimensions
tnutScrewDiam=4;
tnutScrewSeatDiam=7.5;  // Diameter of the screw head
tnutHammerDiam=12;      // Diameter of the diagonal of the hammer nut
tnutScrewSeatDepth=4;       // original has 8mm thickness

// side TNut positioning, this is more or less arbitrary
sideTNutInset=0; /*v6.06*///profW/2; // How much to inset the TNut holes on the sides
sideTNutOffset=3*profW/2; // How much to offset the TNut holes on the sides
// Conical side TNut screw heads
sideTNutSeatDepth=2.4;  // slightly countersunken side screw heads (Was 1.4)
sideTNutScrewDiam=7.4;

// Endstops
endsHolesDiam=1;    // Diameter of the drill hole
endsHolesSpacing=10;// Spacing between the two screw holes
endsWidth=20;       // With of the endstop boxing

endsSwitchDepth=9;  // Distance from holes at which endstop closes
endsXHolesMegaGantryOffset=20; // How much to offset the holes for mega-gantry

// Z endstop support will be bolted on 20x40 frame
endsZSupportWidth=15;
endsZSupportLength=110;
switchHolesDiam=1.5;
switchHolesSpacing=10;
switchWidth=20;
switchHolesOffset=7.5;

// Stepper characteristics
stepperWidth=42;
stepperHeight=40;
stepperHoleDiam=24;
stepperScrewSpacing=31;
stepperScrewDiam=3;
stepperScrewHeadDiam=6;
stepperScrewHeadThk=2;

// Thickness of the belt
beltThk=2;