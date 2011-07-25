//
//  BaseModel.m
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/25/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "BaseModel.h"
#import "NSObjectAdditions.h"


@implementation BaseModel

static NSMutableDictionary* map = nil;

-(id)init {
	
	if(self = [super init]) {
		
		
	}
	return self;
}

-(NSArray*)initFieldList {
	
	if(!map) {
		map = [[NSMutableDictionary alloc] initWithCapacity:10];
	}
	
	NSArray* fieldList = [map objectForKey:[self className]];
	if(!fieldList) {
		
		NSMutableArray* savedFieldList = [[[NSMutableArray alloc] init] autorelease];
		unsigned int outCount;
		
		objc_property_t *propList = class_copyPropertyList([self class], &outCount);
		
		// Loop through properties and add declarations for the create
		for (int i=0; i < outCount; i++) {
			objc_property_t oneProp = propList[i];
			NSString *propName = [NSString stringWithUTF8String:property_getName(oneProp)];
			[savedFieldList addObject:propName];
			
		}
		free(propList);
		
		[map setObject:savedFieldList forKey:[self className]];
		fieldList = [map objectForKey:[self className]];
	}
	
	return [fieldList retain];
}

-(id)initWithCoder:(NSCoder *)coder {
	
	for(NSString* field in [self initFieldList]) {
		[self setValue:[coder decodeObjectForKey:field] forKey:field];
	}
	return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder 
{	
	for(NSString* field in [self initFieldList]) 
	{
		[encoder encodeObject:[self valueForKey:field] forKey:field];
	}
}

-(NSString*)description {
    return [self className];
}


#pragma mark -
#pragma mark Utils

+(NSString*)getShortFormattedDate:(NSDate*)theDate 
{	
	//	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	//	[dateFormatter setDateStyle:NSDateFormatterShortStyle];
	//	[dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	//
	//	NSString *dateString = [dateFormatter stringFromDate:theDate];
	//	[dateFormatter release];
	
	return [NSDateFormatter localizedStringFromDate:theDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

+(BOOL)boolValueForElement:(NSString*)element {
	
	if([[element uppercaseString] isEqualToString:@"FALSE"])
		return NO;
	
	return YES;
}

@end

