//
//  NSDate+RelativeDate.h
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/24/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (NSDateAdditions) 
	
	//(NSString *)getRelativeDateStringFromDate:(NSDate *)dateToConvert;
	//+(NSDate* )getDateFromTZTimestamp:(NSString *)timestamp;
	+(NSDate *)getDateFromNewsFeed:(NSString *)feedString;
	/*+(NSString *)getDateLongStyleWithNoTime:(NSDate *)date;
	+(NSString *)getDateShortStyleWithNoTime:(NSDate *)date;*/
	
@end
