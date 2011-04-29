//
//  SlideView.h
//  Lockstep
//
//  Created by Grayson Hansard on 4/27/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface SlideView : NSView {
@private
	NSArray *_disabledControls;
}
@property (retain) NSArray *disabledControls;

- (void)showInView:(NSView *)view;
- (IBAction)close:(id)sender;

@end
