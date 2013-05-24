//
//  VGResultViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 03.05.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGResultViewController.h"
#import "VGTableView.h"
#import "VGResultRequest.h"
#import "VGRequestQueue.h"

static NSString* const kResult = @"Result";
static NSInteger const kTableHeight = 122;

@interface VGResultViewController ()

@property (retain, nonatomic) IBOutlet UILabel *lblCurrentStudent;
@property (retain, nonatomic) IBOutlet UILabel *lblCurrentExpert;
@property (retain, nonatomic) IBOutlet UILabel *lblCurrentEmployer;
@property (retain, nonatomic) IBOutlet UIScrollView *resultsView;
@property (retain, nonatomic) NSMutableArray* tablesArray;

@end

@implementation VGResultViewController

#pragma mark - View's cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.lblCurrentStudent setText: [NSString stringWithFormat:@"%@ %@", [VGAppDelegate getInstance].currentStudent.firstName, [VGAppDelegate getInstance].currentStudent.secondName]];
    [self.lblCurrentExpert setText: [NSString stringWithFormat:@"%@ %@", [VGAppDelegate getInstance].currentExpert.firstName, [VGAppDelegate getInstance].currentExpert.secondName]];
    [self.lblCurrentEmployer setText: [NSString stringWithFormat:@"%@ %@", [VGAppDelegate getInstance].currentEmployer.firstName, [VGAppDelegate getInstance].currentEmployer.secondName]];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.titleView = [VGUtilities changeTitleNameWithText: kResult];
}

- (void)dealloc
{
    self.results = nil;
    self.lblCurrentStudent = nil;
    self.lblCurrentExpert = nil;
    self.lblCurrentEmployer = nil;
    self.resultsView = nil;
    self.tablesArray = nil;
    [super dealloc];
}

#pragma mark - Actions

- (IBAction)clickResult:(id)sender {
    [VGAlertView showPleaseWaitState];
    VGResultRequest* request = [[[VGResultRequest alloc] initWithCurrentPersons] autorelease];
    request.delegate = self;
    [[VGRequestQueue queue] addRequest:request];
}

#pragma mark - Request delegate

- (void)requestDidFinishSuccessful:(NSData *)data {
    NSError* error;
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    self.tablesArray = [VGUtilities arrayUsersFromResultData:jsonData];
    
    for (UIView* resutView in self.resultsView.subviews) {
        [resutView removeFromSuperview];
    }

    int i = 0;
    int yOffset = 10;
    for (VGUser* user in self.tablesArray) {
        VGTableView* tableView = [[[VGTableView alloc] initWithFrame: CGRectMake(0, i * kTableHeight + ((i == 0) ? 0 : yOffset), self.resultsView.frame.size.width , kTableHeight) andUser: user] autorelease];
        tableView.bounces = NO;
        tableView.parentViewController = self;
        [self.resultsView addSubview:tableView];
        i++;
    }
    [self performSelectorOnMainThread:@selector(hideAlertView) withObject:self waitUntilDone:NO];
}

- (void) hideAlertView {
    [VGAlertView hidePleaseWaitState];
}

@end
