//
//  BaseModel.h
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/25/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <objc/runtime.h>
#import <objc/message.h>

@interface BaseModel : NSObject {
	
}

-(NSArray*)initFieldList;
-(NSString*)description;

+(NSString*)getShortFormattedDate:(NSDate*)theDate;
+(BOOL)boolValueForElement:(NSString*)element;

@end

