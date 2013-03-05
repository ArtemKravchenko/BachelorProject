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

@interface VGAppDelegate() {
    NSMutableArray* _stringValues;
}

@end

@implementation VGAppDelegate

- (void)dealloc {
    [_currentUser release];
    [_values release];
    [_transactionsList release];
    [_rows release];
    [_columns release];
    [_stringValues release];
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
    self.transactionsList = [NSMutableArray array];
    return YES;
}

+ (VGAppDelegate*)getInstance {
    return (VGAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (NSMutableArray*) stringValues {
    if (_stringValues == nil) {
        _stringValues = [[NSMutableArray alloc] init];
    
        for (int i = 0; i < [VGAppDelegate getInstance].values.count; i++) {
            VGTableType* tmpTableTypeElement = [[VGTableType new] autorelease];
            tmpTableTypeElement.key = i;
            NSString* text = [NSString stringWithFormat:@"%@ %@ %@", ((VGTableCell*)[VGAppDelegate getInstance].values[i]).value, ((NSString*)self.columns[((VGTableCell*)[VGAppDelegate getInstance].values[i]).colIndex]),
                              ((NSString*)self.rows[((VGTableCell*)[VGAppDelegate getInstance].values[i]).rowIndex])];
            tmpTableTypeElement.value = text;
            [_stringValues addObject:tmpTableTypeElement];
        }
    }
    
    return [NSMutableArray arrayWithArray: _stringValues];
}

#pragma mark - Work with transactions

- (void) executingTransation {
    for (NSDictionary *transactionItem in self.transactionsList) {
        NSString *stringType = (NSString*)[transactionItem objectForKey:@"transaction_type"];
        NSInteger type = [stringType integerValue];
        if (type == 3) {
            [self changeValue:(NSString*)[transactionItem objectForKey: @"cell_value"] forRowIndex:[((NSNumber*)[transactionItem objectForKey: @"row_index"]) integerValue] andColIndex:[((NSNumber*)[transactionItem objectForKey: @"column_index"]) integerValue]];
        } else {
            [self addObject:type withObject:[transactionItem objectForKey: @"obj_name"]];
        }
    }
    [self.transactionsList removeAllObjects];
}

- (void) addObject:(NSInteger)type withObject:(NSString*)name {
    _stringValues = nil;
}

- (void) changeValue:(NSString*)value forRowIndex:(NSInteger)rowIndex andColIndex:(NSInteger)colIndex {
    for (VGTableCell* cell in self.values) {
        if (rowIndex == cell.rowIndex && colIndex == cell.colIndex) {
            cell.value = value;
        }
    }
    _stringValues = nil;
}

- (void) cancelTransaction {
    for (NSDictionary *transactionItem in self.transactionsList) {
        NSString *stringType = (NSString*)[transactionItem objectForKey:@"transaction_type"];
        NSInteger type = [stringType integerValue];
        if (type == 3) {
            [self returnOldValue:(NSString*)[transactionItem objectForKey: @"old_value"] forRowIndex:[((NSNumber*)[transactionItem objectForKey: @"row_index"]) integerValue] andColIndex:[((NSNumber*)[transactionItem objectForKey: @"column_index"]) integerValue]];
        } else {
            [self removeObject:type withObject:[transactionItem objectForKey: @"obj_name"]];
        }
    }
    [self.transactionsList removeAllObjects];
}

- (void) removeObject:(NSInteger)type withObject:(NSString*)name {
    NSMutableArray* changedArray = (type == 2) ? self.columns : self.rows;
    NSInteger index = [changedArray indexOfObject:name];
    
    NSMutableArray* deletingArray = [NSMutableArray array];
    [changedArray removeObject:name];
    NSInteger count = self.values.count;
    for (int i = 0; i < count; i++) {
        if (((type == 2) ? ((VGTableCell*)self.values[i]).colIndex : ((VGTableCell*)self.values[i]).rowIndex) == index) {
            [deletingArray addObject:self.values[i]];
        }
    }
    
    for (VGTableCell* cell in deletingArray) {
        [self.values removeObject:cell];
    }
    _stringValues = nil;
}

- (void) returnOldValue:(NSString*)value forRowIndex:(NSInteger)rowIndex andColIndex:(NSInteger)colIndex {
    for (VGTableCell* cell in self.values) {
        if (rowIndex == cell.rowIndex && colIndex == cell.colIndex) {
            cell.value = value;
        }
    }
    _stringValues = nil;
}

@end

@implementation VGTableCell

@synthesize value;
@synthesize colIndex;
@synthesize rowIndex;

@end


@implementation VGTableType

- (void)dealloc
{
    self.value = nil;
    [super dealloc];
}

@end