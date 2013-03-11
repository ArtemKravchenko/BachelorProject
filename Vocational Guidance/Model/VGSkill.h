//
//  VGSkill.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGObject.h"

@interface VGSkill : VGObject

@property (nonatomic, assign) NSInteger skillId;
@property (nonatomic, retain) NSString* skillName;
@property (nonatomic, retain) NSString* skillDescription;

@end
