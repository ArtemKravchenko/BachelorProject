//
//  VGJob.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGJob.h"

static NSString* const kJobId = @"job id";
static NSString* const kJobName = @"job name";
static NSString* const kJobDescription = @"job description";

@implementation VGJob

@synthesize objectId;
@synthesize name;
@synthesize description;

-(NSDictionary*) jsonFromObject {
    NSDictionary* jsonInfo = @{
                               kJobId : self.objectId,
                               kJobName : self.name,
                               kJobDescription : self.description
                               };
    return jsonInfo;
}

- (void)dealloc
{
    self.objectId = nil;
    self.name = nil;
    self.description = nil;
    [super dealloc];
}

@end
