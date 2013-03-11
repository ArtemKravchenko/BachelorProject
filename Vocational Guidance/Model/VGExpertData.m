//
//  VGExpertData.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGExpertData.h"

@implementation VGExpertData

- (void)dealloc
{
    [_expertDataSkill release];
    [_expertDataSubject release];
    [super dealloc];
}

@end
