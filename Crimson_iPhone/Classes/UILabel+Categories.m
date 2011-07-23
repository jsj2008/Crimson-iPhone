//
//  UILabel+Categories.m
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/23/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "UILabel+Categories.h"

@implementation UILabel(Size)

-(void)setUpMultiLineFrameWithStartXPosition:(CGFloat)startX withStartYPosition:(CGFloat)startY
{
	self.lineBreakMode = UILineBreakModeWordWrap;
	self.numberOfLines = 0;//instructs the label to contain any number of lines
    
	CGSize minSize = [self getSize];
	[self setFrame:CGRectMake(startX, startY, minSize.width, minSize.height)];
}

-(void)setUpMultiLineFrameBasedOnWidth:(CGFloat)maxWidth withStartXPosition:(CGFloat)startX withHeight:(CGFloat)maxHeight{
	self.lineBreakMode = UILineBreakModeWordWrap;
	self.numberOfLines = 0; //instructs the label to contain any number of lines
    
	CGFloat labelHeight = [self getHeightBasedOnWidth:maxWidth];
	CGFloat padding = ((maxHeight - labelHeight)/2); //center label within maxHeight box
	[self setFrame:CGRectMake(startX, padding, maxWidth, labelHeight)];
}

-(void)setUpMultiLineFrameBasedOnWidth:(CGFloat)maxWidth withStartXPosition:(CGFloat)startX withStartYPosition:(CGFloat)startY{
    
	self.lineBreakMode = UILineBreakModeWordWrap;
	self.numberOfLines = 0;//instructs the label to contain any number of lines
    
	CGFloat labelHeight = [self getHeightBasedOnWidth:maxWidth];
	[self setFrame:CGRectMake(startX, startY, maxWidth, labelHeight)];
}

-(void)setUpMultiLineFrameBasedOnWidth:(CGFloat)maxWidth withStartXPosition:(CGFloat)startX{
	self.lineBreakMode = UILineBreakModeWordWrap;
	self.numberOfLines = 0;//instructs the label to contain any number of lines
    
	CGFloat labelHeight = [self getHeightBasedOnWidth:maxWidth];
	[self setFrame:CGRectMake(startX, 0, maxWidth, labelHeight)];
}

-(CGFloat)getHeightBasedOnWidth:(CGFloat)maxWidth{
    
	CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(maxWidth, 9999) lineBreakMode:self.lineBreakMode];
    
	return size.height;
}

-(CGSize)getSize{
	CGSize size = [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(9999, 9999) lineBreakMode:self.lineBreakMode];
    
	return size;
}
-(void)setTextWithFlexibleHeight:(NSString *)paramText 
{    
    self.text = paramText;
    //forced the linebreak mode and numberoflines to force it to wrap the text
    //some of the labels that were created via Interface Builder didnt have the correct numberoflines
    //and since this is a function to make then bigger according to the text, ive forced it here
    self.numberOfLines = 0;
    self.lineBreakMode = UILineBreakModeWordWrap;
    
    //Calculate the expected size based on the font and linebreak mode of your label
    CGSize maximumLabelSize = CGSizeMake(296,9999);
    
    CGSize expectedLabelSize = [paramText sizeWithFont:self.font 
									 constrainedToSize:maximumLabelSize 
										 lineBreakMode:self.lineBreakMode]; 
    
    //adjust the label the the new height.
    CGRect newFrame = self.frame;
    newFrame.size.height = expectedLabelSize.height;
    self.frame = newFrame;
    
}

@end

