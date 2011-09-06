//
//  FeedListViewController.h
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/22/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedListViewController : UIViewController {
	UITableView *articlesTable;
	UISegmentedControl *segControl;
	
	NSMutableArray *currentArticleItems;
	NSMutableArray *allNewsArticles;
	NSMutableArray *allOpinionArticles;
	NSMutableArray *allSportsArticles;
	NSMutableArray *allFMArticles;
	NSMutableArray *allArtsArticles;
	NSMutableArray *allFlybyArticles;
}

@property(nonatomic, retain) IBOutlet UITableView *articlesTable;
@property(nonatomic, retain) IBOutlet UISegmentedControl *segControl;

@property(nonatomic, retain) NSMutableArray *allNewsArticles;
@property(nonatomic, retain) NSMutableArray *allOpinionArticles;
@property(nonatomic, retain) NSMutableArray *allSportsArticles;
@property(nonatomic, retain) NSMutableArray *allFMArticles;
@property(nonatomic, retain) NSMutableArray *allArtsArticles;
@property(nonatomic, retain) NSMutableArray *allFlybyArticles;
@property(nonatomic, retain) NSMutableArray *currentArticleItems;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
-(IBAction)segmentedControlSegmentChanged:(id)sender;
-(IBAction)onInfoPressed:(id)sender;
-(IBAction)onRefreshPressed:(id)sender;
-(void)updateTableWithNewData:(NSMutableArray *)newArray;

@end
