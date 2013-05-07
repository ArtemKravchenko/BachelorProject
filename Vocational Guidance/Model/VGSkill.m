//
//  VGSkill.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGSkill.h"

static NSString* const kSkillId = @"skill id";
static NSString* const kSkillName = @"skill name";
static NSString* const kSkillDescription = @"skill description";

@implementation VGSkill

@synthesize objectId;
@synthesize name;
@synthesize description;

-(NSDictionary*) jsonFromObject {
    NSDictionary* jsonInfo = @{
                               kSkillId : self.objectId,
                               kSkillName : self.name,
                               kSkillDescription : self.description
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
