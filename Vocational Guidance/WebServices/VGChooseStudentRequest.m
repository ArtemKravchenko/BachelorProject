//
//  VGChooseStudentRequest.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGChooseStudentRequest.h"

static NSString* const kChooseStudentUrlRoute =              @"";

@implementation VGChooseStudentRequest

- (id)initWithStudent:(VGStudent*)student
{
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"/%@/%@", kChooseStudentUrlRoute, student.object_id];
    }
    return self;
}

@end
