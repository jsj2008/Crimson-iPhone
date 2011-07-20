//
//  BaseItemTableViewCell.m
//  HarvardCrimson-iPhone
//
//  Created by Sophie Chang on 7/20/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "BaseItemTableViewCell.h"


@implementation BaseItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifer:(NSString *)reuseIdentifer {
	self = [super initWithStyle:style reuseIdentifer:reuseIdentifer];
	if (self) {
		// Initialization code
	}
	return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	// Configure the view for the selected state
}

- (void)dealloc {
	[super dealloc];
}

@end
