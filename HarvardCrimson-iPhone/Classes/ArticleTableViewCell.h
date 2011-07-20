//
//  ArticleTableViewCell.h
//  HarvardCrimson-iPhone
//
//  Created by Sophie Chang on 7/20/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseItemTableViewCell.h"

@class NewsItem;

@interface ArticleTableViewCell : NSObject {
	UILabel *newsTitleLabel;
	UILabel *descriptionLabel;
	UIImageView *thumbnail;
}

@property(nonatomic, retain) UILabel *newsTitleLabel;
@property(nonatomic, retain) UILabel *descriptionLabel;
@property(nonatomic, retain) UIImageView *thumbnail;

-(void)configureWithNewsItem:(NewsItem *)theNewsItem;
+(float)rowHeight:(NewsItem *)theNewsItem;

@end
