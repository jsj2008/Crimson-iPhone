//
//  FeedListViewController.h
//  HarvardCrimson-iPhone
//
//  Created by Sophie Chang on 7/20/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FeedListViewController : UIViewController {
	IBOutlet UISegmentedControl *chooseFeed;
	IBOutlet UITableView *feedList;
	
	NSMutableArray *allNewsArticles;
	NSMutableArray *allOpinionArticles;
	NSMutableArray *allSportsArticles;
	NSMutableArray *allFMArticles;
	NSMutableArray *allArtsArticles;
	NSMutableArray *allFlybyArticles;
	NSMutableArray *currentArticleItems;
}

// interface
@property (nonatomic, retain) IBOutlet UISegmentedControl *chooseFeed;
@property (nonatomic, retain) IBOutlet UITableView *feedList;

// data
@property(nonatomic, retain) NSMutableArray *allNewsArticles;
@property(nonatomic, retain) NSMutableArray *allOpinionArticles;
@property(nonatomic, retain) NSMutableArray *allSportsArticles;
@property(nonatomic, retain) NSMutableArray *allFMArticles;
@property(nonatomic, retain) NSMutableArray *allArtsArticles;
@property(nonatomic, retain) NSMutableArray *allFlybyArticles;
@property(nonatomic, retain) NSMutableArray *currentArticleItems;

-(IBAction) segmentedControlIndexChanged:(id)sender;
-(void) updateTableWithNewData:(NSMutableArray *)newArray;

@end
