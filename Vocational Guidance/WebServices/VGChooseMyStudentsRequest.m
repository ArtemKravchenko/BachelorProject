//
//  VGChooseMyStudentsRequest.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGChooseMyStudentsRequest.h"

static NSString* const kChooseMyStudentsUrlRoute =              @"";

@implementation VGChooseMyStudentsRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"/%@", kChooseMyStudentsUrlRoute];
    }
    return self;
}


@end
