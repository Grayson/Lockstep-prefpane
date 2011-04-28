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

- (BOOL)state
{
	return _state;
}

- (void)setState:(BOOL)newState
{
	_state = newState;
	
	self.isAnimating = YES;
	BOOL shiftIsPressed = ([NSApp currentEvent].modifierFlags & NSShiftKeyMask) >> 17;
	self.animation = [[[ToggleViewAnimation alloc] initWithDuration:shiftIsPressed ? 0.5 : 0.1 animationCurve:NSAnimationEaseInOut] autorelease];
	self.animation.toggleView = self;
    [self.animation startAnimation];
	self.animation = nil; // Done animating.
}

- (void)mouseUp:(NSEvent *)theEvent
{
	self.state = !self.state;

	if ([self.target respondsToSelector:self.action]) [self.target performSelector:self.action withObject:self];
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSRect rect = self.bounds;
    
	// Draw in the background
	NSBezierPath *background = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:5. yRadius:5.];
	
	NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.8 alpha:1.] endingColor:[NSColor colorWithCalibratedWhite:0.4 alpha:1.]];
	[gradient drawInBezierPath:background angle:90.];
	[gradient release];	
	
	// Draw the text
	NSShadow *textShadow = [[NSShadow new] autorelease];
	textShadow.shadowOffset = NSMakeSize(0., -1.);
	textShadow.shadowBlurRadius = 1.;
	NSDictionary *textAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSColor whiteColor], NSForegroundColorAttributeName,
		[NSFont boldSystemFontOfSize:14.], NSFontAttributeName,
		textShadow, NSShadowAttributeName,
		nil];
	NSString *onText = NSLocalizedString(@"On", @"ToggleView label");
	NSSize onSize = [onText sizeWithAttributes:textAttrs];
	float onXPos = (rect.size.width / 4.) - (onSize.width / 2.) + rect.origin.x;
	float onYPos = (rect.size.height - onSize.height) / 2 + rect.origin.y;
	[onText drawAtPoint:NSMakePoint(onXPos, onYPos) withAttributes:textAttrs];
	
	NSString *offText = NSLocalizedString(@"Off", @"ToggleView label");
	NSSize offSize = [offText sizeWithAttributes:textAttrs];
	float offXPos = (rect.size.width / 4.) - (offSize.width / 2.) + rect.origin.x + (rect.size.width / 2.);
	float offYPos = (rect.size.height - offSize.height) / 2. + rect.origin.y;
	[offText drawAtPoint:NSMakePoint(offXPos, offYPos) withAttributes:textAttrs];
	
	
	
	// Draw the button
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
		else buttonRect.origin.x += 1.;
	}
	
	NSBezierPath *button = [NSBezierPath bezierPathWithRoundedRect:buttonRect xRadius:3. yRadius:3.];
	
	[NSGraphicsContext saveGraphicsState];
	NSShadow *buttonShadow = [NSShadow new];
	buttonShadow.shadowBlurRadius = 3.;
	buttonShadow.shadowOffset = NSMakeSize(0., 0.);
	buttonShadow.shadowColor = [NSColor blackColor];
	[buttonShadow set];
	[button fill];
	[buttonShadow release];
	[NSGraphicsContext restoreGraphicsState];
	
	NSGradient *buttonGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:0.85 alpha:1.] endingColor:[NSColor colorWithCalibratedWhite:0.95 alpha:1.]];
	[buttonGradient drawInBezierPath:button angle:90.];
	[buttonGradient release];
	
	// [[NSColor lightGrayColor] set];
	// [button stroke];
	
	// Draw a small border
	[[NSColor controlShadowColor] set];
	[background stroke];
}

@end
