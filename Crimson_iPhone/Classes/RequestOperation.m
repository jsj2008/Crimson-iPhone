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

@synthesize feedURL, feedName;

@synthesize requestErrorDesc, resultArray, xmlDocument;

@synthesize cacheLifeTimeDays;
@synthesize requestType;

+(id)operationWithRequestType:(RequestType)theRequestType {
	return [[[[self class]alloc]initWithRequestType:theRequestType]autorelease];
}

-(id)initWithRequestType:(RequestType)theRequestType {
	self = [super init];
	if (self) {
		self.requestErrorDesc = @"";
		self.requestType = theRequestType;
	}
	return self;
}

-(void)dealloc {
	[super dealloc];
	
	[feedURL release];
	[feedName release];
	
	[resultArray release];
	[requestErrorDesc release];
	[xmlDocument release];
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
	
	if (requestType == eRequestTypeCachedOnly || requestType == eRequestTypeCachedFirst) {
		self.resultArray = [NSMutableArray arrayWithArray:[self cachedData]];
		[self requestFinished];
	}
	
	if (requestType != eRequestTypeCachedOnly) {
		self.resultArray = [NSMutableArray array];
		
		NSURL *url = [NSURL URLWithString:self.feedURL];
		NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
		
		
		NSURLResponse *response = nil;
		resultData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		
		if (resultData) {
			NSString *responseString = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
			
			[responseString release];
			
			self.xmlDocument = [[[TBXML alloc] initWithXMLData:resultData] autorelease];
			
			[self setExpiryDateWithTotalDaysAfterNow:self.cacheLifeTimeDays];
			
			[self parseResponse];
		}
		else {
			self.resultArray = [NSMutableArray arrayWithArray:[self cachedData]];
			
			if (self.resultArray) {
			
			}
			else {
				self.requestErrorDesc = @"Communication error";
			}
		}
		[self requestFinished];
	}
	
	if (requestType == eRequestTypeNonCachedFirst) {
		self.resultArray = [NSMutableArray arrayWithArray:[self cachedData]];
		[self requestFinished];
	}
	
	[pool drain];
}

-(void)parseResponse {
	// Override with subclass
}

-(void)requestFinished {
	// Override with subclass
}

-(BOOL)getBoolValue:(NSString *)theString {
	if ([theString caseInsensitiveCompare:@"true"] == NSOrderedSame) {
		return YES;
	}
	
	if ([theString caseInsensitiveCompare:@"Y"] == NSOrderedSame) {
		return YES;
	}
	
	return NO;
}

-(NSMutableArray *)cachedData {
	NSMutableArray *cache = nil;
	
	@try {
		cache = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePath]];
		
		if (cache == nil) {
			if (self.feedName == nil) {
				cache = nil;
			}
			else {
				cache = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle]pathForResource:self.feedName ofType:nil]];
			}
		}
	}
	@catch (NSException *e) {
		cache = nil;
	}
	
	return cache;
}

-(void)setCachedData:(NSMutableArray *)cacheArray {
	@try {
		[NSKeyedArchiver archiveRootObject:cacheArray toFile:[self cachePath]];
	}
	@catch (NSException *e) {
		// disregard as next one may work
	}
}

-(NSString *)cachePath {
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *path = nil;
	if ([pathArray count] > 0) {
		NSString *docDirectory = [pathArray objectAtIndex:0];
		
		path = [docDirectory stringByAppendingPathComponent:@"XMLCache"];
		BOOL isDir;
		NSError *error;
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		if ([fileManager fileExistsAtPath:path isDirectory:&isDir] == NO) {
			[fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
		}
		
		path = [path stringByAppendingPathComponent:self.feedName];
	}
	return path;
}

-(NSDate *)cacheExpiryDate {
	NSDate *expiryDate = [[NSUserDefaults standardUserDefaults] objectForKey:self.feedURL];
	
	if (!expiryDate) {
		expiryDate = [NSDate dateWithTimeIntervalSince1970:0];
	}
	
	return expiryDate;
}

-(void)setExpiryDateWithTotalDaysAfterNow:(NSInteger)totalDays {
	NSInteger compFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
	NSDateComponents *todayDateComps = [[NSCalendar currentCalendar] components:compFlags fromDate:[NSDate date]];
	
	todayDateComps.day += totalDays;
	NSDate *expiryDate = [[NSCalendar currentCalendar] dateFromComponents:todayDateComps];
	
	[[NSUserDefaults standardUserDefaults] setObject:expiryDate forKey:self.feedURL];
}

@end
