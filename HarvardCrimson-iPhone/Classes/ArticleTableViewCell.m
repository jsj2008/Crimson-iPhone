//
//  ArticleTableViewCell.m
//  HarvardCrimson-iPhone
//
//  Created by Sophie Chang on 7/20/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "ArticleTableViewCell.h"
#import "NewsItem.h"
#import <QuartzCore/QuartzCore.h>

#define kTableViewCellFrame			CGRectmake(0, 0, 320, 88)
#define kThumbnailFrame				CGRectMake(5, 5, 71, 40)
#define kNewsTitleLabelFrame		CGRectMake(84, 6, 231, 15)
#define kDescriptionLabelFrame		CGRectMake(84, 38, 231, 45)
#define kDescriptionLabelPadding	4
#define kTopPadding					6

@implementation ArticleTableViewCell

@synthesize newsTitleLabel;
@synthesize descriptionLabel;
@synthesize thumbnail;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		// Initialization code
		[self initializeView];
	}
	return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

-(void)dealloc {
	[newsTitleLabel release];
	[descriptionLabel release];
	[thumbnail release];
	[super dealloc];
}

-(void)initializeView {
	self.frame = kTableViewCellFrame;
	// self.thumbnail = 
	self.newsTitleLabel = [[self class] newsTitleLabelBuilder];
	self.descriptionLabel = [[self class] descriptionLabelBuilder];
	
	[self addSubView:newsTitleLabel];
	[self addSubView:descriptionLabel];
	[self addSubView:thumbnail];
}

-(void)clearCell {
	newsTitleLabel.text = @"";
	thumbnail.image = nil;
	[thumbnail setNeedsDisplay];
	descriptionLabel.text = @"";
}

-(void)configureWithNewsItem:(NewsItem *)theNewsItem {
	[self clearCell];
	[newsTitleLabel setTextWithFlexibleHeight:theNewsItem.titleOfItem];
	
	// do something with thumbnail here
	
	CGRect newFrame = descriptionLabel.frame;
	newFrame.origin.y = newsTitleLabel.frame.origin.y + newsTitleLabel.frame.size.height + kDescriptionLabelPadding;
	descriptionLabel.frame = newFrame;
	descriptionLabel.text = theNewsItem.description;
}

+(UILabel *)newsTitleLabelBuilder {
	UILabel *tmpNewsTitleLabel = [[[UILabel alloc]initWithFrame:kNewsTitleLabelFrame]autorelease];
	tmpNewsTitleLabel.numberOfLines = 0;
	tmpNewsTitleLabel.lineBreakMode = UILineBreakModeWordWrap;
	tmpNewsTitleLabel.textColor = [UIColor blackColor];
	tmpNewsTitleLabel.backgroundColor = [UIColor whiteColor];
	tmpNewsTitleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:12];
	tmpNewsTitleLabel.adjustsFontSizeToFitWidth = NO;
	tmpNewsTitleLabel.textAlignment = UITextAlignmentLeft;
	tmpNewsTitleLabel.text = @"";
	return tmpNewsTitleLabel;
}

+(UILabel *)descriptionLabelBuilder {
    UILabel *tmpdescriptionLabelBuilder = [[[UILabel alloc]initWithFrame:kDescriptionLabelFrame]autorelease];
	tmpdescriptionLabelBuilder.numberOfLines = 3;
	tmpdescriptionLabelBuilder.textColor = [UIColor blackColor];
	tmpdescriptionLabelBuilder.backgroundColor = [UIColor whiteColor];
	tmpdescriptionLabelBuilder.font = [UIFont fontWithName:@"HelveticaNeue" size:12];
	tmpdescriptionLabelBuilder.adjustsFontSizeToFitWidth = NO;
	tmpdescriptionLabelBuilder.textAlignment = UITextAlignmentLeft;
	tmpdescriptionLabelBuilder.text = @"";
    return tmpdescriptionLabelBuilder;
}

@end
