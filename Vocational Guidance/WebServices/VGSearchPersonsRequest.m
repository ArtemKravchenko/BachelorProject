//
//  VGSearchPersons.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGSearchPersonsRequest.h"

static NSString* const kSearchExpertsUrlRoute =                 @"getexpertsforcorrespondingparameters";
static NSString* const kSearchEmployersUrlRoute =               @"getemployersforcorrespondingparameters";
static NSString* const kSearchStudentsUrlRoute =                @"getstudentsforcurrentcriteria";
static NSString* const kSearchAllStudents =                     @"getallstudents";
static NSString* const kSearchAllExperts =                      @"getallexperts";
static NSString* const kSearchAllEmployers =                    @"getallemployers";

@implementation VGSearchPersonsRequest

- (id) initWithFirstName:(NSString*) firstName secondName:(NSString*) secondName sideId:(NSString*)sideId andCredentialType:(VGCredentilasType)credentialType
{
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%d", (credentialType == VGCredentilasTypeExpert) ? kSearchExpertsUrlRoute: kSearchEmployersUrlRoute,
                       kSideId, (sideId == nil) ? -1 : [sideId intValue]];
        if (firstName != nil) {
            self.params = [NSString stringWithFormat:@"%@&%@=%@", self.params, kFirstName, firstName];
        }
        if (secondName != nil) {
            self.params = [NSString stringWithFormat:@"%@&%@=%@", self.params, kSecondName, secondName];
        }
    }
    return self;
}

- (id) initWithFirstName:(NSString *)firstName secondName:(NSString *)secondName sideId:(NSString *)sideId cardNumber:(NSString*) studentId age:(NSString*) age {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%d&%@=%d&%@=%d", kSearchStudentsUrlRoute ,kCardNumber,
                       (studentId == nil) ? -1 : [studentId intValue],
                       kSideId, (sideId == nil) ? -1 : [sideId intValue],
                       kAge, (age == nil) ? -1 : [age intValue]];
        if (firstName != nil) {
            self.params = [NSString stringWithFormat:@"%@&%@=%@", self.params, kFirstName, firstName];
        }
        if (secondName != nil) {
            self.params = [NSString stringWithFormat:@"%@&%@=%@", self.params, kSecondName, secondName];
        }
    }
    return self;
}

- (id) initWithAllStudents {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@", kSearchAllStudents];
    }
    return self;
}

- (id) initWithAllExperts {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@", kSearchAllExperts];
    }
    return self;
}

- (id) initWithAllEmployers {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@", kSearchAllEmployers];
    }
    return self;
}


@end
