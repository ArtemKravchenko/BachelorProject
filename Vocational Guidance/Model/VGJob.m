//
//  VGJob.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGJob.h"

@implementation VGJob

@synthesize objectId;
@synthesize name;
@synthesize description;

- (void)dealloc
{
    self.objectId = nil;
    self.name = nil;
    self.description = nil;
    [super dealloc];
}

@end
