//
//  NSObjectAdditions.m
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/25/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "NSObjectAdditions.h"


#import <objc/runtime.h>

@implementation NSObject(ClassName)

- (NSString *)className 
{
	return [NSString stringWithUTF8String:class_getName([self class])];
}

+ (NSString *)className
{
	return [NSString stringWithUTF8String:class_getName(self)];
}

@end

