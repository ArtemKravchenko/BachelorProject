//
//  VGAppDelegate.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (assign, nonatomic) BOOL isLogin;
@property (strong, nonatomic) NSString* currentScreen;


@property (nonatomic, retain) NSMutableArray *rows;
@property (nonatomic, retain) NSMutableArray *columns;
@property (nonatomic, retain) NSMutableArray *values;

+ (VGAppDelegate*) getInstance;

@end

@interface VGTableCell : NSObject

@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, assign) NSInteger colIndex;
@property (nonatomic, retain) NSString  *value;

@end