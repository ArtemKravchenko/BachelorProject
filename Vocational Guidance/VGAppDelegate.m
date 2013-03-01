//
//  VGAppDelegate.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGAppDelegate.h"
#import "VGLoginViewController.h"
#import "VGScreenNavigator.h"

@class VGTableCell;

@implementation VGAppDelegate

- (void)dealloc {
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    VGLoginViewController *loginView = [[[VGLoginViewController alloc] init] autorelease];
    self.currentScreen = @"Login";
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:loginView] autorelease];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    [VGScreenNavigator initStartScreenMapping];
    self.transactionsList = [NSMutableArray array];
    return YES;
}

+ (VGAppDelegate*)getInstance {
    return (VGAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (void) addObject:(NSInteger)type withObject:(NSString*)name {
    if (type == 2) {
        [self.columns addObject:name];
    } else {
        [self.rows addObject:name];
    }
}

- (void) changeValue:(NSString*)value forRowIndex:(NSInteger)rowIndex andColIndex:(NSInteger)colIndex {
    for (VGTableCell* cell in self.values) {
        if (rowIndex == cell.rowIndex && colIndex == cell.colIndex) {
            cell.value = value;
        }
    }
}

- (void) executingTransation {
    for (NSDictionary *transactionItem in self.transactionsList) {
        NSString *stringType = (NSString*)[transactionItem objectForKey:TS_TRANSACTION_TYPE];
        NSInteger type = [stringType integerValue];
        switch (type) {
            case 2:
                [self addObject:(NSInteger)[transactionItem objectForKey: TS_TRANSACTION_TYPE] withObject:[transactionItem objectForKey: TP_OBJ_NAME]];
                break;
                
            case 1:
                [self addObject:(NSInteger)[transactionItem objectForKey: TS_TRANSACTION_TYPE] withObject:[transactionItem objectForKey: TP_OBJ_NAME]];
                break;
                
            case 3:
                [self changeValue:(NSString*)[transactionItem objectForKey: TP_CELL_VALUE] forRowIndex:(NSInteger)[transactionItem objectForKey: TP_ROW_INDEX] andColIndex:(NSInteger)[transactionItem objectForKey: TP_COL_INDEX]];
                break;
                
            default:
                break;
        }
    }
    
    [self.transactionsList removeAllObjects];
}

@end

@implementation VGTableCell

@synthesize value;
@synthesize colIndex;
@synthesize rowIndex;


@end