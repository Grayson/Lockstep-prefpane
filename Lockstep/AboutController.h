//
//  AboutController.h
//  Lockstep
//
//  Created by Grayson Hansard on 4/29/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SlideView.h"

@interface LockstepAboutController : NSObject {
@private
    IBOutlet SlideView *_view;
	IBOutlet NSTextView *_textView;
	NSMutableArray *_topLevelObjects;
}
@property (retain) NSMutableArray *topLevelObjects;

- (void)showInView:(NSView *)aView;
- (IBAction)close:(id)sender;

@end
