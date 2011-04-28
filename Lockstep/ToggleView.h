
//
//  ToggleView.h
//  Lockstep
//
//  Created by Grayson Hansard on 4/27/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ToggleViewAnimation : NSAnimation {
@private
	id _toggleView;
}
@property (retain) id toggleView;
@end


@interface ToggleView : NSControl {
@private
	BOOL _state;
	BOOL _isAnimating;
	
	ToggleViewAnimation *_animation;
}
@property (assign) BOOL state;
@property (assign) BOOL isAnimating;
@property (retain) ToggleViewAnimation *animation;

@end