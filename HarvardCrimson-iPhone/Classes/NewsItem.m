//
//  NewsItem.m
//  HarvardCrimson-iPhone
//
//  Created by Sophie Chang on 7/20/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "NewsItem.h"


@implementation NewsItem

@synthesize titleOfItem;
@synthesize pubDate;
@synthesize description;
@synthesize contentLink;
@synthesize thumbnailURL;
@synthesize author;
@synthesize section;

+(id)newsItem {
	return [[[[self class]alloc]init]autorelease];
}

-(void) dealloc {
	[titleOfItem release];
	[pubDate release];
	[description release];
	[contentLink release];
	[thumbnailURL release];
	[author release];
	[section release];
	[super dealloc];
}

@end
