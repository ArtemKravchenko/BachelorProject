//
//  VGSide.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 24.04.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VGObjectToJSON <NSObject>

@required
-(NSDictionary*)jsonFromObject;

@end


@interface VGSide : NSObject <VGObjectToJSON>

@property (nonatomic, retain) NSString* sideId;
@property (nonatomic, retain) NSString* name;

@end
