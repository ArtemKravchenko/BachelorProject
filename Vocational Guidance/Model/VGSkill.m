//
//  VGSkill.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGSkill.h"

@implementation VGSkill

- (void)dealloc
{
    [_skillId release];
    [_name release];
    [_description release];
    [super dealloc];
}

@end
