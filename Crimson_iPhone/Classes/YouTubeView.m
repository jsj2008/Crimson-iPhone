//
//  YouTubeView.m
//  Crimson_iPhone
//
//  Created by Sophie Chang on 9/19/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import "YouTubeView.h"

#pragma mark-
#pragma mark Initialization

@implementation YouTubeView

-(YouTubeView *)initWithStringAsURL:(NSString *)urlString frame:(CGRect)frame {
    if ((self = [super init])) 
    {
        // Create webview with requested frame size
        self = [[UIWebView alloc] initWithFrame:frame];
        
        // HTML to embed YouTube video
        NSString *youTubeVideoHTML = @"<html><head>\
        <body style=\"margin:0\">\
        <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
        width=\"%0.0f\" height=\"%0.0f\"></embed>\
        </body></html>";
        
        // Populate HTML with the URL and requested frame size
        NSString *html = [NSString stringWithFormat:youTubeVideoHTML, urlString, frame.size.width, frame.size.height];
        
        // Load the html into the webview
        [self loadHTMLString:html baseURL:nil];
    }
    return self;  
}

#pragma mark -
#pragma mark Cleanup

- (void)dealloc 
{
    [super dealloc];
}

@end