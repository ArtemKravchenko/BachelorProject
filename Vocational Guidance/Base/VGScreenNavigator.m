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
            
        case VGCredentilasTypeEmployer:
            [self fillScreenMappingWithCredentialTypeEmployer];
            break;
            
        default:
            [self fillScreenMappingWithCredentialTypeAnonymous];
            break;
    }
}

+ (NSArray*) fieldsForCredentialType:(VGCredentilasType)credentialType {
    NSArray* fields = nil;
    NSDictionary* contentDictionary = nil;
    
    NSString* credentialName = nil;
    switch (credentialType) {
        case VGCredentilasTypeEmployer:
            credentialName = @"User";
            break;
            
        case VGCredentilasTypeExpert:
            credentialName = @"User";
            break;
            
        case VGCredentilasTypeManager:
            credentialName = @"User";
            break;
            
        case VGCredentilasTypeSecretar:
            credentialName = @"User";
            break;
            
        default:
            credentialName = @"Student";
            break;
    }
    
    if (credentialName != nil) {
        NSString* plistPath = [[NSBundle mainBundle] pathForResource:credentialName ofType:@"plist"];
        contentDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
        fields = [contentDictionary objectForKey:@"Fields"];
        NSDictionary* iconDictionary = [contentDictionary objectForKey:@"Icons"];
        [VGAppDelegate getInstance].iconName = [iconDictionary objectForKey:[VGAppDelegate getInstance].currentUser.credentialToString];
    }
    return fields;
}

+ (void) fillScreenMappingWithCredentialTypeManager {
    
    VGSavedScreenInfo *screenInfo = nil;
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGSearchViewController class];
    screenInfo.title = @"Users List";
    [screenMapping setObject:screenInfo forKey: @"Users List"];
    [screenInfo release];
}

+ (void) fillScreenMappingWithCredentialTypeEmployer {
    
    VGSavedScreenInfo *screenInfo = nil;
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGDetailViewController class];
    screenInfo.title = @"My Detail's";
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[VGAppDelegate getInstance].currentUser forKey:@"object"];
    NSArray* fields = [self fieldsForCredentialType:VGCredentilasTypeEmployer];
    [params setObject:fields forKey:@"fields"];
    screenInfo.params = params;
    [screenMapping setObject:screenInfo forKey: @"My Detail's"];
    [screenInfo release];
    
    [self fillScreenMappingWithCredentialTypeAnonymous];
}

+ (void) fillScreenMappingWithCredentialTypeExpert {
    
    VGSavedScreenInfo *screenInfo = nil;
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGDetailViewController class];
    screenInfo.title = @"My Detail's";
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[VGAppDelegate getInstance].currentUser forKey:@"object"];
    NSArray* fields = [self fieldsForCredentialType:VGCredentilasTypeExpert];
    [params setObject:fields forKey:@"fields"];
    screenInfo.params = params;
    [screenMapping setObject:screenInfo forKey: @"My Detail's"];
    [screenInfo release];
    
    [self fillScreenMappingWithCredentialTypeAnonymous];
}

+ (void) fillScreenMappingWithCredentialTypeSecretar {
    
    VGSavedScreenInfo *screenInfo = nil;
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGDetailViewController class];
    screenInfo.title = @"My Detail's";
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    [params setObject:[VGAppDelegate getInstance].currentUser forKey:@"object"];
    NSArray* fields = [self fieldsForCredentialType:VGCredentilasTypeSecretar];
    [params setObject:fields forKey:@"fields"];
    screenInfo.params = params;
    [screenMapping setObject:screenInfo forKey: @"My Detail's"];
    [screenInfo release];
    
    [self fillScreenMappingWithCredentialTypeAnonymous];
}

+ (void) fillScreenMappingWithCredentialTypeAnonymous {
    
    VGSavedScreenInfo *screenInfo = nil;
    NSMutableDictionary* autoblankFields = nil;
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGSearchViewController class];
    screenInfo.title = @"Students List";
    NSMutableDictionary* params = [NSMutableDictionary dictionary];
    NSArray* fields = [self fieldsForCredentialType:VGCredentilasTypeStudent];
    [params setObject:fields forKey:@"fields"];
    
    // Set autoblank fields
    autoblankFields = [NSMutableDictionary dictionary];
    [autoblankFields setObject:@"Students" forKey:@"description"];
    [params setObject:autoblankFields forKey:@"autoblank"];
    
    screenInfo.params = params;
    screenInfo.params = params;
    [screenMapping setObject:screenInfo forKey: @"Students List"];
    [screenInfo release];
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGSearchViewController class];
    screenInfo.title = @"Experts List";
    params = [NSMutableDictionary dictionary];
    fields = [self fieldsForCredentialType:VGCredentilasTypeExpert];
    [params setObject:fields forKey:@"fields"];
    
    // Set autoblank fields
    autoblankFields = [NSMutableDictionary dictionary];
    [autoblankFields setObject:@"Expert" forKey:@"credential"];
    [autoblankFields setObject:@"Expert" forKey:@"description"];
    [autoblankFields setObject:@"Expert" forKey:@"login"];
    [autoblankFields setObject:@"Expert" forKey:@"password"];
    [params setObject:autoblankFields forKey:@"autoblank"];
    
    screenInfo.params = params;
    [screenMapping setObject:screenInfo forKey: @"Experts List"];
    [screenInfo release];
    
    screenInfo = [VGSavedScreenInfo new];
    screenInfo.classValue = [VGSearchViewController class];
    screenInfo.title = @"Employers List";
    params = [NSMutableDictionary dictionary];
    fields = [self fieldsForCredentialType:VGCredentilasTypeEmployer];
    [params setObject:fields forKey:@"fields"];
    
    // Set autoblank fields
    autoblankFields = [NSMutableDictionary dictionary];
    [autoblankFields setObject:@"Emploer" forKey:@"credential"];
    [autoblankFields setObject:@"Employer" forKey:@"description"];
    [autoblankFields setObject:@"Employer" forKey:@"login"];
    [autoblankFields setObject:@"Employer" forKey:@"password"];
    [params setObject:autoblankFields forKey:@"autoblank"];
    
    screenInfo.params = params;
    [screenMapping setObject:screenInfo forKey: @"Employers List"];
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
