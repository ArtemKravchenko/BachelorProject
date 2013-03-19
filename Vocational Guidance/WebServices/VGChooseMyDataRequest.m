//
//  VGChooseMyStudentsRequest.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGChooseMyDataRequest.h"

static NSString* const kChooseMyDataUrlRoute =              @"";

@implementation VGChooseMyDataRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"/%@", kChooseMyDataUrlRoute];
    }
    return self;
}

@end
