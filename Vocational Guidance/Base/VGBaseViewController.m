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
#import "VGScreenNavigator.h"
#import "VGDetailViewController.h"
#import "VGSearchViewController.h"
#import "VGResultViewController.h"

@interface VGBaseViewController ()

@end

@implementation VGBaseViewController 

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
}

#pragma mark Navigation bar

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
    
    options = [NSMutableArray array];
    for (NSString* key in VGScreenNavigator.screenMapping) {
        VGSavedScreenInfo* screenInfo = [VGScreenNavigator.screenMapping objectForKey:key];
        [options addObject:screenInfo.title];
    }
    
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

#pragma mark Navigate between controllers

- (NSMutableArray *) newNavigationStack: (VGSavedScreenInfo *) screenInfo {
    UINavigationController * navController = [VGAppDelegate getInstance].navigationController;
    NSMutableArray * controllers = [[NSMutableArray alloc] init];
    [controllers addObject: [navController.viewControllers objectAtIndex: 0]]; // login controller
    
    VGBaseViewController *secondController = [(VGBaseViewController*)[screenInfo.classValue new] autorelease]; // TODO (maybe excess autorelease)
    
    if (screenInfo.classValue == [VGDetailViewController class]) {
        ((VGDetailViewController*)secondController).object = [screenInfo.params objectForKey:kObject];
        ((VGDetailViewController*)secondController).classValue = [[screenInfo.params objectForKey:kObject] class];
        ((VGDetailViewController*)secondController).fields = [NSMutableArray arrayWithArray:[screenInfo.params objectForKey:kFields]];
        ((VGDetailViewController*)secondController).imageName = [screenInfo.params objectForKey:kIcons][[((VGUser*)[screenInfo.params objectForKey:kObject]) credentialToString]];
    } else if (screenInfo.classValue == [VGSearchViewController class]) {
        ((VGSearchViewController*)secondController).fieldsList = [NSMutableArray arrayWithArray:[screenInfo.params objectForKey:kFields]];
        ((VGSearchViewController*)secondController).emptyFields = [NSMutableArray arrayWithArray:[screenInfo.params objectForKey:kEmptyFields]];
        ((VGSearchViewController*)secondController).objectsType = [screenInfo.params objectForKey:kObjectsType];
    } else if (screenInfo.classValue == [VGResultViewController class]) {
        ((VGResultViewController*)secondController).results = [screenInfo.params objectForKey:kResults];
    }
    
    [controllers addObject: secondController];
    
    return controllers;
}

- (void) sendNewNavigationStack: (VGSavedScreenInfo *) screenInfo toObject: (id) target action: (SEL) action {
    NSMutableArray * controllers = [[self newNavigationStack: screenInfo] autorelease];
    [target performSelector: action withObject: controllers];
}

@end
