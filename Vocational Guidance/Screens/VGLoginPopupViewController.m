//
//  VGLoginPopupViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGLoginPopupViewController.h"
#import "VGScreenNavigator.h"
#import "VGAppDelegate.h"

static NSString* const kEnterAnonymously = @"Enter anonymously";

@interface VGLoginPopupViewController () {
    NSInteger viewFrameIsChanged;
}

@property (retain, nonatomic) IBOutlet UITextField *txtLogin;
@property (retain, nonatomic) IBOutlet UITextField *txtPassword;
@property (retain, nonatomic) IBOutlet UIButton *btnLogin;
@property (retain, nonatomic) IBOutlet UIImageView *imgLogo;

@end

@implementation VGLoginPopupViewController

- (id)init
{
    self = [super initWithNibName:@"VGLoginPopupViewController" bundle:[NSBundle mainBundle]];
    if (self) {
        viewFrameIsChanged = 0;
    }
    return self;
}

#pragma mark Actions

- (IBAction)clickClose:(id)sender {
    [self.btnLogin setSelected:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)clickLogin:(id)sender {
    if ([[[self.btnLogin titleLabel] text] isEqualToString:kLogin]) {
        [self.btnLogin setSelected:YES];
        [self.delegate popupDidCloseWithLogin:self.txtLogin.text andPassword:self.txtPassword.text];
    } else if ([[[self.btnLogin titleLabel] text] isEqualToString:kEnterAnonymously]) {
        [self.delegate popupDidCloseWithLogin:@"" andPassword:@""];
    }
}

#pragma mark Text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![[textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:@""] &&
        ![[textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:@"\n"] &&
        ![[textField.text stringByReplacingCharactersInRange:range withString:string] isEqualToString:@"\t"] ){
        [self.btnLogin setTitle:kLogin forState:UIControlStateNormal];
    } else {
        [self.btnLogin setTitle:kEnterAnonymously forState:UIControlStateNormal];
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (viewFrameIsChanged == 0) {
        [self animateChangeOriginYView:self.view.superview forValue:100];
        viewFrameIsChanged = 1;
    } else if (viewFrameIsChanged >= 1) {
        viewFrameIsChanged = 2;
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (viewFrameIsChanged == 1 && !self.btnLogin.isSelected) {
        [self animateChangeOriginYView:self.view.superview forValue:-100];
        viewFrameIsChanged = 0;
    } else if(viewFrameIsChanged == 2) {
        viewFrameIsChanged = 1;
    }
    
    return YES;
}

- (void)animateChangeOriginYView:(UIView*)view forValue:(NSInteger)value{
    [UIView animateWithDuration:0.2 delay:0 options:(UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationCurveEaseOut)
                     animations:^(void)
     {
         CGRect frame = view.frame;
         frame.origin.x += ([[UIApplication sharedApplication] statusBarOrientation] == 3) ? value : 0 - value;
         view.frame = frame;
     }
                     completion:nil];
}

#pragma mark life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtLogin.delegate  = self;
    self.txtPassword.delegate  = self;
    [self.btnLogin setTitle:kEnterAnonymously forState:UIControlStateNormal];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)dealloc {
    [_txtLogin release];
    [_txtPassword release];
    [_btnLogin release];
    [_imgLogo release];
    [super dealloc];
}
@end
