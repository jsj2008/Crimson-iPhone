//
//  UIView+FirstResponder.m
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/24/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "UIView+FirstResponder.h"

@implementation UIView (firstResponder)

- (UIView *)findFirstResponder {
	
	if ([self isFirstResponder]) {
		return self;
	}
	
	for (UIView *subview in [self subviews]) {
		UIView *firstResponder = [subview findFirstResponder];
		if (nil != firstResponder) {
			return firstResponder;
		}
	}
	
	return nil;
}


@end
