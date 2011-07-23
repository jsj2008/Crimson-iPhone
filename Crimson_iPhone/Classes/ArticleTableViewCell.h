//
//  ArticleTableViewCell.h
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/23/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseItemTableViewCell.h"
#import "NewsItemCellInterface.h"

@class NewsItem;

@interface ArticleTableViewCell : BaseItemTableViewCell <NewsItemCellInterface> {
	UILabel *newsTitleLabel;
	UILabel *descriptionLabel;
	UIImageView *thumbnailImageView;
	UIImageView *separatorImageView;
}

@property(nonatomic, retain) UILabel *newsTitleLabel;
@property(nonatomic, retain) UILabel *descriptionLabel;
@property(nonatomic, retain) UIImageView *thumbnailImageView;
@property(nonatomic, retain) UIImageView *separatorImageView;

-(void)configureWithNewsItem:(NewsItem *)theNewsItem;
+(float)rowHeight:(NewsItem *)theNewsItem;

@end
