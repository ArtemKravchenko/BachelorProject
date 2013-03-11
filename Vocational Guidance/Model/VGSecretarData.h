//
//  VGSecretarData.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGBaseDataModel.h"
#import "VGStudent.h"
#import "VGSubject.h"

@interface VGSecretarData : NSObject

@property (nonatomic, assign) NSInteger secretarDataSubjectId;
@property (nonatomic, retain) VGSubject* secretarDataSubject;
@property (nonatomic, assign) NSInteger secretarDataStudentId;
@property (nonatomic, retain) VGStudent* secretarDataStudent;

@end
