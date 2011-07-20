//
//  FeedListViewController.m
//  HarvardCrimson-iPhone
//
//  Created by Sophie Chang on 7/20/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "FeedListViewController.h"
#import "dialogs.h"

@implementation FeedListViewController
@synthesize chooseFeed;
@synthesize feedList;

@synthesize allNewsArticles;
@synthesize allOpinionArticles;
@synthesize allSportsArticles;
@synthesize allFMArticles;
@synthesize allArtsArticles;
@synthesize allFlybyArticles;
@synthesize currentArticleItems;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	[super viewDidLoad];
	
	self.allNewsArticles = [NSMutableArray array];
	self.allOpinionArticles = [NSMutableArray array];
	self.allSportsArticles = [NSMutableArray array];
	self.allFMArticles = [NSMutableArray array];
	self.allArtsArticles = [NSMutableArray array];
	self.allFlybyArticles = [NSMutableArray array];
	self.currentArticleItems = [NSMutableArray array];
	
	[self initializeView];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) setSegControl {
	[chooseFeed removeAllSegments];
	[chooseFeed insertSegmentWithTitle: kArticleSegmentNews atIndex:0 animated:NO];
	[chooseFeed insertSegmentWithTitle: kArticleSegmentOpinion atIndex:1 animated:NO];
	[chooseFeed insertSegmentWithTitle: kArticleSegmentSports atIndex:2 animated:NO];
	[chooseFeed insertSegmentWithTitle: kArticleSegmentFM atIndex:3 animated:NO];
	[chooseFeed insertSegmentWithTitle: kArticleSegmentArts atIndex:4 animated:NO];
	[chooseFeed insertSegmentWithTitle: kArticleSegmentFlyby atIndex:5 animated:NO];
	chooseFeed.selected = 0;
}

- (void) initializeView {
	[self setSegControl];
}

- (IBAction) segmentedControlIndexChanged:(id)sender {
	switch (self.chooseFeed.selectedSegmentIndex) {
		case 0:
			[self.currentArticleItems removeAllObjects]
			self.currentArticleItems = [NSMutableArray arrayWithArray:self.allNewsArticles];
		case 1:
			[self.currentArticleItems removeAllObjects];
			self.currentArticleItems = [NSMutableArray arrayWithArray:self.allOpinionArticles];
		case 2:
			[self.currentArticleItems removeAllObjects];
			self.currentArticleItems = [NSMutableArray arrayWithArray:self.allSportsArticles];
		case 3:
			[self.currentArticleItems removeAllObjects];
			self.currentArticleItems = [NSMutableArray arrayWithArray:self.allFMArticles];
		case 4:
			[self.currentArticleItems removeAllObjects];
			self.currentArticleItems = [NSMutableArray arrayWithArray:self.allArtsArticles];
		case 5:
			[self.currentArticleItems removeAllObjects];
			self.currentArticleItems = [NSMutableArray arrayWithArray:self.allFlybyArticles];
	}
	
	[self.feedList reloadData];
}

//TODO: Table View Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[chooseFeed release];
	[feedList release];
    [super dealloc];
}


@end
