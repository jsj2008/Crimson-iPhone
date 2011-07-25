//
//  NSDate+RelativeDate.h
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/24/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (NSDateAdditions) 
	
	+(NSDate *)getDateFromNewsFeed:(NSString *)feedString;
	+(NSString *)getNewsDate:(NSDate *)date;
	
@end
