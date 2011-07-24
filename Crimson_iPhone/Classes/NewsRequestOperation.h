//
//  NewsRequestOperation.h
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/24/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "RequestOperation.h"
#import "NewsItem.h"

#define NEWS_FEEDNAME				@"NewsFeatures"
#define NEWS_NOTIFICATION			@"NEWS_NOTIFICATION"

@interface NewsRequestOperation : RequestOperation {
	Section section;
}

@property(nonatomic, assign) Section section;

+(id)operationWithSection:(Section)theSection;
-(id)initWithSection:(Section)theSection;

@end
