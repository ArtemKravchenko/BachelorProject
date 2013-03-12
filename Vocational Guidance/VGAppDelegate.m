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
#import "VGStudent.h"
#import "VGSubject.h"
#import "VGSkill.h"
#import "VGJob.h"
#import "VGEmploerData.h"
#import "VGSecretarData.h"
#import "VGExpertData.h"

@class VGTableCell;

@interface VGAppDelegate() {
    NSMutableArray* _stringValues;
}

@end

@implementation VGAppDelegate

- (void)dealloc {
    self.mocData = nil;
    self.allColumns = nil;
    self.allRows = nil;
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
    self.currentUser = [[VGUser new] autorelease];
    [self initTmpUser];
    self.currentUser.side = @"National Aerospace University";
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:loginView] autorelease];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    self.transactionsList = [NSMutableArray array];
    return YES;
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

- (void) initTmpUser {
    
    self.mocData = [NSMutableDictionary dictionary];
    
    // init students
    NSMutableArray* students = [NSMutableArray array];
    
    VGStudent* student = nil;
    
    student = [[VGStudent new] autorelease];
    student.studentId = @"1";
    student.cardNumber = @"7218271821";
    student.name = @"Kiril";
    student.surname = @"Kukushkin";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.studentId = @"2";
    student.cardNumber = @"7238271821";
    student.name = @"Michael";
    student.surname = @"Obama";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.studentId = @"3";
    student.cardNumber = @"7218211821";
    student.name = @"Barak";
    student.surname = @"Obama";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.studentId = @"4";
    student.cardNumber = @"7218291821";
    student.name = @"Filip";
    student.surname = @"Kirkorov";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.studentId = @"5";
    student.cardNumber = @"8218271821";
    student.name = @"Fredy";
    student.surname = @"Mercury";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.studentId = @"6";
    student.cardNumber = @"7018271821";
    student.name = @"Gusha";
    student.surname = @"Katushkin";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.studentId = @"7";
    student.cardNumber = @"7218151841";
    student.name = @"Victor";
    student.surname = @"Yanukovich";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.studentId = @"8";
    student.cardNumber = @"7212271821";
    student.name = @"Dmitrit";
    student.surname = @"Medvedev";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.studentId = @"9";
    student.cardNumber = @"7218271221";
    student.name = @"Vlodimir";
    student.surname = @"Putin";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    // init jobs
    NSMutableArray* jobs = [NSMutableArray array];
    
    VGJob* job = nil;
    
    job = [[VGJob new] autorelease];
    job.jobId = @"1";
    job.name = @"Java developer";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.jobId = @"2";
    job.name = @"IOS Developer";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.jobId = @"3";
    job.name = @".NET Developer";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.jobId = @"4";
    job.name = @"Front-end Developer";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.jobId = @"5";
    job.name = @"Back-end Developer";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.jobId = @"6";
    job.name = @"Project Manger";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.jobId = @"7";
    job.name = @"System Administrator";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.jobId = @"8";
    job.name = @"HR";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.jobId = @"9";
    job.name = @"Buosnes analityc";
    [jobs addObject:job];
    
    // init subjects
    NSMutableArray* subjects = [NSMutableArray array];
    
    VGSubject* subject = nil;
    
    subject = [[VGSubject new] autorelease];
    subject.subjectId = @"1";
    subject.name = @"Programming";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.subjectId = @"2";
    subject.name = @"Mathemathics Analys";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.subjectId = @"3";
    subject.name = @"English";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.subjectId = @"4";
    subject.name = @"Teory of Algorithm";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.subjectId = @"5";
    subject.name = @"Discret Mathemathics";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.subjectId = @"6";
    subject.name = @"Philosophy";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.subjectId = @"7";
    subject.name = @"Web Develophing";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.subjectId = @"8";
    subject.name = @"Data Bases";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.subjectId = @"9";
    subject.name = @"Functional Analys";
    [subjects addObject:subject];
    
    // init skills
    NSMutableArray* skills = [NSMutableArray array];
    
    VGSkill* skill = nil;
    
    skill = [[VGSkill new] autorelease];
    skill.skillId = @"1";
    skill.name = @"C#";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.skillId = @"2";
    skill.name = @"Objective-c";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.skillId = @"3";
    skill.name = @"PHP";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.skillId = @"4";
    skill.name = @"JavaScript";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.skillId = @"5";
    skill.name = @"HTML";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.skillId = @"6";
    skill.name = @"CSS";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.skillId = @"7";
    skill.name = @"MySql";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.skillId = @"8";
    skill.name = @"MSSQL";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.skillId = @"9";
    skill.name = @"English";
    [skills addObject:skill];
    
    // init employers data
    NSMutableArray* employersData = [NSMutableArray array];
    
    VGEmploerData* employerData = nil;
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"1";
    employerData.value = @"65";
    employerData.employerJob = [jobs objectAtIndex:0];
    employerData.employerSkill = [skills objectAtIndex:0];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"2";
    employerData.value = @"72";
    employerData.employerJob = [jobs objectAtIndex:0];
    employerData.employerSkill = [skills objectAtIndex:1];
    [employersData addObject:employerData];
    
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"3";
    employerData.value = @"82";
    employerData.employerJob = [jobs objectAtIndex:0];
    employerData.employerSkill = [skills objectAtIndex:2];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"4";
    employerData.value = @"91";
    employerData.employerJob = [jobs objectAtIndex:0];
    employerData.employerSkill = [skills objectAtIndex:3];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"5";
    employerData.value = @"71";
    employerData.employerJob = [jobs objectAtIndex:0];
    employerData.employerSkill = [skills objectAtIndex:4];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"6";
    employerData.value = @"25";
    employerData.employerJob = [jobs objectAtIndex:1];
    employerData.employerSkill = [skills objectAtIndex:0];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"7";
    employerData.value = @"46";
    employerData.employerJob = [jobs objectAtIndex:1];
    employerData.employerSkill = [skills objectAtIndex:1];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"8";
    employerData.value = @"92";
    employerData.employerJob = [jobs objectAtIndex:1];
    employerData.employerSkill = [skills objectAtIndex:2];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"9";
    employerData.value = @"51";
    employerData.employerJob = [jobs objectAtIndex:1];
    employerData.employerSkill = [skills objectAtIndex:3];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"10";
    employerData.value = @"79";
    employerData.employerJob = [jobs objectAtIndex:1];
    employerData.employerSkill = [skills objectAtIndex:4];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"11";
    employerData.value = @"52";
    employerData.employerJob = [jobs objectAtIndex:2];
    employerData.employerSkill = [skills objectAtIndex:0];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"12";
    employerData.value = @"63";
    employerData.employerJob = [jobs objectAtIndex:2];
    employerData.employerSkill = [skills objectAtIndex:1];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"13";
    employerData.value = @"59";
    employerData.employerJob = [jobs objectAtIndex:2];
    employerData.employerSkill = [skills objectAtIndex:2];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"14";
    employerData.value = @"31";
    employerData.employerJob = [jobs objectAtIndex:2];
    employerData.employerSkill = [skills objectAtIndex:3];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"15";
    employerData.value = @"90";
    employerData.employerJob = [jobs objectAtIndex:2];
    employerData.employerSkill = [skills objectAtIndex:4];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"16";
    employerData.value = @"85";
    employerData.employerJob = [jobs objectAtIndex:3];
    employerData.employerSkill = [skills objectAtIndex:0];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"17";
    employerData.value = @"74";
    employerData.employerJob = [jobs objectAtIndex:3];
    employerData.employerSkill = [skills objectAtIndex:1];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"18";
    employerData.value = @"22";
    employerData.employerJob = [jobs objectAtIndex:3];
    employerData.employerSkill = [skills objectAtIndex:2];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"19";
    employerData.value = @"78";
    employerData.employerJob = [jobs objectAtIndex:3];
    employerData.employerSkill = [skills objectAtIndex:3];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"20";
    employerData.value = @"55";
    employerData.employerJob = [jobs objectAtIndex:3];
    employerData.employerSkill = [skills objectAtIndex:4];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"21";
    employerData.value = @"95";
    employerData.employerJob = [jobs objectAtIndex:4];
    employerData.employerSkill = [skills objectAtIndex:0];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"22";
    employerData.value = @"52";
    employerData.employerJob = [jobs objectAtIndex:4];
    employerData.employerSkill = [skills objectAtIndex:1];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"23";
    employerData.value = @"76";
    employerData.employerJob = [jobs objectAtIndex:4];
    employerData.employerSkill = [skills objectAtIndex:2];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"24";
    employerData.value = @"95";
    employerData.employerJob = [jobs objectAtIndex:4];
    employerData.employerSkill = [skills objectAtIndex:3];
    [employersData addObject:employerData];
    
    employerData = [[VGEmploerData new] autorelease];
    employerData.dataId = @"25";
    employerData.value = @"72";
    employerData.employerJob = [jobs objectAtIndex:4];
    employerData.employerSkill = [skills objectAtIndex:4];
    [employersData addObject:employerData];
    
    // init operators data
    NSMutableArray* expertssData = [NSMutableArray array];
    
    VGExpertData* expertData = nil;
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"1";
    expertData.value = @"78";
    expertData.expertDataSkill = [skills objectAtIndex:0];
    expertData.expertDataSubject = [subjects objectAtIndex:0];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"2";
    expertData.value = @"35";
    expertData.expertDataSkill = [skills objectAtIndex:0];
    expertData.expertDataSubject = [subjects objectAtIndex:1];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"3";
    expertData.value = @"91";
    expertData.expertDataSkill = [skills objectAtIndex:0];
    expertData.expertDataSubject = [subjects objectAtIndex:2];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"4";
    expertData.value = @"86";
    expertData.expertDataSkill = [skills objectAtIndex:0];
    expertData.expertDataSubject = [subjects objectAtIndex:3];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"5";
    expertData.value = @"37";
    expertData.expertDataSkill = [skills objectAtIndex:0];
    expertData.expertDataSubject = [subjects objectAtIndex:4];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"6";
    expertData.value = @"82";
    expertData.expertDataSkill = [skills objectAtIndex:1];
    expertData.expertDataSubject = [subjects objectAtIndex:0];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"7";
    expertData.value = @"98";
    expertData.expertDataSkill = [skills objectAtIndex:1];
    expertData.expertDataSubject = [subjects objectAtIndex:1];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"8";
    expertData.value = @"74";
    expertData.expertDataSkill = [skills objectAtIndex:1];
    expertData.expertDataSubject = [subjects objectAtIndex:2];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"9";
    expertData.value = @"90";
    expertData.expertDataSkill = [skills objectAtIndex:1];
    expertData.expertDataSubject = [subjects objectAtIndex:3];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"10";
    expertData.value = @"94";
    expertData.expertDataSkill = [skills objectAtIndex:1];
    expertData.expertDataSubject = [subjects objectAtIndex:4];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"11";
    expertData.value = @"68";
    expertData.expertDataSkill = [skills objectAtIndex:2];
    expertData.expertDataSubject = [subjects objectAtIndex:0];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"12";
    expertData.value = @"81";
    expertData.expertDataSkill = [skills objectAtIndex:2];
    expertData.expertDataSubject = [subjects objectAtIndex:1];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"13";
    expertData.value = @"79";
    expertData.expertDataSkill = [skills objectAtIndex:2];
    expertData.expertDataSubject = [subjects objectAtIndex:2];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"14";
    expertData.value = @"80";
    expertData.expertDataSkill = [skills objectAtIndex:2];
    expertData.expertDataSubject = [subjects objectAtIndex:3];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"15";
    expertData.value = @"92";
    expertData.expertDataSkill = [skills objectAtIndex:2];
    expertData.expertDataSubject = [subjects objectAtIndex:4];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"16";
    expertData.value = @"87";
    expertData.expertDataSkill = [skills objectAtIndex:3];
    expertData.expertDataSubject = [subjects objectAtIndex:0];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"17";
    expertData.value = @"69";
    expertData.expertDataSkill = [skills objectAtIndex:3];
    expertData.expertDataSubject = [subjects objectAtIndex:1];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"18";
    expertData.value = @"89";
    expertData.expertDataSkill = [skills objectAtIndex:3];
    expertData.expertDataSubject = [subjects objectAtIndex:2];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"19";
    expertData.value = @"70";
    expertData.expertDataSkill = [skills objectAtIndex:3];
    expertData.expertDataSubject = [subjects objectAtIndex:3];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"20";
    expertData.value = @"91";
    expertData.expertDataSkill = [skills objectAtIndex:3];
    expertData.expertDataSubject = [subjects objectAtIndex:4];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"21";
    expertData.value = @"90";
    expertData.expertDataSkill = [skills objectAtIndex:4];
    expertData.expertDataSubject = [subjects objectAtIndex:0];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"22";
    expertData.value = @"79";
    expertData.expertDataSkill = [skills objectAtIndex:4];
    expertData.expertDataSubject = [subjects objectAtIndex:1];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"23";
    expertData.value = @"82";
    expertData.expertDataSkill = [skills objectAtIndex:4];
    expertData.expertDataSubject = [subjects objectAtIndex:2];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"24";
    expertData.value = @"91";
    expertData.expertDataSkill = [skills objectAtIndex:4];
    expertData.expertDataSubject = [subjects objectAtIndex:3];
    [expertssData addObject:expertData];
    
    expertData = [[VGExpertData new] autorelease];
    expertData.dataId = @"25";
    expertData.value = @"71";
    expertData.expertDataSkill = [skills objectAtIndex:4];
    expertData.expertDataSubject = [subjects objectAtIndex:4];
    [expertssData addObject:expertData];
    
    // init secretars data
    NSMutableArray* secretarsData = [NSMutableArray array];
    
    VGSecretarData* secretarData = nil;
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"1";
    secretarData.value = @"89";
    secretarData.secretarDataSubject = [subjects objectAtIndex:0];
    secretarData.secretarDataStudent = [students objectAtIndex:0];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"2";
    secretarData.value = @"70";
    secretarData.secretarDataSubject = [subjects objectAtIndex:0];
    secretarData.secretarDataStudent = [students objectAtIndex:1];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"3";
    secretarData.value = @"76";
    secretarData.secretarDataSubject = [subjects objectAtIndex:0];
    secretarData.secretarDataStudent = [students objectAtIndex:2];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"4";
    secretarData.value = @"81";
    secretarData.secretarDataSubject = [subjects objectAtIndex:0];
    secretarData.secretarDataStudent = [students objectAtIndex:3];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"5";
    secretarData.value = @"82";
    secretarData.secretarDataSubject = [subjects objectAtIndex:0];
    secretarData.secretarDataStudent = [students objectAtIndex:4];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"6";
    secretarData.value = @"69";
    secretarData.secretarDataSubject = [subjects objectAtIndex:1];
    secretarData.secretarDataStudent = [students objectAtIndex:0];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"7";
    secretarData.value = @"80";
    secretarData.secretarDataSubject = [subjects objectAtIndex:1];
    secretarData.secretarDataStudent = [students objectAtIndex:1];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"8";
    secretarData.value = @"91";
    secretarData.secretarDataSubject = [subjects objectAtIndex:1];
    secretarData.secretarDataStudent = [students objectAtIndex:2];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"9";
    secretarData.value = @"79";
    secretarData.secretarDataSubject = [subjects objectAtIndex:1];
    secretarData.secretarDataStudent = [students objectAtIndex:3];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"10";
    secretarData.value = @"96";
    secretarData.secretarDataSubject = [subjects objectAtIndex:1];
    secretarData.secretarDataStudent = [students objectAtIndex:4];
    [secretarsData addObject:secretarsData];
    
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"11";
    secretarData.value = @"87";
    secretarData.secretarDataSubject = [subjects objectAtIndex:2];
    secretarData.secretarDataStudent = [students objectAtIndex:0];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"12";
    secretarData.value = @"69";
    secretarData.secretarDataSubject = [subjects objectAtIndex:2];
    secretarData.secretarDataStudent = [students objectAtIndex:1];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"13";
    secretarData.value = @"95";
    secretarData.secretarDataSubject = [subjects objectAtIndex:2];
    secretarData.secretarDataStudent = [students objectAtIndex:2];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"14";
    secretarData.value = @"79";
    secretarData.secretarDataSubject = [subjects objectAtIndex:2];
    secretarData.secretarDataStudent = [students objectAtIndex:3];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"15";
    secretarData.value = @"83";
    secretarData.secretarDataSubject = [subjects objectAtIndex:2];
    secretarData.secretarDataStudent = [students objectAtIndex:4];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"16";
    secretarData.value = @"97";
    secretarData.secretarDataSubject = [subjects objectAtIndex:3];
    secretarData.secretarDataStudent = [students objectAtIndex:0];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"17";
    secretarData.value = @"70";
    secretarData.secretarDataSubject = [subjects objectAtIndex:3];
    secretarData.secretarDataStudent = [students objectAtIndex:1];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"18";
    secretarData.value = @"79";
    secretarData.secretarDataSubject = [subjects objectAtIndex:3];
    secretarData.secretarDataStudent = [students objectAtIndex:2];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"19";
    secretarData.value = @"88";
    secretarData.secretarDataSubject = [subjects objectAtIndex:3];
    secretarData.secretarDataStudent = [students objectAtIndex:3];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"20";
    secretarData.value = @"84";
    secretarData.secretarDataSubject = [subjects objectAtIndex:3];
    secretarData.secretarDataStudent = [students objectAtIndex:4];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"21";
    secretarData.value = @"92";
    secretarData.secretarDataSubject = [subjects objectAtIndex:4];
    secretarData.secretarDataStudent = [students objectAtIndex:0];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"22";
    secretarData.value = @"97";
    secretarData.secretarDataSubject = [subjects objectAtIndex:4];
    secretarData.secretarDataStudent = [students objectAtIndex:1];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"23";
    secretarData.value = @"79";
    secretarData.secretarDataSubject = [subjects objectAtIndex:4];
    secretarData.secretarDataStudent = [students objectAtIndex:2];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"24";
    secretarData.value = @"85";
    secretarData.secretarDataSubject = [subjects objectAtIndex:4];
    secretarData.secretarDataStudent = [students objectAtIndex:3];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGSecretarData new] autorelease];
    secretarData.dataId = @"25";
    secretarData.value = @"99";
    secretarData.secretarDataSubject = [subjects objectAtIndex:4];
    secretarData.secretarDataStudent = [students objectAtIndex:4];
    [secretarsData addObject:secretarsData];
    
    // init persons
    NSMutableArray* persons = [NSMutableArray array];
    
    NSMutableArray* tmprowsArray = nil;
    NSMutableArray* tmpcolsArray = nil;
    
    VGUser* person = nil;
    
    tmprowsArray = [NSMutableArray array];
    tmpcolsArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 5; i++) {
        [tmprowsArray addObject:[jobs objectAtIndex:i]];
        [tmpcolsArray addObject:[skills objectAtIndex:i]];
    }
    
    person = [[VGUser new] autorelease];
    person.userId = @"1";
    person.name = @"Stive";
    person.surname = @"Jobs";
    person.side = @"Apple";
    person.login = @"Emplyer";
    person.password = @"Employer";
    person.credential = VGCredentilasTypeEmployer;
    person.dataSet = employersData;
    person.rows = tmprowsArray;
    person.columns = tmpcolsArray;
    [persons addObject:person];
    
    tmprowsArray = [NSMutableArray array];
    tmpcolsArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 5; i++) {
        [tmprowsArray addObject:[skills objectAtIndex:i]];
        [tmpcolsArray addObject:[subjects objectAtIndex:i]];
    }
    
    person = [[VGUser new] autorelease];
    person.userId = @"2";
    person.name = @"Aleksandr";
    person.surname = @"Kulik";
    person.side = @"KHAI";
    person.login = @"Expert";
    person.password = @"Expert";
    person.credential = VGCredentilasTypeExpert;
    person.dataSet = expertssData;
    person.rows = tmprowsArray;
    person.columns = tmpcolsArray;
    [persons addObject:person];
    
    tmprowsArray = [NSMutableArray array];
    tmpcolsArray = [NSMutableArray array];
    
    for (NSInteger i = 0; i < 5; i++) {
        [tmprowsArray addObject:[subjects objectAtIndex:i]];
        [tmpcolsArray addObject:[students objectAtIndex:i]];
    }
    
    person = [[VGUser new] autorelease];
    person.userId = @"3";
    person.name = @"Nina";
    person.surname = @"Bakumenko";
    person.side = @"KHAI";
    person.login = @"Secretar";
    person.password = @"Secretar";
    person.credential = VGCredentilasTypeSecretar;
    person.dataSet = secretarsData;
    person.rows = tmprowsArray;
    person.columns = tmpcolsArray;
    [persons addObject:person];
    
    [self.mocData setObject:students forKey:@"students"];
    [self.mocData setObject:jobs forKey:@"jobs"];
    [self.mocData setObject:subjects forKey:@"subjects"];
    [self.mocData setObject:skills forKey:@"skills"];
    [self.mocData setObject:persons forKey:@"persons"];
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