//
//  FeedListViewController.h
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/22/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshView.h"

@interface FeedListViewController : UIViewController <PullToRefreshViewDelegate>{
	UITableView *articlesTable;
	UISegmentedControl *segControl;
	
	NSMutableArray *currentArticleItems;
	NSMutableArray *allNewsArticles;
	NSMutableArray *allOpinionArticles;
	NSMutableArray *allSportsArticles;
	NSMutableArray *allFMArticles;
	NSMutableArray *allArtsArticles;
	NSMutableArray *allFlybyArticles;
    
    NSOperationQueue *q;
    
    PullToRefreshView *pull;
}

@property(nonatomic, retain) IBOutlet UITableView *articlesTable;
@property(nonatomic, retain) IBOutlet UISegmentedControl *segControl;
@property(nonatomic, retain) PullToRefreshView *pull;
@property(nonatomic, retain) NSMutableArray *allNewsArticles;
@property(nonatomic, retain) NSMutableArray *allOpinionArticles;
@property(nonatomic, retain) NSMutableArray *allSportsArticles;
@property(nonatomic, retain) NSMutableArray *allFMArticles;
@property(nonatomic, retain) NSMutableArray *allArtsArticles;
@property(nonatomic, retain) NSMutableArray *allFlybyArticles;
@property(nonatomic, retain) NSMutableArray *currentArticleItems;

@property(nonatomic, retain) NSOperationQueue *q;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(IBAction)segmentedControlSegmentChanged:(id)sender;
-(IBAction)onInfoPressed:(id)sender;
-(void)updateTableWithNewData:(NSMutableArray *)newArray;
-(void)unloadQueue;
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;

@end
