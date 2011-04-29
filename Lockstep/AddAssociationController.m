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
		NSBundle *b = [NSBundle bundleWithIdentifier:@"com.fromconcentratesoftware.Doppelganger"];
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
	[self.topLevelObjects makeObjectsPerformSelector:@selector(release)];
	self.topLevelObjects = nil;
	
	self.delegate = nil;
	
    [super dealloc];
}

- (void)showInView:(NSView *)view {
	_pathToSourceField.stringValue = @"";
	_pathToTargetField.stringValue = @"";
	[_chooseTargetButton setEnabled:NO];
	[_addButton setEnabled:NO];
	
	[_view showInView:view];
}

- (void)close {
	[_view close:nil];
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
