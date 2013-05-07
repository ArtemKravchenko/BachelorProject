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
    [VGAlertView showPleaseWaitState];
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
        return;
    }
    
    [VGScreenNavigator initStartScreenMapping];
    
    VGPresentViewController *presentVC = [[VGPresentViewController new] autorelease];
    [[VGAppDelegate getInstance].navigationController pushViewController:presentVC animated:YES];
}

#pragma mark - Request delegate


- (void) requestDidFinishSuccessful:(NSData *)data {
    [VGScreenNavigator initStartScreenMapping];
    
    VGPresentViewController *presentVC = [[VGPresentViewController new] autorelease];
    [[VGAppDelegate getInstance].navigationController pushViewController:presentVC animated:YES];
    
    [VGAppDelegate getInstance].currentUser = [VGUtilities userFromJsonData:data];
    // TODO
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
