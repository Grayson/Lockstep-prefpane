
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
	bool _state;
	bool _isAnimating;
	
	ToggleViewAnimation *_animation;
}
@property (assign) bool state;
@property (assign) bool isAnimating;
@property (retain) ToggleViewAnimation *animation;

@end