//
//  FeedListViewController.h
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/22/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsDetailViewController;

@interface FeedListViewController : UIViewController {
	IBOutlet NewsDetailViewController *detailsViewController;
}

@property(nonatomic, retain) NewsDetailViewController *detailsViewController;

-(IBAction)PressMe:(id)sender;

@end
