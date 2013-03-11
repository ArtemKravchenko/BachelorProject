//
//  VGSearchViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGSearchViewController.h"
#import "VGFieldsListViewController.h"

@interface VGSearchViewController ()

@property (nonatomic, retain) VGFieldsListViewController* fieldsViewController;
@property (retain, nonatomic) IBOutlet UIView *fieldsView;

@end

@implementation VGSearchViewController

- (id)init
{
    self = [super initWithNibName:@"VGSearchViewController" bundle:[NSBundle mainBundle]];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // init fields view controller
    self.fieldsViewController = [[VGFieldsListViewController new] autorelease];
    self.fieldsViewController.fields = self.fieldsList;
    self.fieldsViewController.autoBlankFields = self.autoblank;
    self.fieldsViewController.editMode = YES;
    self.fieldsViewController.cellWidth = self.fieldsView.frame.size.width;
    CGRect frame = CGRectMake(0, 0, self.fieldsView.frame.size.width, self.fieldsView.frame.size.height);
    [self.fieldsViewController initFieldsWithFrame:frame];
    [self.fieldsView addSubview:self.fieldsViewController.view];
}

- (void)dealloc
{
    self.fieldsViewController = nil;
    [_autoblank release];
    [_fieldsList release];
    [_fieldsView release];
    [super dealloc];
}

@end
