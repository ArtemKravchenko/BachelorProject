//
//  VGChooseEmployerRequest.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGChooseEmployerRequest.h"

static NSString* const kChooseEmployerUrlRoute =              @"";

@implementation VGChooseEmployerRequest

- (id)initWithEmployer:(VGUser*)employer
{
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"/%@/%@", kChooseEmployerUrlRoute, employer.objectId];
    }
    return self;
}

@end
