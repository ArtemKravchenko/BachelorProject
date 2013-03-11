//
//  VGEmploerData.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGBaseDataModel.h"
#import "VGJob.h"
#import "VGSkill.h"

@interface VGEmploerData : VGBaseDataModel

@property (nonatomic, assign) NSInteger employerJobId;
@property (nonatomic, retain) VGJob* employerJob;
@property (nonatomic, assign) NSInteger employerSkillId;
@property (nonatomic, retain) VGSkill* employerSkill;

@end
