//
//  RequestOperation.h
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/24/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

#define API_RESULT_STATUS_KEY		@"Message"
#define RESPONSEDATA_KEY			@"ResponseData"
#define RESPONSEERROR_KEY		@"ResponseError"

typedef enum {
	eRequestTypeCachedOnly,
	eRequestTypeNonCachedOnly,
	eRequestTypeNonCachedFirst,
	eRequestTypeCachedFirst,
} RequestType;

@class TBXML;

@interface RequestOperation : NSOperation {
	NSString *feedURL;
	NSString *feedName;
	
	TBXML *xmlDocument;
	NSMutableArray *resultArray;
	NSString *requestErrorDesc;
	
	NSInteger cacheLifeTimeDays;
	RequestType requestType;
}

@property(nonatomic, copy) NSString *feedURL;
@property(nonatomic, copy) NSString *feedName;

@property(nonatomic, retain) TBXML *xmlDocument;
@property(nonatomic, retain) NSMutableArray *resultArray;
@property(nonatomic, copy) NSString *requestErrorDesc;

@property(nonatomic, assign) NSInteger cacheLifeTimeDays;
@property(nonatomic, assign) RequestType requestType;

+(id)operationWithRequestType:(RequestType)theRequestType;
-(id)initWithRequestType:(RequestType)theRequestType;
-(void)requestFinished;

-(void)parseResponse;

-(NSMutableArray *)cachedData;
-(void) setCachedData:(NSMutableArray *)cacheArray;
-(NSString *)cachePath;
-(NSDate *)cacheExpiryDate;
-(void)setExpiryDateWithTotalDaysAfterNow:(NSInteger)totalDays;

@end
