//
//  VGAddNewObject.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGAddNewObjectRequest.h"

static NSString* const kAddNewStudentToSecretarUrlRoute =               @"addnewstudenttosecretardata";
static NSString* const kAddNewSubjectToSecretarUrlRoute =               @"addnewsubjecttosecretardata";
static NSString* const kAddNewSubjectToExpertUrlRoute =                 @"addnewsubjecttoexpertdata";
static NSString* const kAddNewSkillToExpertUrlRoute =                   @"addnewskilltoexpertdata";
static NSString* const kAddNewSkillToEmploerUrlRoute =                  @"addnewskilltoemployerdata";
static NSString* const kAddNewVacancyToEmploerUrlRoute =                @"addnewvacancytoemployerdata";

static NSString* const kAddExistStudentToSecretarUrlRoute =             @"addexiststudenttosecretardata";
static NSString* const kAddExistSubjectToSecretarUrlRoute =             @"addexistsubjecttosecretardata";
static NSString* const kAddExistSubjectToExpertUrlRoute =               @"addexistsubjecttoexpertdata";
static NSString* const kAddExistSkillToExpertUrlRoute =                 @"addexistskilltoexpertdata";
static NSString* const kAddExistSkillToEmploerUrlRoute =                @"addexistskilltoemployerdata";
static NSString* const kAddExistVacancyToEmploerUrlRoute =              @"addexistvacancytoemployerdata";

@implementation VGAddNewObjectRequest

#pragma mark - Add new object to table

- (id)initWithNewStudentToSecretarData:(NSString*)studentId firstName:(NSString*)firstName secondName:(NSString*)secondName side:(NSString*)sideId age:(NSString*)age studentDescription:(NSString*)description andPersonId:(NSString*) personId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%d&%@=%@&%@=%@&%@=%d&%@=%d&%@=%@&%@=%d&%@=%@", kAddNewStudentToSecretarUrlRoute, kCardNumber, [studentId intValue], kFirstName, firstName, kSecondName, secondName, kSideId, [sideId intValue], kAge, [age intValue], kDescription, description, kPersonId, [personId intValue], kToken, [VGAppDelegate getInstance].token];
    }
    return self;
}

- (id)initWithNewSubjectToSecretarData:(NSString*)name description:(NSString*)description andPersonId:(NSString*) personId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%d&%@=%@", kAddNewSubjectToSecretarUrlRoute, kName, name, kDescription, description, kPersonId, [personId intValue], kToken, [VGAppDelegate getInstance].token];
    }
    return self;
}

- (id)initWithNewSubjectToExpertData:(NSString*)name description:(NSString*)description andPersonId:(NSString*) personId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%d&%@=%@", kAddNewSubjectToExpertUrlRoute, kName, name, kDescription, description, kPersonId, [personId intValue], kToken, [VGAppDelegate getInstance].token];
    }
    return self;
}

- (id)initWithNewSkillToExpertData:(NSString*)name description:(NSString*)description andPersonId:(NSString*) personId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%d&%@=%@", kAddNewSkillToExpertUrlRoute, kName, name, kDescription, description, kPersonId, [personId intValue], kToken, [VGAppDelegate getInstance].token];
    }
    return self;
}

- (id)initWithNewSkillToEmployerData:(NSString*)name description:(NSString*)description andPersonId:(NSString*) personId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%d&%@=%@", kAddNewSkillToEmploerUrlRoute, kName, name, kDescription, description, kPersonId, [personId intValue], kToken, [VGAppDelegate getInstance].token];
    }
    return self;
}

- (id)initWithNewVacancyToEmployerData:(NSString*)name description:(NSString*)description andPersonId:(NSString*) personId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%d&%@=%@", kAddNewVacancyToEmploerUrlRoute, kName, name, kDescription, description, kPersonId, [personId intValue], kToken, [VGAppDelegate getInstance].token];
    }
    return self;
}

#pragma mark - Add exist object to table

- (id)initWithExistStudentToSecretarData:(NSString*)studentId andPersonId:(NSString*) personId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%d&%@=%d&%@=%@", kAddExistStudentToSecretarUrlRoute, kCardNumber, [studentId intValue], kPersonId, [personId intValue], kToken, [VGAppDelegate getInstance].token];
    }
    return self;
}

- (id)initWithExistSubjectToSecretarData:(NSString*)subjectId andPersonId:(NSString*) personId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%d&%@=%d&%@=%@", kAddExistSubjectToSecretarUrlRoute, kSubjectId, [subjectId intValue], kPersonId, [personId intValue], kToken, [VGAppDelegate getInstance].token];
    }
    return self;
}

- (id)initWithExistSubjectToExpertData:(NSString*)subjectId andPersonId:(NSString*) personId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%d&%@=%d&%@=%@", kAddExistSubjectToExpertUrlRoute, kSubjectId, [subjectId intValue], kPersonId, [personId intValue], kToken, [VGAppDelegate getInstance].token];
    }
    return self;
}

- (id)initWithExistSkillToExpertData:(NSString*)skillId andPersonId:(NSString*) personId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%d&%@=%d&%@=%@", kAddExistSkillToExpertUrlRoute, kSkillId, [skillId intValue], kPersonId, [personId intValue], kToken, [VGAppDelegate getInstance].token];
    }
    return self;
}

- (id)initWithExistSkillToEmployerData:(NSString*)skillId andPersonId:(NSString*) personId { 
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%d&%@=%d&%@=%@", kAddExistSkillToEmploerUrlRoute, kSkillId, [skillId intValue], kPersonId, [personId intValue], kToken, [VGAppDelegate getInstance].token];
    }
    return self;
}

- (id)initWithExistVacancyToEmployerData:(NSString*)vacancyId andPersonId:(NSString*) personId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%d&%@=%d&%@=%@", kAddExistVacancyToEmploerUrlRoute, kVacancyId, [vacancyId intValue], kPersonId, [personId intValue], kToken, [VGAppDelegate getInstance].token];
    }
    return self;
}

@end
