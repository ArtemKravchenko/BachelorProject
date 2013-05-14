//
//  VGStudents.m
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGStudent.h"
#import "VGAppDelegate.h"

@implementation VGStudent

@synthesize objectId;
@synthesize name;
@synthesize description;
@synthesize firstName;
@synthesize secondName;
@synthesize age;
@synthesize side;
@synthesize dataSet = _dataSet;
@synthesize rows = _rows;
@synthesize columns = _columns;
@synthesize credential;

- (id)init
{
    self = [super init];
    if (self) {
        self.credential = VGCredentilasTypeStudent;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] allocWithZone:zone] init];
    [copy setObjectId:[self objectId]];
    [copy setFirstName:[self firstName]];
    [copy setSecondName:[self secondName]];
    [copy setAge:[self age]];
    [copy setSide:[self side]];
    [copy setCredential:[self credential]];
    [copy setDescription:[self description]];
    return copy;
}

- (NSMutableArray*) columns {
    return [NSMutableArray arrayWithObject:[[self copy] autorelease]];
}

- (NSString *)credentialToString {
    return @"Student";
}

- (NSMutableArray*) rows {
    // TEMPORARY STUPID SOLUTION
    if (_rows == nil) {
        _rows = [[NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"persons"]][2] performSelector:NSSelectorFromString(@"rows")];
    }
    return _rows;
}

- (NSMutableArray*) dataSet {
    // TEMPORARY STUPID SOLUTION
    
    NSMutableArray* persons = [NSMutableArray arrayWithArray:[[VGAppDelegate getInstance].mockData objectForKey:@"persons"]];
    VGUser* tmpUser = persons[2];
    _dataSet = [NSMutableArray arrayWithArray: tmpUser.dataSet];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%K LIKE %@", @"col.objectId", self.objectId];
    [_dataSet filterUsingPredicate:predicate];
    
    return _dataSet;
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
