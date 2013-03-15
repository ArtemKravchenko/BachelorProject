//
//  VGAppDelegate.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGUser.h"
#import "VGObject.h"

@class VGUser;

@interface VGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic, assign) NSInteger tmpGlobalId;
@property (assign, nonatomic) BOOL isLogin;
@property (strong, nonatomic) NSString* currentScreen;

@property (nonatomic, retain) NSString* iconName;
@property (nonatomic, retain) VGUser* currentUser;
@property (nonatomic, retain) NSMutableArray *transactionsList;

@property (nonatomic, retain) NSMutableArray* allColumns;
@property (nonatomic, retain) NSMutableArray* allRows;
// Functions

+ (VGAppDelegate*) getInstance;
- (void) executingTransation;
- (void) cancelTransaction;
- (NSMutableArray*) stringValuesFromDataArray:(NSMutableArray*)arrayValues;

@property (nonatomic, retain) NSMutableDictionary* mockData;

@end

// -------------------------------------------- Another types --------------------------------------------

@interface VGTableType : NSObject

@property (nonatomic, retain) NSString* value;
@property (nonatomic, assign) NSInteger key;

@end

@interface VGTransactionItem : NSObject

@property (nonatomic, retain) NSString* transactionState;
@property (nonatomic, retain) NSMutableDictionary* parameters;

@end