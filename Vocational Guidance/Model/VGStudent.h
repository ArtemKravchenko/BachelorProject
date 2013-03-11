//
//  VGStudents.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGObject.h"

@interface VGStudent : VGObject

@property (nonatomic, assign) NSInteger studentId;
@property (nonatomic, retain) NSString* studentName;
@property (nonatomic, retain) NSString* studentSurname;
@property (nonatomic, retain) NSString* studentEmail;
@property (nonatomic, retain) NSString* studentSide;
@property (nonatomic, assign) NSInteger studentAge;

@end
