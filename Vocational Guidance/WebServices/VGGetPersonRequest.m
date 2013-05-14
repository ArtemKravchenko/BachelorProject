//
//  VGGetPersonRequest.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGGetPersonRequest.h"

static NSString* const kGetPersonUrlRoute =                 @"";
static NSString* const kGetPersonByIdUrlRoute =             @"";
static NSString* const kGetStudentByIdUrlRoute =            @"";

static NSString* const kLogin             =                 @"login";
static NSString* const kPassword          =                 @"password";
static NSString* const kPersonId          =                 @"personId";

@implementation VGGetPersonRequest

- (id)initWithLogin:(NSString*)login andPassword:(NSString*)password
{
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@&%@=%@", kGetPersonUrlRoute, kLogin, login, kPassword, password];
    }
    return self;
}

- (id)initWithPersonId:(NSString*) personId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@", kGetPersonByIdUrlRoute, kPersonId, personId];
    }
    return self;
}

- (id)initWithStudentId:(NSString*) studentId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@", kGetStudentByIdUrlRoute, kStudentId, studentId];
    }
    return self;
}

@end
