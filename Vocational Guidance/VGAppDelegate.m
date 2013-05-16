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
    self.mockData = nil;
    self.allStudents = nil;
    self.allSubjects = nil;
    self.allSkills = nil;
    self.allVacancies = nil;
    self.allSides = nil;
    self.currentUser = nil;
    self.currentStudent = nil;
    self.currentExpert = nil;
    self.currentEmployer = nil;
    self.transactionsList = nil;
    self.navigationController = nil;
    self.results = nil;
    [_stringValues release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    VGLoginViewController *loginView = [[[VGLoginViewController alloc] init] autorelease];
    [self clearSession];
    [self initTmpUser];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:loginView] autorelease];
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void) clearSession {
    self.isLogin = NO;
    self.currentUser = nil;
    self.currentEmployer = nil;
    self.currentExpert = nil;
    self.currentStudent = nil;
    self.transactionsList = [NSMutableArray array];
    self.results = nil;
    self.allSides = nil;
    self.allSkills = nil;
    self.allStudents = nil;
    self.allSubjects = nil;
    self.allVacancies = nil;
    self.currentScreen = kLogin;
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

#pragma mark - Execute transactions

- (void) executingTransation {
    for (NSDictionary *transactionItem in self.transactionsList) {
        NSString *stringType = (NSString*)[transactionItem objectForKey:VG_TRANSACTION_TYPE];
        NSInteger type = [stringType integerValue];
        if (type == TS_CHANGED_CELL) {
            [self changeValue:(NSString*)[transactionItem objectForKey: VG_CELL_VALUE] forRow:((id<VGTableVariable>)[transactionItem objectForKey: VG_ROW_OBJECT]) andCol:((id<VGTableVariable>)[transactionItem objectForKey: VG_COL_OBJECT])];
        } else {
            [self addObject:type withObject:[transactionItem objectForKey: VG_OBJECT_NAME]];
        }
    }
    [self.transactionsList removeAllObjects];
}

- (void) addObject:(NSInteger)type withObject:(NSString*)name {
    _stringValues = nil;
}

- (void) changeValue:(NSString*)value forRow:(id<VGTableVariable>)rowIndex andCol:(id<VGTableVariable>)colIndex {
    for (VGBaseDataModel* cell in self.currentUser.dataSet) {
        if (rowIndex.objectId == cell.row.objectId && colIndex.objectId == cell.col.objectId) {
            cell.value = value;
        }
    }
    _stringValues = nil;
}

#pragma mark - Cancel trnsaction

- (void) cancelTransaction {
    for (NSDictionary *transactionItem in self.transactionsList) {
        NSString *stringType = (NSString*)[transactionItem objectForKey:VG_TRANSACTION_TYPE];
        NSInteger type = [stringType integerValue];
        if (type == TS_CHANGED_CELL) {
            [self returnOldValue:(NSString*)[transactionItem objectForKey: VG_OLD_VALUE] forRowIndex:((id<VGTableVariable>)[transactionItem objectForKey: VG_ROW_OBJECT]) andColIndex:((id<VGTableVariable>)[transactionItem objectForKey: VG_COL_OBJECT])];
        } else {
            [self removeObject:type withObject:[transactionItem objectForKey: VG_OBJECT_NAME]];
        }
    }
    [self.transactionsList removeAllObjects];
}

- (void) removeObject:(NSInteger)type withObject:(id<VGTableVariable>)object {
    NSMutableArray* changedArray = (type == TS_ADDED_COL) ? self.currentUser.columns : self.currentUser.rows;
    
    NSMutableArray* deletingArray = [NSMutableArray array];
    [changedArray removeObject:object];
    NSInteger count = self.currentUser.dataSet.count;
    for (int i = 0; i < count; i++) {
        if (((type == TS_ADDED_COL) ? ((VGBaseDataModel*)self.currentUser.dataSet[i]).col.objectId : ((VGBaseDataModel*)self.currentUser.dataSet[i]).row.objectId) == object.objectId) {
            [deletingArray addObject:self.currentUser.dataSet[i]];
        }
    }
    
    for (VGBaseDataModel* cell in deletingArray) {
        [self.currentUser.dataSet removeObject:cell];
    }
    _stringValues = nil;
}

- (void) returnOldValue:(NSString*)value forRowIndex:(id<VGTableVariable>)rowIndex andColIndex:(id<VGTableVariable>)colIndex {
    for (VGBaseDataModel* cell in self.currentUser.dataSet) {
        if (rowIndex.objectId == cell.row.objectId && colIndex.objectId == cell.col.objectId) {
            cell.value = value;
        }
    }
    _stringValues = nil;
}

- (void) checkoutSession {
    if (self.currentStudent != nil && self.currentExpert != nil && self.currentEmployer != nil) {
        [VGScreenNavigator showResultButton];
    } else {
        [VGScreenNavigator hideResultButton];
    }
}

#pragma mark - Init Mock Data

- (void) initTmpUser {
    
    // init tmp id
    
    self.mockData = [NSMutableDictionary dictionary];
    
    // init sides
    
    NSMutableArray* sides = [NSMutableArray array];
    
    VGSide* side = [[VGSide new] autorelease];
    side.objectId = @"1";
    side.name = @"KHAI";
    
    [sides addObject:side];
    
    // init students
    NSMutableArray* students = [NSMutableArray array];
    
    VGStudent* student = nil;
    
    student = [[VGStudent new] autorelease];
    student.objectId = @"1";
    student.firstName = @"Kiril";
    student.secondName = @"Kukushkin";
    student.side = sides[0];
    student.age = @"20";
    student.credential = VGCredentilasTypeStudent;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.objectId = @"2";
    student.firstName = @"Michael";
    student.secondName = @"Obama";
    student.side = sides[0];
    student.age = @"20";
    student.credential = VGCredentilasTypeStudent;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.objectId = @"3";
    student.firstName = @"Barak";
    student.secondName = @"Obama";
    student.side = sides[0];
    student.age = @"20";
    student.credential = VGCredentilasTypeStudent;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.objectId = @"4";
    student.firstName = @"Filip";
    student.secondName = @"Kirkorov";
    student.side = sides[0];
    student.age = @"20";
    student.credential = VGCredentilasTypeStudent;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.objectId = @"5";
    student.firstName = @"Fredy";
    student.secondName = @"Mercury";
    student.side = sides[0];
    student.age = @"20";
    student.credential = VGCredentilasTypeStudent;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.objectId = @"6";
    student.firstName = @"Gusha";
    student.secondName = @"Katushkin";
    student.side = sides[0];
    student.age = @"20";
    student.credential = VGCredentilasTypeStudent;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.objectId = @"7";
    student.firstName = @"Victor";
    student.secondName = @"Yanukovich";
    student.side = sides[0];
    student.age = @"20";
    student.credential = VGCredentilasTypeStudent;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.objectId = @"8";
    student.firstName = @"Dmitrit";
    student.secondName = @"Medvedev";
    student.side = sides[0];
    student.age = @"20";
    student.credential = VGCredentilasTypeStudent;
    [students addObject:student];
    
    student = [[VGStudent new] autorelease];
    student.objectId = @"9";
    student.firstName = @"Vlodimir";
    student.secondName = @"Putin";
    student.side = sides[0];
    student.age = @"20";
    student.credential = VGCredentilasTypeStudent;
    [students addObject:student];
    
    // init jobs
    NSMutableArray* jobs = [NSMutableArray array];
    
    VGJob* job = nil;
    
    job = [[VGJob new] autorelease];
    job.objectId = @"1";
    job.name = @"Java developer";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.objectId = @"2";
    job.name = @"IOS Developer";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.objectId = @"3";
    job.name = @".NET Developer";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.objectId = @"4";
    job.name = @"Front-end Developer";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.objectId = @"5";
    job.name = @"Back-end Developer";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.objectId = @"6";
    job.name = @"Project Manger";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.objectId = @"7";
    job.name = @"System Administrator";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.objectId = @"8";
    job.name = @"HR";
    [jobs addObject:job];
    
    job = [[VGJob new] autorelease];
    job.objectId = @"9";
    job.name = @"Buosnes analityc";
    [jobs addObject:job];
    
    // init subjects
    NSMutableArray* subjects = [NSMutableArray array];
    
    VGSubject* subject = nil;
    
    subject = [[VGSubject new] autorelease];
    subject.objectId = @"1";
    subject.name = @"Programming";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.objectId = @"2";
    subject.name = @"Mathemathics Analys";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.objectId = @"3";
    subject.name = @"English";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.objectId = @"4";
    subject.name = @"Teory of Algorithm";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.objectId = @"5";
    subject.name = @"Discret Mathemathics";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.objectId = @"6";
    subject.name = @"Philosophy";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.objectId = @"7";
    subject.name = @"Web Develophing";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.objectId = @"8";
    subject.name = @"Data Bases";
    [subjects addObject:subject];
    
    subject = [[VGSubject new] autorelease];
    subject.objectId = @"9";
    subject.name = @"Functional Analys";
    [subjects addObject:subject];
    
    // init skills
    NSMutableArray* skills = [NSMutableArray array];
    
    VGSkill* skill = nil;
    
    skill = [[VGSkill new] autorelease];
    skill.objectId = @"1";
    skill.name = @"C#";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.objectId = @"2";
    skill.name = @"Objective-c";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.objectId = @"3";
    skill.name = @"PHP";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.objectId = @"4";
    skill.name = @"JavaScript";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.objectId = @"5";
    skill.name = @"HTML";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.objectId = @"6";
    skill.name = @"CSS";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.objectId = @"7";
    skill.name = @"MySql";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.objectId = @"8";
    skill.name = @"MSSQL";
    [skills addObject:skill];
    
    skill = [[VGSkill new] autorelease];
    skill.objectId = @"9";
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
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"2";
    secretarData.value = @"70";
    secretarData.row = [subjects objectAtIndex:0];
    secretarData.col = [students objectAtIndex:1];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"3";
    secretarData.value = @"76";
    secretarData.row = [subjects objectAtIndex:0];
    secretarData.col = [students objectAtIndex:2];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"4";
    secretarData.value = @"81";
    secretarData.row = [subjects objectAtIndex:0];
    secretarData.col = [students objectAtIndex:3];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"5";
    secretarData.value = @"82";
    secretarData.row = [subjects objectAtIndex:0];
    secretarData.col = [students objectAtIndex:4];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"6";
    secretarData.value = @"69";
    secretarData.row = [subjects objectAtIndex:1];
    secretarData.col = [students objectAtIndex:0];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"7";
    secretarData.value = @"80";
    secretarData.row = [subjects objectAtIndex:1];
    secretarData.col = [students objectAtIndex:1];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"8";
    secretarData.value = @"91";
    secretarData.row = [subjects objectAtIndex:1];
    secretarData.col = [students objectAtIndex:2];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"9";
    secretarData.value = @"79";
    secretarData.row = [subjects objectAtIndex:1];
    secretarData.col = [students objectAtIndex:3];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"10";
    secretarData.value = @"96";
    secretarData.row = [subjects objectAtIndex:1];
    secretarData.col = [students objectAtIndex:4];
    [secretarsData addObject:secretarData];
    
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"11";
    secretarData.value = @"87";
    secretarData.row = [subjects objectAtIndex:2];
    secretarData.col = [students objectAtIndex:0];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"12";
    secretarData.value = @"69";
    secretarData.row = [subjects objectAtIndex:2];
    secretarData.col = [students objectAtIndex:1];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"13";
    secretarData.value = @"95";
    secretarData.row = [subjects objectAtIndex:2];
    secretarData.col = [students objectAtIndex:2];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"14";
    secretarData.value = @"79";
    secretarData.row = [subjects objectAtIndex:2];
    secretarData.col = [students objectAtIndex:3];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"15";
    secretarData.value = @"83";
    secretarData.row = [subjects objectAtIndex:2];
    secretarData.col = [students objectAtIndex:4];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"16";
    secretarData.value = @"97";
    secretarData.row = [subjects objectAtIndex:3];
    secretarData.col = [students objectAtIndex:0];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"17";
    secretarData.value = @"70";
    secretarData.row = [subjects objectAtIndex:3];
    secretarData.col = [students objectAtIndex:1];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"18";
    secretarData.value = @"79";
    secretarData.row = [subjects objectAtIndex:3];
    secretarData.col = [students objectAtIndex:2];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"19";
    secretarData.value = @"88";
    secretarData.row = [subjects objectAtIndex:3];
    secretarData.col = [students objectAtIndex:3];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"20";
    secretarData.value = @"84";
    secretarData.row = [subjects objectAtIndex:3];
    secretarData.col = [students objectAtIndex:4];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"21";
    secretarData.value = @"92";
    secretarData.row = [subjects objectAtIndex:4];
    secretarData.col = [students objectAtIndex:0];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"22";
    secretarData.value = @"97";
    secretarData.row = [subjects objectAtIndex:4];
    secretarData.col = [students objectAtIndex:1];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"23";
    secretarData.value = @"79";
    secretarData.row = [subjects objectAtIndex:4];
    secretarData.col = [students objectAtIndex:2];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"24";
    secretarData.value = @"85";
    secretarData.row = [subjects objectAtIndex:4];
    secretarData.col = [students objectAtIndex:3];
    [secretarsData addObject:secretarData];
    
    secretarData = [[VGBaseDataModel new] autorelease];
    secretarData.dataId = @"25";
    secretarData.value = @"99";
    secretarData.row = [subjects objectAtIndex:4];
    secretarData.col = [students objectAtIndex:4];
    [secretarsData addObject:secretarData];
    
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
    person.objectId = @"1";
    person.firstName = @"Stive";
    person.secondName = @"Jobs";
    person.side = sides[0];
    person.login = @"Employer";
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
    person.objectId = @"2";
    person.firstName = @"Aleksandr";
    person.secondName = @"Kulik";
    person.side = sides[0];
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
    person.objectId = @"3";
    person.firstName = @"Nina";
    person.secondName = @"Bakumenko";
    person.side = sides[0];
    person.login = @"Secretar";
    person.password = @"Secretar";
    person.credential = VGCredentilasTypeSecretar;
    person.dataSet = secretarsData;
    person.rows = tmprowsArray;
    person.columns = tmpcolsArray;
    [persons addObject:person];
    
    [self.mockData setObject:students forKey:@"students"];
    [self.mockData setObject:jobs forKey:@"jobs"];
    [self.mockData setObject:subjects forKey:@"subjects"];
    [self.mockData setObject:skills forKey:@"skills"];
    [self.mockData setObject:persons forKey:@"persons"];
    [self.mockData setObject:sides forKey:@"sides"];
}

@end

@implementation VGTableType

- (void)dealloc
{
    self.value = nil;
    [super dealloc];
}

@end