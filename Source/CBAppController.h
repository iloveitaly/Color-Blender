/*
 Application: Color Blender
 Copyright (C) 2005  Michael Bianco <software@mabwebdesign.com>
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */


#import <Cocoa/Cocoa.h>

#define MABLASTLEFTCOLOR @"leftColor"
#define MABLASTRIGHTCOLOR @"rightColor"
#define MABLASTBLENDRATIO @"blendRatio"

@class CBRGBColor;
@class prefController;
@class menuController;

@interface CBAppController : NSObject
{
	//Outlets
	IBOutlet NSColorWell *colorLeft;
	IBOutlet NSTextField *rLeft;
	IBOutlet NSTextField *gLeft;
    IBOutlet NSTextField *bLeft;
	IBOutlet NSTextField *hexLeft;
	
	IBOutlet NSColorWell *colorRight;
	IBOutlet NSTextField *rRight;
	IBOutlet NSTextField *gRight;
    IBOutlet NSTextField *bRight;
    IBOutlet NSTextField *hexRight;
    
    IBOutlet NSTextField *mixedHex;
	IBOutlet NSColorWell *mixedColor;
	IBOutlet NSSlider *blendRatioSlider;
	IBOutlet NSTextField *rMixed;
	IBOutlet NSTextField *gMixed;
	IBOutlet NSTextField *bMixed;
	NSColor *lastBlend; //last blend color
	
	IBOutlet NSWindow *mainWindow;
	NSUserDefaults *prefs;
	prefController *preferenceWindow;
	menuController *menuControl;
	
	float blendRatio;
	BOOL shouldUnblend;
}

- (IBAction)blendColors:(id)sender;
- (IBAction)unblendColors:(id)sender;
- (IBAction)hexColorLeft:(id)sender;
- (IBAction)hexColorRight:(id)sender;

//fields edited functions
-(IBAction)RGBValuesEditedLeft:(id)sender;
-(IBAction)RGBValuesEditedRight:(id)sender;
-(IBAction)RGBValuesEditedMiddle:(id)sender;
-(IBAction)hexValueEditedLeft:(id)sender;
-(IBAction)hexValueEditedRight:(id)sender;
-(IBAction)hexValueEditedMiddle:(id)sender;
-(void) setLastBlend:(NSColor *)color;
-(void) updateMiddleWithLastColor;

//interface update functions
-(void)updateLeftSideInterfaceWithColor:(CBRGBColor *) color;
-(void)updateRightSideInterfaceWithColor:(CBRGBColor *) color;
-(void)updateMiddleInterfaceWithColor:(CBRGBColor *) color;

-(IBAction) openPrefs:(id)sender;
-(NSMenu *) applicationDockMenu:(NSApplication *)sender;
-(IBAction) goToHomePage:(id)sender;
-(IBAction) getGPL:(id)sender;
-(void) updateShouldUnblendPrefs;
-(void) updateColorPrefix;
-(void) windowWillClose:(NSNotification *)aNotification;
-(void) appDidBecomeActive:(NSNotification *)note;

-(CBRGBColor *) leftRGBColor;
-(CBRGBColor *) rightRGBColor;
-(CBRGBColor *) mixedRGBColor;
@end
