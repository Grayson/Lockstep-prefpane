//
//  Lockstep.h
//  Lockstep
//
//  Created by Grayson Hansard on 4/26/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <PreferencePanes/PreferencePanes.h>
#import "LockstepCLI.h"
#import "AddAssociationController.h"
#import "ToggleView.h"
#import "AboutController.h"
#import "MultiColumnHeaderView.h"

@interface Lockstep : NSPreferencePane {
@private
	IBOutlet NSTableView *_sourceTableView, *_targetTableView;
	IBOutlet NSPopUpButton *_runEveryPopUpButton;
	IBOutlet NSArrayController *_sourceArrayController;
	IBOutlet ToggleView *_toggleView;
	
	NSDictionary *_associations;
    NSArray *_sourceList;
	AddAssociationController *_associationController;
	LockstepAboutController *_aboutController;
}
@property (retain) NSDictionary *associations;
@property (retain) NSArray *sourceList;
@property (retain) AddAssociationController *associationController;
@property (retain) LockstepAboutController *aboutController;

- (void)mainViewDidLoad;

- (IBAction)changeRunTime:(id)sender;
- (IBAction)activateLockstep:(id)sender;
- (IBAction)addNewFileAssociation:(id)sender;
- (IBAction)showAboutSheet:(id)sender;

- (IBAction)delete:(id)sender;

- (void)reloadAssociations;
- (void)restartLockstep;

@end
