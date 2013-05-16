//
//  VGEditObjectRequest.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 15.05.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseRequest.h"

@interface VGEditObjectRequest : VGBaseRequest

- (id) initWithStudent:(NSString*)studentId studentFirstName:(NSString*)firstName studentSecondName:(NSString*)secondName studentSideId:(NSString*)sideId studentAge:(NSString*)age studentDescription:(NSString*)description andPersonId:(NSString*) personId;
- (id) initWithTableObjectId:(NSString*)objectId objectName:(NSString*)name objectDescription:(NSString*) description objectType:(Class)objectType andPersonId:(NSString*) personId;

@end
