//
//  NewsDetailViewController.m
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/22/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsItem.h"
#import "UIImageView+WebCache.h"
#import "NSDate+RelativeDate.h"
#import "UILabel+Categories.h"
#import "config.h"
#import "dialogs.h"
#import "HTMLParser.h"
#import "SHK.h"
#import "FlurryAPI.h"
#import "YouTubeView.h"

@interface NewsDetailViewController(Private)
-(NSString *)stringNameForSection:(Section)theSection;
@end

@implementation NewsDetailViewController

@synthesize mainScrollView;
@synthesize mainContentView;
@synthesize imageView;
@synthesize titleLabel;
@synthesize dateLabel;
@synthesize articleImage;
@synthesize contentWebView;
@synthesize authorLabel;
//@synthesize shareButton;
//@synthesize shareBar;
@synthesize theNewsItem;
@synthesize youTubeView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil newsItem:(NewsItem*)aNewsItem {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
		self.theNewsItem = aNewsItem;
    }
    return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.contentWebView.userInteractionEnabled = YES;
	UILabel *tmpTitleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)] autorelease];
	tmpTitleLabel.textAlignment = UITextAlignmentCenter;
	tmpTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
	tmpTitleLabel.text = [self stringNameForSection:theNewsItem.section];
	tmpTitleLabel.textColor = [UIColor whiteColor];
	tmpTitleLabel.backgroundColor = [UIColor clearColor];
	self.navigationItem.titleView = tmpTitleLabel;
	[self initialiseView];
	self.navigationController.navigationBarHidden = NO;
	self.navigationController.navigationBar.backItem.title = @"Back"; 
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(buttonPressed:)];
    self.navigationItem.rightBarButtonItem = item;
    [item release];
}

// Override to allow orientations other than the default portrait orientation.
/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.imageView = nil;
	self.mainScrollView = nil;
	self.mainContentView = nil;
	self.articleImage = nil;
	self.titleLabel = nil;
	self.authorLabel = nil;
	self.dateLabel = nil;
	self.contentWebView = nil;
    self.youTubeView = nil;
	//self.shareButton = nil;
	//self.shareBar = nil;
}


- (void)dealloc {
    [super dealloc];
	[imageView release];
	[mainScrollView release];
	[mainContentView release];
	[titleLabel release];
	[dateLabel release];
	[articleImage release];
	[authorLabel release];
	[contentWebView release];
    [youTubeView release];
	//[shareButton release];
	//[shareBar release];
	//[theNewsItem release];
}

-(void)initialiseView {
	NSString *logMsg = [NSString stringWithFormat:@"Viewed article: %@", theNewsItem.title];
	[FlurryAPI logEvent:logMsg];
    contentWebView.backgroundColor = [UIColor clearColor];
	[contentWebView setOpaque:NO];
	NSError * error = nil;
	NSString *link = [NSString stringWithFormat:@"%@", theNewsItem.link];
	
	HTMLParser * parser = [[HTMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:link] error:&error];
	if (error) {
		[contentWebView loadHTMLString:[NSString stringWithFormat:@"<html><head><style>#related_contents{display:none;} body{font-family: georgia,\"times new roman\",times,serif; background-color:transparent; padding-left:13px; padding-right:13px; width: 302px; overflow:hidden;}</style><style type=\"text/css\">a:link {color:#000000;text-decoration: none;}</style></head><body><div style=\"font-size:13.5;color:#000000\">%@<p>Connect to the Internet for full article text.</div></body></html>", theNewsItem.description] baseURL:nil];
	}
	else {
		HTMLNode *bodyNode = [parser body];
		NSArray *divNodes = [bodyNode findChildTags:@"div"];
		NSString *articleText = nil;
		for (HTMLNode *divNode in divNodes) {
			if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"text"]) {
				articleText = rawContentsOfNode(divNode -> _node);
			}
		}
		[contentWebView loadHTMLString:[NSString stringWithFormat:@"<html><head><style>#related_contents{display:none;} body{overflow: hidden; font-family: georgia,\"times new roman\",times,serif; background-color:transparent; padding-left:13px; padding-right:20px;}</style><style type=\"text/css\">a:link {color:#000000;text-decoration: none;}</style></head><body><div style=\"font-size:13.5;color:#000000\">%@</div></body></html>", articleText] baseURL:nil];
	}
	titleLabel.backgroundColor = [UIColor clearColor];
	[titleLabel setTextWithFlexibleHeight:theNewsItem.title withWidth:280];
	CGRect newFrame = authorLabel.frame;
	newFrame.origin.y = titleLabel.frame.origin.y + titleLabel.frame.size.height-2;
	authorLabel.frame = newFrame;
	authorLabel.text = [NSString stringWithFormat:@"By: %@", [[NSString stringWithFormat:@"%@", theNewsItem.author] uppercaseString]];
	newFrame = dateLabel.frame;
	newFrame.origin.y = authorLabel.frame.origin.y + authorLabel.frame.size.height-7;
	dateLabel.frame = newFrame;
	dateLabel.text = [NSDate getNewsDate:theNewsItem.pubDate];
    if ([theNewsItem.contentURL hasPrefix:YOUTUBE_URL]) {
        youTubeView = [[YouTubeView alloc] 
                                    initWithStringAsURL:theNewsItem.contentURL 
                                    frame:CGRectMake(17.5, 17.5, 285, 223)];
        float rowHeight = titleLabel.frame.size.height+authorLabel.frame.size.height+dateLabel.frame.size.height+10;
        [imageView addSubview:youTubeView];
        mainContentView.frame = CGRectMake(-2, imageView.frame.size.height +15, 320, rowHeight);
    }

	else if (theNewsItem.contentURL && ![theNewsItem.contentURL hasPrefix:YOUTUBE_URL]) {
		articleImage.contentMode = UIViewContentModeScaleAspectFit;
		if ([theNewsItem.contentURL hasPrefix:[NSString stringWithFormat:@"%@", HOME_URL]]) {
			[articleImage setImageWithURL:[NSURL URLWithString:theNewsItem.contentURL] placeholderImage:[UIImage imageNamed:@"grey_seal.png"]];
		}
		else {
			NSString *fullURL = [NSString stringWithFormat:@"%@%@", HOME_URL, theNewsItem.contentURL];
			[articleImage setImageWithURL:[NSURL URLWithString:fullURL] placeholderImage:[UIImage imageNamed:@"grey_seal.png"]];
		}
		imageView.backgroundColor = [UIColor clearColor];
		imageView.frame = CGRectMake(0, 0, 320, articleImage.frame.size.height+10);
		float rowHeight = titleLabel.frame.size.height+authorLabel.frame.size.height+dateLabel.frame.size.height+10;
		mainContentView.frame = CGRectMake(-2, articleImage.frame.size.height + imageView.frame.origin.y +15, 320, rowHeight);
        
	}
    else {
		CGRect theFrame = CGRectMake(0,0,0,0);
		imageView.frame = theFrame;
		float rowHeight = titleLabel.frame.size.height+authorLabel.frame.size.height+dateLabel.frame.size.height+10;
		mainContentView.frame = CGRectMake(-2, 0, 320, rowHeight);
	}
    mainContentView.backgroundColor = [UIColor clearColor];
    [mainScrollView addSubview:contentWebView];
	[parser release];	
}

-(NSString *)stringNameForSection:(Section)theSection {
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
	return sectionString;
}


-(IBAction)buttonPressed:(id)sender {
		// Create the item to share (in this example, a url)
		NSURL *url = [NSURL URLWithString:theNewsItem.link];
		SHKItem *item = [SHKItem URL:url title:theNewsItem.title];
		
		// Get the ShareKit action sheet
		SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
		
		// Display the action sheet
		[actionSheet showFromToolbar:self.navigationController.toolbar];
	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 
{	
    [mainScrollView insertSubview:mainContentView aboveSubview:contentWebView];
    [mainScrollView insertSubview:imageView aboveSubview:mainContentView];
    
	CGRect frame = contentWebView.frame;
    frame.size.height = 1;
    contentWebView.frame = frame;
    CGSize fittingSize = [contentWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    contentWebView.frame = frame;
	
	
	CGRect theFrame = contentWebView.frame;
	theFrame.origin.x = - 2;
	theFrame.origin.y = mainContentView.frame.size.height + mainContentView.frame.origin.y - 20;
	contentWebView.frame = theFrame;
    
	CGRect contentRect = CGRectZero;
	for (UIView *view in [mainScrollView subviews])
		contentRect = CGRectUnion(contentRect, view.frame);
    mainScrollView.contentSize = CGSizeMake(320, contentRect.size.height);
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
{	
	if(navigationType == UIWebViewNavigationTypeLinkClicked)
	{
		return NO;
	}
	
	return YES;
}

@end
