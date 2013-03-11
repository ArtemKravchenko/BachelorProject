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
    [_iconName release];
    [_currentUser release];
    [_transactionsList release];
    [_stringValues release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    VGLoginViewController *loginView = [[[VGLoginViewController alloc] init] autorelease];
    self.currentScreen = @"Login";
    self.currentUser = [VGUser new];
    self.currentUser.side = @"National Aerospace University";
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:loginView] autorelease];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    self.transactionsList = [NSMutableArray array];
    return YES;
}

- (void) initTmpUser {
    
    //NSMutableArray* columns = [NSMutableArray arrayWithObjects: @"col1", @"col2", @"col3", @"col4", @"col5", @"col6", @"col7", @"col8",  @"col9", @"col10", @"col11", nil];
    //NSMutableArray* rows = [NSMutableArray arrayWithObjects: @"row1", @"row2", @"row3", @"row4", @"row5", @"rowl6", @"row7", @"row8", @"row9", @"row10", @"row11", nil];
    NSMutableArray* columns = [NSMutableArray arrayWithObjects: @"col1", @"col2", @"col3", @"col4", nil];
    NSMutableArray* rows = [NSMutableArray arrayWithObjects: @"row1", @"row2", @"row3", @"row4", nil];
    
    NSMutableArray *values = [NSMutableArray array];
    for (NSInteger i = 0; i < rows.count; i++) {
        for (NSInteger j = 0; j < columns.count; j++) {
            VGTableCell *tableCell = [[VGTableCell new] autorelease];
            tableCell.rowIndex = i;
            tableCell.colIndex = j;
            if (j % 2 == 0) {
                tableCell.value =  [NSString stringWithFormat:@"%d", 0];
            } else {
                tableCell.value = [NSString stringWithFormat:@"%.2f", ((float)(arc4random()  % 100)) / 100.0] ;
            }
            [values addObject: tableCell];
        }
    }
    [self setData:rows columns:columns values:values];
}

- (void) setData:(NSMutableArray*)rows columns:(NSMutableArray*)columns values:(NSMutableArray*)values {
    [VGAppDelegate getInstance].currentUser.columns = columns;
    [VGAppDelegate getInstance].currentUser.rows = rows;
    [VGAppDelegate getInstance].currentUser.dataSet = values;
}

+ (VGAppDelegate*)getInstance {
    return (VGAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (NSMutableArray*) stringValuesFromDataArray:(NSMutableArray*)arrayValues {
    _stringValues = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < arrayValues.count; i++) {
        VGTableType* tmpTableTypeElement = [[VGTableType new] autorelease];
        tmpTableTypeElement.key = i;
        NSString* text = [NSString stringWithFormat:@"%@ %@ %@", ((VGTableCell*)arrayValues[i]).value, ((NSString*)self.currentUser.columns[((VGTableCell*)arrayValues[i]).colIndex]),
                          ((NSString*)self.currentUser.rows[((VGTableCell*)arrayValues[i]).rowIndex])];
        tmpTableTypeElement.value = text;
        [_stringValues addObject:tmpTableTypeElement];
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
    for (VGTableCell* cell in self.currentUser.dataSet) {
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
    NSMutableArray* changedArray = (type == 2) ? self.currentUser.columns : self.currentUser.rows;
    NSInteger index = [changedArray indexOfObject:name];
    
    NSMutableArray* deletingArray = [NSMutableArray array];
    [changedArray removeObject:name];
    NSInteger count = self.currentUser.dataSet.count;
    for (int i = 0; i < count; i++) {
        if (((type == 2) ? ((VGTableCell*)self.currentUser.dataSet[i]).colIndex : ((VGTableCell*)self.currentUser.dataSet[i]).rowIndex) == index) {
            [deletingArray addObject:self.currentUser.dataSet[i]];
        }
    }
    
    for (VGTableCell* cell in deletingArray) {
        [self.currentUser.dataSet removeObject:cell];
    }
    _stringValues = nil;
}

- (void) returnOldValue:(NSString*)value forRowIndex:(NSInteger)rowIndex andColIndex:(NSInteger)colIndex {
    for (VGTableCell* cell in self.currentUser.dataSet) {
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