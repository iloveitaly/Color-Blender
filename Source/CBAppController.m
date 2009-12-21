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

#import "CBAppController.h"
#import "CBRGBColor.h"
#import "CBPrefController.h"
#import "CBMenuController.h"

@implementation CBAppController
//-------------------
//Initilazation
//------------------
+(void)initialize {
	[super initialize];
	
	//register the defaults
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults setObject:[NSNumber numberWithBool:YES] forKey:MABSHOULDUNBLEND];
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSColor cyanColor]] forKey:MABLASTLEFTCOLOR];
	[defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSColor orangeColor]] forKey:MABLASTRIGHTCOLOR];
	[defaults setObject:[NSNumber numberWithFloat:50.0] forKey:MABLASTBLENDRATIO];
	[defaults setObject:[NSString stringWithString:@"#"] forKey:MABCOLORPREFIX];
	[defaults setObject:[NSNumber numberWithBool:MAB_NONCUSTOMPREFIX] forKey:MAB_PREFIXTYPE];
	[defaults setObject:[NSNumber numberWithBool:NO] forKey:MABTERMINATEONCLOSE];
	[defaults setObject:[NSNumber numberWithBool:YES] forKey:MABCPYCOlOROPTIONS];
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
}

-(id)init {	
	if(self = [super init]) {
		[NSApp setDelegate:self];
		
		blendRatio = .5;
		shouldUnblend = FALSE;
		
		prefs = [NSUserDefaults standardUserDefaults];
		[prefs retain];
		
		menuControl = [[CBMenuController alloc] initWithController:self];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(appDidBecomeActive:)
													 name:@"NSApplicationDidBecomeActiveNotification"
												   object:NSApp];		
	}
	
	return self;
}

-(void)awakeFromNib {
	[mainWindow setExcludedFromWindowsMenu:YES];
	
	float sliderVal = [[prefs objectForKey:MABLASTBLENDRATIO] floatValue];
	CBRGBColor *left = [[CBRGBColor alloc] initWithColor:[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:MABLASTLEFTCOLOR]]],
			*right = [[CBRGBColor alloc] initWithColor:[NSKeyedUnarchiver unarchiveObjectWithData:[prefs objectForKey:MABLASTRIGHTCOLOR]]];
	
	[self updateLeftSideInterfaceWithColor:left];
	[self updateRightSideInterfaceWithColor:right];
	
	[blendRatioSlider setFloatValue:sliderVal];
	[self blendColors:blendRatioSlider];
	
	[left release];
	[right release];
}

-(IBAction)openPrefs:(id)sender {
	if(!preferenceWindow) {
		preferenceWindow = [[CBPrefController alloc] initWithMainController:self];
	}
	
	[preferenceWindow showWindow:self];
}

//------------------
//Interface updating
//------------------
-(void)updateLeftSideInterfaceWithColor:(CBRGBColor *) color {
	if([colorLeft isActive]) {
		[colorLeft activate:YES];
	}
	
	//display the hex value
	[hexLeft setStringValue:[color HTMLStringValue]];
	
	//set the color
	[colorLeft setColor:[color colorVal]];
	
	//display the rgb values
	[rLeft setIntValue:[color r]];
	[gLeft setIntValue:[color g]];
	[bLeft setIntValue:[color b]];
}

-(void)updateRightSideInterfaceWithColor:(CBRGBColor *) color {	
	if([colorRight isActive]) {
		[colorRight activate:YES];
	}

	[hexRight setStringValue:[color HTMLStringValue]];
	
	//set the color
	[colorRight setColor:[color colorVal]];
	
	//display the rgb values
	[rRight setIntValue:[color r]];
	[gRight setIntValue:[color g]];
	[bRight setIntValue:[color b]];
}

-(void)updateMiddleInterfaceWithColor:(CBRGBColor *) color {
	if([mixedColor isActive]) {
		[mixedColor activate:YES];
	}
	
	[mixedColor setColor:[color colorVal]];
	[mixedHex setStringValue:[color HTMLStringValue]];
	[rMixed setIntValue:[color r]];
	[gMixed setIntValue:[color g]];
	[bMixed setIntValue:[color b]];
}

- (IBAction)blendColors:(id)sender
{//called from the color slider
	blendRatio = [sender floatValue]/100;
	
	CBRGBColor *currLeftColor = [[CBRGBColor alloc] initWithColor:[colorLeft color]];
	CBRGBColor *currRightColor = [[CBRGBColor alloc] initWithColor:[colorRight color]];
	
	if([currLeftColor r] == [currRightColor r] &&
	   [currLeftColor g] == [currRightColor g] &&
	   [currLeftColor b] == [currRightColor b]) {//if the colors are the same
		[mixedColor setColor:[currLeftColor colorVal]];
		[mixedHex setStringValue:[currLeftColor HTMLStringValue]];
		
		[currLeftColor release];
		[currRightColor release];
		return;
	}
	
	float blendR, blendG, blendB;
	blendR = ([currLeftColor r]*(1-blendRatio))/255.0;
	blendG = ([currLeftColor g]*(1-blendRatio))/255.0;
	blendB = ([currLeftColor b]*(1-blendRatio))/255.0;
	
	blendR += ([currRightColor r]*blendRatio)/255.0;
	blendG += ([currRightColor g]*blendRatio)/255.0;
	blendB += ([currRightColor b]*blendRatio)/255.0;	
	
	NSColor *blendedColor = [NSColor colorWithDeviceRed:blendR 
												  green:blendG 
												   blue:blendB 
												  alpha:1.0];
	CBRGBColor *blendedRGBColor = [[CBRGBColor alloc] initWithColor:blendedColor];
	
	//update the interface
	[self updateMiddleInterfaceWithColor:blendedRGBColor];
	
	//set the last blend
	[self setLastBlend:[blendedRGBColor colorVal]];
	
	//release everything
	[blendedRGBColor release];
	[currLeftColor release];
	[currRightColor release];	
}

-(IBAction)unblendColors:(id)sender {
	if(!shouldUnblend) {
		[sender activate:YES];
		[sender setColor:lastBlend];
		return;
	}
	
	CBRGBColor *blendColor = [[CBRGBColor alloc] initWithColor:[sender color]];
	
	CBRGBColor *leftColor = [[CBRGBColor alloc] initWithColor:
								   [NSColor colorWithDeviceRed:((float)[blendColor r]/255.0)*blendRatio
													green:((float)[blendColor g]/255.0)*blendRatio
													 blue:((float)[blendColor b]/255.0)*blendRatio
													alpha:1.0]];
	
	CBRGBColor *rightColor = [[CBRGBColor alloc] initWithColor:
		[NSColor colorWithDeviceRed:((float)[blendColor r]/255.0)*(1.0-blendRatio)
						 green:((float)[blendColor g]/255.0)*(1.0-blendRatio)
						  blue:((float)[blendColor b]/255.0)*(1.0-blendRatio)
						 alpha:1.0]];
	
	//update the interface
	[self updateLeftSideInterfaceWithColor:leftColor];
	[self updateRightSideInterfaceWithColor:rightColor];
	
	//set the last blend
	[self setLastBlend:[blendColor colorVal]];
	
	//release everything
	[blendColor release];
	[leftColor release];
	[rightColor release];
	
}

-(void) setLastBlend:(NSColor *)color {
	[color retain];
	[lastBlend release];
	lastBlend = color;
}

-(void) updateMiddleWithLastColor {
	CBRGBColor *currColor = [[CBRGBColor alloc] initWithColor:lastBlend];
	[self updateMiddleInterfaceWithColor:currColor];
	[currColor release];
}

//-------------------------
//Event functions, called when certain text fields and such are edited
//-------------------------
-(IBAction)hexColorLeft:(id)sender //called from the color well
{
	//NSLog(@"%.2f:%.2f:%.2f", ([[sender color] redComponent]*255.0), ([[sender color] greenComponent]*255.0), ([[sender color] blueComponent]*255.0));
	CBRGBColor *currLeftColor = [[CBRGBColor alloc] initWithColor:[sender color]];
	[self updateLeftSideInterfaceWithColor:currLeftColor];
	[self blendColors:blendRatioSlider];
	[currLeftColor release];
}

- (IBAction)hexColorRight:(id)sender
{
	//get the color
	CBRGBColor *currRightColor = [[CBRGBColor alloc] initWithColor:[sender color]];
	[self updateRightSideInterfaceWithColor:currRightColor];
	[self blendColors:blendRatioSlider];
	[currRightColor release];	
}

-(IBAction)RGBValuesEditedLeft:(id)sender {
	NSColor *newColor = [NSColor colorWithCalibratedRed:(float)[rLeft intValue]/255.0
												  green:(float)[gLeft intValue]/255.0
												   blue:(float)[bLeft intValue]/255.0
												  alpha:1.0];
	
	CBRGBColor *newRGBColor = [[CBRGBColor alloc] initWithColor:newColor];
	[self updateLeftSideInterfaceWithColor:newRGBColor];
	[self blendColors:blendRatioSlider];
	[newRGBColor release];
}

-(IBAction)RGBValuesEditedRight:(id)sender {
	NSColor *newColor = [NSColor colorWithCalibratedRed:(float)[rRight intValue]/255.0
												  green:(float)[gRight intValue]/255.0
												   blue:(float)[bRight intValue]/255.0
												  alpha:1.0];
	
	CBRGBColor *newRGBColor = [[CBRGBColor alloc] initWithColor:newColor];
	[self updateRightSideInterfaceWithColor:newRGBColor];
	[self blendColors:blendRatioSlider];
	[newRGBColor release];	
}

-(IBAction)RGBValuesEditedMiddle:(id)sender {
	if(!shouldUnblend) {
		[self updateMiddleWithLastColor];
		return;
	}
	
	NSColor *newColor = [NSColor colorWithCalibratedRed:(float)[rMixed intValue]/255.0
												  green:(float)[gMixed intValue]/255.0
												   blue:(float)[bMixed intValue]/255.0
												  alpha:1.0];
	CBRGBColor *newRGBColor = [[CBRGBColor alloc] initWithColor:newColor];
	[self updateMiddleInterfaceWithColor:newRGBColor];
	[newRGBColor release];
	
}

-(IBAction)hexValueEditedRight:(id)sender {
	CBRGBColor *rightColor = [[CBRGBColor alloc] initWithString:[sender stringValue]];
	[self updateRightSideInterfaceWithColor:rightColor];
	[self blendColors:blendRatioSlider];
	[rightColor release];
}

-(IBAction)hexValueEditedLeft:(id)sender {
	CBRGBColor *leftColor = [[CBRGBColor alloc] initWithString:[sender stringValue]];
	[self updateLeftSideInterfaceWithColor:leftColor];
	[self blendColors:blendRatioSlider];
	[leftColor release];
}

-(IBAction)hexValueEditedMiddle:(id)sender {
	if(!shouldUnblend) {
		[self updateMiddleWithLastColor];
		return;
	}
	
	CBRGBColor *leftColor = [[CBRGBColor alloc] initWithString:[sender stringValue]];
	[self updateLeftSideInterfaceWithColor:leftColor];
	[self unblendColors:mixedColor];
	[leftColor release];
}


//-------------------------
// Pref controller methods
//-------------------------
-(void) updateShouldUnblendPrefs {
	shouldUnblend = [prefs boolForKey:MABSHOULDUNBLEND];
}

-(void) updateColorPrefix {
	[self hexColorLeft:colorLeft];
	[self hexColorRight:colorRight];
	[self blendColors:blendRatioSlider];
}

- (void)windowWillClose:(NSNotification *)aNotification {
	//save all the prefs
	[prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:[colorLeft color]]
			  forKey:MABLASTLEFTCOLOR];
	[prefs setObject:[NSKeyedArchiver archivedDataWithRootObject:[colorRight color]]
			  forKey:MABLASTRIGHTCOLOR];
	[prefs setObject:[NSNumber numberWithFloat:[blendRatioSlider floatValue]] forKey:MABLASTBLENDRATIO];
	[prefs synchronize];
	
	if([prefs boolForKey:MABTERMINATEONCLOSE])
		[[NSApplication sharedApplication] terminate:self];
}

//-------------------------
// Actions to be fowarded or used by the menuController
//-------------------------
-(IBAction)goToHomePage:(id)sender {
	[menuControl goToHomePage];
}

- (NSMenu *) applicationDockMenu:(NSApplication *)sender {
	return [menuControl getDockMenu];
}

-(IBAction) getGPL:(id)sender {
	[menuControl getGPL];
}

-(CBRGBColor *) leftRGBColor {
	return [[[CBRGBColor alloc] initWithColor:[colorLeft color]] autorelease];
}

-(CBRGBColor *) rightRGBColor {
	return [[[CBRGBColor alloc] initWithColor:[colorRight color]] autorelease];
}

-(CBRGBColor *) mixedRGBColor {
	return [[[CBRGBColor alloc] initWithColor:[mixedColor color]] autorelease];
}

-(void) appDidBecomeActive:(NSNotification *)note {
	[mainWindow makeKeyAndOrderFront:self];
}
@end
