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

- (id)initWithRow:(id<VGTableVariable>)row andColumn:(id<VGTableVariable>)column andValue:(NSString*)value
{
    self = [super init];
    if (self) {
        self.params = [NSString stringWithFormat:@"/%@/%@/%@/%@", kChangeCellUrlRoute, row.objectId, column.objectId, value];
    }
    return self;
}

@end
