//
//  MultiColumnHeaderView.m
//  Lockstep
//
//  Created by Grayson Hansard on 5/5/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "MultiColumnHeaderView.h"


@implementation MultiColumnHeaderView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initAsCornerViewWithFrame:(NSRect)aRect {
	self = [super initWithFrame:aRect];
	if (!self) return nil;
	
	_isCornerView = YES;
	return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect {
	NSRect b = self.bounds;

	// Draw background
	NSColor *startingColor = [NSColor colorWithCalibratedWhite:1. alpha:1.];
	NSColor *endingColor = [NSColor colorWithCalibratedWhite:0.8 alpha:1.];
	NSGradient *g = [[[NSGradient alloc] initWithStartingColor:startingColor endingColor:endingColor] autorelease];
	[g drawInRect:b angle:90.];
	
	// Draw borders
	[[NSColor colorWithCalibratedWhite:0.7 alpha:1.] set];
	[[NSBezierPath bezierPathWithRect:NSMakeRect(b.origin.x, b.origin.y - 0.5, b.size.width, 1.)] stroke];
	[[NSBezierPath bezierPathWithRect:NSMakeRect(b.origin.x, b.origin.y + b.size.height - 1. + 0.5, b.size.width, 1.)] stroke];
	
	if (_isCornerView)
		[[NSBezierPath bezierPathWithRect:NSMakeRect(b.origin.x + b.size.width - 1. + 0.5, b.origin.y, 1., b.size.height)] stroke];
	
	// Draw text
	NSString *text = nil;
	for (NSTableColumn *col in self.tableView.tableColumns) {
		text = [col.headerCell stringValue];
		if (text && ![text isEqualToString:@""]) break;
	}
	NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSFont systemFontOfSize:12.], NSFontAttributeName,
        [NSColor colorWithCalibratedWhite:0.2 alpha:1.], NSForegroundColorAttributeName,
		nil];
	NSSize size = [text sizeWithAttributes:attrs];
	[text drawAtPoint:NSMakePoint(b.origin.x + (b.size.width - size.width)/2., b.origin.y + (b.size.height - size.height)/2.)
       withAttributes:attrs];	
	
}

@end
