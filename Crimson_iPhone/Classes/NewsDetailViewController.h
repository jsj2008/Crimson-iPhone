//
//  NewsDetailViewController.h
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/22/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class NewsItem;

@interface NewsDetailViewController : UIViewController <MFMailComposeViewControllerDelegate, UIScrollViewDelegate> {
	UIScrollView *mainScrollView;
	UIView *mainContentView;
	UIView *imageView;
	UILabel *titleLabel;
	UILabel *dateLabel;
	UILabel *authorLabel;
	UIImageView *articleImage;
	UIWebView *contentWebView;
	//UIToolbar *shareBar;
	//UIBarButtonItem *shareButton;
	
	NewsItem *theNewsItem;
}

@property(nonatomic, retain) IBOutlet UIScrollView *mainScrollView;
@property(nonatomic, retain) IBOutlet UIView *mainContentView;
@property(nonatomic, retain) IBOutlet UIView *imageView;
@property(nonatomic, retain) IBOutlet UIImageView *articleImage;
@property(nonatomic, retain) IBOutlet UILabel *titleLabel;
@property(nonatomic, retain) IBOutlet UILabel *dateLabel;
@property(nonatomic, retain) IBOutlet UILabel *authorLabel;
@property(nonatomic, retain) IBOutlet UIWebView *contentWebView;
//@property(nonatomic, retain) IBOutlet UIToolbar *shareBar;
//@property(nonatomic, retain) IBOutlet UIBarButtonItem *shareButton;
@property(nonatomic, retain) NewsItem *theNewsItem;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil newsItem:(NewsItem *)aNewsItem;
-(void)initialiseView;
-(IBAction)buttonPressed:(id)sender;

@end
