//
//  VGAppDelegate.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>

//
// Transactions States
//

static NSString* TS_TRANSACTION_TYPE                = @"transaction_type";

//
// Transactions Prameters
//

static NSString* TP_COL_INDEX                       = @"column_index";
static NSString* TP_CELL_VALUE                      = @"cell_value";
static NSString* TP_OBJ_NAME                        = @"obj_name";
static NSString* TP_ROW_INDEX                       = @"row_index";

@interface VGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *navigationController;

@property (assign, nonatomic) BOOL isLogin;
@property (strong, nonatomic) NSString* currentScreen;


@property (nonatomic, retain) NSMutableArray *rows;
@property (nonatomic, retain) NSMutableArray *columns;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) NSMutableArray *transactionsList;

+ (VGAppDelegate*) getInstance;
- (void) executingTransation;

@end

@interface VGTableCell : NSObject

@property (nonatomic, assign) NSInteger rowIndex;
@property (nonatomic, assign) NSInteger colIndex;
@property (nonatomic, retain) NSString  *value;

@end

@interface VGTransactionItem : NSObject

@property (nonatomic, retain) NSString* transactionState;
@property (nonatomic, retain) NSMutableDictionary* parameters;

@end