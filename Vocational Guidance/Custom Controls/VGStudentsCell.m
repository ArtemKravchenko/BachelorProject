//
//  VGStudentsCell.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.05.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGStudentsCell.h"

@implementation VGStudentsCell

- (void)dealloc {
    self.lblCardNumber = nil;
    self.lblFirstName  = nil;
    self.lblSecondName = nil;
    self.lblAge = nil;
    self.lblSide = nil;
    [super dealloc];
}
@end
