//
//  ToggleView.m
//  Lockstep
//
//  Created by Grayson Hansard on 4/27/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "ToggleView.h"

@implementation ToggleViewAnimation
@synthesize toggleView = _toggleView;
- (void)dealloc {
	self.toggleView = nil;
	[super dealloc];
}
- (void)setCurrentProgress:(NSAnimationProgress)progress {
	[super setCurrentProgress:progress];
	[self.toggleView display];
}
@end


@implementation ToggleView
@synthesize state = _state;
@synthesize isAnimating = _isAnimating;
@synthesize animation = _animation;

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
	self.animation = nil;
	
    [super dealloc];
}

- (void)mouseUp:(NSEvent *)theEvent
{
	self.state = !self.state;
	
	self.isAnimating = YES;
	BOOL shiftIsPressed = (theEvent.modifierFlags & NSShiftKeyMask) >> 17;
	self.animation = [[[ToggleViewAnimation alloc] initWithDuration:shiftIsPressed ? 0.5 : 0.1 animationCurve:NSAnimationEaseInOut] autorelease];
	self.animation.toggleView = self;
    [self.animation startAnimation];
	
	if ([self.target respondsToSelector:self.action]) [self.target performSelector:self.action withObject:self];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect rect = self.bounds;
    
	NSBezierPath *background = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:5. yRadius:5.];
	
	NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.8 alpha:1.] endingColor:[NSColor colorWithCalibratedWhite:0.4 alpha:1.]];
	[gradient drawInBezierPath:background angle:90.];
	[gradient release];
	
	[[NSColor controlShadowColor] set];
	[background stroke];
	
	NSRect buttonRect = self.bounds;
	buttonRect.size.width = buttonRect.size.width / 2. - 1.;
	buttonRect.size.height -= 2.;
	buttonRect.origin.y += 1.;
	
	if (self.isAnimating) {
		float xPos = rect.size.width / 2. * self.animation.currentProgress;
		if (self.state) buttonRect.origin.x = xPos;
		else buttonRect.origin.x = rect.size.width / 2. - xPos;
	}
	else {
		if (self.state) buttonRect.origin.x = rect.size.width / 2.;
		else buttonRect.origin.x += 1;
	}
	
	NSBezierPath *button = [NSBezierPath bezierPathWithRoundedRect:buttonRect xRadius:4. yRadius:4.];
	
	NSGradient *buttonGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.7 alpha:1.] endingColor:[NSColor colorWithCalibratedWhite:0.9 alpha:1.]];
	[buttonGradient drawInBezierPath:button angle:90.];
	[buttonGradient release];
	
	[[NSColor lightGrayColor] set];
	[button stroke];
}

@end
