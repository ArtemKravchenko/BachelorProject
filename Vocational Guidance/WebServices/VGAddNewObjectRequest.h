//
//  VGAddNewObject.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseRequest.h"
#import "VGStudent.h"
#import "VGAppDelegate.h"

@interface VGAddNewObjectRequest : VGBaseRequest

- (id)initWithNewStudentToSecretarData:(NSString*)studentId firstName:(NSString*)firstName secondName:(NSString*)secondName side:(NSString*)sideId age:(NSString*)age studentDescription:(NSString*)description andPersonId:(NSString*) personId;
- (id)initWithNewSubjectToSecretarData:(NSString*)name description:(NSString*)description andPersonId:(NSString*) personId;
- (id)initWithNewSubjectToExpertData:(NSString*)name description:(NSString*)description andPersonId:(NSString*) personId;
- (id)initWithNewSkillToExpertData:(NSString*)name description:(NSString*)description andPersonId:(NSString*) personId;
- (id)initWithNewSkillToEmployerData:(NSString*)name description:(NSString*)description andPersonId:(NSString*) personId;
- (id)initWithNewVacancyToEmployerData:(NSString*)name description:(NSString*)description andPersonId:(NSString*) personId;

- (id)initWithExistStudentToSecretarData:(NSString*)studentId andPersonId:(NSString*) personId; 
- (id)initWithExistSubjectToSecretarData:(NSString*)subjectId andPersonId:(NSString*) personId;
- (id)initWithExistSubjectToExpertData:(NSString*)subjectId andPersonId:(NSString*) personId;
- (id)initWithExistSkillToExpertData:(NSString*)skillId andPersonId:(NSString*) personId;
- (id)initWithExistSkillToEmployerData:(NSString*)skillId andPersonId:(NSString*) personId;
- (id)initWithExistVacancyToEmployerData:(NSString*)vacancyId andPersonId:(NSString*) personId;

@end
