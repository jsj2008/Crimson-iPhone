//
//  BaseItemTableViewCell.m
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/23/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "BaseItemTableViewCell.h"


@implementation BaseItemTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
	if (self) {
		// Initialization code
	}
	return self;
}

-(void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	// Configure the view for the selected state
}

-(void)dealloc {
	[super dealloc];
}

@end
