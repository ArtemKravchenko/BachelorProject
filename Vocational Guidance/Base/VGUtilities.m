//
//  VGUtilities.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 03.05.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGUtilities.h"
#import "VGAppDelegate.h"
#import "VGSubject.h"
#import "VGSkill.h"
#import "VGJob.h"
#import "VGAlertView.h"

@implementation VGUtilities

+ (NSMutableDictionary*) fieldsForCredentialType:(VGCredentilasType)credentialType{
    
    NSMutableDictionary* returnDictionary = [NSMutableDictionary dictionary];
    
    NSArray* fields = nil;
    NSArray* emptyFields = nil;
    NSDictionary* contentDictionary = nil;
    
    NSString* credentialName = nil;
    if (credentialType == VGCredentilasTypeStudent) {
        credentialName = kStudent;
    } else {
        credentialName = kUser;
    }
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:credentialName ofType:@"plist"];
    contentDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    fields = [contentDictionary objectForKey:kFields];
    [returnDictionary setObject:fields forKey:kFields];
    
    NSDictionary* iconDictionary = [contentDictionary objectForKey:kIcons];
    [returnDictionary setObject:iconDictionary forKey:kIcons];
    
    emptyFields = [contentDictionary objectForKey:@"Can be empty"];
    [returnDictionary setObject:emptyFields forKey:kEmptyFields];
    
    return returnDictionary;
}

+ (NSMutableDictionary*) fieldsFromPlistNameWithName:(NSString*) name {
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:name ofType:@"plist"];
    NSMutableDictionary* contentDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    return contentDictionary;
}

+ (UILabel*) changeTitleNameWithText:(NSString*) text {
    UILabel* navLabel = [[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 900, 44)] autorelease];
    [navLabel setFont:[UIFont systemFontOfSize:14]];
    [navLabel setText:text];
    [navLabel setTextAlignment:NSTextAlignmentCenter];
    [navLabel setBackgroundColor:[UIColor clearColor]];
    
    return navLabel;
}

#pragma mark - parse JSON

+ (VGUser*)userFromJsonData:(NSDictionary*)jsonInfo {
    VGUser* user = [[VGUser new] autorelease];
    
    user.objectId = [NSString stringWithFormat:@"%@", jsonInfo[@"PersonId"]];
    user.firstName = [NSString stringWithFormat:@"%@", jsonInfo[@"PersonFirstName"]];
    user.secondName = [NSString stringWithFormat:@"%@", jsonInfo[@"PersonSecondName"]];
    user.side = [self objectForId:jsonInfo[@"PersonSideId"] fromArray:[VGAppDelegate getInstance].allSides];
    NSString* credentilId = [NSString stringWithFormat:@"%d",[jsonInfo[@"PersonCredentialId"] intValue]];
    user.credential = ([credentilId isEqualToString:@"2"]) ? VGCredentilasTypeSecretar: ([credentilId isEqualToString:@"3"]) ? VGCredentilasTypeExpert: VGCredentilasTypeEmployer;
    user.login = jsonInfo[@"PersonLogin"];
    user.password = jsonInfo[@"PersonPassword"];
    
    NSString* rowsString = [NSString stringWithFormat:@"%@", jsonInfo[@"Rows"]];
    if (![rowsString isEqualToString: @"<null>"]) {
        NSMutableArray* rows = [NSMutableArray arrayWithArray:jsonInfo[@"Rows"]];
        user.rows = [NSMutableArray array];
        for (NSDictionary* data in rows) {
            [user.rows addObject: [self tableVariableFromJsonData:data withClassType:(user.credential == VGCredentilasTypeSecretar) ? [VGStudent class] : (user.credential == VGCredentilasTypeExpert) ? [VGSubject class] : [VGJob class]]];
        }
    }
    
    NSString* colString = [NSString stringWithFormat:@"%@", jsonInfo[@"Columns"]];
    if (![colString isEqualToString: @"<null>"]) {
        NSMutableArray* cols = [NSMutableArray arrayWithArray:jsonInfo[@"Columns"]];
        user.columns = [NSMutableArray array];
        for (NSDictionary* data in cols) {
            [user.columns addObject: [self tableVariableFromJsonData:data withClassType:(user.credential == VGCredentilasTypeSecretar) ? [VGSubject class] : (user.credential == VGCredentilasTypeExpert) ? [VGSkill class] : [VGSkill class]]];
        }
    }
    NSString* tableDataString =[NSString stringWithFormat:@"%@", jsonInfo[@"PersonTableData"]];
    if (![tableDataString isEqualToString: @"<null>"]) {
        NSMutableArray* dataSet = [NSMutableArray arrayWithArray:jsonInfo[@"PersonTableData"]];
        
        user.dataSet = [NSMutableArray array];
        
        for (NSDictionary* data in dataSet) {
            [user.dataSet addObject: [self baseDataModelFromJsonData:data withCredentialType:user.credential]];
        }
    }
    
    return user;

}

+ (void) fillAllArraysWithRows:(NSMutableArray*)rows andColumns:(NSMutableArray*)columns andCredential:(NSString*)credentialId {
    NSMutableArray* allRows = nil;
    NSMutableArray* allColumns = nil;
    Class rowClass = nil;
    Class colClass = nil;
    
    if([credentialId isEqualToString:@"2"]) {
        [VGAppDelegate getInstance].allStudents = [[[NSMutableArray alloc] init] autorelease];
        [VGAppDelegate getInstance].allSubjects = [[[NSMutableArray alloc] init] autorelease];
        allRows = [VGAppDelegate getInstance].allStudents;
        allColumns = [VGAppDelegate getInstance].allSubjects;
        rowClass = [VGStudent class];
        colClass = [VGSubject class];
    } else if ([credentialId isEqualToString:@"3"]) {
        [VGAppDelegate getInstance].allSubjects = [[[NSMutableArray alloc] init] autorelease];
        [VGAppDelegate getInstance].allSkills = [[[NSMutableArray alloc] init] autorelease];
        allRows = [VGAppDelegate getInstance].allSubjects;
        allColumns = [VGAppDelegate getInstance].allSkills;
        rowClass = [VGSubject class];
        colClass = [VGSkill class];
    } else if ([credentialId isEqualToString:@"4"]) {
        [VGAppDelegate getInstance].allSkills = [[[NSMutableArray alloc] init] autorelease];
        [VGAppDelegate getInstance].allVacancies = [[[NSMutableArray alloc] init] autorelease];
        allRows = [VGAppDelegate getInstance].allVacancies;
        allColumns = [VGAppDelegate getInstance].allSkills;
        rowClass = [VGJob class];
        colClass = [VGSkill class];
    } else {
        NSLog(@"(VGUtilities) Error : Wrong user credentials");
    }
    
    for (NSDictionary* row in rows) {
        id<VGTableVariable> tmp = [VGUtilities tableVariableFromJsonData:row withClassType:rowClass];
        [allRows addObject: tmp];
    }
    
    for (NSDictionary* col in columns) {
        id<VGTableVariable> tmp = [VGUtilities tableVariableFromJsonData:col withClassType:colClass];
        [allColumns addObject: tmp];
    }

}

+ (VGUser*)userFromJsonData:(NSDictionary*)jsonInfo andAllRows:(NSMutableArray*)allRows andAllColumns:(NSMutableArray*)allColumns andRowType:(Class)rowType andColType:(Class)colType {
    VGUser* user = [[VGUser new] autorelease];
    
    user.objectId = [NSString stringWithFormat:@"%@", jsonInfo[@"PersonId"]];
    user.firstName = [NSString stringWithFormat:@"%@", jsonInfo[@"PersonFirstName"]];
    user.secondName = [NSString stringWithFormat:@"%@", jsonInfo[@"PersonSecondName"]];
    user.side = [self objectForId:jsonInfo[@"PersonSideId"] fromArray:[VGAppDelegate getInstance].allSides];
    NSString* credentilId = [NSString stringWithFormat:@"%d",[jsonInfo[@"PersonCredentialId"] intValue]];
    user.credential = ([credentilId isEqualToString:@"2"]) ? VGCredentilasTypeSecretar: ([credentilId isEqualToString:@"3"]) ? VGCredentilasTypeExpert: VGCredentilasTypeEmployer;
    user.login = jsonInfo[@"PersonLogin"];
    user.password = jsonInfo[@"PersonPassword"];
    
    NSString* rowsString = [NSString stringWithFormat:@"%@", jsonInfo[@"Rows"]];
    if (![rowsString isEqualToString: @"<null>"]) {
        NSMutableArray* rows = [NSMutableArray arrayWithArray:jsonInfo[@"Rows"]];
        user.rows = [NSMutableArray array];
        for (NSDictionary* data in rows) {
            [user.rows addObject:[self objectForId:data[[NSString stringWithFormat:@"%@%@", ([[rowType class] isSubclassOfClass:[VGStudent class]]) ?
                                                                         kStudent : ([[rowType class] isSubclassOfClass:[VGSubject class]]) ?
                                                                         kSubject : ([[rowType class] isSubclassOfClass:[VGSkill class]]) ?
                                                                           kSkill : ([[rowType class] isSubclassOfClass:[VGSide class]]) ? kSide : kVacancy , @"Id"]] fromArray:allRows]];
            //[user.rows addObject: [self tableVariableFromJsonData:data withClassType:(user.credential == VGCredentilasTypeSecretar) ? [VGStudent class] : (user.credential == VGCredentilasTypeExpert) ? [VGSubject class] : [VGJob class]]];
        }
    }
    NSString* colString = [NSString stringWithFormat:@"%@", jsonInfo[@"Columns"]];
    if (![colString isEqualToString: @"<null>"]) {
        NSMutableArray* cols = [NSMutableArray arrayWithArray:jsonInfo[@"Columns"]];
        user.columns = [NSMutableArray array];
        for (NSDictionary* data in cols) {
            [user.columns addObject:[self objectForId:data[[NSString stringWithFormat:@"%@%@", ([[colType class] isSubclassOfClass:[VGStudent class]]) ?
                                                                            kStudent : ([[colType class] isSubclassOfClass:[VGSubject class]]) ?
                                                                            kSubject : ([[colType class] isSubclassOfClass:[VGSkill class]]) ?
                                                                              kSkill : ([[colType class] isSubclassOfClass:[VGSide class]]) ? kSide : kVacancy , @"Id"]] fromArray:allColumns]];
            //[user.columns addObject: [self tableVariableFromJsonData:data withClassType:(user.credential == VGCredentilasTypeSecretar) ? [VGSubject class] : (user.credential == VGCredentilasTypeExpert) ? [VGSkill class] : [VGSkill class]]];
        }
    }
    NSString* tableDataString =[NSString stringWithFormat:@"%@", jsonInfo[@"PersonTableData"]];
    if (![tableDataString isEqualToString: @"<null>"]) {
        NSMutableArray* dataSet = [NSMutableArray arrayWithArray:jsonInfo[@"PersonTableData"]];
        user.dataSet = [NSMutableArray array];
        for (NSDictionary* data in dataSet) {
            [user.dataSet addObject: [self baseDataModelFromJsonData:data withCredentialType:user.credential]];
        }
    }
    
    return user;
}

+ (id<VGTableVariable>) tableVariableFromJsonData:(NSDictionary*)jsonInfo withClassType:(Class)type {
    id<VGTableVariable> tableVariable = [[type new] autorelease];
    
    NSString* objectIdString = [NSString stringWithFormat:@"%@%@", ([[type class] isSubclassOfClass:[VGStudent class]]) ?
                                                kStudent : ([[type class] isSubclassOfClass:[VGSubject class]]) ?
                                                kSubject : ([[type class] isSubclassOfClass:[VGSkill class]]) ?
                                                  kSkill : ([[type class] isSubclassOfClass:[VGSide class]]) ? kSide : kVacancy , @"Id"];
    tableVariable.objectId = [NSString stringWithFormat:@"%d", [jsonInfo[objectIdString] intValue]];
    
    NSString* descriptionString = [NSString stringWithFormat:@"%@%@", ([[type class] isSubclassOfClass:[VGStudent class]]) ?
                                                   kStudent : ([[type class] isSubclassOfClass:[VGSubject class]]) ?
                                                   kSubject : ([[type class] isSubclassOfClass:[VGSkill class]]) ?
                                                     kSkill : ([[type class] isSubclassOfClass:[VGSide class]]) ? kSide :kVacancy  , @"Description"];
    tableVariable.description = [NSString stringWithFormat:@"%@", jsonInfo[descriptionString]];
    
    if ([[type class] isSubclassOfClass:[VGStudent class]]) {
        ((VGStudent*)tableVariable).firstName = jsonInfo[@"StudentFirstName"];
        ((VGStudent*)tableVariable).secondName = jsonInfo[@"StudentSecondName"];
        ((VGStudent*)tableVariable).age = [NSString stringWithFormat:@"%@", jsonInfo[@"StudentAge"]];
        ((VGStudent*)tableVariable).side = [self objectForId:jsonInfo[@"StudentSideId"] fromArray:[VGAppDelegate getInstance].allSides];
        NSString* rowsString = [NSString stringWithFormat:@"%@", jsonInfo[@"Rows"]];
        if (![rowsString isEqualToString: @"<null>"]) {
            NSMutableArray* rows = [NSMutableArray arrayWithArray:jsonInfo[@"Rows"]];
            
            ((VGStudent*)tableVariable).rows = [NSMutableArray array];
            
            for (NSDictionary* data in rows) {
                [((VGStudent*)tableVariable).rows addObject: [self tableVariableFromJsonData:data withClassType:[VGStudent class]]];
            }
        }
        
        NSString* colString = [NSString stringWithFormat:@"%@", jsonInfo[@"Columns"]];
        if (![colString isEqualToString: @"<null>"]) {
            NSMutableArray* cols = [NSMutableArray arrayWithArray:jsonInfo[@"Columns"]];
            
            ((VGStudent*)tableVariable).columns = [NSMutableArray array];
            
            for (NSDictionary* data in cols) {
                [((VGStudent*)tableVariable).columns addObject: [self tableVariableFromJsonData:data withClassType:[VGSubject class]]];
            }
        }
        
        NSString* tableDataString =[NSString stringWithFormat:@"%@", jsonInfo[@"PersonTableData"]];
        if (![tableDataString isEqualToString: @"<null>"]) {
            NSMutableArray* dataSet = [NSMutableArray arrayWithArray:jsonInfo[@"PersonTableData"]];
            
            ((VGStudent*)tableVariable).dataSet = [NSMutableArray array];
            
            for (NSDictionary* data in dataSet) {
                [((VGStudent*)tableVariable).dataSet addObject: [self baseDataModelFromJsonData:data withCredentialType:VGCredentilasTypeStudent]];
            }
        }
    } else {
        NSString* nameString = [NSString stringWithFormat:@"%@%@",
                                ([[type class] isSubclassOfClass:[VGSubject class]]) ?
                                                kSubject : ([[type class] isSubclassOfClass:[VGSkill class]]) ?
                                                  kSkill : ([[type class] isSubclassOfClass:[VGSide class]]) ? kSide : kVacancy  , @"Name"];
        tableVariable.name = [NSString stringWithFormat:@"%@", jsonInfo[nameString]];
    }
    
    
    return tableVariable;
}

+ (VGBaseDataModel*) baseDataModelFromJsonData:(NSDictionary*)jsonInfo withCredentialType:(VGCredentilasType)credentialType {
    VGBaseDataModel* dataModel = [[VGBaseDataModel new] autorelease];
    
    dataModel.dataId = [NSString stringWithFormat:@"%@", jsonInfo[@"TableViewId"]];
    dataModel.value = [NSString stringWithFormat:@"%@", jsonInfo[@"Value"]];
    
    Class rowType = nil;
    Class colType = nil;
    
    if (credentialType == VGCredentilasTypeSecretar) {
        rowType = [VGStudent class];
        colType = [VGSubject class];
    } else if (credentialType == VGCredentilasTypeExpert) {
        rowType = [VGSubject class];
        colType = [VGSkill class];
    } else if (credentialType == VGCredentilasTypeEmployer) {
        rowType = [VGJob class];
        colType = [VGSkill class];
    } else if (credentialType == VGCredentilasTypeStudent) {
        rowType = [VGStudent class];
        colType = [VGSubject class];
    } else {
        [VGAlertView showError:[NSString stringWithFormat: @"(VGUtilities) Error: incorect type of user : %d", credentialType]];
    }
    
    dataModel.row = [self tableVariableFromJsonData:jsonInfo[@"Row"] withClassType:rowType];
    dataModel.col = [self tableVariableFromJsonData:jsonInfo[@"Column"] withClassType:colType];
    
    return dataModel;
}

+ (NSMutableArray*) arrayUsersFromResultData:(NSDictionary*)jsonInfo {
    NSMutableArray* usersArray = [NSMutableArray array];

    for (NSDictionary* array in ((NSArray*)jsonInfo[@"solution"])) {
        VGUser* user = [[VGUser new] autorelease];
        
        // We fill user's rows and columns in reverse style, because students count always will been 1, but we have a lot of vacancy
        
        // filling rows
        user.rows = [NSMutableArray  array];
        for (NSDictionary* data in ((NSArray*)jsonInfo[@"columns"])) {
            [user.rows addObject: [self tableVariableFromJsonData:data withClassType:[VGStudent class]]];
        }
        // filling columns
        user.columns = [NSMutableArray array];
        for (NSDictionary* data in ((NSArray*)jsonInfo[@"rows"])) {
            [user.columns addObject:[self tableVariableFromJsonData:data withClassType:[VGJob class]]];
        }
        // filling data set
        user.dataSet = [NSMutableArray array];
        for (NSDictionary* data in ((NSArray*)array)) {
            [user.dataSet addObject:[self baseDataModelFromResultCell:data]];
        }
        
        [usersArray addObject:user];
    }
    
    return usersArray;
}

+ (VGBaseDataModel*) baseDataModelFromResultCell:(NSDictionary*) jsonInfo{
    VGBaseDataModel* dataModel = [[VGBaseDataModel new] autorelease];
    
    dataModel.value = [NSString stringWithFormat:@"%@", jsonInfo[@"Value"]];
    dataModel.row = [self tableVariableFromJsonData:jsonInfo[@"X1"] withClassType:[VGStudent class]];
    dataModel.col = [self tableVariableFromJsonData:jsonInfo[@"X2"] withClassType:[VGJob class]];
    
    return dataModel;
}

+ (id<VGTableVariable>) objectForId:(NSString*)objectId fromArray:(NSMutableArray*)array {
    NSPredicate* predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", @"objectId", [NSString stringWithFormat:@"%@", objectId]];
    NSMutableArray* tmpSides = [NSMutableArray arrayWithArray: array];
    [tmpSides filterUsingPredicate:predicate];
    return ((id<VGTableVariable>)tmpSides[0]);
}

@end
