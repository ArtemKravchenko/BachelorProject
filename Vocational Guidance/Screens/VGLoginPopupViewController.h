//
//  VGLoginPopupViewController.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginPopupDelegate <NSObject>

- (void) popupDidClose;

@end

@interface VGLoginPopupViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic , assign) id<LoginPopupDelegate> delegate;

@end
