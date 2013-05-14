//
//  VGLoginViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGLoginViewController.h"
#import "VGAppDelegate.h"
#import "VGScreenNavigator.h"
#import "VGPresentViewController.h"
#import "VGGetPersonRequest.h"
#import "VGRequestQueue.h"
#import "VGAlertView.h"
#import "VGUtilities.h"

@interface VGLoginViewController () {
    VGLoginPopupViewController *popup;
}

@end

@implementation VGLoginViewController

- (id)init
{
    self = [super initWithNibName:@"VGLoginViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (UIBarButtonItem*) rightNaigationButton {
    UIBarButtonItem* right = [[[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStyleBordered target:self action:@selector(clickRightBarButton)] autorelease];
    return  right;
}

#pragma mark - Login popup delegate

- (void) popupDidCloseWithLogin:(NSString *)login andPassword:(NSString *)password {
    /*
    VGGetPersonRequest* request = [[[VGGetPersonRequest alloc] initWithLogin:login andPassword:password] autorelease];
    [[VGRequestQueue queue] addRequest:request];
    */
    if ([login isEqualToString:@""] && [password isEqualToString:@""]) {
        [popup dismissViewControllerAnimated:YES completion:nil];
        [VGAppDelegate getInstance].isLogin = NO;
    } else {
        [popup dismissViewControllerAnimated:YES completion:nil];
        [VGAppDelegate getInstance].isLogin = YES;
        
        // ----------- TEMPORARY -----------------
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@ AND %K LIKE %@", @"login", login, @"password", password];
        NSMutableArray* tmpArray = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"persons"]];
        
        [tmpArray filterUsingPredicate:predicate];
        if (tmpArray.count) {
            [VGAppDelegate getInstance].currentUser = tmpArray[0];
            
            [VGAppDelegate getInstance].allStudents = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"students"]];
            [VGAppDelegate getInstance].allSubjects = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"subjects"]];
            [VGAppDelegate getInstance].allSkills = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"skills"]];
            [VGAppDelegate getInstance].allVacancies = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"jobs"]];
            [VGAppDelegate getInstance].allSides = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"sides"]];
            
        } else {
            if ([VGAlertView isShowing]) {
                [VGAlertView hidePleaseWaitState];
            }
            return;
        }
    }
    [VGAlertView showPleaseWaitState];
    
    [VGAppDelegate getInstance].allStudents = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"students"]];
    [VGAppDelegate getInstance].allSubjects = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"subjects"]];
    [VGAppDelegate getInstance].allSkills = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"skills"]];
    [VGAppDelegate getInstance].allVacancies = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"jobs"]];
    [VGAppDelegate getInstance].allSides = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"sides"]];
    
    [VGScreenNavigator initStartScreenMapping];
    
    VGPresentViewController *presentVC = [[VGPresentViewController new] autorelease];
    [[VGAppDelegate getInstance].navigationController pushViewController:presentVC animated:YES];
}

#pragma mark - Request delegate

- (void) requestDidFinishSuccessful:(NSData *)data {
    NSError* error;
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if (jsonData[kUser] != nil) {
        
        [VGScreenNavigator initStartScreenMapping];
        
        // Filling all array side
        [VGAppDelegate getInstance].allSides = [NSMutableArray array];
        
        for (NSDictionary* data in jsonData[@"all sides"]) {
            [[VGAppDelegate getInstance].allSides addObject:[VGUtilities tableVariableFromJsonData:data withClassType:[VGSide class]]];
        }
        
        // Filling all rows and all columns
        //
        
        NSString* credentilId = ((NSDictionary*)jsonData[kUser])[@"PersonCredentialId"];
        VGCredentilasType credential = ([credentilId isEqualToString:@"2"]) ? VGCredentilasTypeSecretar: ([credentilId isEqualToString:@"3"]) ? VGCredentilasTypeExpert: VGCredentilasTypeEmployer;
        
        NSMutableArray* allRows = nil;
        NSMutableArray* allColumns = nil;
        
        if([credentilId isEqualToString:@"2"]) {
            [VGAppDelegate getInstance].allStudents = [NSMutableArray array];
            [VGAppDelegate getInstance].allSubjects = [NSMutableArray array];
            allRows = [VGAppDelegate getInstance].allStudents;
            allColumns = [VGAppDelegate getInstance].allSubjects;
        } else if ([credentilId isEqualToString:@"3"]) {
            [VGAppDelegate getInstance].allSubjects = [NSMutableArray array];
            [VGAppDelegate getInstance].allSkills = [NSMutableArray array];
            allRows = [VGAppDelegate getInstance].allSubjects;
            allColumns = [VGAppDelegate getInstance].allSkills;
        } else if ([credentilId isEqualToString:@"4"]) {
            [VGAppDelegate getInstance].allSkills = [NSMutableArray array];
            [VGAppDelegate getInstance].allVacancies = [NSMutableArray array];
            allRows = [VGAppDelegate getInstance].allVacancies;
            allColumns = [VGAppDelegate getInstance].allSkills;
        } else {
            NSLog(@"(VGUtilities) Error : Wrong user credentials");
        }
        
        for (NSDictionary* row in ((NSMutableArray*)jsonData[@"all rows"])) {
            [allRows addObject:[VGUtilities baseDataModelFromJsonData:row withCredentialType:credential]];
        }
        
        for (NSDictionary* col in ((NSMutableArray*)jsonData[@"all columns"])) {
            [allColumns addObject:[VGUtilities baseDataModelFromJsonData:col withCredentialType:credential]];
        }
        
        // Filling current user
        [VGAppDelegate getInstance].currentUser = [VGUtilities userFromJsonData:jsonData[kUser]];
        
        VGPresentViewController *presentVC = [[VGPresentViewController new] autorelease];
        [[VGAppDelegate getInstance].navigationController pushViewController:presentVC animated:YES];
    }
}

- (void) requestDidFinishFail:(NSError**)error {
    // TODO
}

#pragma mark - View controller life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark Actions

- (void) clickRightBarButton{
    popup = [[[VGLoginPopupViewController alloc] init] autorelease];
    popup.delegate = self;
    UIViewController *vc = [VGAppDelegate getInstance].navigationController.viewControllers[0];
    
	popup.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	popup.modalPresentationStyle = UIModalPresentationPageSheet;
    
    [vc presentViewController:popup animated:YES completion:nil];
    
    popup.view.superview.frame = CGRectMake(0, 0, 500, 350);
    popup.view.superview.center = CGPointMake(self.view.center.x, self.view.center.y);
}

- (void)dealloc {
    [popup release];
    [super dealloc];
}
@end
