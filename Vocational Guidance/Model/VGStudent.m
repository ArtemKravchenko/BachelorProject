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
    [_studentName release];
    [_studentSurname release];
    [_studentEmail release];
    [_studentSide release];
    [super dealloc];
}

@end
