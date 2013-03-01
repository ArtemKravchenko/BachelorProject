//
//  VGTableViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGTableViewController.h"

static NSInteger TS_ADDED_ROW                       = 1;
static NSInteger TS_ADDED_COL                       = 2;
static NSInteger TS_CHANGED_CELL                    = 3;

@interface VGTableViewController () {
    BOOL isSomethingWasChanged;
}

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
        isSomethingWasChanged = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[[VGTableView alloc] initWithFrame: CGRectMake(0, 0, self.presentionView.frame.size.width, self.presentionView.frame.size.height)] autorelease];
    self.tableView.bounces = NO;
    //NSMutableArray* columns = [NSMutableArray arrayWithObjects: @"col1", @"col2", @"col3", @"col4", @"col5", @"col6", @"col7", @"col8",  @"col9", @"col10", @"col11", nil];
    //NSMutableArray* rows = [NSMutableArray arrayWithObjects: @"row1", @"row2", @"row3", @"row4", @"row5", @"rowl6", @"row7", @"row8", @"row9", @"row10", @"row11", nil];
    NSMutableArray* columns = [NSMutableArray arrayWithObjects: @"col1", @"col2", @"col3", @"col4", nil];
    NSMutableArray* rows = [NSMutableArray arrayWithObjects: @"row1", @"row2", @"row3", @"row4", nil];
    
    NSMutableArray *values = [NSMutableArray array];
    for (NSInteger i = 0; i < rows.count; i++) {
        for (NSInteger j = 0; j < columns.count; j++) {
            VGTableCell *tableCell = [[VGTableCell new] autorelease];
            tableCell.rowIndex = i;
            tableCell.colIndex = j;
            if (j % 2 == 0) {
                tableCell.value =  [NSString stringWithFormat:@"%d", 0];
            } else {
                tableCell.value = [NSString stringWithFormat:@"%.2f", ((float)(arc4random()  % 100)) / 100.0] ;
            }
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
                        if (!isPressentTable) {
                            [self.graphView reloadData];
                        } else {
                            [self.tableView reloadData];
                        }
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
    BOOL editMode = ([self.btnEdit.titleLabel.text isEqualToString:@"Edit"]) ? YES : NO;
    [self editMode:editMode];
    if (!editMode) {
        [self.tableView reloadData];
    }
}

- (IBAction)clickSave:(id)sender {
    if (isSomethingWasChanged) {
        [self sendSaveRequest];
    }
    isSomethingWasChanged = NO;
    [self editMode:NO];
}

#pragma mark - Send request

- (void) sendSaveRequest {
    // Fake functionality
    [[VGAppDelegate getInstance] executingTransation];
}

#pragma mark - VGTable delegate

- (void) rowDidAddWithName:(NSString*)name {
    NSMutableDictionary* tmpDictionary = [NSMutableDictionary dictionary];
    [tmpDictionary setObject:[NSString stringWithFormat:@"%d", TS_ADDED_ROW] forKey:TS_TRANSACTION_TYPE];
    [tmpDictionary setObject:name forKey:TP_OBJ_NAME];
    [[VGAppDelegate getInstance].transactionsList addObject:tmpDictionary];
    isSomethingWasChanged = YES;
}

- (void) colDidAddWithName:(NSString*)name {
    NSMutableDictionary* tmpDictionary = [NSMutableDictionary dictionary];
    [tmpDictionary setObject:[NSString stringWithFormat:@"%d", TS_ADDED_COL] forKey:TS_TRANSACTION_TYPE];
    [tmpDictionary setObject:name forKey:TP_OBJ_NAME];
    [[VGAppDelegate getInstance].transactionsList addObject:tmpDictionary];
    isSomethingWasChanged = YES;
}

- (void) cellDidChangedAtRow:(NSInteger)rowIndex andColIndex:(NSInteger)colIdex withValue:(NSString*)value {
    NSMutableDictionary* tmpDictionary = [NSMutableDictionary dictionary];
    [tmpDictionary setObject: [NSString stringWithFormat:@"%d", TS_CHANGED_CELL] forKey:TS_TRANSACTION_TYPE];
    [tmpDictionary setObject: [NSNumber numberWithInteger:rowIndex]  forKey:TP_ROW_INDEX];
    [tmpDictionary setObject: [NSNumber numberWithInteger:colIdex]  forKey:TP_COL_INDEX];
    [tmpDictionary setObject: value  forKey:TP_CELL_VALUE];
    [[VGAppDelegate getInstance].transactionsList addObject:tmpDictionary];
    isSomethingWasChanged = YES;
}

@end
