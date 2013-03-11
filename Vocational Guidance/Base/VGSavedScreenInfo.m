//
//  VGSavedScreenInfo.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 26.02.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGSavedScreenInfo.h"

@implementation VGSavedScreenInfo

@synthesize title = _title;

- (void)dealloc
{
    [_params release];
    [_title release];
    [super dealloc];
}

@end
