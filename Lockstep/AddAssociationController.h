//
//  AddAssociationController.h
//  Lockstep
//
//  Created by Grayson Hansard on 4/27/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlideView.h"

@interface AddAssociationController : NSObject {
@private
	IBOutlet SlideView *_view;
	IBOutlet NSButton *_chooseTargetButton;
	IBOutlet NSButton *_addButton;
	IBOutlet NSTextField *_pathToSourceField;
	IBOutlet NSTextField *_pathToTargetField;
	
	NSMutableArray *_topLevelObjects;
	
	id _delegate;
}
@property (retain) NSMutableArray *topLevelObjects;
@property (retain) id delegate;

- (void)showInView:(NSView *)view;
- (void)close;

- (IBAction)chooseSource:(id)sender;
- (IBAction)chooseTarget:(id)sender;

- (IBAction)add:(id)sender;
- (IBAction)cancel:(id)sender;

@end
