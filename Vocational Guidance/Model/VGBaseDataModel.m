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
    self.dataId = nil;
    self.value = nil;
    self.row = nil;
    self.col = nil;
    [super dealloc];
}

@end
