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