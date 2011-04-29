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
	BOOL _adjustedForShadow;
}
@property (retain) NSArray *disabledControls;
@property (assign) BOOL adjustedForShadow;

- (void)showInView:(NSView *)view;
- (IBAction)close:(id)sender;

- (void)_adjustForShadow;

@end
