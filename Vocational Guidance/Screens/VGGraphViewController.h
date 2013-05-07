//
//  VGGraphViewController.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 28.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGAppDelegate.h"

@interface VGGraphViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, retain) NSMutableArray *tableData;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) id<VGPerson> user;

- (void) reloadDataWithArray:(NSMutableArray*)array;
- (id) initWIthUser:(id<VGPerson>)user;

@end

@interface VGGraphItem : UIView

@end

@interface VGGraphDesktopLines : UIView

@property (nonatomic, retain) NSMutableArray* tableValues;
@property (retain, nonatomic) id<VGPerson> user;

- (void) reloadData;

@end

@interface VGGraphDesktop : UIScrollView

@property (nonatomic, retain) NSMutableArray* tableValues;
@property (nonatomic, retain) VGGraphDesktopLines *gdl;
@property (retain, nonatomic) id<VGPerson> user;

- (void) reloadItems;

@end