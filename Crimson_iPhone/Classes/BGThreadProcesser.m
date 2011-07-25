//
//  BGThreadProcessor.m
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/24/11.
//  Copyright 2011 Harvard. All rights reserved.
//
#import "BGThreadProcesser.h"

static BGThreadProcesser *sharedInstance = nil;

@implementation BGThreadProcesser

@synthesize backGroundQueue,imageLoadingQueue;

#pragma mark -
#pragma mark Singleton methods

+ (BGThreadProcesser*)sharedInstance
{
	@synchronized(self)
	{
		if (sharedInstance == nil)
		{
			sharedInstance = [[BGThreadProcesser alloc] init];
			sharedInstance.backGroundQueue = [[NSOperationQueue alloc] init];
			[sharedInstance.backGroundQueue setMaxConcurrentOperationCount:7];
			
			sharedInstance.imageLoadingQueue = [[NSOperationQueue alloc] init];
			[sharedInstance.imageLoadingQueue setMaxConcurrentOperationCount:4];
		}
		
	}
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *)zone 
{
	@synchronized(self)
	{
		if (sharedInstance == nil) 
		{
			sharedInstance = [super allocWithZone:zone];
			return sharedInstance;  // assignment and return on first allocation
		}
	}
	
	return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone
{
	return self;
}

- (id)retain 
{
	return self;
}

- (unsigned)retainCount 
{
	return UINT_MAX;  // denotes an object that cannot be released
}

- (void)release 
{
	//do nothing
}

#pragma mark -
#pragma mark Page Loading methods

-(void)cancelCurrentOperations
{
	[self.backGroundQueue cancelAllOperations];
}

-(void)addBackgroundOperation:(NSOperation *)theOperation
{
	[self.backGroundQueue addOperation:theOperation];
}

@end

