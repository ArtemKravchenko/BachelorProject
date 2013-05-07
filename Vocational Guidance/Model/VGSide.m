//
//  VGSide.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 24.04.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGSide.h"

@implementation VGSide

-(NSDictionary*) jsonFromObject {
    NSMutableDictionary* jsonInfo = [NSMutableDictionary dictionary];
    
    return jsonInfo;
}

-(void)dealloc {
    self.name = nil;
    self.sideId = nil;
    [super dealloc];
}

@end
