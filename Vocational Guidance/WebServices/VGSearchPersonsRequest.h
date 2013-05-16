//
//  VGSearchPersons.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseRequest.h"
#import "VGUser.h"

@interface VGSearchPersonsRequest : VGBaseRequest

- (id) initWithFirstName:(NSString*) firstName secondName:(NSString*) secondName sideId:(NSString*)sideId  andCredentialType:(VGCredentilasType)credentialType;
- (id) initWithFirstName:(NSString *)firstName secondName:(NSString *)secondName sideId:(NSString *)sideId cardNumber:(NSString*) studentId age:(NSString*) age;
- (id) initWithAllStudents;
- (id) initWithAllExperts;
- (id) initWithAllEmployers;

@end
