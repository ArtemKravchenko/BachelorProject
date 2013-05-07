//
//  VGUser.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 05.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGUser.h"
#import "VGBaseDataModel.h"

static NSString* const kUserId = @"user id";
static NSString* const kUserFirstName = @"user first name";
static NSString* const kUserSecondName = @"user second name";
static NSString* const kUserLogin = @"user login";
static NSString* const kUserPassword = @"user password";
static NSString* const kUserDataSet = @"user data set";
static NSString* const kUserAge = @"user age";
static NSString* const kUserSide = @"user side";
static NSString* const kUserCredential = @"user credeential";
static NSString* const kUserDescription = @"user descriprion";
static NSString* const kUserColumns = @"user columns";
static NSString* const kUserRows = @"user rows";

@implementation VGUser

@synthesize dataSet = _dataSet;
@synthesize firstName;
@synthesize secondName;
@synthesize age;
@synthesize side;
@synthesize objectId;
@synthesize name;
@synthesize description;

- (NSString *)credentialToString {
    NSString* stringCredential = nil;
    switch (self.credential) {
        case VGCredentilasTypeEmployer:
            stringCredential = @"Employer";
            break;
            
        case VGCredentilasTypeExpert:
            stringCredential = @"Expert";
            break;
            
        case VGCredentilasTypeManager:
            stringCredential = @"Manager";
            break;
            
        case VGCredentilasTypeSecretar:
            stringCredential = @"Secretar";
            break;
            
        default:
            stringCredential = kStudent;
            break;
    }
    return stringCredential;
}

-(NSDictionary*) jsonFromObject {
    NSDictionary* jsonInfo = @{
                               kUserId : self.objectId,
                               kUserFirstName : self.firstName,
                               kUserSecondName : self.secondName,
                               kUserLogin : self.login,
                               kUserPassword : self.password,
                               kUserDataSet : self.dataSet,
                               kUserAge : self.age,
                               kUserSide : [self.side jsonFromObject],
                               kUserCredential : [NSNumber numberWithInt: self.credential],
                               kUserDescription : self.description,
                               kUserColumns : self.columns,
                               kUserRows : self.rows
                               };
    return jsonInfo;
}

-(NSString*) name {
    return [NSString stringWithFormat:@""];
}

-(void)setDataSet:(NSMutableArray *)value {
    if (value) {
        [_dataSet release];
        _dataSet = [value retain];
    }
    
}

- (void)dealloc
{
    self.objectId = nil;
    self.name = nil;
    self.description = nil;
    self.rows = nil;
    self.columns = nil;
    self.dataSet = nil;
    self.login = nil;
    self.password = nil;
    self.firstName = nil;
    self.secondName = nil;
    self.age = nil;
    self.side = nil;
    [super dealloc];
}

@end