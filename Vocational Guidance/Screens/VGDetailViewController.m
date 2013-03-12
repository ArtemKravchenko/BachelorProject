//
//  VGDetailViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGDetailViewController.h"
#import "VGFieldsListViewController.h"
#import "VGTableViewController.h"

@interface VGDetailViewController ()

@property (retain, nonatomic) IBOutlet UIImageView *imgIcon;
@property (retain, nonatomic) IBOutlet UIView *fieldsView;
@property (retain, nonatomic) IBOutlet UIButton *btnViewTable;
@property (retain, nonatomic) IBOutlet UIButton *btnEdit;
@property (retain, nonatomic) VGFieldsListViewController* fieldsViewController;
@property (retain, nonatomic) VGTableViewController* tableViewController;

@end

@implementation VGDetailViewController

- (id)init{
    self = [super initWithNibName:@"VGDetailViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.btnViewTable.hidden = ![self.object isKindOfClass:[VGUser class]];
    self.btnEdit.hidden = !(([self.object isKindOfClass:[VGUser class]] == NO) && ([VGAppDelegate getInstance].isMyDetail == YES));
    // init self view
    self.imgIcon.image = [UIImage imageNamed:[VGAppDelegate getInstance].iconName];
    // init fields view controller
    self.fieldsViewController = [[VGFieldsListViewController new] autorelease];
    self.fieldsViewController.fields = self.fields;
    self.fieldsViewController.object = self.object;
    self.fieldsViewController.cellWidth = self.fieldsView.frame.size.width;
    CGRect frame = CGRectMake(0, 0, self.fieldsView.frame.size.width, self.fieldsView.frame.size.height);
    [self.fieldsViewController initFieldsWithFrame:frame];
    [self.fieldsView addSubview:self.fieldsViewController.view];
}

- (void)dealloc {
    self.tableViewController = nil;
    [_fields release];
    [_fieldsViewController release];
    [_object release];
    [_imgIcon release];
    [_fieldsView release];
    [_btnViewTable release];
    [_btnEdit release];
    [super dealloc];
}

#pragma mark - Actions

- (IBAction)clickViewTable:(id)sender {
    self.tableViewController = [[[VGTableViewController alloc] initWithUser:(VGUser*)self.object] autorelease];
    [self.navigationController pushViewController:self.tableViewController animated:YES];
}

- (IBAction)clickEdit:(id)sender {
    
}

@end
