//
//  VGTableViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGTableViewController.h"
#import "VGAppDelegate.h"


@interface VGTableViewController () 

@property (retain, nonatomic) IBOutlet UIView *presentionView;
@property (retain, nonatomic) IBOutlet UIButton *btnEdit;
@property (retain, nonatomic) IBOutlet UIButton *btnSave;

- (IBAction)clickViewTransition:(id)sender;
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
    self.tableView = [[[VGTableView alloc] initWithFrame: CGRectMake(0, 0, self.presentionView.frame.size.width, self.presentionView.frame.size.height)] autorelease];
    self.tableView.bounces = NO;
    NSMutableArray* columns = [NSMutableArray arrayWithObjects: @"col1", @"col2", @"col3", @"col4", @"col5", @"col6", @"col7", @"col8",  @"col9", @"col10", @"col11", nil];
    NSMutableArray* rows = [NSMutableArray arrayWithObjects: @"row1", @"row2", @"row3", @"row4", @"row5", @"rowl6", @"row7", @"row8", @"row9", @"row10", @"row11", nil];
    
    //self.tableView.values = [NSMutableArray array];
    NSMutableArray *values = [NSMutableArray array];
    for (NSInteger i = 0; i < rows.count; i++) {
        for (NSInteger j = 0; j < columns.count; j++) {
            VGTableCell *tableCell = [[VGTableCell new] autorelease];
            tableCell.rowIndex = i;
            tableCell.colIndex = j;
            tableCell.value = [NSString stringWithFormat:@"%.2f", ((float)(arc4random()  % 100)) / 100.0] ;
            [values addObject: tableCell];
        }
    }
    [self setData:rows columns:columns values:values];
    // init graph view
    self.graphView = [[VGGraphViewController new] autorelease];
    self.graphView.view.frame = CGRectMake(0, 0, self.presentionView.frame.size.width, self.presentionView.frame.size.height);
    self.graphView.view.hidden = YES;
    [self.presentionView addSubview:self.tableView];
    
    [self.presentionView addSubview:self.graphView.view];
}

- (void)dealloc {
    self.tableView = nil;
    [_presentionView release];
    [_btnEdit release];
    [_btnSave release];
    [super dealloc];
}

- (void) setData:(NSMutableArray*)rows columns:(NSMutableArray*)columns values:(NSMutableArray*)values {
    [VGAppDelegate getInstance].columns = columns;
    [VGAppDelegate getInstance].rows = rows;
    [VGAppDelegate getInstance].values = values;
    self.tableView.tableDetegate = self;
}

#pragma mark - Actions

- (IBAction)clickViewTransition:(id)sender {
    self.btnEdit.hidden = (((UIButton*)sender).tag == 12) ? YES : NO;
    [self presentionViewTransition: (((UIButton*)sender).tag == 11) ? YES : NO];
}


- (void) presentionViewTransition:(BOOL)isPressentTable {
    [UIView beginAnimations:nil context:NULL];
    [UIView commitAnimations];
    
    [UIView transitionWithView:self.presentionView
                      duration:1
                       options:(isPressentTable)?UIViewAnimationOptionTransitionFlipFromLeft:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        self.tableView.hidden = !isPressentTable;
                        self.graphView.view.hidden = isPressentTable;
                    }
                    completion:^(BOOL finished){
                        
                    }];
    [UIView commitAnimations];
}

#pragma mark - Edit-Save-Cancel logic

- (void) editMode:(BOOL)canEdit {
    self.btnSave.hidden = !canEdit;
    [self.btnEdit setTitle:(canEdit) ? @"Cancel" : @"Edit" forState:UIControlStateNormal];
    [self.tableView edtiMode:canEdit];
}

- (IBAction)clickEdit:(id)sender {
    [self editMode:([self.btnEdit.titleLabel.text isEqualToString:@"Edit"]) ? YES : NO];
}

- (IBAction)clickSave:(id)sender {
    [self editMode:NO];
}

#pragma mark VGTable delegate

- (void) rowDidAddWithName:(NSString*)name {

}

- (void) colDidAddWithName:(NSString*)name {
    
}

- (void) cellDidChangedAtRow:(NSInteger)rowIndex andColIndex:(NSInteger)colIdex withValue:(NSString*)value {
    NSLog(@"%d %d :%@", rowIndex, colIdex, value);
}

@end
