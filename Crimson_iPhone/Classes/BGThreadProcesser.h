//
//  BGThreadProcessor.h
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/24/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BGThreadProcesser : NSObject 
{
	NSOperationQueue *backGroundQueue;
	NSOperationQueue *imageLoadingQueue;
}

@property (retain) NSOperationQueue *backGroundQueue;
@property (retain) NSOperationQueue *imageLoadingQueue;

+(BGThreadProcesser*)sharedInstance;
-(void)addBackgroundOperation:(NSOperation *)theOperation;
- (void)cancelCurrentOperations;

@end

