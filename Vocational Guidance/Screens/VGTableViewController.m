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

- (id)initWithUser:(VGUser*)user
{
    self = [super initWithNibName:@"VGTableViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        isSomethingWasChanged = NO;
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[[VGTableView alloc] initWithFrame: CGRectMake(0, 0, self.presentionView.frame.size.width, self.presentionView.frame.size.height) andUser:self.user] autorelease];
    self.tableView.bounces = NO;
    // init graph view
    self.graphView = [[VGGraphViewController new] autorelease];
    self.graphView.view.frame = CGRectMake(0, 0, self.presentionView.frame.size.width, self.presentionView.frame.size.height);
    self.graphView.view.hidden = YES;
    [self.presentionView addSubview:self.tableView];
    self.tableView.tableDetegate = self;
    [self.presentionView addSubview:self.graphView.view];
}

- (void)dealloc {
    self.user = nil;
    self.tableView = nil;
    [_presentionView release];
    [_btnEdit release];
    [_btnSave release];
    [super dealloc];
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
                            [self.graphView reloadDataWithArray:[VGAppDelegate getInstance].currentUser.dataSet];
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
    if ([self.btnEdit.titleLabel.text isEqualToString:@"Cancel"]) {
        [[VGAppDelegate getInstance] cancelTransaction];
        [self.tableView reloadData];
    } 
    BOOL editMode = ([self.btnEdit.titleLabel.text isEqualToString:@"Edit"]) ? YES : NO;
    [self editMode:editMode];
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
    self.btnSave.enabled = YES;
    VGObject* row = [[VGObject new] autorelease];
    row.name = name;
    NSMutableDictionary* tmpDictionary = [NSMutableDictionary dictionary];
    [tmpDictionary setObject:[NSString stringWithFormat:@"%d", TS_ADDED_ROW] forKey:@"transaction_type"];
    [tmpDictionary setObject:row forKey:@"obj_name"];
    [[VGAppDelegate getInstance].transactionsList addObject:tmpDictionary];
    isSomethingWasChanged = YES;
}

- (void) colDidAddWithName:(NSString*)name {
    self.btnSave.enabled = YES;
    VGObject* col = [[VGObject new] autorelease];
    col.name = name;
    NSMutableDictionary* tmpDictionary = [NSMutableDictionary dictionary];
    [tmpDictionary setObject:[NSString stringWithFormat:@"%d", TS_ADDED_COL] forKey:@"transaction_type"];
    [tmpDictionary setObject:col forKey:@"obj_name"];
    [[VGAppDelegate getInstance].transactionsList addObject:tmpDictionary];
    isSomethingWasChanged = YES;
}

- (void) cellDidChangedAtRow:(VGObject*)row andColIndex:(VGObject*)col withValue:(NSString*)value andWithOldValue:(NSString *)oldValue {
    self.btnSave.enabled = YES;
    NSMutableDictionary* tmpDictionary = [NSMutableDictionary dictionary];
    [tmpDictionary setObject: [NSString stringWithFormat:@"%d", TS_CHANGED_CELL] forKey:@"transaction_type"];
    [tmpDictionary setObject: row  forKey:@"row_index"];
    [tmpDictionary setObject: col  forKey:@"column_index"];
    [tmpDictionary setObject: value  forKey:@"cell_value"];
    [tmpDictionary setObject: oldValue forKey:@"old_value"];
    [[VGAppDelegate getInstance].transactionsList addObject:tmpDictionary];
    isSomethingWasChanged = YES;
}

- (void) cellWillChanging {
    self.btnSave.enabled = NO;
}

- (void) objectWillAdding {
    self.btnSave.enabled = NO;
}
@end