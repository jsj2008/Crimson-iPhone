//
//  RequestOperation.m
//  HarvardCrimson-iPhone
//
//  Created by Sophie Chang on 7/20/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "RequestOperation.h"
#import "TBXML.h"


@implementation RequestOperation

@synthesize feedURL, feedName;
@synthesize requestErrorDesc, resultArray //and xml document
@synthesize cacheLifeTimeDays;
@synthesize requestType;

+(id)operationWithRequestType:(RequestType)theRequestType {
	return [[[[self class]alloc]initWithRequestType:<#(RequestType)theRequestType#>]autorelease];
}

-(id)initWithRequestType:(RequestType)theRequestType {
	self = [super init];
	if(self) {
		self.requestErrorDesc=@"";
		self.requestType = theRequestType;
	}
	return self;
}

-(void)dealloc {
	[feedURL release];
	[feedName release];
	
	[resultArray release];
	[requestErrorDesc release];
	[xmlDocument release];
	
	[super dealloc];
}

-(void)main {
	if (!feedURL) {
		return;
	}
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc]init];
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
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
		
		//Execute request
		NSURLResponse *response = nil;
		resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
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
				debugLog(@"%@::performRequestWithURL - Request failed, fetching old data from cache", [[self class] description], [error localizedDescription]);
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
	// Override with subclass
}

-(void)requestFinished {
	// Override with subclass
}

-(BOOL)getBoolValue:(NSString*)theString{ 
	if([theString caseInsensitiveCompare:@"true"]==NSOrderedSame) {
		return YES:
	}
	if ([theString caseInsensitiveCompare:@"Y"]==NSOrderedSame) {
		return YES;
	}
	return NO;
}

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
	NSInteger		 compFlags  = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *todayDateComps = [[NSCalendar currentCalendar] components:compFlags fromDate:[NSDate date]];	
	
	// setup expiry date
	todayDateComps.day += totalDays;
	NSDate *expiryDate = [[NSCalendar currentCalendar] dateFromComponents:todayDateComps];
	
	// store
	[[NSUserDefaults standardUserDefaults] setObject:expiryDate forKey:self.feedURL];
}


@end
