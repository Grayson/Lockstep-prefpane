//
//  SlideView.m
//  Lockstep
//
//  Created by Grayson Hansard on 4/27/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "SlideView.h"


@implementation SlideView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect rect = self.bounds;
    
	NSShadow *shadow = [NSShadow new];
	shadow.shadowOffset = NSMakeSize(0., -2.);
	shadow.shadowBlurRadius = 5.;
	
	rect.origin.x += 5.;
	rect.size.width -= 10.;
	rect.origin.y += 5.;
	rect.size.height -= 5.;
	
	[[NSColor windowBackgroundColor] set];
	[shadow set];
	[[NSBezierPath bezierPathWithRect:rect] fill];
	
	[shadow release];
}

@end
