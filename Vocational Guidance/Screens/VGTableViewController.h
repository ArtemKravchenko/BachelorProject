//
//  VGTableViewController.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseViewController.h"
#import "VGTableView.h"
#import "VGGraphViewController.h"
#import "VGAppDelegate.h"

@interface VGTableViewController : VGBaseViewController <VGTableAddDelegate>

@property (nonatomic, retain) VGTableView *tableView;
@property (nonatomic, retain) VGGraphViewController *graphView;
@property (nonatomic, retain) VGUser* user;

- (id)initWithUser:(VGUser*)user;

@end
