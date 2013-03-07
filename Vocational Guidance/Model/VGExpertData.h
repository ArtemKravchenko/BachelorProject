//
//  VGExpertData.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGSkill.h"
#import "VGSubject.h"

@interface VGExpertData : NSObject

@property (nonatomic, assign) NSInteger expertDataId;
@property (nonatomic, assign) NSInteger expertDataSkillId;
@property (nonatomic, retain) VGSkill* expertDataSkill;
@property (nonatomic, assign) NSInteger expertDataSubjectId;
@property (nonatomic, retain) VGSubject* expertDataSubject;
@property (nonatomic, retain) NSString* expertDataValue;

@end
