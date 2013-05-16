//
//  VGGetPersonRequest.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGGetPersonRequest.h"

static NSString* const kGetPersonUrlRoute =                 @"getpersonbyloginandpassword";
static NSString* const kGetPersonByIdUrlRoute =             @"getpersonbyid";
static NSString* const kGetStudentByIdUrlRoute =            @"getstudentbyid";

static NSString* const kLoginParameter             =                 @"login";
static NSString* const kPasswordParameter          =                 @"password";

@implementation VGGetPersonRequest

- (id)initWithLogin:(NSString*)login andPassword:(NSString*)password
{
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@&%@=%@", kGetPersonUrlRoute, kLoginParameter, login, kPasswordParameter, password];
    }
    return self;
}

- (id)initWithPersonId:(NSString*) personId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%d", kGetPersonByIdUrlRoute, kPersonId, [personId intValue]];
    }
    return self;
}

- (id)initWithStudentId:(NSString*) studentId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%d", kGetStudentByIdUrlRoute, kStudentId, [studentId intValue]];
    }
    return self;
}

@end
