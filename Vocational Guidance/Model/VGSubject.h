//
//  VGSubject.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VGSubject : NSObject

@property (nonatomic, assign) NSInteger subjectId;
@property (nonatomic, retain) NSString* subjectName;
@property (nonatomic, retain) NSString* subjectDescription;

@end
