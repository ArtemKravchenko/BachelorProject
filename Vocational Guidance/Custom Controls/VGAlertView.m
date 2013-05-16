//
//  VGAlertView.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 03.05.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGAlertView.h"

static VGAlertView *_alert;
static BOOL _isShowing;

@implementation VGAlertView

+ (void) showPleaseWaitState {
    _alert = [[[VGAlertView alloc] initWithTitle:@"Processing"
                                        message:@"Please Wait..."
                                       delegate:nil
                              cancelButtonTitle:nil
                               otherButtonTitles:nil] autorelease];
    _isShowing = YES;
    [_alert show];
}

+ (void) hidePleaseWaitState {
    _isShowing = NO;
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
}

+ (BOOL) isShowing {
    return _isShowing;
}

+ (void) showError:(NSString*)message {
    _alert = [[[VGAlertView alloc] initWithTitle:@"Error"
                                         message:message
                                        delegate:nil
                               cancelButtonTitle:@"OK"
                               otherButtonTitles:nil] autorelease];
    [_alert show];
}

@end
