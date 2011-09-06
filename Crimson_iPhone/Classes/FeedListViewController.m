//
//  FeedListViewController.m
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/22/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "FeedListViewController.h"
#import "NewsRequestOperation.h"
#import "ArticleTableViewCell.h"
#import "NewsDetailViewController.h"
#import "InfoViewController.h"
#import "UIView+FirstResponder.h"
#import "dialogs.h"
#import "config.h"
#import "FlurryAPI.h"

@interface FeedListViewController(Private)

-(void)initialiseView;

@end

@implementation FeedListViewController

@synthesize articlesTable;
@synthesize segControl;

@synthesize allNewsArticles;
@synthesize allOpinionArticles;
@synthesize allSportsArticles;
@synthesize allFMArticles;
@synthesize allArtsArticles;
@synthesize allFlybyArticles;
@synthesize currentArticleItems;


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
	self.title = @"";
	self.allNewsArticles = [NSMutableArray array];
	self.allOpinionArticles = [NSMutableArray array];
	self.allSportsArticles = [NSMutableArray array];
	self.allFMArticles = [NSMutableArray array];
	self.allArtsArticles = [NSMutableArray array];
	self.allFlybyArticles = [NSMutableArray array];
	self.currentArticleItems = [NSMutableArray array];
	
	[self initialiseView];
	
	NSOperationQueue *q = [[NSOperationQueue alloc]init];
	[q setMaxConcurrentOperationCount:2];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fetchArticlesRequestDidFinish:) name:NEWS_NOTIFICATION object:nil];
	 
	 NewsRequestOperation *op1 = [NewsRequestOperation operationWithSection:eSectionNews];
	 NewsRequestOperation *op2 = [NewsRequestOperation operationWithSection:eSectionOpinion];
	 NewsRequestOperation *op3 = [NewsRequestOperation operationWithSection:eSectionSports];
	 NewsRequestOperation *op4 = [NewsRequestOperation operationWithSection:eSectionFM];
	 NewsRequestOperation *op5 = [NewsRequestOperation operationWithSection:eSectionArts];
	 NewsRequestOperation *op6 = [NewsRequestOperation operationWithSection:eSectionFlyby];
	 
	 [op1 setQueuePriority:NSOperationQueuePriorityVeryHigh];
	 [q addOperation:op1];
	 [q addOperation:op2];
	 [q addOperation:op3];
	 [q addOperation:op4];
	 [q addOperation:op5];
	 [q addOperation:op6];
	 
	 [q release];
						  
}

- (void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}



// Override to allow orientations other than the default portrait orientation.
/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.articlesTable = nil;
	self.segControl = nil;
}

- (void)dealloc {
    [super dealloc];
	
	[articlesTable release];
	[segControl release];
	
	[allNewsArticles release];
	[allOpinionArticles release];
	[allSportsArticles release];
	[allFMArticles release];
	[allArtsArticles release];
	[allFlybyArticles release];
	[currentArticleItems release];
}

-(void)setupSegControl {
	[segControl removeAllSegments];
	[segControl insertSegmentWithTitle:kArticleSegmentNews atIndex:0 animated:NO];
	[segControl insertSegmentWithTitle:kArticleSegmentOpinion atIndex:1 animated:NO];
	[segControl insertSegmentWithTitle:kArticleSegmentSports atIndex:2 animated:NO];
	[segControl insertSegmentWithTitle:kArticleSegmentFM atIndex:3 animated:NO];
	[segControl insertSegmentWithTitle:kArticleSegmentArts atIndex:4 animated:NO];
	[segControl insertSegmentWithTitle:kArticleSegmentFlyby atIndex:5 animated:NO];
	segControl.selectedSegmentIndex = 0;
    
}

-(void)initialiseView {
	NSLog(@"Initializing View");
	[self setupSegControl];
}

-(IBAction)segmentedControlSegmentChanged:(id)sender {
	if (0 == segControl.selectedSegmentIndex) {
		[self.currentArticleItems removeAllObjects];
		self.currentArticleItems = [NSMutableArray arrayWithArray:self.allNewsArticles];
		[FlurryAPI logEvent:@"Viewed News feed"];
	}
	if (1 == segControl.selectedSegmentIndex) {
		[self.currentArticleItems removeAllObjects];
		self.currentArticleItems = [NSMutableArray arrayWithArray:self.allOpinionArticles];
		[FlurryAPI logEvent:@"Viewed Opinion feed"];
	}
	if (2 == segControl.selectedSegmentIndex) {
		[self.currentArticleItems removeAllObjects];
		self.currentArticleItems = [NSMutableArray arrayWithArray:self.allSportsArticles];
		[FlurryAPI logEvent:@"Viewed Sports feed"];
	}
	if (3 == segControl.selectedSegmentIndex) {
		[self.currentArticleItems removeAllObjects];
		self.currentArticleItems = [NSMutableArray arrayWithArray:self.allFMArticles];
		[FlurryAPI logEvent:@"Viewed FM feed"];
	}
	if (4 == segControl.selectedSegmentIndex) {
		[self.currentArticleItems removeAllObjects];
		self.currentArticleItems = [NSMutableArray arrayWithArray:self.allArtsArticles];
		[FlurryAPI logEvent:@"Viewed Arts feed"];
	}
	if (5 == segControl.selectedSegmentIndex) {
		[self.currentArticleItems removeAllObjects];
		self.currentArticleItems = [NSMutableArray arrayWithArray:self.allFlybyArticles];
		[FlurryAPI logEvent:@"Viewed Flyby feed"];
	}
	[self.articlesTable reloadData];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	[[self.view findFirstResponder]resignFirstResponder];
	if ([currentArticleItems count] > indexPath.row) {
		NewsDetailViewController *vc = [[NewsDetailViewController alloc]initWithNibName:@"NewsDetailViewController" bundle:[NSBundle mainBundle] newsItem:[currentArticleItems objectAtIndex:indexPath.row]];	
		[self.navigationController pushViewController:vc animated:YES];
		[vc release];
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NewsItem *tmpNews = (NewsItem *)[currentArticleItems objectAtIndex:indexPath.row];
	return [ArticleTableViewCell rowHeight:tmpNews];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell2";
	
	ArticleTableViewCell *cell = (ArticleTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[ArticleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	
	if ([currentArticleItems count] > indexPath.row) {
		[cell configureWithNewsItem:[currentArticleItems objectAtIndex:indexPath.row]];
	}
	
	return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.currentArticleItems count];
}

-(void)fetchArticlesRequestDidFinish:(NSNotification *)notification {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(fetchArticlesRequestDidFinish:) withObject:notification waitUntilDone:YES];
		return;
	}
	
	NSArray *responseData = [notification.userInfo objectForKey:@"ResponseData"];
	NSString *responseError = [notification.userInfo objectForKey:@"ResponseError"];
	
	if ((responseData) && ((!responseError) || ([@"" isEqualToString:responseError]))) {
		if ([responseData count] > 0) {
		// api request success
		NewsItem *item = [responseData objectAtIndex:0];
		switch (item.section) {
			case eSectionNews:
				[self.allNewsArticles removeAllObjects];
				self.allNewsArticles = [NSMutableArray arrayWithArray:responseData];
				if (0 == segControl.selectedSegmentIndex) {
					NSLog(@"Going to update new data");
					[self updateTableWithNewData:self.allNewsArticles];
				}
				break;
			case eSectionOpinion:
				[self.allOpinionArticles removeAllObjects];
				self.allOpinionArticles = [NSMutableArray arrayWithArray:responseData];
				if (1 == segControl.selectedSegmentIndex) {
					[self updateTableWithNewData:self.allOpinionArticles];
				}
				break;
			case eSectionSports:
				[self.allSportsArticles removeAllObjects];
				self.allSportsArticles = [NSMutableArray arrayWithArray:responseData];
				if (2 == segControl.selectedSegmentIndex) {
					[self updateTableWithNewData:self.allSportsArticles];
				}
				break;
			case eSectionFM:
				[self.allFMArticles removeAllObjects];
				self.allFMArticles = [NSMutableArray arrayWithArray:responseData];
				if (3 == segControl.selectedSegmentIndex) {
					[self updateTableWithNewData:self.allFMArticles];
				}
				break;
			case eSectionArts:
				[self.allArtsArticles removeAllObjects];
				self.allArtsArticles = [NSMutableArray arrayWithArray:responseData];
				if (4 == segControl.selectedSegmentIndex) {
					[self updateTableWithNewData:self.allArtsArticles];
				}
				break;
			case eSectionFlyby:
				[self.allFlybyArticles removeAllObjects];
				self.allFlybyArticles = [NSMutableArray arrayWithArray:responseData];
				if (5 == segControl.selectedSegmentIndex) {
					[self updateTableWithNewData:self.allFlybyArticles];
				}
				break;
		}}
	}
}

-(void)updateTableWithNewData:(NSMutableArray *)newArray
{
	BOOL needsToReload = NO;
	
	if ([self.currentArticleItems count] != [newArray count])
	{
		needsToReload = YES;
	}
	
	[self.currentArticleItems removeAllObjects];
	self.currentArticleItems = [NSMutableArray arrayWithArray:newArray];
	
	if (needsToReload)
	{
		[self.articlesTable reloadData];
	}
}

-(NSMutableArray*)arrayForSelectedSegment {
	
	switch (segControl.selectedSegmentIndex) {
		case 0:
			return self.allNewsArticles;
			break;
		case 1:
			return self.allOpinionArticles;
			break;
		case 2:
			return self.allSportsArticles;
			break;
		case 3:
			return self.allFMArticles;
			break;
		case 4:
			return self.allArtsArticles;
			break;
		case 5:
			return self.allFlybyArticles;
			break;
		default:
			break;
	}
	
	return nil;
}

- (void)scrollViewWillBeginDragging:(UITableView *)tableView {
	
	[[self.view findFirstResponder] resignFirstResponder];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[super touchesEnded:touches withEvent:event];
	[[self.view findFirstResponder] resignFirstResponder];
}

-(IBAction)onInfoPressed:(id)sender {
	InfoViewController *info = [[InfoViewController alloc]initWithNibName:@"InfoViewController" bundle:[NSBundle mainBundle]];
	[UIView beginAnimations:@"View Flip" context:nil];
	[UIView setAnimationDuration:0.80];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	
	[UIView setAnimationTransition:
	 UIViewAnimationTransitionFlipFromRight
						   forView:self.navigationController.view cache:NO];
	
	
	[self.navigationController pushViewController:info animated:YES];
	[UIView commitAnimations];
	[info release];
}

-(IBAction)onRefreshPressed:(id)sender {
    NSLog(@"Refresh button pressed");
}
	 
@end
