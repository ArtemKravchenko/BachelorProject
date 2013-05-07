//
//  VGPersonsCell.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.05.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGPersonsCell.h"

@implementation VGPersonsCell


- (void)dealloc {
    self.lblFirstName  = nil;
    self.lblSecondName  = nil;
    self.lblSide = nil;
    [super dealloc];
}
@end
