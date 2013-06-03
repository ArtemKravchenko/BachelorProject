//
//  VGLoginViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGLoginViewController.h"
#import "VGScreenNavigator.h"
#import "VGPresentViewController.h"
#import "VGGetPersonRequest.h"
#import "VGRequestQueue.h"
#import "VGSubject.h"
#import "VGSkill.h"
#import "VGJob.h"

@interface VGLoginViewController ()

@property (nonatomic, retain) VGLoginPopupViewController *popup;
@property (nonatomic, assign) BOOL isAnonymous;

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
    UIBarButtonItem* right = [[[UIBarButtonItem alloc] initWithTitle:kLogin style:UIBarButtonItemStyleBordered target:self action:@selector(clickRightBarButton)] autorelease];
    return  right;
}

#pragma mark Mock function

- (void) mockUser:(NSString*)login password:(NSString*)password {
    [self.popup dismissViewControllerAnimated:YES completion:nil];
    if ([login isEqualToString:@""] && [password isEqualToString:@""]) {
        [VGAppDelegate getInstance].isLogin = NO;
    } else {
        [VGAppDelegate getInstance].isLogin = YES;
        
        // ----------- TEMPORARY -----------------
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@ AND %K LIKE %@", @"login", login, @"password", password];
        NSMutableArray* tmpArray = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:kPersons]];
        
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
    
    [VGAppDelegate getInstance].allStudents = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"students"]];
    [VGAppDelegate getInstance].allSubjects = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"subjects"]];
    [VGAppDelegate getInstance].allSkills = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"skills"]];
    [VGAppDelegate getInstance].allVacancies = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"jobs"]];
    [VGAppDelegate getInstance].allSides = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"sides"]];
    
    [VGScreenNavigator initStartScreenMapping];
    
    VGPresentViewController *presentVC = [[VGPresentViewController new] autorelease];
    [[VGAppDelegate getInstance].navigationController pushViewController:presentVC animated:YES];
}

#pragma mark - Login popup delegate

- (void) popupDidCloseWithLogin:(NSString *)login andPassword:(NSString *)password {
    
    [VGAlertView showPleaseWaitState];
    if ([login isEqualToString:@""] && [password isEqualToString:@""]) {
        VGGetPersonRequest* request = [[[VGGetPersonRequest alloc] initWithAllSides] autorelease];
        request.delegate = self;
        [[VGRequestQueue queue] addRequest:request];
        self.isAnonymous = YES;
    } else {
        VGGetPersonRequest* request = [[[VGGetPersonRequest alloc] initWithLogin:login andPassword:password] autorelease];
        request.delegate = self;
        [[VGRequestQueue queue] addRequest:request];
        self.isAnonymous = NO;
    }
    /*
     [self mockUser:login password:password];
     */
}

#pragma mark - Request delegate

- (void) requestDidFinishSuccessful:(NSData *)data {
    NSError* error;
    NSDictionary* jsonData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    // Filling all array side
    [VGAppDelegate getInstance].allSides = [NSMutableArray array];
    
    for (NSDictionary* data in jsonData[@"all sides"]) {
        [[VGAppDelegate getInstance].allSides addObject:[VGUtilities tableVariableFromJsonData:data withClassType:[VGSide class]]];
    }
    
    if (!self.isAnonymous) {
        [VGAppDelegate getInstance].isLogin = YES;
        
        // Filling all rows and all columns
        //
        
        
        [VGUtilities fillAllArraysWithRows:((NSMutableArray*)jsonData[@"all rows"])
                                andColumns:((NSMutableArray*)jsonData[@"all columns"])
                                andCredential:[NSString stringWithFormat:@"%@", ((NSDictionary*)jsonData[kUser])[@"PersonCredentialId"]]];
        
        [VGAppDelegate getInstance].token = jsonData[@"token"];
        
        // Filling current user
        //[VGAppDelegate getInstance].currentUser = [VGUtilities userFromJsonData:jsonData[kUser] andAllRows:allRows andAllColumns:allColumns andRowType:[rowClass class] andColType:[colClass class]];
        [VGAppDelegate getInstance].currentUser = [VGUtilities userFromJsonData:jsonData[kUser]];
    }
    [VGScreenNavigator initStartScreenMapping];
    
    [self performSelectorOnMainThread:@selector(goToPresentViewController) withObject:self waitUntilDone:NO];
}

- (void) goToPresentViewController {
    [self.popup dismissViewControllerAnimated:YES completion:nil];
    VGPresentViewController *presentVC = [[VGPresentViewController new] autorelease];
    [[VGAppDelegate getInstance].navigationController pushViewController:presentVC animated:YES];
}

#pragma mark - View controller life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark Actions

- (void) clickRightBarButton{
    self.popup = [[[VGLoginPopupViewController alloc] init] autorelease];
    self.popup.delegate = self;
    UIViewController *vc = [VGAppDelegate getInstance].navigationController.viewControllers[0];
    
	self.popup.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	self.popup.modalPresentationStyle = UIModalPresentationPageSheet;
    
    [vc presentViewController:self.popup animated:YES completion:nil];
    
    self.popup.view.superview.frame = CGRectMake(0, 0, 500, 350);
    self.popup.view.superview.center = CGPointMake(self.view.center.x, self.view.center.y);
}

- (void)dealloc {
    self.popup = nil;
    [super dealloc];
}
@end
