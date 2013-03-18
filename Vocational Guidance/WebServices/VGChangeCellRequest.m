//
//  VGChangeCellRequest.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGChangeCellRequest.h"

static NSString* const kChangeCellUrlRoute =              @"";

@implementation VGChangeCellRequest

- (id)initWithRow:(VGObject*)row andColumn:(VGObject*)column andValue:(NSString*)value
{
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"/%@/%@/%@/%@", kChangeCellUrlRoute, row.object_id, column.object_id, value];
    }
    return self;
}

@end
