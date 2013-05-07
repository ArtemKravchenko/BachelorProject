//
//  VGMakeActiveExpertRequest.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGChooseExpertRequest.h"

static NSString* const kChooseExpertUrlRoute =              @"";

@implementation VGChooseExpertRequest

- (id)initWithExpert:(VGUser*)expert
{
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"/%@/%@", kChooseExpertUrlRoute, expert.objectId];
    }
    return self;
}

@end
