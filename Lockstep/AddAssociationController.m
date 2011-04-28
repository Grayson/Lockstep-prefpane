//
//  AddAssociationController.m
//  Lockstep
//
//  Created by Grayson Hansard on 4/27/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "AddAssociationController.h"


@implementation AddAssociationController
@synthesize topLevelObjects = _topLevelObjects;
@synthesize delegate = _delegate;

- (id)init
{
    self = [super init];
    if (self) {
		NSMutableArray *topLevelObjects = [NSMutableArray array];
		NSDictionary *nameTable = [NSDictionary dictionaryWithObjectsAndKeys:
			self, NSNibOwner,
			topLevelObjects, NSNibTopLevelObjects,
			nil];
		NSBundle *b = [NSBundle bundleWithIdentifier:@"com.fromconcentratesoftware.Lockstep"];
		[b loadNibFile:@"AddAssociationView" externalNameTable:nameTable withZone:[self zone]];
		
		self.topLevelObjects = topLevelObjects;
    }
    
    return self;
}

- (void)awakeFromNib
{
	_pathToSourceField.stringValue = @"";
	_pathToTargetField.stringValue = @"";
}

- (void)dealloc
{
	[_topLevelObjects makeObjectsPerformSelector:@selector(release)];
	self.topLevelObjects = nil;
	
	self.delegate = nil;
	
    [super dealloc];
}

- (void)showInView:(NSView *)view {
	_pathToSourceField.stringValue = @"";
	_pathToTargetField.stringValue = @"";
	[_chooseTargetButton setEnabled:NO];
	[_addButton setEnabled:NO];
	
	if ([_view superview]) [_view removeFromSuperview];
	[view addSubview:_view];
	
	NSPoint origin = view.frame.origin;
	NSSize size = view.frame.size;
	
	NSRect startFrame = _view.frame;
	NSRect endFrame = _view.frame;
	
	float xPos = (origin.x + size.width - startFrame.size.width) / 2.;
	
	startFrame.origin = NSMakePoint( xPos, origin.y + size.height );
	endFrame.origin = NSMakePoint( xPos, origin.y + size.height - endFrame.size.height );
	
	// Do animations
	NSArray *viewAnimations = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
		_view, NSViewAnimationTargetKey,
		[NSValue valueWithRect: startFrame], NSViewAnimationStartFrameKey,
		[NSValue valueWithRect: endFrame], NSViewAnimationEndFrameKey,
		nil], nil];
	NSViewAnimation *animation = [[[NSViewAnimation alloc] initWithViewAnimations:viewAnimations] autorelease];
	animation.duration = 0.2;
	[animation startAnimation];
}

- (void)close {
	NSRect startFrame = _view.frame;
	NSRect endFrame = _view.frame;
	
	endFrame.origin.y = endFrame.origin.y + endFrame.size.height;
	
	NSArray *viewAnimations = [NSArray arrayWithObjects:[NSDictionary dictionaryWithObjectsAndKeys:
		_view, NSViewAnimationTargetKey,
		[NSValue valueWithRect: startFrame], NSViewAnimationStartFrameKey,
		[NSValue valueWithRect: endFrame], NSViewAnimationEndFrameKey,
		nil], nil];
	NSViewAnimation *animation = [[[NSViewAnimation alloc] initWithViewAnimations:viewAnimations] autorelease];
	animation.duration = 0.2;
	animation.animationBlockingMode = NSAnimationBlocking;
	[animation startAnimation];
	
	[_view removeFromSuperview];
}

- (IBAction)chooseSource:(id)sender {
	NSOpenPanel *op = [NSOpenPanel openPanel];
	[op setCanChooseDirectories:YES];
	[op setCanChooseFiles:YES];
	if ([op runModal] != NSOKButton) return;
	
	_pathToSourceField.stringValue = [NSString stringWithString:op.filename];
	
	[_chooseTargetButton setEnabled:YES];
}

- (IBAction)chooseTarget:(id)sender {
	NSOpenPanel *op = [NSOpenPanel openPanel];
	[op setCanChooseDirectories:YES];
	[op setCanChooseFiles:YES];
	[op setCanCreateDirectories:YES];
	if ([op runModal] != NSOKButton) return;
	
	_pathToTargetField.stringValue = [NSString stringWithString:op.filename];
	
	[_addButton setEnabled:YES];
}

- (IBAction)add:(id)sender {
	if (![self.delegate respondsToSelector:@selector(addTarget:forSource:)]) {
		[self close];
		return;
	}
	
	NSString *target = [NSString stringWithString:_pathToTargetField.stringValue];
	NSString *source = [NSString stringWithString:_pathToSourceField.stringValue];
	[self.delegate performSelector:@selector(addTarget:forSource:) withObject:target withObject:source];
	
	[self close];
}

- (IBAction)cancel:(id)sender {
	[self close];
}

@end
