//
//  VGBaseViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseViewController.h"
#import "VGSavedScreenInfo.h"
#import "VGAppDelegate.h"
#import "VGOptionsViewController.h"

@interface VGBaseViewController ()

@end

@implementation VGBaseViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
    // Do any additional setup after loading the view from its nib.
}

# pragma mark Navigation bar

- (void) initNavigationBar {
    self.navigationItem.rightBarButtonItem = [self rightNaigationButton];
    if ([VGAppDelegate getInstance].isLogin) {
        self.navigationItem.leftBarButtonItem = [self leftNaigationButton];
    }
    
    self.navigationItem.title =[VGAppDelegate getInstance].currentScreen;
}

- (UIBarButtonItem*) rightNaigationButton {
    UIBarButtonItem* right = [[[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(clickRightBarButton)] autorelease];
    return  right;
}

- (UIBarButtonItem*) leftNaigationButton {
    UIBarButtonItem* right = [[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(clickLeftBarButton)] autorelease];
    return  right;
}

- (void) clickRightBarButton {
    UIPopoverController *popover = nil;
    NSMutableArray *options = nil;
    
    options = [NSMutableArray arrayWithObjects: @"User's Data", @"Search", @"Select Operator", nil];
    
    popover = [VGOptionsViewController newPopoverWithTitle:@"Main Menu" options:options delegate:self tag:PO_NAV_OPTIONS];
    [popover presentPopoverFromRect: CGRectMake(990, 54, 1, 1)
                                       inView: self.navigationController.view
                     permittedArrowDirections: UIPopoverArrowDirectionUp
                                     animated: YES];
    [popover release];
}

- (void) clickLeftBarButton {
    if ([self.navigationItem.leftBarButtonItem.title isEqualToString:@"Logout"]) {
        [VGAppDelegate getInstance].isLogin = NO;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

# pragma mark Navigate between controllers

- (NSMutableArray *) newNavigationStack: (VGSavedScreenInfo *) screenInfo {
    UINavigationController * navController = [VGAppDelegate getInstance].navigationController;
    NSMutableArray * controllers = [[NSMutableArray alloc] init];
    [controllers addObject: [navController.viewControllers objectAtIndex: 0]]; // login controller
    
    VGBaseViewController *secondController = (VGBaseViewController*)[screenInfo.classValue new];
    
    [controllers addObject: secondController];
    
    return controllers;
}

- (void) sendNewNavigationStack: (VGSavedScreenInfo *) screenInfo toObject: (id) target action: (SEL) action {
    NSMutableArray * controllers = [[self newNavigationStack: screenInfo] autorelease];
    [target performSelector: action withObject: controllers];
}

@end
