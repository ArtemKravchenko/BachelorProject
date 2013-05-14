//
//  VGAddNewObject.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGAddNewObject.h"

static NSString* const kAddNewStudentToSecretarUrlRoute =               @"";
static NSString* const kAddNewSubjectToSecretarUrlRoute =               @"";
static NSString* const kAddNewSubjectToExpertUrlRoute =                 @"";
static NSString* const kAddNewSkillToExpertUrlRoute =                   @"";
static NSString* const kAddNewSkillToEmploerUrlRoute =                  @"";
static NSString* const kAddNewVacancyToEmploerUrlRoute =                @"";

static NSString* const kAddExistStudentToSecretarUrlRoute =             @"";
static NSString* const kAddExistSubjectToSecretarUrlRoute =             @"";
static NSString* const kAddExistSubjectToExpertUrlRoute =               @"";
static NSString* const kAddExistSkillToExpertUrlRoute =                 @"";
static NSString* const kAddExistSkillToEmploerUrlRoute =                @"";
static NSString* const kAddExistVacancyToEmploerUrlRoute =              @"";

@implementation VGAddNewObject

#pragma mark - Add new object to table

- (id)initWithNewStudentToSecretarData:(NSString*)studentId firstName:(NSString*)firstName secondName:(NSString*)secondName side:(NSString*)sideId age:(NSString*)age {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%@&%@=%@&%@=%@", kAddNewStudentToSecretarUrlRoute, kStudentId, studentId, kFirstName, firstName, kSecondName, secondName, kSideId, sideId, kAge, age];
    }
    return self;
}

- (id)initWithNewSubjectToSecretarData:(NSString*)name description:(NSString*)description {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@&%@=%@", kAddNewSubjectToSecretarUrlRoute, kName, name, kDescription, description];
    }
    return self;
}

- (id)initWithNewSubjectToExpertData:(NSString*)name description:(NSString*)description {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@&%@=%@", kAddNewSubjectToExpertUrlRoute, kName, name, kDescription, description];
    }
    return self;
}

- (id)initWithNewSkillToExpertData:(NSString*)name description:(NSString*)description {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@&%@=%@", kAddNewSkillToExpertUrlRoute, kName, name, kDescription, description];
    }
    return self;
}

- (id)initWithNewSkillToEmployerData:(NSString*)name description:(NSString*)description {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@&%@=%@", kAddNewSkillToEmploerUrlRoute, kName, name, kDescription, description];
    }
    return self;
}

- (id)initWithNewVacancyToEmployerData:(NSString*)name description:(NSString*)description {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@&%@=%@", kAddNewVacancyToEmploerUrlRoute, kName, name, kDescription, description];
    }
    return self;
}

#pragma mark - Add exist object to table

- (id)initWithExistStudentToSecretarData:(NSString*)studentId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@", kAddExistStudentToSecretarUrlRoute, kStudentId, studentId];
    }
    return self;
}

- (id)initWithExistSubjectToSecretarData:(NSString*)subjectId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@", kAddExistSubjectToSecretarUrlRoute, kSubjectId, subjectId];
    }
    return self;
}

- (id)initWithExistSubjectToExpertData:(NSString*)subjectId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@", kAddExistSubjectToExpertUrlRoute, kSubjectId, subjectId];
    }
    return self;
}

- (id)initWithExistSkillToExpertData:(NSString*)skillId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@", kAddExistSkillToExpertUrlRoute, kSkillId, skillId];
    }
    return self;
}

- (id)initWithExistSkillToEmployerData:(NSString*)skillId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@", kAddExistSkillToEmploerUrlRoute, kSkillId, skillId];
    }
    return self;
}

- (id)initWithExistVacancyToEmployerData:(NSString*)vacancyId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@", kAddExistVacancyToEmploerUrlRoute, kVacancyId, vacancyId];
    }
    return self;
}

@end
