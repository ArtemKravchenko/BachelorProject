//
//  VGUser.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 05.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGUser.h"
#import "VGBaseDataModel.h"

@implementation VGUser

@synthesize dataSet = _dataSet;
@synthesize firstName;
@synthesize secondName;
@synthesize age;
@synthesize side;
@synthesize objectId;
@synthesize name;
@synthesize description;
@synthesize rows;
@synthesize columns;
@synthesize credential;

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