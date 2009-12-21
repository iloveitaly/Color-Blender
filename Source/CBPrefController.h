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

#define MABCOLORPREFIX @"colorPrefix"
#define MABSHOULDUNBLEND @"shouldUnblend"
#define MABTERMINATEONCLOSE @"terminateOnClose"
#define MABCPYCOlOROPTIONS @"cpyColorPref"

#define MAB_PREFIXTYPE @"prefixType"
#define MAB_NONCUSTOMPREFIX 0
#define MAB_CUSTOMPREFIX 1

@class CBAppController;

@interface CBPrefController : NSWindowController {
	IBOutlet NSButton *shouldUnblendCheckBox;
	IBOutlet NSTextField *customPrefix;
	IBOutlet NSMatrix *prefixButtons;
	IBOutlet NSMatrix *copyButtons;
	IBOutlet NSButton *shouldTerminateCheckBox;
	
	NSString *colorPrefix;
	BOOL prefixType; //prefix type is 0 for non-custom and 1 for custom
	BOOL shouldUnblend;
	BOOL shouldTerminateOnClose;
	
	
	NSUserDefaults *prefs;
	CBAppController *mainController;
}

-(id)initWithMainController:(CBAppController *)controller;

-(IBAction)setShouldUnblend:(id)sender;
-(BOOL)shouldUnblend;

-(IBAction)setColorPrefix:(id)sender;
-(NSString *)colorPrefix;

-(IBAction) setShouldTerminate:(id)sender;
-(BOOL) shouldTerminate;

-(IBAction)setColorCpyOptions:(id)sender;
-(BOOL)colorCpyOptions;

-(void) windowDidLoad;
-(void) windowWillClose:(NSNotification *)aNotification;
@end
