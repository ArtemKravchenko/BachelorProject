//
//  VGEmploerData.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGEmploerData.h"

@implementation VGEmploerData

- (void)dealloc
{
    [_employerJob release];
    [_employerSkill release];
    [super dealloc];
}

@end
