//
//  VGAlertView.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 03.05.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGAlertView.h"

static VGAlertView *alert;

@implementation VGAlertView

+ (void) showPleaseWaitState {
    alert = [[[VGAlertView alloc] initWithTitle:@"Please Wait"
                                        message:@""
                                       delegate:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:nil, nil] autorelease];
    [alert show];
}

+ (void) hidePleaseWaitState {
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

@end
