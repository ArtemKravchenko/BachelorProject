//
//  VGDetailViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGDetailViewController.h"
#import "VGFieldsListViewController.h"

@interface VGDetailViewController ()

@property (retain, nonatomic) IBOutlet UIImageView *imgIcon;
@property (retain, nonatomic) IBOutlet UIView *fieldsView;
@property (retain, nonatomic) VGFieldsListViewController* fieldsViewController;

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
    self.fieldsViewController = [[VGFieldsListViewController new] autorelease];
    self.fieldsViewController.fields = self.fields;
    self.fieldsViewController.object = self.object;
    self.fieldsViewController.cellWidth = self.fieldsView.frame.size.width;
    CGRect frame = CGRectMake(0, 0, self.fieldsView.frame.size.width, self.fieldsView.frame.size.height);
    [self.fieldsViewController initFieldsWithFrame:frame];
    [self.fieldsView addSubview:self.fieldsViewController.view];
}

- (void)dealloc {
    [_fields release];
    [_fieldsViewController release];
    [_object release];
    [_imgIcon release];
    [_fieldsView release];
    [super dealloc];
}

#pragma mark -
@end
