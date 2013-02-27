//
//  VGMessageHandler.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VGMessageHandlerViewController : UIViewController

- (void)onPopoverDone:(UIPopoverController *)popoverController selection:(NSString *)selection;

@end
