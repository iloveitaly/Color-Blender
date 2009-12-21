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

#import "CBMenuController.h"
#import "CBAppController.h"
#import "CBRGBColor.h"
#import "CBPrefController.h"

@implementation CBMenuController
-(id) init {
	if(self = [super init]) {
		newDockMenu = [[NSMenu alloc] init];
		leftText = [[NSMenuItem alloc] initWithTitle:@"Copy Left Hex Value" action:@selector(copyLeft) keyEquivalent:@""];
		rightText = [[NSMenuItem alloc] initWithTitle:@"Copy Right Hex Value" action:@selector(copyRight) keyEquivalent:@""];
		mixedText = [[NSMenuItem alloc] initWithTitle:@"Copy Mixed Hex Value" action:@selector(copyMixed) keyEquivalent:@""];
		
		[leftText setTarget:self];
		[rightText setTarget:self];
		[mixedText setTarget:self];
		[newDockMenu addItem:leftText];
		[newDockMenu addItem:mixedText];
		[newDockMenu addItem:rightText];
	}
	
	return self;
}

-(id)initWithController:(id)control {
	[self init];
	controller = control;
	
	return self;
}

-(void)copyLeft {
	NSPasteboard *board = [NSPasteboard generalPasteboard];
	[board declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
	if([[NSUserDefaults standardUserDefaults] boolForKey:MABCPYCOlOROPTIONS]) //then we want hex string
		[board setString:[[controller leftRGBColor] HTMLStringValue] forType:NSStringPboardType];
	else
		[board setString:[[controller leftRGBColor] RGBStringValue] forType:NSStringPboardType];
	
}

-(void)copyRight {
	NSPasteboard *board = [NSPasteboard generalPasteboard];
	[board declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
	if([[NSUserDefaults standardUserDefaults] boolForKey:MABCPYCOlOROPTIONS]) //then we want hex string
		[board setString:[[controller rightRGBColor] HTMLStringValue] forType:NSStringPboardType];
	else
		[board setString:[[controller rightRGBColor] RGBStringValue] forType:NSStringPboardType];
	
}

-(void)copyMixed {
	NSPasteboard *board = [NSPasteboard generalPasteboard];
	[board declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:self];
	
	if([[NSUserDefaults standardUserDefaults] boolForKey:MABCPYCOlOROPTIONS]) //then we want hex string
		[board setString:[[controller mixedRGBColor] HTMLStringValue] forType:NSStringPboardType];
	else
		[board setString:[[controller mixedRGBColor] RGBStringValue] forType:NSStringPboardType];
}

-(NSMenu *)getDockMenu {
	if([[NSUserDefaults standardUserDefaults] boolForKey:MABCPYCOlOROPTIONS]) {//then we want the hex cpy
		[leftText setTitle:@"Copy Left Hex Value"];
		[rightText setTitle:@"Copy Right Hex Value"];
		[mixedText setTitle:@"Copy Mixed Hex Value"];
	} else {//then we want RGB
		[leftText setTitle:@"Copy Left RGB Value"];
		[rightText setTitle:@"Copy Right RGB Value"];
		[mixedText setTitle:@"Copy Mixed RGB Value"];		
	}
	
	return newDockMenu;
}

-(void) goToHomePage {
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:MABHOMEPAGE]];
}

-(void) getGPL {
	[[NSWorkspace sharedWorkspace] openFile:[[NSBundle mainBundle] pathForResource:@"gpl" ofType:@"txt"]];
}
@end
