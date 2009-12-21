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

#import "CBRGBColor.h"
#import "CBPrefController.h"

//needed for the C string stuff
#import <string.h>
#import <stdio.h>

#import <math.h>

@implementation CBRGBColor
-(id)init {	
	if(self = [super init]) {
		r = 0.0F;
		g = 0.0F;
		b = 0.0F;
		
		//init the dynamic prefix stuff
		NSString *prefix = [[NSUserDefaults standardUserDefaults] objectForKey:MABCOLORPREFIX];
		htmlString = [[NSString alloc] initWithFormat:@"%@%%.2x%%02x%%02x", prefix];
		
		inputString = (char *) malloc([htmlString length]+1); //+1 for the '\0'
		strcpy(inputString, [prefix cString]);
		strcat(inputString, "%2x%2x%2x");
		
		rgbString = [[NSString alloc] initWithFormat:@"%%i, %%i, %%i"];
	}
	
	return self;
}

-(id)initWithString:(NSString *)colorVal {
	if(self = [self init]) {
		sscanf([colorVal cString], inputString, &r, &g, &b);
		rgbColorValue = [NSColor colorWithDeviceRed:(float)r/255.0
											  green:(float)g/255.0
											   blue:(float)b/255.0
											  alpha:1.0F];
		[rgbColorValue retain];
		[self getRGBValues];
	}
	
	return self;
}

-(id)initWithColor:(NSColor *)colorVal {
	if(self = [self init]) {
		if([colorVal respondsToSelector:@selector(colorSpace)] && [[colorVal colorSpace] colorSpaceModel] == NSRGBColorSpaceModel) {
			rgbColorValue = colorVal;
		} else {
			rgbColorValue = [colorVal colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
		}
		
		[rgbColorValue retain];
		[self getRGBValues];
	}
	
	return self;
}

-(void)getRGBValues {
	r = (int)lround([rgbColorValue redComponent]*255.0F);
	g = (int)lround([rgbColorValue greenComponent]*255.0F);
	b = (int)lround([rgbColorValue blueComponent]*255.0F);
}

-(NSString *)HTMLStringValue {
	NSString *htmlValString = [NSString stringWithFormat:htmlString, r, g, b];
	return htmlValString;
}

-(NSString *)RGBStringValue {
	NSString *rgbValString = [NSString stringWithFormat:rgbString, r, g, b];
	return rgbValString;
}

-(unsigned int) r {
	return r;
}

-(unsigned int) g {
	return g;
}

-(unsigned int) b {
	return b;
}

-(NSColor *)colorVal {
	return rgbColorValue;
}

-(NSString *) description {
	return [NSString stringWithFormat:@"RGB Color %i:%i:%i", r, g, b];
}

-(void)dealloc {
	free(inputString);
	[rgbString release];
	[htmlString release];
	[rgbColorValue release];
	[super dealloc];
}
@end
