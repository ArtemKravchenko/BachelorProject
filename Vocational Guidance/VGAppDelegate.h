//
//  VGAppDelegate.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VGUser.h"
#import "VGStudent.h"
#import "VGSide.h"

@interface VGAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;

@property (nonatomic, assign) NSInteger tmpGlobalId;
@property (assign, nonatomic) BOOL isLogin;
@property (strong, nonatomic) NSString* currentScreen;

#pragma mark - Session values

@property (nonatomic, retain) VGUser* currentUser;
@property (nonatomic, retain) VGStudent* currentStudent;
@property (nonatomic, retain) VGUser* currentExpert;
@property (nonatomic, retain) VGUser* currentEmployer;
@property (nonatomic, retain) NSDictionary* results;

#pragma mark - Rows and columns
@property (nonatomic, retain) NSMutableArray *transactionsList;

@property (nonatomic, retain) NSMutableArray* allStudents;
@property (nonatomic, retain) NSMutableArray* allSubjects;
@property (nonatomic, retain) NSMutableArray* allSkills;
@property (nonatomic, retain) NSMutableArray* allVacancies;
@property (nonatomic, retain) NSMutableArray* allSides;
#pragma mark - Methods

+ (VGAppDelegate*) getInstance;
- (void) executingTransation;
- (void) cancelTransaction;
- (NSMutableArray*) stringValuesFromDataArray:(NSMutableArray*)arrayValues;
- (void) checkoutSession;

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