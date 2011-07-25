//
//  NewsItem.h
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/23/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseModel.h"

typedef enum {
	eSectionNews,
	eSectionOpinion,
	eSectionSports,
	eSectionFM,
	eSectionArts,
	eSectionFlyby,
} Section;

@interface NewsItem : BaseModel {
	Section section;
	NSString *_title;
	NSString *_thumbnailURL;
	NSString *_link;
	NSString *_ePubDate;
	NSDate *_pubDate;
	NSString *_description;
	NSString *_author;
}

@property (nonatomic, assign) Section section;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *thumbnailURL;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *ePubDate;
@property (nonatomic, retain) NSDate *pubDate;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *author;

+(id)newsItem;

@end
