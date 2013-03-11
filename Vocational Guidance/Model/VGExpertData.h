//
//  VGExpertData.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGBaseDataModel.h"
#import "VGSkill.h"
#import "VGSubject.h"

@interface VGExpertData : VGBaseDataModel

@property (nonatomic, retain) VGSkill* expertDataSkill;
@property (nonatomic, retain) VGSubject* expertDataSubject;

@end
