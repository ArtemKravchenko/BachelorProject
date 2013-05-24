//
//  VGEditObjectRequest.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 15.05.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGEditObjectRequest.h"
#import "VGSubject.h"
#import "VGSkill.h"
#import "VGJob.h"

static NSString* const kEditStudentUrlRoute =               @"changestudentdetails";
static NSString* const kEditSubjectUrlRoute =               @"changesubjectdetails";
static NSString* const kEditSkillUrlRoute   =               @"changeskilldetails";
static NSString* const kEditVacancyUrlRoute =               @"changevacancydetails";

@implementation VGEditObjectRequest
 
- (id) initWithStudent:(NSString*)studentId studentFirstName:(NSString*)firstName studentSecondName:(NSString*)secondName studentSideId:(NSString*)sideId studentAge:(NSString*)age studentDescription:(NSString *)description andPersonId:(NSString *)personId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%d&%@=%@&%@=%@&%@=%d&%@=%d&%@=%@&%@=%d", kEditStudentUrlRoute, kCardNumber, [studentId intValue], kFirstName, firstName, kSecondName, secondName, kSideId, [sideId intValue], kAge, [age intValue], kDescription, ([description isEqualToString:@"<null>"]) ? @"" : description , kPersonId, [personId intValue]];
    }
    return self;
}

- (id) initWithTableObjectId:(NSString*)objectId objectName:(NSString*)name objectDescription:(NSString*) description objectType:(Class)objectType andPersonId:(NSString*) personId {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%@&%@=%d", ([objectType isSubclassOfClass: [VGSubject class]]) ?
                                                    kEditSubjectUrlRoute : ([objectType isSubclassOfClass: [VGSkill class]]) ?
                                                    kEditSkillUrlRoute: kEditVacancyUrlRoute,
                                                    ([objectType isSubclassOfClass: [VGSubject class]]) ?
                                                    kSubjectId : ([objectType isSubclassOfClass: [VGSkill class]]) ?
                                                    kSkillId: kVacancyId, objectId,
                                                    kName, name,
                                                    kDescription, ([description isEqualToString:@"<null>"]) ? @"" : description ,
                                                    kPersonId, [personId intValue]];
    }
    return self;
}

@end
