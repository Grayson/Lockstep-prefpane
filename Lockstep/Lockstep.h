//
//  Lockstep.h
//  Lockstep
//
//  Created by Grayson Hansard on 4/26/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>


@interface Lockstep : NSPreferencePane {
@private
	IBOutlet NSTableView *_sourceTableView, *_targetTableView;
	IBOutlet NSPopUpButton *_runEveryPopUpButton;
}

- (void)mainViewDidLoad;

- (IBAction)changeRunTime:(id)sender;
- (IBAction)activateLockstep:(id)sender;

@end
