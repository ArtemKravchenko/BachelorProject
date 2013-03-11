//
//  VGBaseDataModel.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseDataModel.h"

@implementation VGBaseDataModel

- (void)dealloc
{
    [_dataValue release];
    [super dealloc];
}

@end
