//
//  InfoViewController.h
//  Crimson_iPhone
//
//  Created by Sophie Chang on 8/19/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface InfoViewController : UIViewController {
	UIWebView *aboutWebView;
}

@property(nonatomic, retain) IBOutlet UIWebView *aboutWebView;

@end
