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
#import "VGUser.h"
#import "VGDetailViewController.h"

static NSMutableDictionary *screenMapping = nil;

@interface VGScreenNavigator ()

@end

@implementation VGScreenNavigator

- (void)dealloc
{
    [super dealloc];
}

+ (NSMutableDictionary*) screenMapping {
    return screenMapping;
}

#pragma mark - Init functions

+ (void) initStartScreenMapping {
    screenMapping = [[NSMutableDictionary alloc] init];
    
    VGCredentilasType credential = [VGAppDelegate getInstance].currentUser.credential;
    
    switch (credential) {
        case VGCredentilasTypeExpert:
            [self fillScreenMappingWithCredentialTypeExpert];
            break;
        
        case VGCredentilasTypeManager:
            [self fillScreenMappingWithCredentialTypeManager];
            break;
            
        case VGCredentilasTypeSecretar:
            [self fillScreenMappingWithCredentialTypeSecretar];
            break;
            
        default:
            break;
    }
}

+ (void) fillScreenMappingWithCredentialTypeExpert {
    
    VGSavedScreenInfo *screenInfo = nil;
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGDetailViewController class];
    screenInfo.title = @"My Detail's";
    [screenMapping setObject:screenInfo forKey: @"My Detail's"];
    [screenInfo release];
}

+ (void) fillScreenMappingWithCredentialTypeManager {
    
    VGSavedScreenInfo *screenInfo = nil;
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGSearchViewController class];
    screenInfo.title = @"Users list";
    [screenMapping setObject:screenInfo forKey: @"Users list"];
    [screenInfo release];
}

+ (void) fillScreenMappingWithCredentialTypeSecretar {
    
    VGSavedScreenInfo *screenInfo = nil;
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGSearchViewController class];
    screenInfo.title = @"Expert List";
    [screenMapping setObject:screenInfo forKey: @"Expert List"];
    [screenInfo release];
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGSearchViewController class];
    screenInfo.title = @"Employers list";
    [screenMapping setObject:screenInfo forKey: @"Employers list"];
    [screenInfo release];
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGTableViewController class];
    screenInfo.title = @"My Table";
    [screenMapping setObject:screenInfo forKey: @"My Table"];
    [screenInfo release];
}

#pragma mark - Navigate functions

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

@end
