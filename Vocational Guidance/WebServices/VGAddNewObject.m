//
//  VGAddNewObject.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGAddNewObject.h"

static NSString* const kAddNewObjectUrlRoute =              @"";

@implementation VGAddNewObject

- (id)initWithObject:(VGObject*)object
{
    self = [super init];
    if (self) {
        NSMutableString* tmpParams = [NSMutableString stringWithFormat:@"%@/%@", kAddNewObjectUrlRoute, object.description];
        if ([[object class] isSubclassOfClass:[VGStudent class]]) {
            [tmpParams appendFormat:@"/%@/%@/%@/%@/%@", ((VGStudent*)object).studentName, ((VGStudent*)object).studentSurname, ((VGStudent*)object).email, ((VGStudent*)object).side, ((VGStudent*)object).age];
        } else {
            [tmpParams appendFormat:@"/%@", object.name];
        }
        self.params = tmpParams;
    }
    return self;
}

@end
