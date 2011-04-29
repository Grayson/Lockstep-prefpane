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
@synthesize adjustedForShadow = _adjustedForShadow;

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
	return self;
}

- (void)dealloc
{
	self.disabledControls = nil;
	
    [super dealloc];
}

- (void)_adjustForShadow {
	NSRect f = self.frame;
	f.size.width += 10;
	f.size.height += 5;
	self.frame = f;
	
	void (^adjustOrigin)(NSView *, NSUInteger, BOOL *) = ^(NSView * view, NSUInteger index, BOOL *stop) {
		NSRect f = view.frame;
		// f.origin.y -= 5;
		f.origin.x += 5;
		view.frame = f;
	};
	[[self subviews] enumerateObjectsUsingBlock:adjustOrigin];
	self.adjustedForShadow = YES;
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
	
	// [[[NSColor windowBackgroundColor] colorWithAlphaComponent:0.9] set];
	[[NSColor colorWithCalibratedRed:0xff/0xe3 green:0xff/0xe6 blue:0xff/0xea alpha:0.9] set];
	[shadow set];
	[[NSBezierPath bezierPathWithRect:rect] fill];
	
	[shadow release];
	
	// #E3E6EA
}


- (void)showInView:(NSView *)view {
	if ([self superview]) [self removeFromSuperview];
	if (!self.adjustedForShadow) [self _adjustForShadow];
	
	NSPoint origin = view.frame.origin;
	NSSize size = view.frame.size;
	
	NSRect startFrame = self.frame;
	NSRect endFrame = self.frame;
	
	float xPos = (origin.x + size.width - startFrame.size.width) / 2.;
	
	startFrame.origin = NSMakePoint( xPos, origin.y + size.height );
	endFrame.origin = NSMakePoint( xPos, origin.y + size.height - endFrame.size.height );
	
	self.frame = startFrame;
	
	[view addSubview:self];
	
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
	__block NSMutableArray *disabled = [NSMutableArray array];
	__block void (^disableSubviews)(NSView *) = ^(NSView *view) {
		for (NSView *subview in [view subviews]) {
			if (subview == self) continue;
			if (![subview isKindOfClass:[NSControl class]]) {
				disableSubviews(subview); // Recurse deeper
				continue;
			}
			if (![(NSControl *)subview isEnabled]) continue; // skip the already disabled ones
			[(NSControl *)subview setEnabled:NO];
			[disabled addObject:subview];
		}
	};
	disableSubviews([self superview]);
	self.disabledControls = disabled;
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
