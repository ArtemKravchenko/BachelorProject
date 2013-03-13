//
//  VGObject.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGObject.h"

@implementation VGObject

- (void)dealloc
{
    [_object_id release];
    [_name release];
    [_description release];
    [super dealloc];
}

@end
