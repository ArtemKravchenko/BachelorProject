//
//  VGChooseEmployerRequest.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 18.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import "VGBaseRequest.h"
#import "VGUser.h"

@interface VGChooseEmployerRequest : VGBaseRequest

- (id)initWithEmployer:(VGUser*)employer;

@end
