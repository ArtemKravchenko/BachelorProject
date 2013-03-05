//
//  VGAppDelegate.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGUser.h"

@class VGUser;

@interface VGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (assign, nonatomic) BOOL isLogin;
@property (strong, nonatomic) NSString* currentScreen;


@property (nonatomic, retain) VGUser* currentUser;
@property (nonatomic, retain) NSMutableArray *rows;
@property (nonatomic, retain) NSMutableArray *columns;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) NSMutableArray *transactionsList;
@property (nonatomic, retain) NSMutableArray *stringValues;

+ (VGAppDelegate*) getInstance;
- (void) executingTransation;
- (void) cancelTransaction;

@end

// -------------------------------------------- Another types --------------------------------------------


@interface VGTableCell : NSObject

@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, assign) NSInteger colIndex;
@property (nonatomic, retain) NSString  *value;

@end


@interface VGTableType : NSObject

@property (nonatomic, retain) NSString* value;
@property (nonatomic, assign) NSInteger key;

@end

@interface VGTransactionItem : NSObject

@property (nonatomic, retain) NSString* transactionState;
@property (nonatomic, retain) NSMutableDictionary* parameters;

@end