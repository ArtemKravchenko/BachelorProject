//
//  VGBaseDataModel.h
//  Vocational Guidance
//
//  Created by Artem Kravchenko on 07.03.13.
//  Copyright (c) 2013 K304. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VGObject.h"

@interface VGBaseDataModel : NSObject

@property (nonatomic, assign) NSString* dataId;
@property (nonatomic, retain) NSString* value;
@property (nonatomic, retain) VGObject* row;
@property (nonatomic, retain) VGObject* col;

@end
