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
#import "VGBaseDataModel.h"

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
        NSString* text = [NSString stringWithFormat:@"%@ %@ %@", ((VGBaseDataModel*)arrayValues[i]).value,
                          ((VGBaseDataModel*)arrayValues[i]).col.name,
                          ((VGBaseDataModel*)arrayValues[i]).row.name];
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
            [self changeValue:(NSString*)[transactionItem objectForKey: @"cell_value"] forRow:((VGObject*)[transactionItem objectForKey: @"row_index"]) andCol:((VGObject*)[transactionItem objectForKey: @"column_index"])];
        } else {
            [self addObject:type withObject:[transactionItem objectForKey: @"obj_name"]];
        }
    }
    [self.transactionsList removeAllObjects];
}

- (void) addObject:(NSInteger)type withObject:(NSString*)name {
    _stringValues = nil;
}

- (void) changeValue:(NSString*)value forRow:(VGObject*)rowIndex andCol:(VGObject*)colIndex {
    for (VGBaseDataModel* cell in self.currentUser.dataSet) {
        if (rowIndex.object_id == cell.row.object_id && colIndex.object_id == cell.col.object_id) {
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
            [self returnOldValue:(NSString*)[transactionItem objectForKey: @"old_value"] forRowIndex:((VGObject*)[transactionItem objectForKey: @"row_index"]) andColIndex:((VGObject*)[transactionItem objectForKey: @"column_index"])];
        } else {
            [self removeObject:type withObject:[transactionItem objectForKey: @"obj_name"]];
        }
    }
    [self.transactionsList removeAllObjects];
}

- (void) removeObject:(NSInteger)type withObject:(VGObject*)name {
    NSMutableArray* changedArray = (type == 2) ? self.currentUser.columns : self.currentUser.rows;
    
    NSMutableArray* deletingArray = [NSMutableArray array];
    [changedArray removeObject:name];
    NSInteger count = self.currentUser.dataSet.count;
    for (int i = 0; i < count; i++) {
        if (((type == 2) ? ((VGBaseDataModel*)self.currentUser.dataSet[i]).col.object_id : ((VGBaseDataModel*)self.currentUser.dataSet[i]).row.object_id) == name.object_id) {
            [deletingArray addObject:self.currentUser.dataSet[i]];
        }
    }
    
    for (VGBaseDataModel* cell in deletingArray) {
        [self.currentUser.dataSet removeObject:cell];
    }
    _stringValues = nil;
}

- (void) returnOldValue:(NSString*)value forRowIndex:(VGObject*)rowIndex andColIndex:(VGObject*)colIndex {
    for (VGBaseDataModel* cell in self.currentUser.dataSet) {
        if (rowIndex.object_id == cell.row.object_id && colIndex.object_id == cell.col.object_id) {
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
    student.object_id = @"1";
    student.cardNumber = @"7218271821";
    student.studentName = @"Kiril";
    student.studentSurname = @"Kukushkin";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.object_id = @"2";
    student.cardNumber = @"7238271821";
    student.studentName = @"Michael";
    student.studentSurname = @"Obama";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.object_id = @"3";
    student.cardNumber = @"7218211821";
    student.studentName = @"Barak";
    student.studentSurname = @"Obama";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.object_id = @"4";
    student.cardNumber = @"7218291821";
    student.studentName = @"Filip";
    student.studentSurname = @"Kirkorov";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.object_id = @"5";
    student.cardNumber = @"8218271821";
    student.studentName = @"Fredy";
    student.studentSurname = @"Mercury";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.object_id = @"6";
    student.cardNumber = @"7018271821";
    student.studentName = @"Gusha";
    student.studentSurname = @"Katushkin";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.object_id = @"7";
    student.cardNumber = @"7218151841";
    student.studentName = @"Victor";
    student.studentSurname = @"Yanukovich";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.object_id = @"8";
    student.cardNumber = @"7212271821";
    student.studentName = @"Dmitrit";
    student.studentSurname = @"Medvedev";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.object_id = @"9";
    student.cardNumber = @"7218271221";
    student.studentName = @"Vlodimir";
    student.studentSurname = @"Putin";
    student.side = @"KHAI";
    student.age = 20;
    [students addObject:student];
    
    // init jobs
    NSMutableArray* jobs = [NSMutableArray array];
    
    VGJob* job = nil;
    
    job = [[VGJob new] autorelease];
    job.object_id = @"1";
    job.name = @"Java developer";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.object_id = @"2";
    job.name = @"IOS Developer";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.object_id = @"3";
    job.name = @".NET Developer";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.object_id = @"4";
    job.name = @"Front-end Developer";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.object_id = @"5";
    job.name = @"Back-end Developer";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.object_id = @"6";
    job.name = @"Project Manger";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.object_id = @"7";
    job.name = @"System Administrator";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.object_id = @"8";
    job.name = @"HR";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.object_id = @"9";
    job.name = @"Buosnes analityc";
    [jobs addObject:job];
    
    // init subjects
    NSMutableArray* subjects = [NSMutableArray array];
    
    VGSubject* subject = nil;
    
    subject = [[VGSubject new] autorelease];
    subject.object_id = @"1";
    subject.name = @"Programming";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.object_id = @"2";
    subject.name = @"Mathemathics Analys";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.object_id = @"3";
    subject.name = @"English";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.object_id = @"4";
    subject.name = @"Teory of Algorithm";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.object_id = @"5";
    subject.name = @"Discret Mathemathics";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.object_id = @"6";
    subject.name = @"Philosophy";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.object_id = @"7";
    subject.name = @"Web Develophing";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.object_id = @"8";
    subject.name = @"Data Bases";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.object_id = @"9";
    subject.name = @"Functional Analys";
    [subjects addObject:subject];
    
    // init skills
    NSMutableArray* skills = [NSMutableArray array];
    
    VGSkill* skill = nil;
    
    skill = [[VGSkill new] autorelease];
    skill.object_id = @"1";
    skill.name = @"C#";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.object_id = @"2";
    skill.name = @"Objective-c";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.object_id = @"3";
    skill.name = @"PHP";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.object_id = @"4";
    skill.name = @"JavaScript";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.object_id = @"5";
    skill.name = @"HTML";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.object_id = @"6";
    skill.name = @"CSS";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.object_id = @"7";
    skill.name = @"MySql";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.object_id = @"8";
    skill.name = @"MSSQL";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.object_id = @"9";
    skill.name = @"English";
    [skills addObject:skill];
    
    // init employers data
    NSMutableArray* employersData = [NSMutableArray array];
    
    VGBaseDataModel* employerData = nil;
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"1";
    employerData.value = @"65";
    employerData.row = [jobs objectAtIndex:0];
    employerData.col = [skills objectAtIndex:0];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"2";
    employerData.value = @"72";
    employerData.row = [jobs objectAtIndex:0];
    employerData.col = [skills objectAtIndex:1];
    [employersData addObject:employerData];
    
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"3";
    employerData.value = @"82";
    employerData.row = [jobs objectAtIndex:0];
    employerData.col = [skills objectAtIndex:2];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"4";
    employerData.value = @"91";
    employerData.row = [jobs objectAtIndex:0];
    employerData.col = [skills objectAtIndex:3];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"5";
    employerData.value = @"71";
    employerData.row = [jobs objectAtIndex:0];
    employerData.col = [skills objectAtIndex:4];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"6";
    employerData.value = @"25";
    employerData.row = [jobs objectAtIndex:1];
    employerData.col = [skills objectAtIndex:0];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"7";
    employerData.value = @"46";
    employerData.row = [jobs objectAtIndex:1];
    employerData.col = [skills objectAtIndex:1];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"8";
    employerData.value = @"92";
    employerData.row = [jobs objectAtIndex:1];
    employerData.col = [skills objectAtIndex:2];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"9";
    employerData.value = @"51";
    employerData.row = [jobs objectAtIndex:1];
    employerData.col = [skills objectAtIndex:3];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"10";
    employerData.value = @"79";
    employerData.row = [jobs objectAtIndex:1];
    employerData.col = [skills objectAtIndex:4];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"11";
    employerData.value = @"52";
    employerData.row = [jobs objectAtIndex:2];
    employerData.col = [skills objectAtIndex:0];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"12";
    employerData.value = @"63";
    employerData.row = [jobs objectAtIndex:2];
    employerData.col = [skills objectAtIndex:1];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"13";
    employerData.value = @"59";
    employerData.row = [jobs objectAtIndex:2];
    employerData.col = [skills objectAtIndex:2];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"14";
    employerData.value = @"31";
    employerData.row = [jobs objectAtIndex:2];
    employerData.col = [skills objectAtIndex:3];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"15";
    employerData.value = @"90";
    employerData.row = [jobs objectAtIndex:2];
    employerData.col = [skills objectAtIndex:4];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"16";
    employerData.value = @"85";
    employerData.row = [jobs objectAtIndex:3];
    employerData.col = [skills objectAtIndex:0];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"17";
    employerData.value = @"74";
    employerData.row = [jobs objectAtIndex:3];
    employerData.col = [skills objectAtIndex:1];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"18";
    employerData.value = @"22";
    employerData.row = [jobs objectAtIndex:3];
    employerData.col = [skills objectAtIndex:2];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"19";
    employerData.value = @"78";
    employerData.row = [jobs objectAtIndex:3];
    employerData.col = [skills objectAtIndex:3];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"20";
    employerData.value = @"55";
    employerData.row = [jobs objectAtIndex:3];
    employerData.col = [skills objectAtIndex:4];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"21";
    employerData.value = @"95";
    employerData.row = [jobs objectAtIndex:4];
    employerData.col = [skills objectAtIndex:0];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"22";
    employerData.value = @"52";
    employerData.row = [jobs objectAtIndex:4];
    employerData.col = [skills objectAtIndex:1];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"23";
    employerData.value = @"76";
    employerData.row = [jobs objectAtIndex:4];
    employerData.col = [skills objectAtIndex:2];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"24";
    employerData.value = @"95";
    employerData.row = [jobs objectAtIndex:4];
    employerData.col = [skills objectAtIndex:3];
    [employersData addObject:employerData];
    
    employerData = [[VGBaseDataModel new] autorelease];
    employerData.dataId = @"25";
    employerData.value = @"72";
    employerData.row = [jobs objectAtIndex:4];
    employerData.col = [skills objectAtIndex:4];
    [employersData addObject:employerData];
    
    // init operators data
    NSMutableArray* expertssData = [NSMutableArray array];
    
    VGBaseDataModel* expertData = nil;
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"1";
    expertData.value = @"78";
    expertData.row = [skills objectAtIndex:0];
    expertData.col = [subjects objectAtIndex:0];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"2";
    expertData.value = @"35";
    expertData.row = [skills objectAtIndex:0];
    expertData.col = [subjects objectAtIndex:1];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"3";
    expertData.value = @"91";
    expertData.row = [skills objectAtIndex:0];
    expertData.col = [subjects objectAtIndex:2];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"4";
    expertData.value = @"86";
    expertData.row = [skills objectAtIndex:0];
    expertData.col = [subjects objectAtIndex:3];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"5";
    expertData.value = @"37";
    expertData.row = [skills objectAtIndex:0];
    expertData.col = [subjects objectAtIndex:4];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"6";
    expertData.value = @"82";
    expertData.row = [skills objectAtIndex:1];
    expertData.col = [subjects objectAtIndex:0];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"7";
    expertData.value = @"98";
    expertData.row = [skills objectAtIndex:1];
    expertData.col = [subjects objectAtIndex:1];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"8";
    expertData.value = @"74";
    expertData.row = [skills objectAtIndex:1];
    expertData.col = [subjects objectAtIndex:2];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"9";
    expertData.value = @"90";
    expertData.row = [skills objectAtIndex:1];
    expertData.col = [subjects objectAtIndex:3];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"10";
    expertData.value = @"94";
    expertData.row = [skills objectAtIndex:1];
    expertData.col = [subjects objectAtIndex:4];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"11";
    expertData.value = @"68";
    expertData.row = [skills objectAtIndex:2];
    expertData.col = [subjects objectAtIndex:0];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"12";
    expertData.value = @"81";
    expertData.row = [skills objectAtIndex:2];
    expertData.col = [subjects objectAtIndex:1];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"13";
    expertData.value = @"79";
    expertData.row = [skills objectAtIndex:2];
    expertData.col = [subjects objectAtIndex:2];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"14";
    expertData.value = @"80";
    expertData.row = [skills objectAtIndex:2];
    expertData.col = [subjects objectAtIndex:3];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"15";
    expertData.value = @"92";
    expertData.row = [skills objectAtIndex:2];
    expertData.col = [subjects objectAtIndex:4];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"16";
    expertData.value = @"87";
    expertData.row = [skills objectAtIndex:3];
    expertData.col = [subjects objectAtIndex:0];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"17";
    expertData.value = @"69";
    expertData.row = [skills objectAtIndex:3];
    expertData.col = [subjects objectAtIndex:1];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"18";
    expertData.value = @"89";
    expertData.row = [skills objectAtIndex:3];
    expertData.col = [subjects objectAtIndex:2];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"19";
    expertData.value = @"70";
    expertData.row = [skills objectAtIndex:3];
    expertData.col = [subjects objectAtIndex:3];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"20";
    expertData.value = @"91";
    expertData.row = [skills objectAtIndex:3];
    expertData.col = [subjects objectAtIndex:4];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"21";
    expertData.value = @"90";
    expertData.row = [skills objectAtIndex:4];
    expertData.col = [subjects objectAtIndex:0];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"22";
    expertData.value = @"79";
    expertData.row = [skills objectAtIndex:4];
    expertData.col = [subjects objectAtIndex:1];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"23";
    expertData.value = @"82";
    expertData.row = [skills objectAtIndex:4];
    expertData.col = [subjects objectAtIndex:2];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"24";
    expertData.value = @"91";
    expertData.row = [skills objectAtIndex:4];
    expertData.col = [subjects objectAtIndex:3];
    [expertssData addObject:expertData];
    
    expertData = [[VGBaseDataModel new] autorelease];
    expertData.dataId = @"25";
    expertData.value = @"71";
    expertData.row = [skills objectAtIndex:4];
    expertData.col = [subjects objectAtIndex:4];
    [expertssData addObject:expertData];
    
    // init secretars data
    NSMutableArray* secretarsData = [NSMutableArray array];
    
    VGBaseDataModel* secretarData = nil;
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"1";
    secretarData.value = @"89";
    secretarData.row = [subjects objectAtIndex:0];
    secretarData.col = [students objectAtIndex:0];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"2";
    secretarData.value = @"70";
    secretarData.row = [subjects objectAtIndex:0];
    secretarData.col = [students objectAtIndex:1];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"3";
    secretarData.value = @"76";
    secretarData.row = [subjects objectAtIndex:0];
    secretarData.col = [students objectAtIndex:2];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"4";
    secretarData.value = @"81";
    secretarData.row = [subjects objectAtIndex:0];
    secretarData.col = [students objectAtIndex:3];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"5";
    secretarData.value = @"82";
    secretarData.row = [subjects objectAtIndex:0];
    secretarData.col = [students objectAtIndex:4];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"6";
    secretarData.value = @"69";
    secretarData.row = [subjects objectAtIndex:1];
    secretarData.col = [students objectAtIndex:0];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"7";
    secretarData.value = @"80";
    secretarData.row = [subjects objectAtIndex:1];
    secretarData.col = [students objectAtIndex:1];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"8";
    secretarData.value = @"91";
    secretarData.row = [subjects objectAtIndex:1];
    secretarData.col = [students objectAtIndex:2];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"9";
    secretarData.value = @"79";
    secretarData.row = [subjects objectAtIndex:1];
    secretarData.col = [students objectAtIndex:3];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"10";
    secretarData.value = @"96";
    secretarData.row = [subjects objectAtIndex:1];
    secretarData.col = [students objectAtIndex:4];
    [secretarsData addObject:secretarsData];
    
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"11";
    secretarData.value = @"87";
    secretarData.row = [subjects objectAtIndex:2];
    secretarData.col = [students objectAtIndex:0];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"12";
    secretarData.value = @"69";
    secretarData.row = [subjects objectAtIndex:2];
    secretarData.col = [students objectAtIndex:1];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"13";
    secretarData.value = @"95";
    secretarData.row = [subjects objectAtIndex:2];
    secretarData.col = [students objectAtIndex:2];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"14";
    secretarData.value = @"79";
    secretarData.row = [subjects objectAtIndex:2];
    secretarData.col = [students objectAtIndex:3];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"15";
    secretarData.value = @"83";
    secretarData.row = [subjects objectAtIndex:2];
    secretarData.col = [students objectAtIndex:4];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"16";
    secretarData.value = @"97";
    secretarData.row = [subjects objectAtIndex:3];
    secretarData.col = [students objectAtIndex:0];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"17";
    secretarData.value = @"70";
    secretarData.row = [subjects objectAtIndex:3];
    secretarData.col = [students objectAtIndex:1];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"18";
    secretarData.value = @"79";
    secretarData.row = [subjects objectAtIndex:3];
    secretarData.col = [students objectAtIndex:2];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"19";
    secretarData.value = @"88";
    secretarData.row = [subjects objectAtIndex:3];
    secretarData.col = [students objectAtIndex:3];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"20";
    secretarData.value = @"84";
    secretarData.row = [subjects objectAtIndex:3];
    secretarData.col = [students objectAtIndex:4];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"21";
    secretarData.value = @"92";
    secretarData.row = [subjects objectAtIndex:4];
    secretarData.col = [students objectAtIndex:0];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"22";
    secretarData.value = @"97";
    secretarData.row = [subjects objectAtIndex:4];
    secretarData.col = [students objectAtIndex:1];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"23";
    secretarData.value = @"79";
    secretarData.row = [subjects objectAtIndex:4];
    secretarData.col = [students objectAtIndex:2];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"24";
    secretarData.value = @"85";
    secretarData.row = [subjects objectAtIndex:4];
    secretarData.col = [students objectAtIndex:3];
    [secretarsData addObject:secretarsData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"25";
    secretarData.value = @"99";
    secretarData.row = [subjects objectAtIndex:4];
    secretarData.col = [students objectAtIndex:4];
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
    person.object_id = @"1";
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
    person.object_id = @"2";
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
    person.object_id = @"3";
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

@implementation VGTableType

- (void)dealloc
{
    self.value = nil;
    [super dealloc];
}

@end