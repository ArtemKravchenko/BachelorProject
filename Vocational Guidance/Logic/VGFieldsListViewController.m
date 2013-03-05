//
//  VGFieldsListViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 05.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGFieldsListViewController.h"

static const NSInteger cellHeight            = 44;
static const NSInteger cellLabelWidth    = 130;

@interface VGFieldsListViewController ()

@end

@implementation VGFieldsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark - View life's cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)dealloc
{
    [_fields release];
    [super dealloc];
}

#pragma mark - Initialize functions

- (UIView*) cellViewWithWidth:(NSInteger)cellWidth andOriginY:(NSInteger)originY {
    UIView* newCellView = [[UIView new] autorelease];
    [newCellView setFrame:CGRectMake(0, originY, cellWidth, cellHeight)];
    [newCellView setBackgroundColor:[UIColor whiteColor]];
    return newCellView;
}

- (UILabel*) cellLabelWithValue:(NSString*)value andOriginX:(NSInteger)originX andOriginY:(NSInteger)originY {
    UILabel* newCellLabel = [[UILabel new] autorelease];
    [newCellLabel setFrame:CGRectMake(originX, originY, cellLabelWidth, cellHeight)];
    [newCellLabel setText:value];
    [newCellLabel setFont:[UIFont systemFontOfSize:17]];
    return newCellLabel;
}

@end
