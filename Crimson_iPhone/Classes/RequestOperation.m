//
//  RequestOperation.m
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/24/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "RequestOperation.h"
#import "TBXML.h"
#import "BGThreadProcesser.h"

@implementation RequestOperation

//Request
@synthesize feedURL, feedName;

//Response
@synthesize requestErrorDesc, resultArray, xmlDocument;

//Cache
@synthesize cacheLifeTimeDays;
@synthesize requestType;

#pragma mark -
#pragma mark Create

+(id)operationWithRequestType:(RequestType)theRequestType 
{
	return [[[[self class]alloc]initWithRequestType:theRequestType]autorelease];
}

-(id)initWithRequestType:(RequestType)theRequestType 
{
	self = [super init];
	if(self) 
	{
		self.requestErrorDesc = @"";
		self.requestType = theRequestType;
	}
	return self;
}

- (void)dealloc {
	
	//Request
	[feedURL release];
	[feedName release];
	
	//Response
	[resultArray release];
	[requestErrorDesc release];
	[xmlDocument release];	
	
	[super dealloc];
}


#pragma mark -
#pragma mark Main

- (void)main {
	
	// Validate
	if(!feedURL) 
    {
		NSLog(@"feedURL not set for %@",  [[self class] description]);
		return;
	}
	
	//Process
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	self.resultArray = nil;
	self.xmlDocument = nil;
	NSData *resultData = nil;
	NSError *error = nil;
	
	if(requestType == eRequestTypeCachedOnly || requestType == eRequestTypeCachedFirst) 
    {
		self.resultArray = [NSMutableArray arrayWithArray:[self cachedData]];
		[self requestFinished];
	}
	
	if(requestType != eRequestTypeCachedOnly) 
	{
		//Init array
		self.resultArray = [NSMutableArray array];
		
		//Build request
		NSURL *url = [NSURL URLWithString:self.feedURL];
		ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
		request.numberOfTimesToRetryOnTimeout = 2;
		request.timeOutSeconds = 30;
		request.shouldPresentAuthenticationDialog = NO;
		[request startSynchronous];
		resultData = [request responseData];
		if(resultData) 
		{
			NSString *responseString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
			
			[responseString release];
			
			// create the xml object
			self.xmlDocument = [[[TBXML alloc] initWithXMLData:resultData] autorelease];
			
			// set cache expiry date
			[self setExpiryDateWithTotalDaysAfterNow:self.cacheLifeTimeDays];
			
			//parse the xml
			[self parseResponse];
		} 
		else 
		{
			//Attempt to get from cache
			self.resultArray = [NSMutableArray arrayWithArray:[self cachedData]];
			
			if(self.resultArray)
			{
				NSLog(@"%@::performRequestWithURL - Request failed, fetching old data from cache", [[self class] description], [error localizedDescription]);
			}
			else
			{
				self.requestErrorDesc = @"Communication Error";
			}		
		}
		
		[self requestFinished];
	}
	
	if(requestType == eRequestTypeNonCachedFirst) 
	{
		self.resultArray = [NSMutableArray arrayWithArray:[self cachedData]];
		[self requestFinished];
	}
	
	//Cleanup
	[pool drain];
}

-(void)parseResponse {
	//Override with sub class
}

- (void)requestFinished {
	//Override with sub class
}

-(BOOL)getBoolValue:(NSString*)theString 
{	
	if([theString caseInsensitiveCompare:@"true"] == NSOrderedSame)
		return YES;
	
	if([theString caseInsensitiveCompare:@"Y"] == NSOrderedSame)
		return YES;
	
	return NO;
}

#pragma mark -
#pragma mark Cache

-(NSMutableArray*)cachedData 
{	
	NSMutableArray *cache = nil;	
	//	@synchronized(self) 
	//    {
	@try
	{
		cache = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePath]];
		
		if(cache == nil)
		{
			if (self.feedName == nil)
			{
				cache = nil;
			}
			else
			{
				cache = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:self.feedName ofType:nil]];	
			}
		}
	}
	@catch (NSException *e)
	{
		//if it fails then just return nil
		cache = nil;
	}
	//}
    
	return cache;
}

-(void)setCachedData:(NSMutableArray*)cacheArray 
{
	//	@synchronized(self) 
	//    {
	@try
	{
		[NSKeyedArchiver archiveRootObject:cacheArray toFile:[self cachePath]];
	}
	@catch (NSException *e)
	{
		//we dont care if this fails as the next one might work
	}
	//	}
}

-(NSString*)cachePath 
{
	// Note: path can't be cached as it changes depending on subclass
	NSArray  *pathArray	   = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = nil;
	if ([pathArray count] > 0)
	{
		NSString *docDirectory = [pathArray objectAtIndex:0];
        
		path = [docDirectory stringByAppendingPathComponent:@"XMLCache"];
		BOOL isDir;
		NSError *error;
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		if([fileManager fileExistsAtPath:path isDirectory:&isDir] == NO) 
		{
			[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
		}
		
		path = [path stringByAppendingPathComponent:self.feedName];
	}
	return path;
}

-(NSDate*)cacheExpiryDate {
	
	NSDate *expiryDate = [[NSUserDefaults standardUserDefaults] objectForKey:self.feedURL];
	
	// if no date set yet so set date to expired
	if(!expiryDate) {
		expiryDate = [NSDate dateWithTimeIntervalSince1970:0];
	}
	
	return expiryDate;
}

-(void)setExpiryDateWithTotalDaysAfterNow:(NSInteger)totalDays {
	// setup current date - ignoring hours, mins, seconds so it is rounded down to start of day
	NSInteger compFlags  = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *todayDateComps = [[NSCalendar currentCalendar] components:compFlags fromDate:[NSDate date]];	
	
	// setup expiry date
	todayDateComps.day += totalDays;
	NSDate *expiryDate = [[NSCalendar currentCalendar] dateFromComponents:todayDateComps];
	
	// store
	[[NSUserDefaults standardUserDefaults] setObject:expiryDate forKey:self.feedURL];
}


@end