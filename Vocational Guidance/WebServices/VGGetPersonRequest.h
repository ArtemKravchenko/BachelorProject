//
//  VGGetPersonRequest.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseRequest.h"

@interface VGGetPersonRequest : VGBaseRequest

- (id)initWithLogin:(NSString*)login andPassword:(NSString*)password;
- (id)initWithPersonId:(NSString*) personId;
- (id)initWithStudentId:(NSString*) studentId;
- (id)initWithAllSides;

@end
