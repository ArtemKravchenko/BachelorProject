//
//  VGJob.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGJob.h"

@implementation VGJob

- (void)dealloc
{
    [_jobId release];
    [_name release];
    [_description release];
    [super dealloc];
}

@end
