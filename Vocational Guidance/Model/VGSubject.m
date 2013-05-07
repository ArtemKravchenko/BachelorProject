//
//  VGSubject.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGSubject.h"

static NSString* const kSubjectId = @"subject id";
static NSString* const kSubjectName = @"subject name";
static NSString* const kSubjectDescription = @"subject description";

@implementation VGSubject

@synthesize objectId;
@synthesize name;
@synthesize description;

-(NSDictionary*) jsonFromObject {
    NSDictionary* jsonInfo = @{
                               kSubjectId : self.objectId,
                               kSubjectName : self.name,
                               kSubjectDescription : self.description
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
