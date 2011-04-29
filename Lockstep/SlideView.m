//
//  SlideView.m
//  Lockstep
//
//  Created by Grayson Hansard on 4/27/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "SlideView.h"


@implementation SlideView
@synthesize disabledControls = _disabledControls;

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
	self.disabledControls = nil;
	
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


- (void)showInView:(NSView *)view {
	if ([self superview]) [self removeFromSuperview];
	[view addSubview:self];
	
	NSPoint origin = view.frame.origin;
	NSSize size = view.frame.size;
	
	NSRect startFrame = self.frame;
	NSRect endFrame = self.frame;
	
	float xPos = (origin.x + size.width - startFrame.size.width) / 2.;
	
	startFrame.origin = NSMakePoint( xPos, origin.y + size.height );
	endFrame.origin = NSMakePoint( xPos, origin.y + size.height - endFrame.size.height );
	
	// Do animations
	NSArray *viewAnimations = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
		self, NSViewAnimationTargetKey,
		[NSValue valueWithRect: startFrame], NSViewAnimationStartFrameKey,
		[NSValue valueWithRect: endFrame], NSViewAnimationEndFrameKey,
		nil], nil];
	NSViewAnimation *animation = [[[NSViewAnimation alloc] initWithViewAnimations:viewAnimations] autorelease];
	animation.duration = 0.2;
	[animation startAnimation];
	
	// Disable the controls on the original view
	NSMutableArray *disabled = [NSMutableArray array];
	for (NSView *subview in [[view superview] subviews]) {
		if (subview == self) continue;
		if (![subview isKindOfClass:[NSControl class]]) continue; // only NSControls can be enabled.
		if (![(NSControl *)subview isEnabled]) continue; // skip the already disabled ones
		[(NSControl *)subview setEnabled:NO];
		[disabled addObject:subview];
	}
}

- (IBAction)close:(id)sender {
	NSRect startFrame = self.frame;
	NSRect endFrame = self.frame;
	
	endFrame.origin.y = endFrame.origin.y + endFrame.size.height;
	
	NSArray *viewAnimations = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
		self, NSViewAnimationTargetKey,
		[NSValue valueWithRect: startFrame], NSViewAnimationStartFrameKey,
		[NSValue valueWithRect: endFrame], NSViewAnimationEndFrameKey,
		nil], nil];
	NSViewAnimation *animation = [[[NSViewAnimation alloc] initWithViewAnimations:viewAnimations] autorelease];
	animation.duration = 0.2;
	animation.animationBlockingMode = NSAnimationBlocking;
	[animation startAnimation];
	
	[self removeFromSuperview];
	
	// Re-enable the disabled controls
	for (NSControl *control in self.disabledControls) {
		[control setEnabled:YES];
	}
	self.disabledControls = nil;
}

@end
