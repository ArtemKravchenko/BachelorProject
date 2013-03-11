//
//  VGJob.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGObject.h"

@interface VGJob : VGObject

@property (nonatomic, assign) NSInteger jobId;
@property (nonatomic, retain) NSString* jobName;
@property (nonatomic, retain) NSString* jobDescription;

@end
