//
//  NewsItem.m
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/23/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "NewsItem.h"


@implementation NewsItem

@synthesize section;
@synthesize title;
@synthesize thumbnailURL;
@synthesize link;
@synthesize ePubDate;
@synthesize pubDate;
@synthesize description;
@synthesize author;

+(id)newsItem {
	return [[[[self class]alloc]init]autorelease];
}

-(void)dealloc {
	[super dealloc];
	[title release];
	[thumbnailURL release];
	[link release];
	[ePubDate release];
	[pubDate release];
	[description release];
	[author release];
}

@end
