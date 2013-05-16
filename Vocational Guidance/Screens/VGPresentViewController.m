//
//  VGPresentViewController.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGPresentViewController.h"

@interface VGPresentViewController ()

@end

@implementation VGPresentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([VGAlertView isShowing]) {
        [VGAlertView hidePleaseWaitState];
    }
    // Do any additional setup after loading the view from its nib.
}

@end
