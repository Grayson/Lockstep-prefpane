//
//  MultiColumnHeaderView.h
//  Lockstep
//
//  Created by Grayson Hansard on 5/5/11.
//  Copyright 2011 From Concentrate Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MultiColumnHeaderView : NSTableHeaderView {
@private
	BOOL _isCornerView;
}

- (id)initAsCornerViewWithFrame:(NSRect)aRect;

@end
