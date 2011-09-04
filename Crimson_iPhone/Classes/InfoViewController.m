//
//  InfoViewController.m
//  Crimson_iPhone
//
//  Created by Sophie Chang on 8/19/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "InfoViewController.h"


@implementation InfoViewController

@synthesize aboutWebView;

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
	self.navigationController.navigationBarHidden = NO;
	self.navigationController.navigationBar.backItem.title = @"Back"; 
	self.title = @"About";
	[aboutWebView loadHTMLString:@"<html><head><meta name='viewport' content='initial-scale=1.0,maximum-scale=10.0'/><style>#related_contents{display:none;} body{font-family: georgia,\"times new roman\",times,serif; background-color:transparent; padding-left:13px; padding-right:13px;}</style><style type=\"text/css\">a:link {color:#000000;text-decoration: none;}</style></head><body><div style=\"font-size:13.5;color:#000000\"><p><b>The Harvard Crimson<br />v 1.0</b></p><p><b>About Us</b></p><p>The Harvard Crimson is the only breakfast-table daily newspaper in Cambridge, Mass. The Crimson publishes every morning, Monday through Friday, except on federal and University holidays. In addition to the daily newspaper, The Crimson publishes an extended sports section on Mondays; an arts section on Tuesdays; and Fifteen Minutes, the weekend magazine of The Crimson, on Thursdays.</p><p><b>Copyright</b></p><p>Copyright 2011 by The Harvard Crimson, Inc. All content contained in this application (including, but not limited to, text, photographs, illustrations, video, and audio) is protected by U.S. copyright and other laws and may not be copied, modified, distributed, transmitted, displayed or published (either in hard copy or online) without the prior permission of The Harvard Crimson.</p><p><b>Privacy Policy</b></p><p>For more information about our privacy policy, please see: http://www.thecrimson.com/about/privacy/</p></div></body></html>" baseURL:nil];
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
}


- (void)dealloc {
    [super dealloc];
	[aboutWebView release];
}


@end
