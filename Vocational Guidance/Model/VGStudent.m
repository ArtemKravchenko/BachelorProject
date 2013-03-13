//
//  VGStudents.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGStudent.h"

@implementation VGStudent

- (NSString*) name {
    return [NSString stringWithFormat:@"%@ %@", self.studentName, self.studentSurname];
}

- (void)dealloc
{
    [_cardNumber release];
    [_studentName release];
    [_studentSurname release];
    [_email release];
    [_side release];
    [super dealloc];
}

@end
