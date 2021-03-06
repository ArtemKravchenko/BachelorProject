//
//  VGTableViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGTableViewController.h"
#import "VGRequestQueue.h"
#import "VGChangeCellRequest.h"

static NSString* const kCancel = @"Cancel";

@interface VGTableViewController () {
    BOOL isSomethingWasChanged;
}

@property (retain, nonatomic) IBOutlet UIView *presentionView;
@property (retain, nonatomic) IBOutlet UIButton *btnEdit;
@property (retain, nonatomic) IBOutlet UIButton *btnSave;
@property (assign, nonatomic) BOOL editMode;

- (IBAction)clickViewTransition:(id)sender;
@end

@implementation VGTableViewController

- (id)initWithUser:(id<VGPerson>)user andEditMode:(BOOL)editMode
{
    self = [super initWithNibName:@"VGTableViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        isSomethingWasChanged = NO;
        self.user = user;
        self.editMode = editMode;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self clearPresentView];
    self.tableView = [[[VGTableView alloc] initWithFrame: CGRectMake(0, 0, self.presentionView.frame.size.width, self.presentionView.frame.size.height) andUser:self.user] autorelease];
    self.tableView.bounces = NO;
    [self.tableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"MainBackground2.png"]]];
    self.tableView.parentViewController = self;
    // init graph view
    self.graphViewController = [[VGGraphViewController new] autorelease];
    self.graphViewController.view.frame = CGRectMake(0, 0, self.presentionView.frame.size.width, self.presentionView.frame.size.height);
    self.graphViewController.view.hidden = YES;
    self.graphViewController.user = self.user;
    [self.presentionView addSubview:self.tableView];
    self.tableView.tableDetegate = self;
    [self.presentionView addSubview:self.graphViewController.view];
    [self editMode:NO];
    [self performSelectorOnMainThread:@selector(goToPresentViewController) withObject:self waitUntilDone:NO];
}

- (void) goToPresentViewController {
    if ([VGAlertView isShowing]) {
        [VGAlertView hidePleaseWaitState];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.btnEdit.hidden = !self.editMode;
    // init graph view
}

- (void)dealloc {
    self.user = nil;
    self.tableView = nil;
    self.graphViewController = nil;
    self.presentionView = nil;
    self.btnEdit = nil;
    self.btnSave = nil;
    [super dealloc];
}

#pragma mark - Actions

- (void) clearPresentView {
    for (UIView* view in self.presentionView.subviews) {
        [view removeFromSuperview];
    }
}

- (IBAction)clickBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clickViewTransition:(id)sender {
    self.btnEdit.hidden = (((UIButton*)sender).tag == 12) ? YES : !self.editMode;
    [self presentionViewTransition: (((UIButton*)sender).tag == 11)];
}


- (void) presentionViewTransition:(BOOL)isPressentTable {
    [UIView beginAnimations:nil context:NULL];
    [UIView commitAnimations];
    
    [UIView transitionWithView:self.presentionView
                      duration:1
                       options:(isPressentTable)?UIViewAnimationOptionTransitionFlipFromLeft:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{
                        self.tableView.hidden = !isPressentTable;
                        self.graphViewController.view.hidden = isPressentTable;
                    }
                    completion:^(BOOL finished){
                        if (!isPressentTable) {
                            [self.graphViewController reloadDataWithArray:self.user.dataSet];
                        } else {
                            [self.tableView reloadData];
                        }
                    }];
    [UIView commitAnimations];
}

- (IBAction)clickEdit:(id)sender {
    if ([self.btnEdit.titleLabel.text isEqualToString: kCancel]) {
        [[VGAppDelegate getInstance] cancelTransaction];
        [self.tableView reloadData];
    }
    BOOL editMode = ([self.btnEdit.titleLabel.text isEqualToString:kEdit]);
    [self editMode:editMode];
}

- (IBAction)clickSave:(id)sender {
    if (isSomethingWasChanged) {
        [self sendSaveRequest];
    }
    isSomethingWasChanged = NO;
    [self editMode:NO];
}

#pragma mark - Edit-Save-Cancel logic

- (void) editMode:(BOOL)canEdit {
    self.btnSave.hidden = !canEdit;
    [self.btnEdit setTitle:(canEdit) ? kCancel : kEdit forState:UIControlStateNormal];
    [self.tableView edtiMode:canEdit];
}

#pragma mark - Request delegate

-(void)requestDidFinishSuccessful:(NSData *)data {
    NSError* error;
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (jsonData != nil) {
        [VGAppDelegate getInstance].currentUser = [VGUtilities userFromJsonData:jsonData];
        ((VGDetailViewController*)self.navigationController.viewControllers[self.navigationController.viewControllers.count - 2]).object = [VGAppDelegate getInstance].currentUser;
        [self editMode:NO];
        [self reloadInputViews];
        if ([VGAlertView isShowing]) {
            [VGAlertView hidePleaseWaitState];
        }
    } else {
        if ([VGAlertView isShowing]) {
            [VGAlertView hidePleaseWaitState];
        }
        [VGAlertView showError:[NSString stringWithFormat:@"%@", error]];
    }
}

#pragma mark - Send request

- (void) sendSaveRequest {
    if (![VGAlertView isShowing]) {
        [VGAlertView showPleaseWaitState];
    }
    
    VGChangeCellRequest* request = [[[VGChangeCellRequest alloc]
                                     initWithPersonId:[VGAppDelegate getInstance].currentUser.objectId
                                     andDelegate:self] autorelease];
    [[VGRequestQueue queue] addRequest:request];
    
    // Fake functionality
    /*
     [[VGAppDelegate getInstance] executingTransation];
     */
}

#pragma mark - VGTable delegate

- (void) rowDidAddWithName:(id<VGTableVariable>)object {
    self.btnSave.enabled = YES;
    NSMutableDictionary* tmpDictionary = [NSMutableDictionary dictionary];
    [tmpDictionary setObject:[NSString stringWithFormat:@"%d", TS_ADDED_ROW] forKey:VG_TRANSACTION_TYPE];
    [tmpDictionary setObject:object forKey:VG_OBJECT_NAME];
    [[VGAppDelegate getInstance].transactionsList addObject:tmpDictionary];
    isSomethingWasChanged = YES;
}

- (void) colDidAddWithName:(id<VGTableVariable>)object {
    self.btnSave.enabled = YES;
    NSMutableDictionary* tmpDictionary = [NSMutableDictionary dictionary];
    [tmpDictionary setObject:[NSString stringWithFormat:@"%d", TS_ADDED_COL] forKey:VG_TRANSACTION_TYPE];
    [tmpDictionary setObject:object forKey:VG_OBJECT_NAME];
    [[VGAppDelegate getInstance].transactionsList addObject:tmpDictionary];
    isSomethingWasChanged = YES;
}

- (void) cellDidChangedAtRow:(NSString*)row andColIndex:(NSString*)col withValue:(NSString*)value andWithOldValue:(NSString *)oldValue {
    self.btnSave.enabled = YES; // TODO
    NSMutableDictionary* tmpDictionary = [NSMutableDictionary dictionary];
    [tmpDictionary setObject: [NSString stringWithFormat:@"%d", TS_CHANGED_CELL] forKey:VG_TRANSACTION_TYPE];
    [tmpDictionary setObject: row  forKey:VG_ROW_OBJECT];
    [tmpDictionary setObject: col  forKey:VG_COL_OBJECT];
    [tmpDictionary setObject: value  forKey:VG_CELL_VALUE];
    [tmpDictionary setObject: oldValue forKey:VG_OLD_VALUE];
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