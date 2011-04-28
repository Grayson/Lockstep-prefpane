//
//  SourceTableView.m
//  Lockstep
//
//  Created by Grayson Hansard on 4/27/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "SourceTableView.h"


@implementation SourceTableView

- (id)initWithFrame:(NSRect)frame
{
	self = [super initWithFrame:frame];
	if (!self) return nil;
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aCoder
{
	self = [super initWithCoder:aCoder];
	if (!self) return nil;
	
	NSBundle *b = [NSBundle bundleWithIdentifier:@"com.fromconcentratesoftware.Lockstep"];
	NSImage *dots = [[[NSImage alloc] initByReferencingFile:[b pathForImageResource:@"dots.png"]] autorelease];
	[self setBackgroundColor:[NSColor colorWithPatternImage:dots]];
	
	
	return self;
}

- (void)highlightSelectionInClipRect:(NSRect)clipRect {
	[[NSColor redColor] set];
	NSIndexSet *set = [self selectedRowIndexes];
	[set enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
		NSRect rowRect = [self rectOfRow:idx];
		NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[[NSColor selectedControlColor] shadowWithLevel:0.3] endingColor:[NSColor alternateSelectedControlColor]];
		[gradient drawInRect:rowRect angle:90.];
		
		[[NSColor selectedControlColor] set];
		[NSBezierPath bezierPathWithRect:NSMakeRect(rowRect.origin.x, rowRect.origin.y + rowRect.size.height -2., rowRect.size.width, 2.)];
	}];
}

- (id)_highlightColorForCell:(NSCell *)cell
{
  return nil;
}
@end
