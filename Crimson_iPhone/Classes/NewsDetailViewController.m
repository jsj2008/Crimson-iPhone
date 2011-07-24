//
//  NewsDetailViewController.m
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/22/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsItem.h"

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
	[self initialiseView];
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
	authorLabel.text = theNewsItem.author;
	// TODO something with image here
	[mainScrollView addSubview:mainContentView];
	contentWebView.backgroundColor = [UIColor clearColor];
	[contentWebView setOpaque:NO];
	// TODO Load HTML String into contentWebView
	[mainScrollView insertSubview:contentWebView belowSubview:mainContentView];
}

-(IBAction)buttonPressed:(id)sender {
	if (shareButton == sender) {
		// TODO do something here with shareButton
	}
}

@end
