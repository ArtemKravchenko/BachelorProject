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

@interface VGTableViewController : VGBaseViewController <VGTableAddDelegate>

@property (nonatomic, retain) VGTableView *tableView;
@property (nonatomic, retain) VGGraphViewController *graphViewController;
@property (nonatomic, assign) id<VGPerson> user;

- (id)initWithUser:(id<VGPerson>)user andEditMode:(BOOL)editMode;

@end
