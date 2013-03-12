//
//  VGSubject.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGSubject.h"

@implementation VGSubject

- (void)dealloc
{
    [_subjectId release];
    [_name release];
    [_description release];
    [super dealloc];
}

@end
