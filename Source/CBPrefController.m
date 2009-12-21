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

#import "CBPrefController.h"
#import "CBAppController.h"

@implementation CBPrefController
-(id)initWithMainController:(CBAppController *)controller {	
	if(self = [self init]) {
		mainController = controller;
	}
	
	return self;
}

-(id)init {
	self = [super initWithWindowNibName:@"Preferences"];
	
	if(self) {
		prefs = [NSUserDefaults standardUserDefaults];
	}
	
	return self;
}

//init all the vars and mirror the display on the UI
-(void) windowDidLoad {
	//get the should blend var
	shouldUnblend = [prefs boolForKey:MABSHOULDUNBLEND];
	[shouldUnblendCheckBox setState:shouldUnblend];
	
	//get the should terminate
	shouldTerminateOnClose = [prefs boolForKey:MABTERMINATEONCLOSE];
	[shouldTerminateCheckBox setState:shouldTerminateOnClose];
	
	//get the custom prefix
	colorPrefix = [prefs objectForKey:MABCOLORPREFIX];
	prefixType = [prefs boolForKey:MAB_PREFIXTYPE];
	
	//set the visual display to mirror the data in the preferences
	if(prefixType) {//then its a custom prefix
		[customPrefix setEnabled:YES];
		[customPrefix setStringValue:colorPrefix];
		[prefixButtons selectCellAtRow:2 column:0];
	} else {//then its one of the premade prefixes
		[customPrefix setEnabled:NO];
		if([colorPrefix isEqualToString:@"0x"]) //then its prefix 0
			[prefixButtons selectCellAtRow:0 column:0];
		else if([colorPrefix isEqualToString:@"#"]) //then its prefix 1
			[prefixButtons selectCellAtRow:1 column:0];
	}
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(windowWillClose:) 
												 name:@"windowDidClose" 
											   object:[self window]];
}

//--------------------
//Application closing on termination
//--------------------
-(IBAction) setShouldTerminate:(id)sender {
	shouldTerminateOnClose = [sender state];
	[prefs setBool:shouldTerminateOnClose forKey:MABTERMINATEONCLOSE];
}

-(BOOL) shouldTerminate {
	return shouldTerminateOnClose;
}

//--------------------
//Set blending methods
//--------------------
-(IBAction)setShouldUnblend:(id)sender {
	[prefs setBool:[sender state] forKey:MABSHOULDUNBLEND];
	[mainController updateShouldUnblendPrefs];
}

-(BOOL)shouldUnblend {
	return shouldUnblend;
}

//--------------------
//Color prefix methods
//--------------------
-(IBAction)setColorPrefix:(id)sender {
	if(sender == customPrefix) {//then this method is being called from the custom text field
		[prefs setObject:[sender stringValue] forKey:MABCOLORPREFIX];
		[prefs setBool:MAB_CUSTOMPREFIX forKey:MAB_PREFIXTYPE];
		[mainController updateColorPrefix];
		return;
	}
	
	switch([sender selectedRow]) {
		case 0: //0x prefix
			[prefs setObject:@"0x" forKey:MABCOLORPREFIX];
			[prefs setBool:MAB_NONCUSTOMPREFIX forKey:MAB_PREFIXTYPE];
			[customPrefix setEnabled:NO];
			[mainController updateColorPrefix];
		break;
		case 1: //# prefix
			[prefs setObject:@"#" forKey:MABCOLORPREFIX];
			[prefs setBool:MAB_NONCUSTOMPREFIX forKey:MAB_PREFIXTYPE];
			[customPrefix setEnabled:NO];
			[mainController updateColorPrefix];
		break;
		case 2: //custom prefix
		[customPrefix setEnabled:YES];
		break;
	}
}

-(NSString *)colorPrefix {
	return [prefs objectForKey:MABCOLORPREFIX];
}

//--------------------
//Color dock copying methods
//--------------------
-(IBAction)setColorCpyOptions:(id)sender {
	switch([sender selectedRow]) {
		case 0: //cpy hex string
		[prefs setBool:YES forKey:MABCPYCOlOROPTIONS];
		break;
		case 1: //cpy rgb string
		[prefs setBool:NO forKey:MABCPYCOlOROPTIONS];
		break;
	}
}

-(BOOL)colorCpyOptions {
	return [prefs boolForKey:MABCPYCOlOROPTIONS];
}

//synch the prefs if the window closes
-(void) windowWillClose:(NSNotification *)aNotification {
	[prefs synchronize];
}
@end