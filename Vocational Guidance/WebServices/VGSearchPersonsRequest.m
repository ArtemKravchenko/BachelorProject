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
static NSString* const kSearchAllStudents =                     @"";
static NSString* const kSearchAllExperts =                      @"";
static NSString* const kSearchAllEmployers =                    @"";

@implementation VGSearchPersonsRequest

- (id) initWithFirstName:(NSString*) firstName secondName:(NSString*) secondName sideId:(NSString*)sideId andCredentialType:(VGCredentilasType)credentialType
{
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%@", (credentialType == VGCredentilasTypeExpert) ? kSearchExpertsUrlRoute: kSearchEmployersUrlRoute, kFirstName, firstName, kSecondName, secondName, kSideId, sideId];
    }
    return self;
}

- (id) initWithFirstName:(NSString *)firstName secondName:(NSString *)secondName sideId:(NSString *)sideId cardNumber:(NSString*) studentId age:(NSString*) age {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%d&%@=%@&%@=%@&%@=%d&%@=%d", kSearchStudentsUrlRoute ,kCardNumber, ([studentId isEqualToString:@""]) ? -1 : [studentId intValue], kFirstName, firstName, kSecondName, secondName, kSideId, ([sideId isEqualToString:@""]) ? -1 : [sideId intValue], kAge, [age isEqualToString:@""] ? -1 : [age intValue]];
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
