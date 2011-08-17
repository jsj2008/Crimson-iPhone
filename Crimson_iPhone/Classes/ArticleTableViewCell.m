//
//  ArticleTableViewCell.m
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/23/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "ArticleTableViewCell.h"
#import "NewsItem.h"
#import "UILabel+Categories.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>

#define kTableViewCellFrame			CGRectMake(0,0,320, 71)
#define kThumbImageFrame			CGRectMake(7, 7, 73, 57)
#define kNoThumbImageFrame			CGRectMake(0, 0, 0, 0)
#define kNewsTitleLabelFrame		CGRectMake(88, 5, 227, 0)
#define kDescriptionLabelFrame		CGRectMake(88, 23, 227, 45)
#define kNewsTitleNoImageLabelFrame	CGRectMake(9, 5, 301, 0)
#define kDescriptionNoImgLabelFrame	CGRectMake(9, 23, 301, 45)
#define kSeparatorImageFrame		CGRectMake(5, 88, 320, 1)
#define kDescriptionLabelPadding	-5
#define kTopPadding					5
#define kSeparatorPadding			3

static UIImage *separatorImage = nil;

@interface ArticleTableViewCell(Private)

-(void)initialiseView;
-(void)clearCell;
+(UILabel *)newsTitleLabelBuilder;
+(UILabel *)descriptionLabelBuilder;
+(UIImageView *)separatorImageViewBuilder;
+(UIImageView *)thumbnailImageViewBuilder;

@end

@implementation ArticleTableViewCell

@synthesize separatorImageView;
@synthesize newsTitleLabel;
@synthesize thumbnailImageView;
@synthesize descriptionLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		separatorImage = [UIImage imageNamed:@"table_hr"];
		[self initialiseView];
	}
	return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

-(void)dealloc {
	[super dealloc];
	[newsTitleLabel release];
	[thumbnailImageView release];
	[descriptionLabel release];
	[separatorImageView release];
}

-(void)initialiseView {
	self.frame = kTableViewCellFrame;
	self.thumbnailImageView = [[[UIImageView alloc]initWithFrame:kThumbImageFrame]autorelease];
	self.newsTitleLabel = [[self class]newsTitleLabelBuilder];
	self.descriptionLabel = [[self class] descriptionLabelBuilder];
	self.separatorImageView = [[self class]separatorImageViewBuilder];
	[self addSubview:newsTitleLabel];
	[self addSubview:thumbnailImageView];
	[self addSubview:descriptionLabel];
	[self addSubview:separatorImageView];
}

-(void)clearCell {
	newsTitleLabel.text = @"";
	thumbnailImageView.image = nil;
	[thumbnailImageView setNeedsDisplay];
	descriptionLabel.text = @"";
}

-(void)configureWithNewsItem:(NewsItem *)theNewsItem {
	[self clearCell];
	if (theNewsItem.thumbnailURL) {
		thumbnailImageView.frame = kThumbImageFrame;
		if ([theNewsItem.thumbnailURL hasPrefix:HOME_URL]) {
			[thumbnailImageView setImageWithURL:[NSURL URLWithString:theNewsItem.thumbnailURL] placeholderImage:[UIImage imageNamed:@"grey_seal.png"]];
		}
		else {
			NSString *fullURL = [NSString stringWithFormat:@"%@%@", HOME_URL, theNewsItem.thumbnailURL];
			[thumbnailImageView setImageWithURL:[NSURL URLWithString:fullURL] placeholderImage:[UIImage imageNamed:@"grey_seal.png"]];
		}
		newsTitleLabel.frame = kNewsTitleLabelFrame;
		[newsTitleLabel setTextWithFlexibleHeight:theNewsItem.title withWidth:227];
		descriptionLabel.frame = kDescriptionLabelFrame;
	}
	else {
		thumbnailImageView.frame = kNoThumbImageFrame;
		newsTitleLabel.frame = kNewsTitleNoImageLabelFrame;
		[newsTitleLabel setTextWithFlexibleHeight:theNewsItem.title withWidth:303];
		descriptionLabel.frame = kDescriptionNoImgLabelFrame;
	}
	[descriptionLabel setText:theNewsItem.description];
	CGRect newFrame = descriptionLabel.frame;
	newFrame.origin.y = newsTitleLabel.frame.origin.y + newsTitleLabel.frame.size.height + kDescriptionLabelPadding;
	descriptionLabel.frame = newFrame;
	
	newFrame = separatorImageView.frame;
	newFrame.origin.y = descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height + kSeparatorPadding;
	separatorImageView.frame = newFrame;
}

#pragma mark -
#pragma mark Helper function to find height of cell
+(float)rowHeight:(NewsItem *)theNewsItem {
	CGRect cellFrame = kTableViewCellFrame;
	UILabel *newsTitleLabel = [[self class] newsTitleLabelBuilder];
	UILabel *descriptionLabel = [[self class] descriptionLabelBuilder];
	UIImageView *separatorImageView = [[self class] separatorImageViewBuilder];
	[newsTitleLabel setTextWithFlexibleHeight:theNewsItem.title withWidth:227];
	[descriptionLabel setText:theNewsItem.description];
	float totalHeight;
	totalHeight = newsTitleLabel.frame.size.height + descriptionLabel.frame.size.height + separatorImageView.frame.size.height + kDescriptionLabelPadding + kSeparatorPadding + kTopPadding;
	return totalHeight < cellFrame.size.height ? cellFrame.size.height : totalHeight;
}

+(UILabel *)newsTitleLabelBuilder {
	UILabel *tmpNewsTitleLabel = tmpNewsTitleLabel = [[[UILabel alloc]initWithFrame:kNewsTitleLabelFrame]autorelease];;
	tmpNewsTitleLabel.numberOfLines = 0;
	tmpNewsTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
	tmpNewsTitleLabel.textColor = [UIColor blackColor];
	tmpNewsTitleLabel.backgroundColor = [UIColor clearColor];
	tmpNewsTitleLabel.font = [UIFont fontWithName:@"Georgia-Bold" size:13];
	tmpNewsTitleLabel.adjustsFontSizeToFitWidth = NO;
	tmpNewsTitleLabel.textAlignment = UITextAlignmentLeft;
	tmpNewsTitleLabel.text = @"";
	return tmpNewsTitleLabel;
}

+(UILabel *) descriptionLabelBuilder {
	UILabel *tmpDescriptionLabelBuilder = [[[UILabel alloc] initWithFrame:kDescriptionLabelFrame] autorelease];
	tmpDescriptionLabelBuilder.numberOfLines = 2;
	tmpDescriptionLabelBuilder.textColor = [UIColor blackColor];
	tmpDescriptionLabelBuilder.backgroundColor = [UIColor clearColor];
	tmpDescriptionLabelBuilder.font = [UIFont fontWithName:@"Georgia" size:12];
	tmpDescriptionLabelBuilder.adjustsFontSizeToFitWidth = NO;
	tmpDescriptionLabelBuilder.textAlignment = UITextAlignmentLeft;
	tmpDescriptionLabelBuilder.text = @"";
	return tmpDescriptionLabelBuilder;
}

+(UIImageView *)separatorImageViewBuilder {
	UIImageView *tmpSeparatorView = [[[UIImageView alloc]initWithFrame:kSeparatorImageFrame] autorelease];
	tmpSeparatorView.contentMode = UIViewContentModeCenter;
	tmpSeparatorView.image = separatorImage;
	return tmpSeparatorView;
}

@end
