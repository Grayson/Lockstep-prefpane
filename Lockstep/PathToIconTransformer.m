//
//  PathToIconTransformer.m
//  Lockstep
//
//  Created by Grayson Hansard on 4/27/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import "PathToIconTransformer.h"


@implementation PathToIconTransformer

+(void)load {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	[NSValueTransformer setValueTransformer:[[[self class] new] autorelease] forName:NSStringFromClass([self class])];
	[pool drain];
}

+ (Class)transformedValueClass { return [NSImage class]; }
+ (BOOL)allowsReverseTransformation { return NO; }
- (id)transformedValue:(id)value {
    NSImage *img = [[NSWorkspace sharedWorkspace] iconForFile:value];
    [img setScalesWhenResized:YES];
	return (value == nil) ? nil : img;
}

@end
