//
//  VGOptionsViewController.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGMessageHandlerViewController.h"

@interface VGOptionsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate>

@property (nonatomic, retain) NSArray *arrayOptions;
@property (nonatomic, retain) UIPopoverController *popover;
@property (nonatomic, assign) VGMessageHandlerViewController *delegate;

+ (UIPopoverController *) newPopoverWithTitle: (NSString *) title options: (NSArray *) options delegate: (VGMessageHandlerViewController *) delegate tag: (NSInteger) tag;

@end
