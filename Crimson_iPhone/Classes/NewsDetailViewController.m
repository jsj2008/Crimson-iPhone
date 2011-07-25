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
#import "config.h"
#import "dialogs.h"
#import "HTMLParser.h"

@interface NewsDetailViewController(Private)
-(NSString *)stringNameForSection:(Section)theSection;
@end

@implementation NewsDetailViewController

@synthesize mainScrollView;
@synthesize mainContentView;
@synthesize titleLabel;
@synthesize dateLabel;
@synthesize articleImage;
@synthesize contentWebView;
@synthesize authorLabel;
@synthesize shareButton;

@synthesize theNewsItem;

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
	self.contentWebView.userInteractionEnabled = NO;
	self.title = [self stringNameForSection:theNewsItem.section];
	[self initialiseView];
	self.navigationController.navigationBarHidden = NO;
	self.navigationController.navigationBar.backItem.title = @"Back";  
	self.navigationController.navigationBar.tintColor = [UIColor 
														 colorWithRed:186.0/255 
														 green:6.0/255 
														 blue:0.0/255 
														 alpha:1];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.mainScrollView = nil;
	self.mainContentView = nil;
	self.articleImage = nil;
	self.titleLabel = nil;
	self.authorLabel = nil;
	self.dateLabel = nil;
	self.contentWebView = nil;
	self.shareButton = nil;
}


- (void)dealloc {
    [super dealloc];
	
	[mainScrollView release];
	[mainContentView release];
	[titleLabel release];
	[dateLabel release];
	[articleImage release];
	[authorLabel release];
	[contentWebView release];
	[shareButton release];
	
	[theNewsItem release];
}

-(void)initialiseView {
	titleLabel.text = theNewsItem.title;
	authorLabel.text = [NSString stringWithFormat:@"By: %@", [[NSString stringWithFormat:@"%@", theNewsItem.author] uppercaseString]];
	dateLabel.text = [NSDate getNewsDate:theNewsItem.pubDate];
	if (theNewsItem.thumbnailURL) {
		if ([theNewsItem.thumbnailURL hasPrefix:[NSString stringWithFormat:@"%@", HOME_URL]]) {
			[articleImage setImageWithURL:[NSURL URLWithString:theNewsItem.thumbnailURL] placeholderImage:[UIImage imageNamed:@"grey_seal.png"]];
		}
		else {
			NSString *fullURL = [NSString stringWithFormat:@"%@%@", HOME_URL, theNewsItem.thumbnailURL];
			[articleImage setImageWithURL:[NSURL URLWithString:fullURL] placeholderImage:[UIImage imageNamed:@"grey_seal.png"]];
		}
	}
	else {
		[articleImage setImage:[UIImage imageNamed:@"grey_seal.png"]];
	}
	[mainScrollView addSubview:mainContentView];
	contentWebView.backgroundColor = [UIColor clearColor];
	[contentWebView setOpaque:NO];
	NSError * error = nil;
	NSString *link = [NSString stringWithFormat:@"%@", theNewsItem.link];
	HTMLParser * parser = [[HTMLParser alloc] initWithContentsOfURL:[NSURL URLWithString:link] error:&error];
	if (error) {
		NSLog(@"Error: %@", error);
		return;
	}
	HTMLNode *bodyNode = [parser body];
	NSArray *divNodes = [bodyNode findChildTags:@"div"];
	NSString *articleText = nil;
	for (HTMLNode *divNode in divNodes) {
		if ([[divNode getAttributeNamed:@"class"] isEqualToString:@"text"]) {
			articleText = rawContentsOfNode(divNode -> _node);
		}
	}
	[parser release];
	//Load the request in the UIWebView.
	[contentWebView loadHTMLString:[NSString stringWithFormat:@"<html><head><style>#related_contents{display:none;} body{font-family: georgia,\"times new roman\",times,serif; background-color:transparent; padding-left:13px; padding-right:13px;}</style><style type=\"text/css\">a:link {color:#000000;text-decoration: none;}</style></head><body><div style=\"font-size:13.5;color:#000000\">%@</div></body></html>", articleText] baseURL:nil];
	[mainScrollView insertSubview:contentWebView belowSubview:mainContentView];
	[shareButton setTitle:@"Share" forState:UIControlStateNormal];
	[mainScrollView addSubview:shareButton];
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
	if (shareButton == sender) {
		// TODO do something here with shareButton
	}
}

- (void)webViewDidFinishLoad:(UIWebView *)webView 
{	
	CGRect frame = contentWebView.frame;
    frame.size.height = 1;
    contentWebView.frame = frame;
    CGSize fittingSize = [contentWebView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    contentWebView.frame = frame;
	
	
	CGRect theFrame = contentWebView.frame;
	theFrame.origin.x = - 2;
	theFrame.origin.y = mainContentView.frame.size.height + mainContentView.frame.origin.y - 10;
	contentWebView.frame = theFrame;
	
	//Reposition share button
	theFrame = shareButton.frame;
	theFrame.origin.x = ((320-theFrame.size.width)/2);
	theFrame.origin.y = contentWebView.frame.origin.y + contentWebView.frame.size.height + 5;
	shareButton.frame = theFrame;
	
	//Resize main scroll view content view
	mainScrollView.contentSize = CGSizeMake(320, mainContentView.frame.size.height + contentWebView.frame.size.height + shareButton.frame.size.height + 15);
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType 
{	
	if(navigationType == UIWebViewNavigationTypeLinkClicked)
	{
		return NO;
	}
	
	return YES;
}

-(void)composeMail {
	
	if(![MFMailComposeViewController canSendMail]) {
		
		UIAlertView *cantMailAlert = [[UIAlertView alloc]initWithTitle:@""
															   message:kSharingEmailNotEnabled
															  delegate:nil
													 cancelButtonTitle:kDefaultAlertViewOk
													 otherButtonTitles:nil];
		[cantMailAlert show];
		[cantMailAlert release];
		return;
	}
	
	MFMailComposeViewController *mailController = [[[MFMailComposeViewController alloc]init]autorelease];
	mailController.navigationBar.tintColor = [UIColor blackColor];
	[mailController setSubject:kSharingEmailSubjectPrefix];
	[mailController setMessageBody:[NSString stringWithFormat:@"<p>%@</p><p>%@</p><p>%@</p>", theNewsItem.title, theNewsItem.description, theNewsItem.link] isHTML:YES];
	mailController.mailComposeDelegate = self;
	[self presentModalViewController:mailController animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller 
		  didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	
	if(error) 
	{
		
		UIAlertView *mailErrorAlert = [[UIAlertView alloc]initWithTitle:@"" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok"otherButtonTitles:nil];
		[mailErrorAlert show];
		[mailErrorAlert release];
		
	}
	else {
		
		[self dismissModalViewControllerAnimated:YES];
	}
}

@end
