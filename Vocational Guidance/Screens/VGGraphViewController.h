//
//  VGGraphViewController.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 28.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGAppDelegate.h"

@interface VGGraphViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *tableData;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end

@interface VGGraphItem : UIView

@end

@interface VGGraphDesktop : UIScrollView

@end