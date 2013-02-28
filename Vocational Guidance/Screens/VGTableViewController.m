//
//  VGTableViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGTableViewController.h"
#import "VGTableView.h"


@interface VGTableViewController () 

@property (retain, nonatomic) IBOutlet UIView *presentionView;

@end

@implementation VGTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    VGTableView *tableView = [[[VGTableView alloc] initWithFrame: self.presentionView.frame] autorelease];
    tableView.bounces = NO;
    tableView.columns = [NSMutableArray arrayWithObjects: @"col1", @"col2", @"col3", @"col4", @"col5", @"col6", @"col7", @"col8", @"col9", @"col10", @"col11", nil];
    tableView.rows = [NSMutableArray arrayWithObjects: @"row1", @"row2", @"row3", @"row4", @"row5", @"rowl6", @"row7", @"row8", @"row9", @"row10", @"row11", nil];
    tableView.values = [NSMutableArray array];
    for (NSInteger i = 0; i < tableView.rows.count; i++) {
        for (NSInteger j = 0; j < tableView.columns.count; j++) {
            VGTableCell *tableCell = [[VGTableCell new] autorelease];
            tableCell.rowIndex = i;
            tableCell.colIndex = j;
            tableCell.value = [NSString stringWithFormat:@"%f", ((float)(arc4random()  % 100)) / 100] ;
            [tableView.values addObject: tableCell];
        }
    }
    [self.view addSubview: tableView];
}

- (void)dealloc {
    [_presentionView release];
    [super dealloc];
}
@end
