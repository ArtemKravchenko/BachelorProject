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
    [popup dismissViewControllerAnimated:YES completion:nil];
    [VGAppDelegate getInstance].isLogin = YES;
    
    // ----------- TEMPORARY -----------------
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@ AND %K LIKE %@", @"login", login, @"password", password];
    NSMutableArray* tmpArray = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"persons"]];
    
    [tmpArray filterUsingPredicate:predicate];
    if (tmpArray.count) {
        [VGAppDelegate getInstance].currentUser = tmpArray[0];
        
        switch ([VGAppDelegate getInstance].currentUser.credential) {
            case VGCredentilasTypeEmployer:
                [VGAppDelegate getInstance].allRows = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"jobs"]];
                [VGAppDelegate getInstance].allColumns = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"skills"]];
                break;
                
            case VGCredentilasTypeExpert:
                [VGAppDelegate getInstance].allRows = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"skills"]];
                [VGAppDelegate getInstance].allColumns = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"subjects"]];
                break;
                
            case VGCredentilasTypeSecretar:
                [VGAppDelegate getInstance].allRows = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"subjects"]];
                [VGAppDelegate getInstance].allColumns = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"students"]];
                break;
                
            default:
                break;
        }
    } else {
        return;
    }
    
    [VGScreenNavigator initStartScreenMapping];
    
    VGPresentViewController *presentVC = [[VGPresentViewController new] autorelease];
    [[VGAppDelegate getInstance].navigationController pushViewController:presentVC animated:YES];
}

#pragma View controller life cycle

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
