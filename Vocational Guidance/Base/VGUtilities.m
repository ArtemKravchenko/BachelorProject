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
    
    //[VGAppDelegate getInstance].allSides = [NSMutableArray arrayWithArray:jsonInfo[@"all sides"]];
    
    user.objectId = [NSString stringWithFormat:@"%@", jsonInfo[@"PersonId"]];
    user.firstName = [NSString stringWithFormat:@"%@", jsonInfo[@"PersonFirstName"]];
    user.secondName = [NSString stringWithFormat:@"%@", jsonInfo[@"PersonSecondName"]];
    user.side = [self objectForId:jsonInfo[@"PersonSideId"] fromArray:[VGAppDelegate getInstance].allSides];
    NSString* credentilId = jsonInfo[@"PersonCredentialId"];
    user.credential = ([credentilId isEqualToString:@"2"]) ? VGCredentilasTypeSecretar: ([credentilId isEqualToString:@"3"]) ? VGCredentilasTypeExpert: VGCredentilasTypeEmployer;
    user.login = jsonInfo[@"PersonLogin"];
    user.password = jsonInfo[@"PersonPassword"];
    // TODO : add table data, rows and cols
    NSMutableArray* dataSet = [NSMutableArray arrayWithArray:jsonInfo[@"PersonTableData"]];
    NSMutableArray* rows = [NSMutableArray arrayWithArray:jsonInfo[@"Rows"]];
    NSMutableArray* cols = [NSMutableArray arrayWithArray:jsonInfo[@"Cols"]];
    
    user.dataSet = [NSMutableArray array];
    user.rows = [NSMutableArray array];
    user.columns = [NSMutableArray array];
    
    for (NSDictionary* data in rows) {
        [user.rows addObject: [self tableVariableFromJsonData:data withClassType:(user.credential == VGCredentilasTypeSecretar) ? [VGStudent class] : (user.credential == VGCredentilasTypeExpert) ? [VGSubject class] : [VGJob class]]];
    }
    
    for (NSDictionary* data in cols) {
        [user.columns addObject: [self tableVariableFromJsonData:data withClassType:(user.credential == VGCredentilasTypeSecretar) ? [VGSubject class] : (user.credential == VGCredentilasTypeExpert) ? [VGSkill class] : [VGSkill class]]];
    }
    
    for (NSDictionary* data in dataSet) {
        [user.dataSet addObject: [self baseDataModelFromJsonData:data withCredentialType:user.credential]];
    }
    
    return user;
}

+ (id<VGTableVariable>) tableVariableFromJsonData:(NSDictionary*)jsonInfo withClassType:(Class)type {
    id<VGTableVariable> tableVariable = [[type new] autorelease];
    
    tableVariable.objectId = jsonInfo[[NSString stringWithFormat:@"%@%@", ([[type class] isSubclassOfClass:[VGStudent class]]) ?
                                                        kStudent : ([[type class] isSubclassOfClass:[VGSubject class]]) ?
                                                        kSubject : ([[type class] isSubclassOfClass:[VGSkill class]]) ?
                                                         kSkill : ([[type class] isSubclassOfClass:[VGSide class]]) ? kSide : kVacancy , @"Id"]];
    
    tableVariable.description = jsonInfo[[NSString stringWithFormat:@"%@%@", ([[type class] isSubclassOfClass:[VGStudent class]]) ?
                                                 kStudent : ([[type class] isSubclassOfClass:[VGSubject class]]) ?
                                                 kSubject : ([[type class] isSubclassOfClass:[VGSkill class]]) ?
                                                   kSkill : ([[type class] isSubclassOfClass:[VGSide class]]) ? kSide :kVacancy  , @"Description"]];
    
    if ([[type class] isSubclassOfClass:[VGStudent class]]) {
        ((VGStudent*)tableVariable).firstName = jsonInfo[@"StudentFirstName"];
        ((VGStudent*)tableVariable).secondName = jsonInfo[@"StudentSecondName"];
        ((VGStudent*)tableVariable).age = [NSString stringWithFormat:@"%@", jsonInfo[@"StudentAge"]];
        ((VGStudent*)tableVariable).side = [self objectForId:jsonInfo[@"StudentSideId"] fromArray:[VGAppDelegate getInstance].allSides];
    } else {
        tableVariable.name = [NSString stringWithFormat:@"%@%@",
                          ([[type class] isSubclassOfClass:[VGSubject class]]) ?
                          kSubject : ([[type class] isSubclassOfClass:[VGSkill class]]) ?
                          kSkill : kVacancy  , jsonInfo[@"Name"]];
    }
    
    
    return tableVariable;
}

+ (VGBaseDataModel*) baseDataModelFromJsonData:(NSDictionary*)jsonInfo withCredentialType:(VGCredentilasType)credentialType {
    VGBaseDataModel* dataModel = [[VGBaseDataModel new] autorelease];
    
    dataModel.dataId = [NSString stringWithFormat:@"%@", jsonInfo[@"TableViewId"]];
    dataModel.value = [NSString stringWithFormat:@"%@", jsonInfo[@"Value"]];
    dataModel.row = [self objectForId:jsonInfo[@"Row"] fromArray:[NSMutableArray arrayWithArray: (credentialType == VGCredentilasTypeSecretar) ?
                                                                  [VGAppDelegate getInstance].allStudents :
                                                                  (credentialType == VGCredentilasTypeExpert) ? [VGAppDelegate getInstance].allSubjects :
                                                                  [VGAppDelegate getInstance].allVacancies]];
    dataModel.col = [self objectForId:jsonInfo[@"Column"] fromArray:[NSMutableArray arrayWithArray: (credentialType == VGCredentilasTypeSecretar) ?
                                                                  [VGAppDelegate getInstance].allSubjects :
                                                                  (credentialType == VGCredentilasTypeExpert) ? [VGAppDelegate getInstance].allSkills :
                                                                  [VGAppDelegate getInstance].allSkills]];
    
    return dataModel;
}

+ (NSMutableArray*) arrayUsersFromResultData:(NSDictionary*)jsonInfo {
    NSMutableArray* usersArray = [NSMutableArray array];
    
    return usersArray;
}

+ (VGSide*) objectForId:(NSString*)sideId fromArray:(NSMutableArray*)array {
    NSPredicate* predicate = nil;
    predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", @"objectId", sideId];
    NSMutableArray* tmpSides = [NSMutableArray arrayWithArray: array];
    [tmpSides filterUsingPredicate:predicate];
    return ((VGSide*)tmpSides[0]);
}

@end
