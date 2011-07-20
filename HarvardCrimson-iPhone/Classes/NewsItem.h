//
//  NewsItem.h
//  HarvardCrimson-iPhone
//
//  Created by Sophie Chang on 7/20/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NewsItem : NSObject {
	NSString *titleOfItem;
	NSString *pubDate;
	NSString *description;
	NSString *contentLink;
	NSString *thumbnailURL;
	NSString *author;
	NSString *section;
}

@property(nonatomic, copy) NSString *titleOfItem;
@property(nonatomic, copy) NSString *pubDate;
@property(nonatomic, copy) NSString *description;
@property(nonatomic, copy) NSString *contentLink;
@property(nonatomic, copy) NSString *thumbnailURL;
@property(nonatomic, copy) NSString *author;
@property(nonatomic, copy) NSString *section;

+(id)newsItem;

@end
