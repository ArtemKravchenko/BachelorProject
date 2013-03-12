//
//  VGStudents.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGStudent.h"

@implementation VGStudent

- (void)dealloc
{
    [_studentId release];
    [_cardNumber release];
    [_description release];
    [_name release];
    [_surname release];
    [_email release];
    [_side release];
    [super dealloc];
}

@end
