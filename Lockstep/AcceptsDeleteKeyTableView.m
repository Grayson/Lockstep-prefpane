//
//  AcceptsDeleteKeyTableView.m
//  Lockstep
//
//  Created by Grayson Hansard on 4/27/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "AcceptsDeleteKeyTableView.h"


@implementation AcceptsDeleteKeyTableView

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)keyDown:(NSEvent *)theEvent {
    if (theEvent.keyCode == 51 && [self.target respondsToSelector:@selector(delete:)]) // Delete key event
		[self.target performSelector:@selector(delete:) withObject:self];
}

@end
