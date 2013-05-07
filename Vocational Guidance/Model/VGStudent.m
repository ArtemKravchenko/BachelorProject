//
//  VGStudents.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGStudent.h"

static NSString* const kStudentId = @"student id";
static NSString* const kStudentFirstName = @"student first name";
static NSString* const kStudentSecondName = @"student second name";
static NSString* const kStudentAge = @"student age";
static NSString* const kStudentSide = @"student side";
static NSString* const kStudentDescription = @"student description";

@implementation VGStudent

@synthesize objectId;
@synthesize name;
@synthesize description;
@synthesize firstName;
@synthesize secondName;
@synthesize age;
@synthesize side;

-(NSDictionary*) jsonFromObject {
    NSDictionary* jsonInfo = @{
                               kStudentId : self.objectId,
                               kStudentFirstName : self.firstName,
                               kStudentSecondName : self.secondName,
                               kStudentAge : self.age,
                               kStudentSide : [self.side jsonFromObject],
                               kStudentDescription : self.description
                               };
    
    return jsonInfo;
}

- (NSString*) name {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.secondName];
}

- (void)dealloc
{
    self.objectId = nil;
    self.name = nil;
    self.description = nil;
    self.firstName = nil;
    self.secondName = nil;
    self.age = nil;
    self.side = nil;
    [super dealloc];
}

@end
