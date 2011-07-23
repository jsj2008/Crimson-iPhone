//
//  NewsItemCellInterface.h
//  Crimson_iPhone
//
//  Created by Sophie Chang on 7/23/11.
//  Copyright 2011 Harvard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsItem.h"

@protocol NewsItemCellInterface<NSObject>
@required
+(float)rowHeight:(NewsItem *)theNewsItem;
@end
