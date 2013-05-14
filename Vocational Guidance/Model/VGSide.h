//
//  VGSide.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 24.04.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VGTableVariable <NSObject>

@property (nonatomic, retain) NSString* objectId;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* description;

@end

@interface VGSide : NSObject <VGTableVariable>

@end
