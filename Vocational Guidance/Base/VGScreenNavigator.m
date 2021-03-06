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
#import "VGTableViewController.h"
#import "VGSearchViewController.h"
#import "VGPresentViewController.h"
#import "VGDetailViewController.h"
#import "VGResultViewController.h"
#import "VGUtilities.h"

static NSString* const kMyDetails = @"My Details";
static NSString* const kMyUserList = @"Users List";


static NSMutableDictionary *screenMapping = nil;

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
    if ([VGAppDelegate getInstance].currentUser != nil) {
        [self fillDetailsScreenWitCredentialType:[VGAppDelegate getInstance].currentUser.credential withObject:[VGAppDelegate getInstance].currentUser forKey:kMyDetails];
    }
    [self fillSearchScreenWithCredentialType:VGCredentilasTypeStudent forKey:kStudentList];
    [self fillSearchScreenWithCredentialType:VGCredentilasTypeExpert forKey:kExpertList];
    [self fillSearchScreenWithCredentialType:VGCredentilasTypeEmployer forKey:kEmployerList];
}

+ (void) fillDetailsScreenWitCredentialType:(VGCredentilasType)credentialType withObject:(id<VGPerson>) person forKey:(NSString*)key {
    VGSavedScreenInfo* screenInfo = nil;
    screenInfo = [VGSavedScreenInfo new];
    
    if (credentialType != VGCredentilasTypeManager) {
        
        // Set class value
        screenInfo.classValue = [VGDetailViewController class];
        // Set title
        screenInfo.title = key;
        // Set params
        NSMutableDictionary* params = [NSMutableDictionary dictionary];
        [params setObject:person forKey:kObject];
        NSMutableDictionary* allFields = [VGUtilities fieldsForCredentialType:credentialType];
        [params setObject:allFields[kFields] forKey:kFields];
        [params setObject:allFields[kEmptyFields] forKey:kEmptyFields];
        [params setObject:allFields[kIcons] forKey:kIcons];
        
        screenInfo.params = params;
        
    } else {
        
        // Set clas value
        screenInfo.classValue = [VGSearchViewController class];
        // Set title
        screenInfo.title = kMyUserList;
    }
    [screenMapping setObject:screenInfo forKey: key];
    [screenInfo release];
}

+ (void) fillSearchScreenWithCredentialType:(VGCredentilasType)credentialType forKey:(NSString*)key {
    VGSavedScreenInfo *screenInfo = nil;
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGSearchViewController class];
    screenInfo.title = key;
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    NSMutableDictionary* allFields = [VGUtilities fieldsForCredentialType:credentialType];
    [params setObject: (credentialType == VGCredentilasTypeStudent) ? [VGStudent class] : [VGUser class] forKey: kObjectsType];
    [params setObject:allFields[kFields] forKey:kFields];
    [params setObject:allFields[kEmptyFields] forKey:kEmptyFields];
    
    screenInfo.params = params;
    [screenMapping setObject:screenInfo forKey: key];
    [screenInfo release];
}

+ (void) showResultButton {
    VGSavedScreenInfo *screenInfo = nil;
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGResultViewController class];
    screenInfo.title = kResults;
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    
    if ([VGAppDelegate getInstance].results == nil) {
        [VGAppDelegate getInstance].results = [NSDictionary dictionary];
    }
    
    [params setObject:[VGAppDelegate getInstance].results forKey:kResults];
    
    screenInfo.params = params;
    [screenMapping setObject:screenInfo forKey: kResults];
    [screenInfo release];
}

+ (void) hideResultButton {
    [screenMapping removeObjectForKey:kResults];
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
