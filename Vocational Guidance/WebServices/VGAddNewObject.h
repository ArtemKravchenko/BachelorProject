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

@interface VGAddNewObject : VGBaseRequest

- (id)initWithNewStudentToSecretarData:(NSString*)studentId firstName:(NSString*)firstName secondName:(NSString*)secondName side:(NSString*)sideId age:(NSString*)age;
- (id)initWithNewSubjectToSecretarData:(NSString*)name description:(NSString*)description;
- (id)initWithNewSubjectToExpertData:(NSString*)name description:(NSString*)description;
- (id)initWithNewSkillToExpertData:(NSString*)name description:(NSString*)description;
- (id)initWithNewSkillToEmployerData:(NSString*)name description:(NSString*)description;
- (id)initWithNewVacancyToEmployerData:(NSString*)name description:(NSString*)description;

- (id)initWithExistStudentToSecretarData:(NSString*)studentId;
- (id)initWithExistSubjectToSecretarData:(NSString*)subjectId;
- (id)initWithExistSubjectToExpertData:(NSString*)subjectId;
- (id)initWithExistSkillToExpertData:(NSString*)skillId;
- (id)initWithExistSkillToEmployerData:(NSString*)skillId;
- (id)initWithExistVacancyToEmployerData:(NSString*)vacancyId;

@end
