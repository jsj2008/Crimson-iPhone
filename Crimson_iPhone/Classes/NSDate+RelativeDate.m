//
//  NSDate+RelativeDate.m
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/24/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "NSDate+RelativeDate.h"

@implementation NSDate (NSDateAdditions)

+(NSDate *)getDateFromNewsFeed:(NSString *)feedString {
	NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
	return [dateFormatter dateFromString:feedString];
}

@end
