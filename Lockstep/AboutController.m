//
//  AboutController.m
//  Lockstep
//
//  Created by Grayson Hansard on 4/29/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "AboutController.h"


@implementation LockstepAboutController
@synthesize topLevelObjects = _topLevelObjects;

- (id)init
{
    self = [super init];
    if (self) {
		NSMutableArray *topLevelObjects = [NSMutableArray array];
		NSDictionary *nameTable = [NSDictionary dictionaryWithObjectsAndKeys:
			self, NSNibOwner,
			topLevelObjects, NSNibTopLevelObjects,
			nil];
		NSBundle *b = [NSBundle bundleForClass:[self class]];
		[b loadNibFile:@"AboutView" externalNameTable:nameTable withZone:[self zone]];
		
		NSLog(@"Found the bundle? %@", b);
		
		self.topLevelObjects = topLevelObjects;
    }
    
    return self;
}

- (void)awakeFromNib
{
	NSBundle *b = [NSBundle bundleForClass:[self class]];
	NSString *creditsPath = [b pathForResource:@"Credits" ofType:@"rtf"];
	NSAttributedString *as = [[[NSAttributedString alloc] initWithPath:creditsPath documentAttributes:nil] autorelease];
	[_textView.textStorage setAttributedString: as];
}

- (void)dealloc
{
	[self.topLevelObjects makeObjectsPerformSelector:@selector(release)];
	self.topLevelObjects = nil;
    [super dealloc];
}

- (void)showInView:(NSView *)aView {
	[_view showInView:aView];
}

- (IBAction)close:(id)sender {
	[_view close:sender];
}

@end
