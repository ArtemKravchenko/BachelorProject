//
//  VGSecretarData.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGSecretarData.h"

@implementation VGSecretarData

- (void)dealloc
{
    [_secretarDataStudent release];
    [_secretarDataSubject release];
    [_secretarDataValue release];
    [super dealloc];
}

@end
