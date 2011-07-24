//
//  NewsDetailViewController.h
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/22/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsItem;

@interface NewsDetailViewController : UIViewController {
	UIScrollView *mainScrollView;
	UIView *mainContentView;
	UILabel *titleLabel;
	UILabel *dateLabel;
	UILabel *authorLabel;
	UIImageView *articleImage;
	UIWebView *contentWebView;
	UIButton *shareButton;
	
	NewsItem *theNewsItem;
}

@property(nonatomic, retain) IBOutlet UIScrollView *mainScrollView;
@property(nonatomic, retain) IBOutlet UIView *mainContentView;
@property(nonatomic, retain) IBOutlet UIImageView *articleImage;
@property(nonatomic, retain) IBOutlet UILabel *titleLabel;
@property(nonatomic, retain) IBOutlet UILabel *dateLabel;
@property(nonatomic, retain) IBOutlet UILabel *authorLabel;
@property(nonatomic, retain) IBOutlet UIWebView *contentWebView;
@property(nonatomic, retain) IBOutlet UIButton *shareButton;

@property(nonatomic, retain) NewsItem *theNewsItem;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil newsItem:(NewsItem *)aNewsItem;
-(void)initialiseView;
-(IBAction)buttonPressed:(id)sender;
-(void)composeMail;

@end
