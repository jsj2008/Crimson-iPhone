//
//  NewsRequestOperation.m
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/24/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "NewsRequestOperation.h"
#import "TBXML.h"
#import "GTMNSString+HTML.h"
#import "BGThreadProcesser.h"
#import "config.h"
#import "NSDate+RelativeDate.h"

@interface NewsRequestOperation(private) 
	-(NSString *)feedURLForSection:(Section)theSection;
	-(NSString *)feedNameForSection:(Section)theSection;
	-(void)sortResults;

@end

@implementation NewsRequestOperation

@synthesize section;

+(id)operationWithSection:(Section)theSection {
	return [[[[self class] alloc]initWithSection:theSection]autorelease];
}

-(id)initWithSection:(Section)theSection{
	self = [super initWithRequestType:eRequestTypeCachedFirst];
	if (self) {
		self.section = theSection;
		self.feedURL = [self feedURLForSection:theSection];
		self.feedName = [self feedNameForSection:section];
		self.cacheLifeTimeDays = 9999;
	}
	return self;
}

-(void)parseResponse {
	if (xmlDocument) {
		TBXMLElement *root = xmlDocument.rootXMLElement;
		if (root) {
			TBXMLElement *channelElement = [TBXML childElementNamed:@"channel" parentElement:root];
			if (channelElement) {
				TBXMLElement *itemElement = channelElement -> firstChild;
				if (itemElement) {
					do {
						itemElement = itemElement -> nextSibling;
					} while(![[TBXML elementName:itemElement] isEqualToString:@"item"]);
					do {
						NewsItem *theNewsItem = [[NewsItem alloc]init];
						theNewsItem.section = self.section;
						TBXMLElement *childElement = itemElement -> firstChild;
						do {
							if ([[TBXML elementName:childElement] isEqualToString:@"title"]) {
								theNewsItem.title = [[TBXML textForElement:childElement]gtm_stringByUnescapingFromHTML];
							}
							else if ([[TBXML elementName:childElement] isEqualToString:@"description"]) {
								theNewsItem.description = [[TBXML textForElement:childElement]gtm_stringByUnescapingFromHTML];
							}
							else if ([[TBXML elementName:childElement] isEqualToString:@"pubDate"]) {
								theNewsItem.ePubDate = [TBXML textForElement:childElement];
								theNewsItem.pubDate = [NSDate getDateFromNewsFeed:theNewsItem.ePubDate];
							}
							else if ([[TBXML elementName:childElement] isEqualToString:@"link"]) {
								theNewsItem.link = [TBXML textForElement:childElement];
							}
							else if ([[TBXML elementName:childElement] isEqualToString:@"media:content"]) {
								theNewsItem.thumbnailURL = [TBXML valueOfAttributeNamed:@"url" forElement:childElement];
							}
							else if ([[TBXML elementName:childElement] isEqualToString:@"dc:creator"]) {
								theNewsItem.author = [[TBXML textForElement:childElement]gtm_stringByUnescapingFromHTML];
							}
							childElement = childElement -> nextSibling;
						} while(childElement != nil);
						
						[self.resultArray addObject:theNewsItem];
						[theNewsItem release];
						itemElement = itemElement -> nextSibling;
					} while(itemElement != nil);
				}
			}
		}
	}
}

-(void)sortResults {
	NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:NO];
	[self.resultArray sortUsingDescriptors:[NSArray arrayWithObject:sortDesc]];
	[sortDesc release];
}

-(void)requestFinished {
	[self sortResults];
	if ([self.resultArray count]) {
		[self setCachedData:self.resultArray];
	}
	
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
	if (self.resultArray) {
		[userInfo setObject:self.resultArray forKey:RESPONSEDATA_KEY];
	}
	if (self.requestErrorDesc) {
		[userInfo setObject:self.requestErrorDesc forKey:RESPONSEERROR_KEY];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:NEWS_NOTIFICATION object:nil userInfo:userInfo];
}

-(NSString *)feedURLForSection:(Section)theSection {
	NSString *sectionString = @"";
	switch(theSection) {
		case eSectionNews:
			sectionString = @"news";
			break;
		case eSectionOpinion:
			sectionString = @"opinion";
			break;
		case eSectionSports:
			sectionString = @"sports";
			break;
		case eSectionFM:
			sectionString = @"fm";
			break;
		case eSectionArts:
			sectionString = @"arts";
			break;
		case eSectionFlyby:
			sectionString = @"flyby";
			break;
		default:
			sectionString = @"";
			break;
	}
	NSString *returnURL = nil;
	
	returnURL = [NSString stringWithFormat:@"%@%@",FEED_BASE_URL, sectionString];
	
	return returnURL;
}

-(NSString *)feedNameForSection:(Section)theSection {
	NSString *sectionString = @"";
	switch (theSection) {
		case eSectionNews:
			sectionString = @"News";
			break;
		case eSectionOpinion:
			sectionString = @"Opinion";
			break;
		case eSectionSports:
			sectionString = @"Sports";
			break;
		case eSectionFM:
			sectionString = @"FM";
			break;
		case eSectionArts:
			sectionString = @"Arts";
			break;
		case eSectionFlyby:
			sectionString = @"Flyby";
			break;
		default:
			sectionString = @"";
			break;
	}
	return [NSString stringWithFormat:@"%@_%@", NEWS_FEEDNAME, sectionString];
}

@end
