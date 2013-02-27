//
//  VGBaseViewController.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGSavedScreenInfo.h"
#import "VGMessageHandlerViewController.h"

@interface VGBaseViewController : VGMessageHandlerViewController

- (void) sendNewNavigationStack: (VGSavedScreenInfo *) screenInfo toObject: (id) target action: (SEL) action;

@end
