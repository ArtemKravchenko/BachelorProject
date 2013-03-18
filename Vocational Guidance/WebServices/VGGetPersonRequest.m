//
//  VGGetPersonRequest.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGGetPersonRequest.h"

static NSString* const kGetPersonUrlRoute =              @"";

@implementation VGGetPersonRequest

- (id)initWithLogin:(NSString*)login andPassword:(NSString*)password
{
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@/%@/%@", kGetPersonUrlRoute, login, password];
    }
    return self;
}

@end
