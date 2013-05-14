//
//  VGSide.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 24.04.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGSide.h"

@implementation VGSide

@synthesize objectId;
@synthesize name;
@synthesize description;

-(void)dealloc {
    self.name = nil;
    self.objectId = nil;
    self.description = nil;
    [super dealloc];
}

@end
