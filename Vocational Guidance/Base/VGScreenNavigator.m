//
//  VGScreenNavigator.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGScreenNavigator.h"
#import "VGBaseViewController.h"
#import "VGAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "VGSavedScreenInfo.h"
#import "VGTableViewController.h"
#import "VGSearchViewController.h"
#import "VGPresentViewController.h"
#import "VGSelectOperatorViewController.h"

static NSMutableDictionary *screenMapping = nil;

@interface VGScreenNavigator ()

@end

@implementation VGScreenNavigator

+ (void) initStartScreenMapping {
    screenMapping = [[NSMutableDictionary alloc] init];
    
    VGSavedScreenInfo *screenInfo = nil;
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGTableViewController class];
    [screenMapping setObject:screenInfo forKey: VG_Table_Screen];
    [screenInfo release];
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGSearchViewController class];
    [screenMapping setObject:screenInfo forKey: VG_Search_Screen];
    [screenInfo release];
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGSelectOperatorViewController class];
    [screenMapping setObject:screenInfo forKey: VG_Select_Operator_Screen];
    [screenInfo release]; 
}

+ (void) navigateToScreen : (NSString*)name {
    VGSavedScreenInfo *screenInfo = nil;
    
    screenInfo = [screenMapping objectForKey:name];
    
    if (!screenInfo) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"Failed navigate to initial screen"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        return;
    }
    
    VGBaseViewController *mainController = (VGBaseViewController*)[screenInfo.classValue new];
    [VGAppDelegate getInstance].currentScreen = name;
    [mainController sendNewNavigationStack: screenInfo toObject: self action: @selector(presentNewScreen:)];
}

+ (void) presentNewScreen: (NSArray *) navigationStack {
    UINavigationController * navController = [VGAppDelegate getInstance].navigationController;
    
    CATransition * transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [navController.view.layer addAnimation: transition forKey: nil];
    [navController setViewControllers: navigationStack animated: NO];
}

- (void)dealloc
{
    [super dealloc];
}

@end
