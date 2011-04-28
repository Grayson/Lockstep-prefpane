//
//  Lockstep.m
//  Lockstep
//
//  Created by Grayson Hansard on 4/26/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "Lockstep.h"


@implementation Lockstep
@synthesize associations = _associations;
@synthesize sourceList = _sourceList;
@synthesize associationController = _associationController;

- (void)mainViewDidLoad
{
	freopen("/Users/ghansard/Desktop/lockstep.log", "a", stderr);
	
	_sourceTableView.target = self;
	_targetTableView.target = self;

	[self reloadAssociations];
}

- (void)dealloc
{
	self.associations = nil;
	self.sourceList = nil;
	self.associationController = nil;
	
	[super dealloc];
}

- (IBAction)changeRunTime:(id)sender {
}

- (IBAction)activateLockstep:(id)sender {
}

- (IBAction)addNewFileAssociation:(id)sender {
	if (!self.associationController) {
		self.associationController = [[AddAssociationController new] autorelease];
		self.associationController.delegate = self;
	}
	[self.associationController showInView:_runEveryPopUpButton.superview];
}

- (IBAction)delete:(id)sender {
	if (sender == _sourceTableView) {
		NSInteger row = [_sourceTableView selectedRow];
		if (row == -1) return;
		
		[LockstepCLI removeAssociationsForSource:[[self.sourceList objectAtIndex:row] objectForKey:@"path"]];
		[self reloadAssociations];
	}
	else if (sender == _targetTableView) {
		NSInteger sourceRow = [_sourceTableView selectedRow];
		if (sourceRow == -1) return;
		NSString *source = [[self.sourceList objectAtIndex:sourceRow] objectForKey:@"path"];
		NSArray *targets = [[self.sourceList objectAtIndex:sourceRow] objectForKey:@"targets"];
		[[_targetTableView selectedRowIndexes] enumerateIndexesUsingBlock:^(NSUInteger index, BOOL *stop) {
			NSString *target = [targets objectAtIndex:index];
			[LockstepCLI removeAssociationForSource:source target:target];
		}];
		[self reloadAssociations];
	}
	else NSBeep();
}

- (void)addTarget:(NSString *)target forSource:(NSString *)source
{
	[LockstepCLI addAssociationForSource:source target:target];
	[self reloadAssociations];
}

- (void)reloadAssociations {
	self.associations = [LockstepCLI fileAssociations];
	
	NSArray *keys = [self.associations allKeys];
	if (!keys.count) return;
    
    NSUInteger count = keys.count, index = 0;
	NSDictionary *sources [ count ];

	NSShadow *shadow = [[NSShadow new] autorelease];
	shadow.shadowColor = [NSColor colorWithCalibratedWhite:0. alpha:0.5];
	shadow.shadowBlurRadius = 3.;
	shadow.shadowOffset = NSMakeSize(0., -2.);
	NSMutableParagraphStyle *pStyle = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
	pStyle.lineBreakMode = NSLineBreakByTruncatingHead;
	NSDictionary *titleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSFont boldSystemFontOfSize:14.0], NSFontAttributeName, 
		[NSColor whiteColor], NSForegroundColorAttributeName,
		shadow, NSShadowAttributeName,
		nil];
	NSDictionary *pathAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
		[NSColor lightGrayColor], NSForegroundColorAttributeName,
		pStyle, NSParagraphStyleAttributeName,
		nil];
    for (index = 0; index < count; index++) {
        NSString *path = [keys objectAtIndex:index];
        NSString *filename = [path lastPathComponent];
        NSString *composite = [NSString stringWithFormat:@"%@\n%@", filename, path];
		NSMutableAttributedString *as = [[[NSMutableAttributedString alloc] initWithString:composite] autorelease];
		
		[as setAttributes:titleAttributes range:NSMakeRange(0, [filename length])];
		[as setAttributes:pathAttributes range:NSMakeRange([filename length], [composite length] - [filename length])];
		
		NSArray *targets = [self.associations objectForKey:path];
		
		sources[ index ] = [NSDictionary dictionaryWithObjectsAndKeys:
			as, @"displayLabel",
			path, @"path",
			targets ? targets : [NSNull null], @"targets",
			nil];
			
    }
	NSArray *sourceList = [NSArray arrayWithObjects:sources count:count];
	self.sourceList = sourceList;
}

- (void)restartLockstep {
}

@end
