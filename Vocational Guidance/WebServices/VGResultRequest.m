//
//  VGResultRequest.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 21.05.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGResultRequest.h"
#import "VGAppDelegate.h"

static NSString* const kResultRoute = @"getresult";
static NSString* const kExpertId = @"expertId";
static NSString* const kEmployerId = @"employerId";

@implementation VGResultRequest

- (id) initWithCurrentPersons {
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%@", kResultRoute, kStudentId, [VGAppDelegate getInstance].currentStudent.objectId, kExpertId, [VGAppDelegate getInstance].currentExpert.objectId, kEmployerId, [VGAppDelegate getInstance].currentEmployer.objectId];
    }
    return self;
}

@end
