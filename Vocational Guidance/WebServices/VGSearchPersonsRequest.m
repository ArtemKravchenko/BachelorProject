//
//  VGSearchPersons.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGSearchPersonsRequest.h"

static NSString* const kSearchPersonsUrlRoute =              @"";

@implementation VGSearchPersonsRequest

- (id)initWithUser:(VGUser*)user
{
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@", kSearchPersonsUrlRoute, user.login, user.password, user.side, user.secondName, user.firstName];
    }
    return self;
}

@end
