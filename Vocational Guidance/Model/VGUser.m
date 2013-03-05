//
//  VGUser.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 05.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGUser.h"

@implementation VGUser

- (void)dealloc
{
    [_name release];
    [_surname release];
    [_side release];
    [_login release];
    [_password release];
    [_user_id release];
    [_dataSet release];
    [super dealloc];
}

@end
